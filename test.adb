with Ada.Text_IO, Ada.Integer_Text_IO, display, stats, player, inventory_list, Game_Map;
use Ada.Text_IO, Ada.Integer_Text_IO, display, stats, player, inventory_list, Game_Map;

procedure test is
    User : Character := 'o';
	Level_1 : Coords(1..10, 1..10);
	Level_2 : Coords(1..20, 1..30);
	Level_3 : Coords(1..30, 1..50);
	Position : Room_Ptr;
	Map_1 : Map_Type := (1..10 => (1..10 => (Others => Character'Val(178))));
	Map_2 : Map_Type := (1..20 => (1..30 => (Others => Character'Val(178))));
	Map_3 : Map_Type := (1..30 => (1..50 => (Others => Character'Val(178))));
	Destroyed: Integer := 0;
	My_Player : Player_Type;
begin
Initialize(50, 30); -- Mark's Display System (Opposite My Coords)
Instantiate;
clearCharacter(My_Player);
Initialize(Level_3, Position);
Link(Level_3, Position, map_3);
WipeScreen;
Show_Screen(Position, map_3);
 while (User /= 'q') loop
   Get_Immediate(User);
   If (User = 'w') then
      Move_North(Position, map_3, My_Player);
   elsif (User = 'a') then
      Move_West(Position, map_3, My_Player);
   elsif (User = 's') then
      Move_South(Position, map_3, My_Player);
   elsif (User = 'd') then
      Move_East(Position, map_3, My_Player);
   end if;
 If (Empty(Position)) then
	Show_Screen(Position, map_3);
	Print(Position, map_3);

Else
	Put_Line("Map has been deleted!");
End If;
end loop;
end test;
