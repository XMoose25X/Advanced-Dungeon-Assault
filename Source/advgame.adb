with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with display; use display;
with stats; use stats;
with player; use player;
with game_map; use game_map;
with inventory_list; use inventory_list;
with save_load_game; use save_load_game;
with Cutscenes; use Cutscenes;

procedure advgame is
	--Room Stuff
	User : Character := 'o';
	bossBattle : Boolean := false;
	finalBattle : Boolean := false;
	Level_1 : Coords(1..10, 1..10);
	Level_2 : Coords(1..20, 1..30);
	Level_3 : Coords(1..30, 1..50);
	Level_4 : Coords(1..10,  1..5);
	Position : Room_Ptr;
	Map_1 : Map_Type := (1..10 => (1..10 => (Others => Character'Val(178))));
	Map_2 : Map_Type := (1..20 => (1..30 => (Others => Character'Val(178))));
	Map_3 : Map_Type := (1..30 => (1..50 => (Others => Character'Val(178))));
	Map_4 : Map_Type := (1..10 => (1..5  => (Others => Character'Val(178))));
	Destroyed: Integer := 0;
	-- End Room Stuff
	RoomID : Integer := -1;
	SpriteDir : String := "Sprites/";
	EnemyPath : String := "Enemies/";
	INVALID_INPUT : Exception;
	input : Character := ASCII.ESC;
	battleCommand : Integer := -1;
	slot : Integer := 1;
	lastSlot : Integer := 1;
	slotID : Integer;
	level : integer := 1;
	textBoxHeight : constant Positive := 8;
	arrow : SpriteType := LoadSprite(SpriteDir & "arrow.sprite");
	inBattle : Boolean := false;
	inBackpack : Boolean := false;
	target : Integer := 1;
	damage : Integer;
	xpGain : Integer := 0;
	lvGain : Integer := 0;
	subtype nameType is String(1..16);
	-- keyArrowUp : constant character := character'val(65);
	-- keyArrowDown : constant character := character'val(66);
	-- keyArrowLeft : constant character := character'val(68);
	-- keyArrowRight : constant character := character'val(67);
	keyArrowUp : constant character := 'w';
	keyArrowDown : constant character := 's';
	keyArrowLeft : constant character := 'a';
	keyArrowRight : constant character := 'd';
	--enemy type
	Type enemyType is record
		Name : nameType := "MissingNo       ";
		NameLen : Integer;
		Sprite : SpriteType;
		Stats : statType;
	end record;
	playerChar : player_type;
	enemy : array(1..3) of enemyType;
	--event display
	subtype eventString is string(1..110);
	type textArray is array (1..textBoxHeight-1) of eventString;
	eventText : textArray;
---------------------------------------------------------------------------------------------------	
	--adds event to text display
	procedure addEvent(event : String) is
	begin
		eventText(1) := eventText(2);
		for I in 2..eventText'length-1 loop
			eventText(I) := eventText(I+1);
		end loop;
		eventText(eventText'Length) := (1..eventString'length => ' ');
		eventText(eventText'length)(1..event'Length) := event;
	end addEvent;
---------------------------------------------------------------------------------------------------	
	--sets an enemy into the identified slot
	procedure clearEnemies is
	begin
		for I in 1..3 loop
			enemy(I).name := "MissingNo       ";
			enemy(I).stats.HP := 0;
		end loop;
	end clearEnemies;
---------------------------------------------------------------------------------------------------	
	function setEnemy(enemyFileLoc : String; addLevels : Integer := 0) return enemyType is
		enemyFile : File_Type;
		enemyName : nameType;
		NameLen : Integer;
		newEnemy : enemyType;
		tempInt : Integer;
		spriteLoc : String(1..100);
	begin
		--load enemy
		--put(enemyFileLoc);--debug
		Open(enemyFile, In_File, enemyFileLoc);
		--put("got here");--debug
		Get_Line(enemyFile, enemyName, NameLen);
		newEnemy.name := "                ";
		newEnemy.name(1..NameLen) := enemyName(1..NameLen);
		newEnemy.nameLen := NameLen;
		--Put(newEnemy.name);--debug
		get_line(enemyFile, spriteLoc, NameLen);
		--put(SpriteDir & spriteLoc(1..NameLen));--debug
		newEnemy.sprite := LoadSprite(SpriteDir & spriteLoc(1..NameLen));
		--Put("Got Here");--debug
		--set enemy stats
		get(enemyFile, tempInt);--hp
			newEnemy.stats.HP := tempInt;
			newEnemy.stats.MaxHP := tempInt;
		get(enemyFile, tempInt);--magic
			newEnemy.stats.Magic := tempInt;
			newEnemy.stats.MaxMag := tempInt;
		get(enemyFile, newEnemy.stats.Attack);--ATK
		get(enemyFile, newEnemy.stats.Defense);--DEF
		get(enemyFile, newEnemy.stats.Agility);--AGT
		get(enemyFile, newEnemy.stats.Level);--LV
		--set enemy experience
		newEnemy.stats.XP := addLevels * 100;
		battleCommand := -1;
		inBattle := true;
		close(enemyFile);
		return newEnemy;
	end setEnemy;
---------------------------------------------------------------------------------------------------
	--get Boss from file
	procedure findBoss(path : String) is
		eFile : File_Type;
		slot : Integer;
		eName : String(1..25);
		nameL : Integer;
		dummy : Character;
	begin
		Open(eFile, in_file, path & "/_boss.list");
		clearEnemies;
		addEvent(Get_Line(eFile));
			for I in 1..3 loop
				get(eFile, slot);
				get(eFile, dummy);
				Get_Line(eFile,eName, nameL);
				enemy(slot) := setEnemy(path & "/" & eName(1..nameL), 0);
				inBattle := true;
				exit when end_of_file(eFile);
			end loop;
		bossBattle := true;
		close(eFile);
		--reset cursor
		for I in 1..3 loop
			target := target+1;
			if(target > 3) then
				target := 1;
			end if;
			--check if slot exists
			if(enemy(target).name /= "MissingNo       ") then
				exit;
			end if;
		end loop;
	end findBoss;
---------------------------------------------------------------------------------------------------	
	--get enemies from file
	procedure findEnemies(path : String) is
		eFile : File_Type;
		chance, lv : Integer;
		eName : String(1..25);
		nameL : Integer;
		eNum : Integer := RandomRange(23)/10 + 1;
		dummy : Character;
	begin
		for I in 1..eNum loop
			Open(eFile, in_file, path & "/_enemies.list");
				loop
					get(eFile, chance);
					get(eFile, lv);
					get(eFile, dummy);
					Get_Line(eFile,eName, nameL);
				exit when end_of_file(eFile);
					if (RandomRange(100) < chance) then
						enemy(I) := setEnemy(path & "/" & eName(1..nameL), lv);
					end if;
				end loop;
				addEvent("You encountered a " & enemy(I).name(1..enemy(I).nameLen) & "!");
			close(eFile);
		end loop;
		--reset cursor
		for I in 1..3 loop
			target := target+1;
			if(target > 3) then
				target := 1;
			end if;
			--check if slot exists
			if(enemy(target).name /= "MissingNo       ") then
				exit;
			end if;
		end loop;		
		bossBattle := false;
	end findEnemies;
---------------------------------------------------------------------------------------------------	
	procedure clearEvents is
	begin
		for I in 1..eventText'length loop
			addEvent(" ");
		end loop;
	end clearEvents;
---------------------------------------------------------------------------------------------------	
	procedure showBorders is
	begin
		For X in 0..Screen_Width loop
			setPixel(X,0,Char_BorderH,colorDefault);
			setPixel(X,Screen_Height-textBoxHeight,Char_BorderH,colorDefault);
			setPixel(X,Screen_Height,Char_BorderH,colorDefault);
		end loop;
		For Y in 0..Screen_Height loop
			setPixel(0,Y,Char_BorderV,colorDefault);
			setPixel(Screen_Width,Y,Char_BorderV,colorDefault);
		end loop;
		--draw stats
		for Y in Screen_Height-textBoxHeight+1..Screen_Height-1 loop
			setPixel(Screen_Width-20, Y, Char_BorderV,colorDefault);
		end loop;
		setText(Screen_Width-19, Screen_Height-textBoxHeight+1,
			"HP :" & Integer'Image(playerChar.stats.HP) & "/" & Integer'Image(playerChar.stats.MaxHP));
		setText(Screen_Width-19, Screen_Height-textBoxHeight+2,
			"Mag:" & Integer'Image(playerChar.stats.Magic) & "/" & Integer'Image(playerChar.stats.MaxMag));
		setText(Screen_Width-19, Screen_Height-textBoxHeight+3,
			"A/D:" & Integer'Image(playerChar.stats.attack) & " / " & Integer'Image(playerChar.stats.Defense));
		setText(Screen_Width-19, Screen_Height-textBoxHeight+4,
			"Agt:" & Integer'Image(playerChar.stats.agility));
		setText(Screen_Width-19, Screen_Height-textBoxHeight+5,
			"XP :" & Integer'Image(playerChar.stats.XP));
		setText(Screen_Width-19, Screen_Height-textBoxHeight+6,
			"Lv :" & Integer'Image(playerChar.stats.level));
		--set corners
		setPixel(0,0,character'val(201),colorDefault);
		setPixel(Screen_Width,0,character'val(187),colorDefault);
		setPixel(0,Screen_Height-textBoxHeight,character'val(204),colorDefault);
		setPixel(Screen_Width,Screen_Height-textBoxHeight,character'val(185),colorDefault);
		setPixel(0,Screen_Height,character'val(200),colorDefault);
		setPixel(Screen_Width,Screen_Height,character'val(188),colorDefault);
		--set event text
		for I in 1..eventText'Length loop
			SetText(2, Screen_Height - textBoxHeight + I, eventText(I));
		end loop;
	end showBorders;
---------------------------------------------------------------------------------------------------	
	procedure drawEnemies is
		Offset : Integer := Screen_Width/3;
		eOffs : Integer;
	begin
		For I in 1..3 loop
			if(enemy(I).stats.hp > 0) then
				eOffs := 1+(Screen_Width/3 - (enemy(I).sprite.Width)+1)/2;
				setSprite(Offset*(I-1) + eOffs, 7, enemy(I).sprite);--set x and y
				setText(Offset*(I-1) + Screen_Width/6, 4, enemy(I).name(1..Enemy(I).nameLen), colorYellowI);
				setText(Offset*(I-1) + Screen_Width/6, 5,
					"HP: " & Integer'Image(enemy(I).stats.HP) & "/" & Integer'Image(enemy(I).stats.MaxHP), colorGreenI);
			end if;
		end loop;
	end drawEnemies;
---------------------------------------------------------------------------------------------------
	procedure inventoryScreen is
	begin
		input := 'o';
		clearEvents;
		addEvent("W: Up   S: Down   SPACE: Equip/Use   I: Exit Inventory");
		if inBattle = true then
			battleCommand := 0;
		end if;
		while (input /= 'i') loop
			inBackpack := True;
			clearDisplay;
			if getSlotName(playerChar.backpack, 1) = "        Inventory Empty" then
				slot := 1;
				lastSlot := 1;
				setText(3,2, "        Inventory Empty");
			else
				for i in 1..30 loop  --Display Inventory List
					lastSlot := i-1;
					exit when getSlotName(playerChar.backpack, i) = "0";
					setText(3,1+i, getSlotName(playerChar.backpack, i));
				end loop;
			end if;
			setText(100, 2, "       --Equipment--");
			setText(100, 3, "Weapon:      ");
			setText(100, 4, "Helmet:      ");
			setText(100, 5, "Chest Armor: ");
			setText(100, 6, "Gauntlets:   ");
			setText(100, 7, "Leg Armor:   ");
			setText(100, 8, "Boots:       ");
			setText(113, 3, playerChar.weapon.name);
			setText(113, 4, playerChar.helmet.name);
			setText(113, 5, playerChar.chestArmor.name);
			setText(113, 6, playerChar.gauntlets.name);
			setText(113, 7, playerChar.legArmor.name);
			setText(113, 8, playerChar.boots.name);
			setText(2,slot+1, ">");  --Display Selection Arrow
			showBorders;
			refresh;
			get_immediate(input);
			if (input = keyArrowUp) then --Move Arrow  Up
				slot := slot - 1;
				if slot = 0 then
					slot := lastSlot;
				end if;
			elsif (input = keyArrowDown) then --Move Arrow Down
				slot := slot + 1;
				if slot > lastSlot then
					slot := 1;
				end if;
			elsif (input = ' ') then --Select Item with Space
				slotID := getSlotID(playerChar.backpack, slot);
				--put(slotID);
				equipOrUse(slotID, playerChar);
				lastSlot := lastSlot - 1;
				if inBattle = true and slotID /= -1 then
					battleCommand := 3;
				end if;
				if slot > lastSlot then
					slot := 1;
				end if;
			end if;
			clearDisplay;
		end loop;
		input := 'o';
		inBackpack := false;
		slot :=1;
	end inventoryScreen;
---------------------------------------------------------------------------------------------------	
	procedure nextDungeon is
	begin
		
		Level := Level + 1;
		if (Level = 2) then
			Delete_Map(Position); -- Free Old Map
			Initialize(Level_2, Position);
			Link(Level_2, Position, Map_2);
		elsif (Level = 3) then
			Delete_Map(Position); -- Free Old Map
			Initialize(Level_3, Position);
			Link(Level_3, Position, Map_3);
		elsif (Level = 4) then
			Delete_Map(Position); -- Free Old Map
			Initialize(Level_4, Position);
			Link(Level_4, Position, Map_4);
		end if;	
	end nextDungeon;
---------------------------------------------------------------------------------------------------	
	function titleScreen return character is
		response : character := 'o';
		titlePic : spriteType := LoadSprite(SpriteDir & "title.sprite");
	begin
		loop
			ClearDisplay;
			ClearEvents;
			setSprite(1, 1, titlePic);
			refresh;
			for i in 1..7 Loop
				put_line("                                      ");
			End Loop;
			put("  N: New Game, L: Load Game, X: Quit  ");
			new_line;
			put("                                      ");
			new_line;
			get_immediate(response);
			If response = 'X' OR response = 'x'  OR 
				response = 'N' OR response = 'n'  OR 
				response = 'l' OR response = 'L' then
				Return response;
			End If;
		End Loop;
	end titleScreen;
---------------------------------------------------------------------------------------------------
begin
	put(ASCII.ESC & "[?25l"); -- cursor off (?25h for on)
	Instantiate; -- Random Number Generation
	--set text box to blank
	for I in 1..textArray'length loop
		addEvent("    ");
	end loop;

	setStats(playerChar.stats, 10, 10, 8, 0, 20, 0);	--initialize player stats

	Initialize(145,39);--initialize the screen
	Put(ASCII.ESC & "[2J");--reset cursor to 0,0

	-- TestSprite := LoadSprite("Enemies/dragon.sprite");
	-- Sprite2 := LoadSprite("Enemies/test.sprite");
	-- Sprite3 := LoadSprite("Enemies/Rainbow.sprite");
	refresh;
	Display_Settings;
	input := titleScreen;
	if input = 'X' OR input = 'x' then
		return;
	elsif input = 'L' OR input = 'l' then
			ClearDisplay;
			ClearEvents;
			refresh;
			for i in 1..7 Loop
				put_line("                                      ");
			End Loop;
			put("Save File 1, 2, or 3?                 ");
			new_line;
			put("                                      ");
			new_line;
			loop
			get_immediate(input);
				if input = '1' then
					loadGame(playerChar, level, 1);
					if level = 1 then
						Initialize(Level_1, Position);
						Link(Level_1, Position, Map_1);
					elsif level = 2 then
						Initialize(Level_2, Position);
						Link(Level_2, Position, Map_2);
					elsif level = 3 then
						Initialize(Level_3, Position);
						Link(Level_3, Position, Map_3);
					elsif level = 4 then
						Initialize(Level_4, Position);
						Link(Level_4, Position, Map_4);
					end if;
					exit;
				elsif input = '2' then
					loadGame(playerChar, level, 2);
					if level = 1 then
						Initialize(Level_1, Position);
						Link(Level_1, Position, Map_1);
					elsif level = 2 then
						Initialize(Level_2, Position);
						Link(Level_2, Position, Map_2);
					elsif level = 3 then
						Initialize(Level_3, Position);
						Link(Level_3, Position, Map_3);
					elsif level = 4 then
						Initialize(Level_4, Position);
						Link(Level_4, Position, Map_4);
					end if;
					exit;
				elsif input = '3' then
					loadGame(playerChar, level, 3);
					if level = 1 then
						Initialize(Level_1, Position);
						Link(Level_1, Position, Map_1);
					elsif level = 2 then
						Initialize(Level_2, Position);
						Link(Level_2, Position, Map_2);
					elsif level = 3 then
						Initialize(Level_3, Position);
						Link(Level_3, Position, Map_3);
					elsif level = 4 then
						Initialize(Level_4, Position);
						Link(Level_4, Position, Map_4);						
					end if;
					exit;
				end if;
			end loop;
			for i in 1..12 Loop
				put_line("                                      ");
			End Loop;
			new_line;
			Display_Opening;
			refresh;
		else -- New Game Started
		ClearDisplay;
		ClearEvents;
		refresh;
		clearCharacter(playerChar);
		Initialize(Level_1, Position);
		Link(Level_1, Position, Map_1);
			for i in 1..9 Loop
				put_line("                                      ");
			End Loop;
			new_line;
		Display_Opening;
		refresh;
	end if;
	loop
		if(input = 'q') then
			clearDisplay;
			SetText(16, 16, "Do you really want to quit? (Y/N)");
			refresh;
			while(input /= 'y' and input /= 'n') loop
				Get_Immediate(input);
			end loop;
			
			if(input = 'y') then
				exit;
			end if;
		end if;
		--if world map
		if(inBattle = False AND inBackpack = False) then
			clearDisplay;
			showBorders;
			if level = 1 then
				Show_Screen(Position, map_1);
			elsif level = 2 then
				Show_Screen(Position, map_2);
			elsif level = 3 then
				Show_Screen(Position, map_3);
			elsif level = 4 then
				Show_Screen(Position, map_4);
			end if;
			while (Input /= 'q') loop
				If (Input = keyArrowUp) then
					if level = 1 then
						Move_North(Position, map_1, playerChar, RoomID);
					elsif level = 2 then
						Move_North(Position, map_2, playerChar, RoomID);
					elsif level = 3 then
						Move_North(Position, map_3, playerChar, RoomID);
					elsif level = 4 then
						Move_North(Position, map_4, playerChar, RoomID);
					end if;
				elsif (Input = keyArrowLeft) then
					if level = 1 then
						Move_West(Position, map_1, playerChar, RoomID);
					elsif level = 2 then
						Move_West(Position, map_2, playerChar, RoomID);
					elsif level = 3 then
						Move_West(Position, map_3, playerChar, RoomID);
					elsif level = 4 then
						Move_West(Position, map_4, playerChar, RoomID);
					end if;
				elsif (Input = keyArrowDown) then
					if level = 1 then
						Move_South(Position, map_1, playerChar, RoomID);
					elsif level = 2 then
						Move_South(Position, map_2, playerChar, RoomID);
					elsif level = 3 then
						Move_South(Position, map_3, playerChar, RoomID);
					elsif level = 4 then
						Move_South(Position, map_4, playerChar, RoomID);
					end if;
				elsif (Input = keyArrowRight) then
					if level = 1 then
						Move_East(Position, map_1, playerChar, RoomID);
					elsif level = 2 then
						Move_East(Position, map_2, playerChar, RoomID);
					elsif level = 3 then
						Move_East(Position, map_3, playerChar, RoomID);
					elsif level = 4 then
						Move_East(Position, map_4, playerChar, RoomID);
					end if;
				elsif (Input = 'I') or (Input = 'i') then -- Inventory Screen
					inventoryScreen;
				end if;
				If RoomID = 0 Then
					if(RandomRange(100) < 15) then
						findEnemies(EnemyPath & "Level_" & Integer'Image(level)(2));
						exit;
					end if;
				Elsif (RoomID > 0) and (RoomID < 31) Then -- Item
					AddEvent("You opened the chest and found " & GetName(RoomID));
					RoomID := -1;
				Elsif (RoomID = 31) then -- No Chest
					AddEvent("You decide to leave the chest unopened.");
				Elsif (RoomID = 49) then -- No Statue
					AddEvent("You leave the statue alone.");
				Elsif (RoomID = 50) then -- Heals
					AddEvent("Praying at the statue has refilled your strength.");
					playerChar.stats.HP := playerChar.stats.MaxHP;
					playerChar.stats.Magic := playerChar.stats.MaxMag;
				Elsif (RoomID = 77) then -- Wall
					AddEvent("You are unable to pass through. The wall is impenetrable.");
				Elsif (RoomID = 99) then -- Boss
					if level = 4 then
						finalBattle := true;
					end if;
					clearEvents;
					addEvent("A powerful foe appears...");
					showBorders;
					refresh;
					flush;
					delay(2.0);
					findBoss(EnemyPath & "Level_" & Integer'Image(level)(2));
					if finalBattle = false then
						nextDungeon;
					end if;
					exit;
				End If;
				
				if(inBattle = false) then
					if level = 1 then
						Show_Screen(Position, map_1);
					elsif level = 2 then
						Show_Screen(Position, map_2);
					elsif level = 3 then
						Show_Screen(Position, map_3);
					elsif level = 4 then
						Show_Screen(Position, map_4);
					end if;
				end if;
				showBorders;
				refresh;
				Get_Immediate(Input);
			end loop;
		
		else--in battle
		
			ClearDisplay;
			--WipeScreen;
			--draw enemies
			drawEnemies;
				
			--show commands
			if(battleCommand /= 0) then
				addEvent("---------------------------------------------------");
				addEvent("A = Attack, M = Magic (20M), I = Inventory, R = Run");
			end if;
				
			showBorders;
			
			--refresh the screen
			refresh;
			--Flush;
			battleCommand := 0;--if battleCommand is 0, ask for input
			
			Get_Immediate(input);
			
			if (battleCommand = 0) then
				--if a, attack an enemy
				if(input = 'a') then
					battleCommand := 1;
				elsif(input = 'm') then
					if(playerChar.stats.Magic >= 20) then
						battleCommand := 2;
					else
						AddEvent("You don't have enough MAGIC to perform that!");
					end if;
				elsif(input = 'i') then
					battleCommand := 3;
				elsif(input = 'r') then
					battleCommand := 4;
				end if;
			end if;
				
			--handle attacks
			if(battleCommand = 1 or battleCommand = 2) then
				addEvent("Select your target and press SPACE to attack!");
				--enemy select
				while (input /= ' ') loop
					ClearDisplay;
					drawEnemies;
					setSprite(Screen_Width/3*(target-1) + Screen_Width/6 - 4, 1, arrow);
					showBorders;
					refresh;
					Get_Immediate(input);
					--cycle left
					if(input = keyArrowLeft) then
						for I in 1..3 loop
							target := target-1;
							if(target < 1) then
								target := 3;
							end if;
							--check if slot exists
							if(enemy(target).name /= "MissingNo       ") then
								exit;
							end if;
						end loop;
					end if;
					--cycle left
					if(input = keyArrowRight) then
						for I in 1..3 loop
							target := target+1;
							if(target > 3) then
								target := 1;
							end if;
							--check if slot exists
							if(enemy(target).name /= "MissingNo       ") then
								exit;
							end if;
						end loop;
					end if;
					
					if(input = 'q') then
						battleCommand := 0;--back to battle menu
						input := ' ';
						exit;
					end if;
					--refresh screen
					--ClearDisplay;
					drawEnemies;
					setSprite(Screen_Width/3*(target-1) + Screen_Width/6 - 4, 1, arrow);
					showBorders;
					refresh;
				
				end loop;
			end if;
			
			--handle items
			if(battleCommand = 3) then
				inventoryScreen;
			end if;
			
			--running away
			if(battleCommand = 4) then
				if(not bossBattle) then
					inBattle := false;
					clearEnemies;
					addEvent("You got away!");
				else
					addEvent("You can't run from a boss!");
					battleCommand := 0;
				end if;
			end if;
			
			--if a command has been issued, have enemies attack
			if(battleCommand /= 0 and battleCommand /= 4) then
				clearEvents;
				
				--regular attack
				if(battleCommand =  1) then
					--calculate damage
					calculateDamage(playerChar.stats, enemy(target).stats, damage);
					if(damage = 0) then
						addEvent("You Missed");
					else
						addEvent("Inflicted " & Integer'Image(damage) & " damage to " & enemy(target).name(1..enemy(target).nameLen));
					end if;
				end if;
				
				--magic attack
				if(battleCommand = 2) then
					--Magic attack ignores defence and agility
					playerChar.stats.Magic := playerChar.stats.Magic - 20;--decrement magic
					calculateDamage(playerChar.stats, enemy(target).stats, damage, true);
					playerChar.stats.HP := playerChar.stats.HP + damage;
					if(playerChar.stats.HP > playerChar.stats.MaxHP) then
						playerChar.stats.HP := playerChar.stats.MaxHP;
					end if;
					addEvent("Stole " & Integer'Image(damage) & " HP from " & enemy(target).name(1..enemy(target).nameLen));
				end if;
				
				if(battleCommand = 3) then
					addEvent("Used an item");
				end if;
				
				--calculate enemy damage
				for I in 1..3 loop
					if (enemy(I).stats.HP > 0) then
						calculateDamage(enemy(I).stats, playerChar.stats, damage);
						if(damage = 0) then
							addEvent( enemy(I).name(1..Enemy(I).nameLen) & "'s attack missed");
						else
							addEvent(enemy(I).name(1..Enemy(I).nameLen) & " inflicted " & Integer'Image(damage) & " damage to you!");
						end if;
					end if;
				end loop;
			
				inBattle := false;
				--test for enemy death
				xpGain := 0;
				for I in 1..3 loop
					if (enemy(I).name /= "MissingNo       ") then
						if(enemy(I).stats.HP <= 0) then
							lvGain := playerChar.stats.level;
							addEvent("Defeated " & enemy(I).name(1..enemy(I).nameLen) & "!");
							--handle experience
							xpGain := xpGain + (enemy(I).stats.MaxHP / 2) + enemy(I).stats.Defense*2 + enemy(I).stats.Attack + enemy(I).stats.agility/2;
							if(xpGain < 1) then
								xpGain := 1;
							end if;
							addEvent("Gained " & Integer'Image(xpGain) & " XP!");
							addXP(xpGain, playerChar.stats);
							if(lvGain /= playerChar.stats.level) then
								addEvent("You Leveled up to level " & Integer'Image(playerChar.stats.level));
							end if;
							enemy(I).name := "MissingNo       ";
							
							--auto move cursor
							for I in 1..3 loop
								target := target+1;
								if(target > 3) then
									target := 1;
								end if;
								--check if slot exists
								if(enemy(target).name /= "MissingNo       ") then
									exit;
								end if;
							end loop;
						else
							inBattle := true;
						end if;
					end if;
				end loop;
				
				if(playerChar.stats.HP <= 0) then
					battleCommand := 9;--player is dead
					clearEvents;
					inBattle := false;
					exit;
				end if;
				
				if(inBattle = false and battleCommand /= 9) then
					addEvent(" ");
					addEvent("You have won!");
					clearEnemies;
					clearDisplay;
					showBorders;
					refresh;
					
					battleCommand := -1;
					inBackpack := false;
					get_immediate(input);
					
					if finalBattle = true then  --Ending
						clearEvents;
						Display_Credits;
						return;
					elsif bossBattle = true and finalBattle = false then --Save Prompt
						clearDisplay;
						clearEvents;
						setText(5,5, "Would you like to save your game?");
						addEvent("Y/N");
						showBorders;
						refresh;
						
						loop
							get_immediate(input);
							exit when input = 'y' OR input = 'n';
						end loop;
						
						if input = 'y' then
							clearDisplay;
							clearEvents;
							setText(5,5, "Save file 1, 2, or 3?");
							addEvent("1: Save 1  2: Save 2  3: Save 3  Q: Don't save");
							showBorders;
							refresh;
						
							loop
								get_immediate(input);
								exit when input = '1' OR input = '2' OR input = '3' OR input = 'q';
							end loop;
							
							if input = '1' then
								saveGame(playerChar, level, 1);
							elsif input = '2' then
								saveGame(playerChar, level, 2);
							elsif input = '3' then
								saveGame(playerChar, level, 3);
							end if;
							
						end if;
						
						bossBattle := false;
						RoomID := 0;
						
						if finalBattle = false then
							clearEvents;
							addEvent("The lair of the monster crumbles behind you as you barely ");
							addEvent(" leap out of the way.  You feel more darkness ahead of you. ");
							addEvent(" Your quest is not yet finished... ");
							
						
						end if;						
						
					end if;
					
				end if;
			
				ClearDisplay;
				drawEnemies;
				showBorders;
			end if;
		end if;
	
	showBorders;
	
	Refresh;--redraw the screen
	battleCommand := -1;
	end loop;
	
	if(battleCommand = 9) then
		WipeScreen;
		clearDisplay;
		SetText(32,16, "YOU HAVE BEEN SLAIN!", colorRedI);
		refresh;
	end if;
	
	Put(ASCII.ESC & "[00m");
	put(ASCII.ESC & "[?25h"); -- cursor off (?25h for on)
	--Initialize(Level_1);
	
end advgame;