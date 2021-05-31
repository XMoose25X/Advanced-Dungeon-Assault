with Ada.Text_IO, Ada.Integer_Text_IO, display, stats, player;
use Ada.Text_IO, Ada.Integer_Text_IO, display, stats, player;

Procedure game is

	procedure settings is
	
		input : character;
	
	begin
	
		ClearDisplay;
		WipeScreen;
		SetText(1,22,"Please take these following steps to fully enjoy the game:", colorGreen);
		SetText(1,24,"  1) Right click the PuTTY title bar" , colorDefault);
		SetText(1,25,"  2) Click 'Change Settings...'" , colorDefault);
		SetText(1,26,"  3) Select 'Appearance'" , colorDefault);
		SetText(1,27,"  4) Change the font to 'Terminal' 14pt" , colorDefault);
		SetText(1,28,"  5) Go to 'Translation'" , colorDefault);
		SetText(1,29,"  6) Change the character set to 'use font encoding'" , colorDefault);
		SetText(1,30,"  7) Apply, then maximize the window" , colorDefault);
		SetText(1,32,"After all is set, press any key to start the game." , colorGreenL);
		
		refresh;
		
		get_immediate(input);
		
		ClearDisplay;
		
		refresh;
	
	end settings;

begin
	
	settings;
	
end game;
