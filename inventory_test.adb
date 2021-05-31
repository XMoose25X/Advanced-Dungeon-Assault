with Ada.Text_IO;			Use Ada.Text_IO;
with Ada.Integer_Text_IO;  	Use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;  	Use Ada.Float_Text_IO;
with inventory_list;		Use inventory_list;

Procedure inventory_test is

	backpack : List_Type;
	usedItem : inventoryItem;
	response : Integer := -1;
	itemID : Integer;
	
begin	

	loop
	
		begin
		
		put("What do you want to do in your backpack?");
		new_line;
		put("1: Insert, 2: Use, 3: Drop, 4: Display, 5: Check Empty, 6: Clear, 0: Quit");
		new_line;
		get(response);
		exit when response = 0;
	
		if response = 1 then
		
			new_line;
			put("Item ID: ");
			get(itemID);
			insert(itemID, backpack);
		
		elsif response = 2 then
			
			new_line;
			put("Item ID: ");
			begin
				get(itemID);
			exception
				when OTHERS => 
					put("Number input not found.");
			end;
			useItem(itemID, backpack, usedItem);
			new_line;
			put("Name: ");
			put(usedItem.name);
			new_line;
			put("Type: ");
			if usedItem.itemType = 1 then
				put("Weapon");
				new_line;
				put("Attack: ");
				put(usedItem.effects(1));
				new_line;
				put("Magic: ");
				put(usedItem.effects(3));
				new_line;
			elsif usedItem.itemType = 2 then
				put("Armor");
				new_line;
				put("Defense: ");
				put(usedItem.effects(2));
				new_line;
				put("Magic: ");
				put(usedItem.effects(3));
				new_line;
			else
				put("Usable Item");
				new_line;
				put("HP restore: ");
				put(usedItem.effects(1));
				new_line;
				put("Mana restore: ");
				put(usedItem.effects(2));
				new_line;
			end if;
	
		elsif response = 3 then
		
			new_line;
			put("Item ID: ");
			get(itemID);
			drop(itemID, backpack);
	
		elsif response = 4 then
		
			display(backpack);
	
		elsif response = 5 then
		
			if isEmpty(backpack) then
				put("Inventory is empty");
				new_line;
			else
				put("Inventory is not empty");
				new_line;
			end if;
		
		elsif response = 6 then
		
			clear(backpack);
		
		end if;
		
		exception
		
			when OTHERS => 
				put("Incorrect input");
				new_line;
				skip_line;
		
		end;
		
	end loop;
	
end inventory_test;