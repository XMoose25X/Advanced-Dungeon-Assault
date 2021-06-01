with inventory_list;		Use inventory_list;
with stats;					Use stats;

package player is

	Type Player_Type is record
		weapon : inventoryItem;
		helmet : inventoryItem;
		chestArmor : inventoryItem;
		gauntlets : inventoryItem;
		legArmor : inventoryItem;
		boots : inventoryItem;
		backpack : List_Type;
		stats : statType;
	end record;
	
	Procedure clearCharacter(player : in out player_type);
	--implemented when you die or when newGame is made (initializaion of player)
	
	Procedure equipOrUse(itemID : in integer; player : in out player_type);
	--equips items and changes stats
	
	Procedure unequip(itemType : in integer; player : in out player_type);
	--unequips items based on slot and changes stats
	-- 1 -> weapon
	-- 2 -> helmet
	-- 3 -> chest armor
	-- 4 -> gauntlets
	-- 5 -> leg armor
	-- 6 -> boots
	
	Procedure decMagic(magUsed : in integer; player : in out player_type);
	--decrements Magic by the input parameter.
	
	
	
end player;