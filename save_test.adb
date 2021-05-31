with Ada.Integer_Text_IO;  	Use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;  	Use Ada.Float_Text_IO;
with Ada.Text_IO;			Use Ada.Text_IO;
with inventory_list;		Use inventory_list;
with player;				Use player;
with save_load_game;		Use save_load_game;

Procedure save_test is
	
	bob : Player_Type;
	
begin

	clearCharacter(bob);
	
	saveGame(bob, 1, 1);
	saveGame(bob, 1, 2);
	saveGame(bob, 1, 3);
	
end save_test;
