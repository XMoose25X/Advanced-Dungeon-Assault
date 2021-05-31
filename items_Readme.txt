--items.dat Readme--
Ex1:
03	1    3      0       1	    Enchanted Sword
ID	Type Attack Defense Magic	Name

Ex2:
14	3    20     20	  Warrior's Brew
ID	Type Health Magic Name
 
 Type 1 = weapon
 Type 2 = Armor
 Type 3 = 1 time use
 
 
Notes: 
- When added to inventory, items will be sorted in alphabetical
	order by name
- When items are equiped, the character will store the Item ID
- When dungeon and rooms are initialized, the item ID will be stored in the room record.
- stats from items.dat will be read in when item is equipped or used