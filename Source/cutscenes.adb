with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with display; use display;
with stats; use stats;
with player; use player;

package body Cutscenes is

	procedure Display_Settings is
		input : Character;
	begin
		ClearDisplay;
		WipeScreen;
		SetText(1,22,"Please take these following steps to fully enjoy the game:", colorGreen);
		SetText(1,24,"  1) Right click the PuTTY title bar" , colorDefault);
		SetText(1,25,"  2) Click 'Change Settings...'" , colorDefault);
		SetText(1,26,"  3) Select 'Appearance'" , colorDefault);
		SetText(1,27,"  4) Change the font to 'Terminal' with any size" , colorDefault);
		SetText(1,28,"  5) Go to 'Translation'" , colorDefault);
		SetText(1,29,"  6) Change the character set to 'use font encoding'" , colorDefault);
		SetText(1,30,"  7) Apply, then maximize the window" , colorDefault);
		SetText(1,32,"After all is set, press any key to start the game." , colorGreenL);
		refresh;
		get_immediate(input);
		ClearDisplay;
		refresh;
	end Display_Settings;

	procedure Display_Opening is
		input : Character;
	begin
		ClearDisplay;
		WipeScreen;
		SetText(1,23,"You awaken in a dark and slimy dungeon, anware of what happened to you.", colorBlackL);
		SetText(1,24,"Your body buckles underneath your own weight. You collapse once more." , colorBlackL);
		SetText(1,25,"Suddenly, you hear scratching in the distance..." , colorDefault);
		SetText(1,26,"Your senses sharpen with each passing second." , colorDefault);
		SetText(1,27,"Unfamiliar with your surroundings, your body begins to tremor in fear." , colorRed);
		SetText(1,28,"You vow to scour this dungeon and find those responsible!" , colorRed);
		Flush;
		refresh;
		get_immediate(input);
		ClearDisplay;
		refresh;
	end Display_Opening;

	procedure Display_Credits is
		input : Character;
	begin
		ClearDisplay;
		WipeScreen;
		SetText(1,23,"You find a large set of keys in one of the fallen elders' robes.", colorRed);
		SetText(1,24,"You push the key in the huge door behind the now vacant throne." , colorRed);
		SetText(1,25,"The door swings open..." , colorDefault);
		SetText(1,26,"And you are bathed in warm sunlight." , colorDefault);
		SetText(1,27,"You have finally escaped the Dungeon..." , colorBlackL);
		SetText(1,28,"You are free!" , colorBlackL);
		Flush;
		refresh;
		get_immediate(input);
		ClearDisplay;
		refresh;
		WipeScreen;
		SetText(1,23,"Thank You for Playing!");
		SetText(1,24,"    Mathew Moose");
		SetText(1,25,"     Ryan Bost");
		SetText(1,26,"    Mark Bambino");
		Flush;
		refresh;
		get_immediate(input);
		ClearDisplay;
		refresh;
	end Display_Credits;
	
end Cutscenes;
