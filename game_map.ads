With Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO, player, inventory_list, stats, Ada.Unchecked_Deallocation;
Use  Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO, player, inventory_list, stats;
---------------------------------------------------------------------------------------------------
Package game_map is
---------------------------------------------------------------------------------------------------
-- Mathew Moose, Mark Bambino, Ryan Boast
-- Map Package
---------------------------------------------------------------------------------------------------
Type Room_Ptr is Private;

Type Coords is Array (Integer Range <>, Integer Range <>) of Integer;

Type Map_Stuff is Record
	Chars : Character;
	Color : Character;
End Record;

Type Map_Type is Array (Integer Range <>, Integer Range <>) of Map_Stuff;

Boss_Icon : Character := Character'Val(234); -- Ω
Chest_Icon : Character := Character'Val(236); -- ∞
Statue_Icon : Character := 't';
Function Empty (Position : in Room_Ptr) Return Boolean;
Procedure Print(Current : in Room_Ptr; Map : in Map_Type);
Procedure Move_North (Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer);
Procedure Move_East (Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer);
Procedure Move_South (Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer);
Procedure Move_West (Pos : in out Room_Ptr; Map : in out Map_Type; My_Player : in out Player_Type; RoomID : out Integer);
Procedure Initialize (Level : in out Coords; Start : Out Room_Ptr);
Procedure Link(Level : in out Coords; Current : in out Room_Ptr; Map : in out Map_Type);
Procedure Traverse (Location :  in Room_Ptr; Floor_Map : in out Map_Type; Show_North : in Boolean := True;
					Show_East : in Boolean := True; Show_South : in Boolean := True; Show_West : in Boolean := True);
Procedure Show_Screen (Location : in out Room_Ptr; Floor_Map : in out Map_Type);
Procedure Delete_Map (Location :  in out Room_Ptr);
---------------------------------------------------------------------------------------------------
Private 

Type Room;
Type Room_Ptr is access Room;
Type Room is record
	North     : Room_Ptr;
	East      : Room_Ptr;
	South     : Room_Ptr;
	West      : Room_Ptr;
	Y_Axis    : Integer;
	X_Axis    : Integer;
	Item	  : Integer;
	Statue	  : Boolean := False;
	Boss	  : Boolean := False;
	Traversed : Boolean := False;
	Set       : Boolean := False;
End Record;
end game_map;
