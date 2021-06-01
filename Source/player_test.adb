with Ada.Integer_Text_IO;  	Use Ada.Integer_Text_IO;
with Ada.Text_IO;			Use Ada.Text_IO;
with inventory_list;		Use inventory_list;
with player;				Use player;
with save_load_game;		Use save_load_game;
with stats;                 Use stats;

Procedure player_test is

	response : Integer := -1;
	response2 : Integer := -1;
	response3 : character;
	dungeon: Integer := 1;
	bob : player_type;
	
	--usedItem : inventoryItem; 

begin

	clearCharacter(bob);
	
	insert(1, bob.backpack);
	insert(2, bob.backpack);
	insert(3, bob.backpack);
	insert(4, bob.backpack);
	insert(5, bob.backpack);
	insert(6, bob.backpack);
	insert(7, bob.backpack);
	insert(8, bob.backpack);
	insert(9, bob.backpack);
	insert(10, bob.backpack);
	insert(11, bob.backpack);
	insert(12, bob.backpack);
	insert(13, bob.backpack);
	insert(14, bob.backpack);
	insert(15, bob.backpack);
	insert(16, bob.backpack);
	insert(17, bob.backpack);
	insert(18, bob.backpack);
	insert(19, bob.backpack);
	insert(20, bob.backpack);
	insert(21, bob.backpack);
	insert(22, bob.backpack);
	insert(23, bob.backpack);
	insert(24, bob.backpack);
	insert(25, bob.backpack);
	insert(26, bob.backpack);
	insert(27, bob.backpack);
	insert(28, bob.backpack);
	insert(29, bob.backpack);
	insert(30, bob.backpack);
		
	loop

		exit when response = 0;
		put(ASCII.ESC & "[2J");
		
		put("***Player*** ");
		new_line;
		put("Attack:  ");
		put(bob.stats.attack);
		new_line;
		put("Defense: ");
		put(bob.stats.defense);
		new_line;
		put("Magic:   ");
		put(bob.stats.Magic);
		put("/");
		put(bob.stats.MaxMag, 0);
		new_line;
		put("Agility: ");
		put(bob.stats.agility);
		new_line;
		put("Level:   ");
		put(bob.stats.level);
		new_line;
		put("HP:      ");
		put(bob.stats.HP);
		put("/");
		put(bob.stats.MaxHP, 0);
		new_line;
		put("XP:      ");
		put(bob.stats.xp);
		new_line(2);
		
		put("*Equipment* ");
		new_line;
		put("Weapon:      ");
		put(bob.Weapon.name);
		new_line;
		put("Helmet:      ");
		put(bob.helmet.name);
		new_line;
		put("Chest Armor: ");
		put(bob.chestArmor.name);
		new_line;
		put("Gauntlets:   ");
		put(bob.gauntlets.name);
		new_line;
		put("Leg Armor:   ");
		put(bob.legArmor.name);
		new_line;
		put("Boots:       ");
		put(bob.boots.name);
		new_line(2);
		
		put("*Inventory*");
		new_line;
		DisplayList(bob.backpack);
	
		new_line;
		put("Use/Equip item: 1        Unequip item: 2");
		new_line;
		put("Hurt Player: 3           Decrement Magic: 4");
		new_line;
		put("Add XP: 5                Clear Character: 6");
		new_line;
		put("Save Game: 7             Load Game: 8");
		new_line;
		put("Quit: 0");
		new_line;
		
		get(response);
		
		if response = 1 then
			put("Type in the item ID that you are using/equipping: ");
			get(response2);
			equipOrUse(response2, bob);
			response2 := -1;
		elsif response = 2 then 
			put("Type in the item type that you are unequipping. ");
			new_line;
			put("1: Weapon,   2: Helmet,   3: Chest Armor ");
			new_line;
			put("4: Gauntlets 5: Leg Armor 6: Boots ");
			new_line;
			get(response2);
			unequip(response2, bob);
			response2 := -1;
		elsif response = 3 then
			put("Type in the amount of damage you want to inflict: ");
			get(response2);
			calculateDamage(bob.stats, bob.stats, response2, true);
			response2 := -1;
		elsif response = 4 then
			put("Type in the amount of magic you want to use: ");
			get(response2);
			decMagic(response2, bob);
			response2 := -1;
		elsif response = 5 then
			put("Type in the earned XP: ");
			get(response2);
			addXP(response2, bob.stats);
			response2 := -1;
		elsif response = 6 then
			put("New Character? (Y/N): ");
			get(response3);
			if response3 = 'Y' OR response3 = 'y' then
				clearCharacter(bob);
			end if;
			response3 := '0';
		elsif response = 7 then
			put("Dungeon 1, 2, or 3? ");
			get(dungeon);
			loop
				put("Save File 1, 2, or 3? ");
				get(response2);
				exit when response2 = 1 OR response2 = 2 OR response2 = 3;
			end loop;
			saveGame(bob, dungeon, response2);
			response2 := -1;
		elsif response = 8 then
			loop
				put("Save File 1, 2, or 3? ");
				get(response2);
				exit when response2 = 1 OR response2 = 2 OR response2 = 3;
			end loop;
			loadGame(bob, dungeon, response2);
			response2 := -1;
		end if;
	end loop;
end player_test;
