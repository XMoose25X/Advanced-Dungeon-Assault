
with Ada.Integer_Text_IO;  	Use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;  	Use Ada.Float_Text_IO;
with Ada.Text_IO;			Use Ada.Text_IO;

with inventory_list;		Use inventory_list;
with stats;					Use stats;

package body player is

	empty : inventoryItem;
	
	Procedure clearCharacter(player : in out player_type) is
	
	begin
	
		empty.itemID := 00;
		empty.name := "Empty                    ";
		empty.itemType := 00;
		empty.quantity := 0;
		empty.effects := (0,0,0);
	
		player.weapon := empty;
		player.helmet := empty;
		player.chestArmor := empty;
		player.gauntlets := empty;
		player.legArmor := empty;
		player.boots := empty;
		Clear(player.backpack);
		player.stats.Level := 1;
		player.stats.HP := 100;
		player.stats.MaxHP := 100;
		player.stats.Magic := 100;
		player.stats.MaxMag := 100;
		player.stats.Attack := 10;
		player.stats.Defense := 5;
		player.stats.Agility := 4;
		player.stats.XP := 0;
	
	end clearCharacter;
	
	Procedure equipOrUse(itemID : in integer; player : in out player_type) is

		usableItem : inventoryItem;
		prevMaxMag : Integer;
	
	begin
	
		useItem (itemID, player.backpack, usableItem);
	
		empty.itemID := 00;
		empty.name := "Empty                    ";
		empty.itemType := 00;
		empty.quantity := 0;
		empty.effects := (0,0,0);
		
		prevMaxMag := player.stats.MaxMag;
	
		if usableItem.itemType = 1 then
			if player.weapon.itemID /= 0 then
				unequip(1,player);
			end if;
			player.weapon := usableItem;
			player.stats.attack := (player.stats.Level*10) + (usableItem.effects(1) * 3);
			player.stats.MaxMag := (player.stats.MaxMag) + (usableItem.effects(3)*5);
		elsif usableItem.itemType = 2 then
			if usableItem.effects(1) = 1 then
				if player.helmet.effects(1) /= 0 then
					unequip(2,player);
				end if;
				player.helmet := usableItem;
				player.stats.defense := (player.stats.defense) + (usableItem.effects(2));
				player.stats.MaxMag := (player.stats.MaxMag) + (usableItem.effects(3)*5);
			elsif usableItem.effects(1) = 2 then
				if player.chestArmor.effects(1) /= 0 then
					unequip(3,player);
				end if;
				player.chestArmor := usableItem;
				player.stats.defense := (player.stats.defense) + (usableItem.effects(2));
				player.stats.MaxMag := (player.stats.MaxMag) + (usableItem.effects(3)*5);
			elsif usableItem.effects(1) = 3 then
				if player.gauntlets.effects(1) /= 0 then
					unequip(4,player);
				end if;
				player.gauntlets := usableItem;
				player.stats.defense := (player.stats.defense) + (usableItem.effects(2));
				player.stats.MaxMag := (player.stats.MaxMag) + (usableItem.effects(3)*5);
			elsif usableItem.effects(1) = 4 then
				if player.legArmor.effects(1) /= 0 then
					unequip(5,player);
				end if;
				player.legArmor := usableItem;
				player.stats.defense := (player.stats.defense) + (usableItem.effects(2));
				player.stats.MaxMag := (player.stats.MaxMag) + (usableItem.effects(3)*5);
			else
				if player.boots.effects(1) /= 0 then
					unequip(6,player);
				end if;
				player.boots := usableItem;
				player.stats.defense := (player.stats.defense) + (usableItem.effects(2));
				player.stats.MaxMag := (player.stats.MaxMag) + (usableItem.effects(3)*5);
			end if;
		else
			player.stats.HP := player.stats.HP + usableItem.effects(1);
			
			if player.stats.HP > player.stats.MaxHP then
				player.stats.HP := player.stats.MaxHP;
			end if;
			
			player.stats.Magic := player.stats.Magic + usableItem.effects(2);
			
			if player.stats.Magic > player.stats.MaxMag then
				player.stats.Magic := player.stats.MaxMag;
			end if;
			
		end if;
		
		if player.stats.Magic = prevMaxMag then
			player.stats.Magic := player.stats.MaxMag;
		end if;
	
	end equipOrUse;
	
	Procedure unequip(itemType : in integer; player : in out player_type) is
	
	begin
	
		empty.itemID := 00;
		empty.name := "Empty                    ";
		empty.itemType := 00;
		empty.quantity := 0;
		empty.effects := (0,0,0);
		
		if itemType = 1 then
			insert(player.weapon.itemID, player.backpack);
			player.stats.attack := player.stats.Level*10;
			player.stats.MaxMag := player.stats.MaxMag - player.weapon.effects(3)*5;
			player.weapon := empty;
		elsif itemType = 2 then
			insert(player.helmet.itemID, player.backpack);
			player.stats.defense := player.stats.defense - player.helmet.effects(2);
			player.stats.MaxMag := (player.stats.MaxMag) - (player.helmet.effects(3)*5);
			player.helmet := empty;
		elsif itemType = 3 then
			insert(player.chestArmor.itemID, player.backpack);
			player.stats.defense := player.stats.defense - player.chestArmor.effects(2);
			player.stats.MaxMag := (player.stats.MaxMag) - (player.chestArmor.effects(3)*5);
			player.chestArmor := empty;
		elsif itemType = 4 then
			insert(player.gauntlets.itemID, player.backpack);
			player.stats.defense := player.stats.defense - player.gauntlets.effects(2);
			player.stats.MaxMag := (player.stats.MaxMag) - (player.gauntlets.effects(3)*5);
			player.gauntlets := empty;
		elsif itemType = 5 then
			insert(player.legArmor.itemID, player.backpack);
			player.stats.defense := player.stats.defense - player.legArmor.effects(2);
			player.stats.MaxMag := (player.stats.MaxMag) - (player.legArmor.effects(3)*5);
			player.legArmor := empty;
		elsif itemType = 6 then
			insert(player.boots.itemID, player.backpack);
			player.stats.defense := player.stats.defense - player.boots.effects(2);
			player.stats.MaxMag := (player.stats.MaxMag) - (player.boots.effects(3)*5);
			player.boots := empty;
		else
		
			NULL;
		
		end if;
		if player.stats.Magic > player.stats.MaxMag then
			player.stats.Magic := player.stats.MaxMag;
		end if;
	
	end unequip;
	
	Procedure decMagic(magUsed : in integer; player : in out player_type) is
	
	begin
	
		player.stats.Magic := player.stats.Magic - magUsed;
			if player.stats.Magic < 0 then
				player.stats.Magic := 0;
			end if;
	
	end decMagic;
	
end player;
