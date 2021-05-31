With Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO, stats, display, player, inventory_list, Ada.Unchecked_Deallocation, System.Address_Image;
Use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO, stats, display, player, inventory_list;
---------------------------------------------------------------------------------------------------
Package Body game_map is
---------------------------------------------------------------------------------------------------
-- Mathew Moose, Mark Bambino, Ryan Bost
-- Map Package
---------------------------------------------------------------------------------------------------
Map_File : File_Type;
Type Item_Set is Array (1..30) of Integer;

Function Empty (Position : in Room_Ptr) Return Boolean is
Begin
	If (Position = NULL) then
		Return False;
	Else
		Return True;
	End If;
End Empty;
---------------------------------------------------------------------------------------------------
Procedure Action(Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer) is
User : Character := 'o';
Chance : Integer;
begin
	If (Pos.Boss = True) then
		-- Start Battle
		RoomID := 99;
		pos.Boss := false;
	Elsif (Pos.Statue = True) then -- Statue Location Handling
		Map(Pos.Y_Axis, Pos.X_Axis).Color := 's';
		--Put(ASCII.ESC & "[H");
		Put(ASCII.ESC & "[39;4H");
		Put_Line("Found Statue! Y/N                                                                                   ");
			Loop
				Get_Immediate(User);
				If (User = 'n') OR (User ='N') then
					RoomID := 49;
					New_Line(20);
					Exit;
				Elsif (User = 'y') OR (User = 'Y') then
					RoomID := 50;
					Pos.Statue := False;
					Map(Pos.Y_Axis, Pos.X_Axis).Color := 't';
					New_Line(20);
					Exit;
				Else
					Put(ASCII.ESC & "[39;40H");
					Put_Line("Enter a valid character.");
				End If;
			End Loop;
	Elsif (Pos.Item >= 0) then -- Item Location Handling
		Map(Pos.Y_Axis, Pos.X_Axis).Color := 's';
		Put(ASCII.ESC & "[39;4H");
		Put_Line("Found Item Chest! Open it? Y/N                                                                      ");
			Loop
				Get_Immediate(User);
				If (User = 'n') OR (User ='N') then
					RoomID := 31;
					New_Line(20);
					Exit;
				Elsif (User = 'y') OR (User = 'Y') then
					RoomID := (Pos.Item); -- Display in Main
					Insert(Pos.Item, My_Player.Backpack); -- Add Item
					Pos.Item := -1;
					Map(Pos.Y_Axis, Pos.X_Axis).Color := 't';
					New_Line(20);
					Exit;
				Else
					Put(ASCII.ESC & "[39;40H");
					Put_Line("Enter a valid character.");
				End If;
			End Loop;
	Else -- Regular Room
		Chance := RandomZero(100);
		If (Chance <= 20) then
			RoomID := 0;
		End If;
	End If;
	If (Pos.Item = -1) AND (Pos.Statue = False) then -- Set Map Colors
		Map(Pos.Y_Axis, Pos.X_Axis).Color := 't';
	Else
		Map(Pos.Y_Axis, Pos.X_Axis).Color := 's';
     End If;
End Action;
---------------------------------------------------------------------------------------------------
Procedure Move_North(Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer) is
Item : Integer := -1;
begin
   If (Pos.North = NULL) then
      RoomID:= 77;
   Else
      Pos := Pos.North;
	  Action(Pos, Map, My_Player, Item);
	  RoomID := Item;
   End If;
end Move_North;
---------------------------------------------------------------------------------------------------
Procedure Move_East(Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer) is
Item : Integer := -1;
begin
   If (Pos.East = NULL) then
      RoomID:= 77;
   Else
      Pos := Pos.East;
	  Action(Pos, Map, My_Player, Item);
	  RoomID := Item;
   End If;
end Move_East;
---------------------------------------------------------------------------------------------------
Procedure Move_South(Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer) is
Item : Integer := -1;
begin
     If (Pos.South = NULL) then
         RoomID:= 77;
     Else
		Pos := Pos.South;
		Action(Pos, Map, My_Player, Item);
		RoomID := Item;
     End If;
end Move_South;
---------------------------------------------------------------------------------------------------
Procedure Move_West(Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer) is
Item : Integer := -1;
begin
      If (Pos.West = NULL) then
         RoomID:= 77;
      Else
        Pos := Pos.West;
		Action(Pos, Map, My_Player, Item);
		RoomID := Item;
      End If;
end Move_West;
---------------------------------------------------------------------------------------------------
Function "=" (A,B : Room) Return Boolean is
Begin
	If ((A.X_Axis = B.X_Axis) AND (A.Y_Axis = B.Y_Axis)) Then
		Return True;
	Else
		Return False;
	End If;
End "=";
---------------------------------------------------------------------------------------------------
Function "=" (A : Room_Ptr; B : Room) Return Boolean is
Begin
	If ((A.X_Axis = B.X_Axis) AND (A.Y_Axis = B.Y_Axis)) Then
		Return True;
	Else
		Return False;
	End If;
End "=";
---------------------------------------------------------------------------------------------------	
Procedure Print(Current : in Room_Ptr; Map : in Map_Type) is
Begin
	Put("Location: (");
	Put(Current.X_Axis, Width => 0);
	Put(",");
	Put(Current.Y_Axis, Width => 0);
	Put_Line(")");
	Put("North: (");
	If Current.North = NULL then
		Put("Wall");
	Else
		Put(Current.North.X_Axis, Width => 0);
		Put(",");
		Put(Current.North.Y_Axis, Width => 0);
	End If;
	Put_Line(")");
		Put("East: (");
	If Current.East = NULL then
		Put("Wall");
	Else
		Put(Current.East.X_Axis, Width => 0);
		Put(",");
		Put(Current.East.Y_Axis, Width => 0);
	End If;
	Put_Line(")");
		Put("South: (");
	If Current.South = NULL then
		Put("Wall");
	Else
		Put(Current.South.X_Axis, Width => 0);
		Put(",");
		Put(Current.South.Y_Axis, Width => 0);
	End If;
	Put_Line(")");
		Put("West: (");
	If Current.West = NULL then
		Put("Wall");
	Else
		Put(Current.West.X_Axis, Width => 0);
		Put(",");
		Put(Current.West.Y_Axis, Width => 0);
	End If;
	Put_Line(")");
	Put("Item: ");
	Put(Item => Current.Item, Width => 0);
	New_Line;
	Put("Boss: ");
	If (Current.Boss = True) Then
		Put_Line("True");
	Else
		Put_Line("False");
	End If;
	Put("Statue: ");
	If (Current.Statue = True) Then
		Put_Line("True");
	Else
		Put_Line("False");
	End If;
	
	Put("Color:");
	Put(Map(Current.Y_Axis, Current.X_Axis).Color);
	
End Print;
---------------------------------------------------------------------------------------------------
Procedure Search (Position : in Room_Ptr; Key : in Room; Location : out Room_Ptr; Found : out Boolean) is
Temp : Room_Ptr;
Begin
	If (Position = Key) then
		Location := Position; -- Saves Location of Room with Key Coordinates
		Found := True; -- Used to Break Recursive Calls
		Return;
	Else
		If (Position.North /= NULL) AND Then (Position.North.Traversed = False) then
			Temp := Position.North;
			Temp.Traversed := True;
			Search(Temp, Key, Location, Found);
			If (Found = True) then -- Break out of the Recursive Calls
				Return;
			End If;
		End If;
		If (Position.East /= NULL) AND Then (Position.East.Traversed = False) then
			Temp := Position.East;
			Temp.Traversed := True;
			Search(Temp, Key, Location, Found);
			If (Found = True) then -- Break out of the Recursive Calls
				Return;
			End If;
		End If;
		If (Position.South /= NULL) AND Then (Position.South.Traversed = False) then
			Temp := Position.South;
			Temp.Traversed := True;
			Search(Temp, Key, Location, Found);
			If (Found = True) then -- Break out of the Recursive Calls
				Return;
			End If;
		End If;
		If (Position.West /= NULL) AND Then(Position.West.Traversed = False) then
			Temp := Position.West;
			Temp.Traversed := True;
			Search(Temp, Key, Location, Found);
			If (Found = True) then -- Break out of the Recursive Calls
				Return;
			End If;
		End If;
	End If;
End Search;
---------------------------------------------------------------------------------------------------
Procedure Reset (Location : in Room_Ptr) is
Temp : Room_Ptr;
Begin
	Temp := Location;
	Temp.Traversed := False;
		If (Location.North /= NULL) AND Then (Location.North.Traversed = True) then
			Temp := Location.North;
			Temp.Traversed := False;
			Reset(Temp);
		End If;
		If (Location.East /= NULL) AND Then (Location.East.Traversed = True) then
			Temp := Location.East;
			Temp.Traversed := False;
			Reset(Temp);
		End If;
		If (Location.South /= NULL) AND Then (Location.South.Traversed = True) then
			Temp := Location.South;
			Temp.Traversed := False;
			Reset(Temp);
		End If;
		If (Location.West /= NULL) AND Then(Location.West.Traversed = True) then
			Temp := Location.West;
			Temp.Traversed := False;
			Reset(Temp);
		End If;
End Reset;
---------------------------------------------------------------------------------------------------
Procedure Traverse (Location :  in Room_Ptr; Floor_Map : in out Map_Type; Show_North : in Boolean := True;
					Show_East : in Boolean := True; Show_South : in Boolean := True; Show_West : in Boolean := True) is
Temp : Room_Ptr;
Begin
	Temp := Location;
	If (Temp.Boss = True) then
		NULL; -- Don't Change Character when Discovered
	Elsif (Temp.Statue = True) then
		Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Statue_Icon;
	Elsif (Temp.Item >= 0) then
		Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Chest_Icon; -- ∞
	Else
		If (Temp.North /= NULL) then
			If (Temp.South /= NULL) then
				If (Temp.East /= NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(206); -- ╬
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(204); -- ╠
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				Elsif (Temp.East = NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(185); -- ╣
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(186); -- ║
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				End If;
			Elsif (Temp.South = NULL) then
				If (Temp.East /= NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(202); -- ╩
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(200); -- ╚
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				Elsif (Temp.East = NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(188); -- ╝
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(186); -- ║
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				End If;
			End If;
		Elsif (Temp.North = NULL) then
			If (Temp.South /= NULL) then
				If (Temp.East /= NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(203); -- ╦
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(201); -- ╔
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				Elsif (Temp.East = NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(187); -- ╗
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(186); -- ║
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				End If;
			Elsif (Temp.South = NULL) then
				If (Temp.East /= NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(205); -- ═
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(205); -- ═
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				Elsif (Temp.East = NULL) then
					If (Temp.West /= NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(205); -- ═
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					Elsif (Temp.West = NULL) then
						Floor_Map(Temp.Y_Axis, Temp.X_Axis).Chars := Character'Val(219); -- █
						If (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 't') OR
						   (Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color = 's')then
							NULL;
						Else
							Floor_Map(Temp.Y_Axis, Temp.X_Axis).Color := 'd';
						End If;
					End If;
				End If;
			End If;
		End If;
	End If;
	-- After this point, all adjacent rooms will become visible
	If (Show_North = True) Then
		If (Location.North /= NULL) then
			Temp := Location.North;
			Traverse(Temp, Floor_Map, False, False, False, False); -- Calls to assign value
			Temp := Location;
		Else
			If (Temp.Y_Axis = 1) then NULL;
				Else
					Floor_Map(Temp.Y_Axis - 1, Temp.X_Axis).Chars := Character'Val(219); -- █
			End If;
		End If;
	End If;
	If (Show_East = True) Then
		If (Location.East /= NULL) then
			Temp := Location.East;
			Traverse(Temp, Floor_Map, False, False, False, False); -- Calls to assign value
			Temp := Location;
		Else
			If (Temp.X_Axis = Floor_Map'Length(2)) then NULL;
				Else
					Floor_Map(Temp.Y_Axis, Temp.X_Axis + 1).Chars := Character'Val(219); -- █
			End If;
		End If;
	End If;
	If (Show_South = True) Then
		If (Location.South /= NULL) then
			Temp := Location.South;
			Traverse(Temp, Floor_Map, False, False, False, False); -- Calls to assign value
			Temp := Location;
		Else
			If (Temp.Y_Axis = Floor_Map'Length(1)) then NULL;
				Else
					Floor_Map(Temp.Y_Axis + 1, Temp.X_Axis).Chars := Character'Val(219); -- █
			End If;
		End If;
	End If;
	If (Show_West = True) Then
		If (Location.West /= NULL) then
			Temp := Location.West;
			Traverse(Temp, Floor_Map, False, False, False, False); -- Calls to assign value
			Temp := Location;
		Else
			If (Temp.X_Axis = 1) then NULL;
				Else
					Floor_Map(Temp.Y_Axis, Temp.X_Axis - 1).Chars := Character'Val(219); -- █
			End If;
		End If;
	End If;
End Traverse;

---------------------------------------------------------------------------------------------------

Procedure Show_Screen (Location : in out Room_Ptr; Floor_Map : in out Map_Type) is
Temp : Room_Ptr;
X_Offset : Integer := 0;
Y_Offset : Integer := 0;
Level : Integer := 1;
begin
	
   clearDisplay;
   Temp := Location;
   If (Floor_Map'Length(2) = 5) then
		Level := 4;
   Else
		Level := Floor_Map'Length(1) / 10;
	End If;
   if (Level = 1) then
		X_Offset := 67;
		Y_Offset := 11;
   elsif (Level = 2) then
		X_Offset := 57;
		Y_Offset := 6;
   elsif (Level = 3) then
		X_Offset := 50;
		Y_Offset := 0;
	elsif (Level = 4) then
		X_Offset := 69;
		Y_Offset := 11;
   End if;
   setText(1,1, "-----World Map Actions-----", colorWhiteL);
   setText(1,2, "Press 'w' to Move North", colorWhiteL);
   setText(1,3, "Press 'a' to Move West", colorWhiteL);
   setText(1,4, "Press 's' to Move South", colorWhiteL);
   setText(1,5, "Press 'd' to Move East", colorWhiteL);
   setText(1,6, "Press 'i' to Open Inventory", colorWhiteL);
   setText(1,7, "Press 'q' to Quit Game", colorWhiteL);
   setText(123,1, "-------Map Key-------", colorWhiteL);
   setText(136,2, "O", colorMag);
   setText(137,2, " is you", colorWhiteL);
   setText(131,3, Boss_Icon, colorRed); -- Ω
   setText(132,3, " is the boss", colorWhiteL);
   setText(124,4, Statue_Icon, colorYellow);
   setText(125,4, " is an angel statue", colorWhiteL);
   setText(132,5, Chest_Icon, colorYellow);
   setText(133,5, " is a chest", colorWhiteL);
   
   Traverse(Location, Floor_Map);
	for i in 1..Floor_Map'Length(1) loop
		for j in 1..Floor_Map'Length(2) loop
			if (Temp.X_Axis = j) and (Temp.Y_Axis = i) then -- Position Color
				setPixel(j + X_Offset, i + Y_Offset,'O', colorMag);
			else
				if (Floor_Map(i,j).Chars = Boss_Icon) then -- Boss Room Color
					setPixel(j + X_Offset, i + Y_Offset,Floor_Map(i,j).Chars, colorRed); 
				elsif (Floor_Map(i,j).Chars = Character'Val(219)) then -- Wall Color
					setPixel(j + X_Offset, i + Y_Offset,Floor_Map(i,j).Chars, colorBlue);
				Elsif (Floor_Map(i,j).Chars = Character'Val(178)) then -- Unknown Color
					setPixel(j + X_Offset, i + Y_Offset,Floor_Map(i,j).Chars, colorBlackL);
				Else -- Path Color
					If (Floor_Map(i,j).Color = 'd') then
						setPixel(j + X_Offset, i + Y_Offset,Floor_Map(i,j).Chars, colorBlackL);
					Elsif (Floor_Map(i,j).Color = 't') then
						setPixel(j + X_Offset, i + Y_Offset,Floor_Map(i,j).Chars, colorGreen);
					Elsif (Floor_Map(i,j).Color = 's') then
						setPixel(j + X_Offset, i + Y_Offset,Floor_Map(i,j).Chars, colorYellow);
					End If;
				End If;
			end if;
		end loop;
		new_Line;
	end loop;
	--Refresh;
end Show_Screen;   
---------------------------------------------------------------------------------------------------
Procedure Generate (Level : in Integer) is
Random : Integer;
begin
	Random := RandomRange(3);
	If (Level = 1) Then
		If (Random = 1) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_1/Lvl_1_a.txt");
		Elsif (Random = 2) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_1/Lvl_1_b.txt");
		Elsif (Random = 3) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_1/Lvl_1_c.txt");
		End If;
	End If;
	If (Level = 2) Then
		If (Random = 1) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_2/Lvl_2_a.txt");
		Elsif (Random = 2) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_2/Lvl_2_b.txt");
		Elsif (Random = 3) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_2/Lvl_2_c.txt");
		End If;
	End If;
	If (Level = 3) Then
		If (Random = 1) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_3/Lvl_3_a.txt");
		Elsif (Random = 2) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_3/Lvl_3_b.txt");
		Elsif (Random = 3) then
			Open(File => Map_File, Mode => In_File, Name => "Maps/Level_3/Lvl_3_c.txt");
		End If;
	End If;
	If (Level = 4) Then
		Open(File => Map_File, Mode => In_File, Name => "Maps/Level_4/Lvl_4.txt");
	End If;
End Generate;
---------------------------------------------------------------------------------------------------
Procedure Initialize (Level : in out Coords; Start : Out Room_Ptr) is
Floor : Integer;
begin
	If (Level'Length(2) = 5) then
		Floor := 4;
	Else
		Floor := Level'Length(1) / 10; -- Determine Level by Size of Map
	End If;
	Generate(Floor);
	For i in 1..Level'Length(1) Loop -- Outer Loop for Y-Axis
		For j in 1..Level'Length(2) Loop -- Inner Loop for X-Axis
			Get(File => Map_File, Item => Level(i,j)); -- Row Dominant, (y,x)
			--Put(Level(i,j), Width => 0);
		End Loop;
		If Not End_of_File (Map_File) then -- Checks for End of File
			Skip_Line(Map_File); -- Moves to Next Line
		end If;
		New_Line;
	End Loop;
	Close(Map_File);
	Start := new Room'(North => NULL, East => NULL, South => NULL, West => NULL,
					   Y_Axis => Level'Length(1), X_Axis => (Level'Length(2) / 2 + 1),
					   Item => -1, Statue => False, Boss => False, Traversed => False, Set => False);	
end Initialize;
---------------------------------------------------------------------------------------------------
Procedure Alter (Layout : in Coords; Area : in out Room_Ptr; Map : in out Map_Type) is
Level : Integer;
Items_1 : Item_Set := (14, 15, 16, 17, 18, 19, 20, 07, 06, 21, Others => 0); -- 11
Items_2 : Item_Set := (14, 15, 16, 17, 18, 19, 20, 07, 01, 02, 03, 04, 05, 06, 21, 08, 09, 10, 11, 12, 13, 22, 23, 30, Others => 0); -- 24
Items_3 : Item_Set := (14, 15, 16, 17, 18, 19, 20, 07, 01, 02, 03, 04, 05, 06, 21, 08, 09, 10, 11, 12, 13, 22, 23, 30, 24, 25, 26, 27, 28, 29); -- 30
begin
	If (Map'Length(2) = 5) then
		Level := 4;
	Else
		Level := Map'Length(1) / 10; -- Determine Level by Size of Map
	End If;
	If (Layout((Area.Y_Axis),(Area.X_Axis)) = 2) Then -- Item
		If (Level = 1) then -- Only Get Level 1 Items
			Area.Item := Items_1(RandomRange(11));
		Elsif (Level = 2) then -- Only Get Level 2 Items
			Area.Item := Items_2(RandomRange(24));
		Elsif (Level = 3) then -- Only Get Level 3 Items
			Area.Item := Items_3(RandomRange(30));
		Else -- Level 4 Items
			Area.Item := Items_3(RandomRange(30));
		End If;
		Map((Area.Y_Axis),(Area.X_Axis)).Color := 'd';
	Elsif (Layout((Area.Y_Axis),(Area.X_Axis)) = 9) Then -- Boss
		Area.Boss := True;
		Map((Area.Y_Axis),(Area.X_Axis)).Chars := Boss_Icon; -- Ω
		Map((Area.Y_Axis),(Area.X_Axis)).Color := 'b';
	Elsif (Layout((Area.Y_Axis),(Area.X_Axis)) = 3) Then -- Statue
		Area.Statue := True;
		Map((Area.Y_Axis),(Area.X_Axis)).Color := 'd';
	End If;
End Alter;
---------------------------------------------------------------------------------------------------
Procedure Link(Level : in out Coords; Current : in out Room_Ptr; Map : in out Map_Type) is
	Key : Room; -- Used for Finding if a Room Exists at a Specific Coordinate
	Temp : Room_Ptr; -- Will Point to Key
	Found : Boolean := False; -- Triggers if Key is Found
Begin
	Begin -- Checking for Rooms North
		If ((Level(Current.Y_Axis - 1, Current.X_Axis) /= 0) AND (Current.North = NULL)) Then -- Room Should Exist to North
			Key.Y_Axis := Current.Y_Axis - 1; -- Declaring the Map Coordinates
			Key.X_Axis := Current.X_Axis; -- Declaring the Map Coordinates
			Search(Current, Key, Temp, Found); -- Sees if the Key Has Already Been Made
			Reset(Current); -- Resets Traversed Flags
			If (Found = False) then -- Making New Room to North
				Current.North := New Room'(North => NULL, East => NULL, South => Current, West => NULL, Y_Axis => Current.Y_Axis - 1,
				X_Axis => Current.X_Axis, Item => -1, Statue => False, Boss => False, Traversed => False, Set => False);
				Alter(Level, Current.North, Map);
			Elsif (Found = True) then -- Linking to Room North
				Current.North := Temp;
				Current.North.South := Current;
				Found := False; -- Reset Flag
			End If;
		End If;
		Exception
			When Constraint_Error => NULL;
	End;
	Begin -- Checking for Rooms South
		If ((Level(Current.Y_Axis + 1, Current.X_Axis) /= 0) AND (Current.South = NULL)) then -- Room Should Exist to South
		   -- Put_Line("South Shows 1");
			Key.Y_Axis := Current.Y_Axis + 1; -- Declaring the Map Coordinates
			Key.X_Axis := Current.X_Axis;  -- Declaring the Map Coordinates
			Search(Current, Key, Temp, Found); -- Sees if the Key Has Already Been Made
			Reset(Current); -- Resets Traversed Flags
			If (Found = False) then -- Making New Room to South
				Current.South := New Room'(North => Current, East => NULL, South => NULL, West => NULL, Y_Axis => Current.Y_Axis + 1,
				X_Axis => Current.X_Axis, Item => -1, Statue => False, Boss => False, Traversed => False, Set => False);
				Alter(Level, Current.South, Map);
			Elsif (Found = True) then -- Linking to Room South
				Current.South := Temp;
				Current.South.North := Current;
				Found := False; -- Reset Flag
			End If;
		End If;
		Exception
			When Constraint_Error => NULL;
	End;
	Begin -- Checking for Rooms East
		If ((Level(Current.Y_Axis, Current.X_Axis + 1) /= 0) AND (Current.East = NULL)) then -- Room Should Exist to East
			--Put_Line("East Shows 1");
			Key.Y_Axis := Current.Y_Axis; -- Declaring the Map Coordinates
			Key.X_Axis := Current.X_Axis + 1;  -- Declaring the Map Coordinates
			Search(Current, Key, Temp, Found); -- Sees if the Key Has Already Been Made
			Reset(Current); -- Resets Traversed Flags
			If (Found = False) then -- Making New Room to East
				Current.East := New Room'(North => NULL, East => NULL, South => NULL, West => Current, Y_Axis => Current.Y_Axis,
				X_Axis => Current.X_Axis + 1, Item => -1, Statue => False, Boss => False, Traversed => False, Set => False);
				Alter(Level, Current.East, Map);
			Elsif (Found = True) then -- Linking to Room East
				Current.East := Temp;
				Current.East.West := Current;
				Found := False; -- Reset Flag
			End If;
		End If;
		Exception
			When Constraint_Error => NULL;
	End;
	Begin -- Checking for Rooms West
		If ((Level(Current.Y_Axis, Current.X_Axis - 1) /= 0) AND (Current.West = NULL)) then -- Room Should Exist to West
			--Put_Line("West Shows 1");
			Key.Y_Axis := Current.Y_Axis; -- Declaring the Map Coordinates
			Key.X_Axis := Current.X_Axis - 1;  -- Declaring the Map Coordinates
			Search(Current, Key, Temp, Found); -- Sees if the Key Has Already Been Made
			Reset(Current); -- Resets Traversed Flags
			If (Found = False) then -- Making New Room West
				Current.West := New Room'(North => NULL, East => Current, South => NULL, West => NULL, Y_Axis => Current.Y_Axis,
				X_Axis => Current.X_Axis - 1, Item => -1, Statue => False, Boss => False, Traversed => False, Set => False);
				Alter(Level, Current.West, Map);
			Elsif (Found = True) then -- Linking Room West
				Current.West := Temp;
				Current.West.East := Current;
				Found := False; -- Reset Flag
			End If;
		End If;
		Exception
			When Constraint_Error => NULL;
	End;
	Current.Set := True; -- Makes sure no room is visited twice
	If (Current.North /= NULL) AND then (Current.North.Set = False) then -- Recursive Call North
		Link(Level,Current.North, Map);
	End If;
	If (Current.East /= NULL) AND then (Current.East.Set = False) then  -- Recursive Call East
		Link(Level,Current.East, Map);
	End If;
	If (Current.South /= NULL) AND then (Current.South.Set = False) then  -- Recursive Call South
		Link(Level,Current.South, Map);
	End If;
	If (Current.West /= NULL) AND then (Current.West.Set = False) then  -- Recursive Call West
		Link(Level,Current.West, Map);
	End If;
End Link;
---------------------------------------------------------------------------------------------------
procedure Free is new Ada.Unchecked_Deallocation(Object => Room, Name => Room_Ptr);
-- Grabage Collection
---------------------------------------------------------------------------------------------------
Procedure Delete_Map (Location :  in out Room_Ptr) is
Temp : Room_Ptr;
Begin
	Temp := Location;
	Temp.Traversed := True;
		If (Location.North /= NULL) AND Then (Location.North.Traversed = False) then
			Temp := Location.North;
			Temp.Traversed := True;
			Delete_Map(Temp);
		End If;
		If (Location.East /= NULL) AND Then (Location.East.Traversed = False) then
			Temp := Location.East;
			Temp.Traversed := True;
			Delete_Map(Temp);
		End If;
		If (Location.South /= NULL) AND Then (Location.South.Traversed = False) then
			Temp := Location.South;
			Temp.Traversed := True;
			Delete_Map(Temp);
		End If;
		If (Location.West /= NULL) AND Then(Location.West.Traversed = False) then
			Temp := Location.West;
			Temp.Traversed := True;
			Delete_Map(Temp);
		End If;
		Free(Location);

End Delete_Map;

---------------------------------------------------------------------------------------------------
End game_map;
