with Ada.Integer_Text_IO;  	Use Ada.Integer_Text_IO;
with Ada.Text_IO;			Use Ada.Text_IO;

package inventory_list is 

-- inventory system that stores items from items.dat in a linked-list
--  alphabetically.

	KEY_ERROR	: exception;
	OVERFLOW	: exception;

	type List_Type is private;
	type Node_Ptr is private;
	type valueArray is array(1..3) of Integer;
	subtype nameType is String (1..25);
	
	type inventoryItem is record
		itemID : Integer;
		name : nameType;
		itemType : Integer;
		quantity : Integer;
		effects : valueArray;
		next : Node_Ptr;
	end record;
	
	procedure Clear (List : in out List_Type);
	--Empties Inventory list
	
	procedure Insert (key : in Integer; List : in out List_Type);
	--Adds inventory item from item ID
	
	
	
	procedure useItem (key : in Integer; List : in out List_Type; item : out inventoryItem);
	--uses inventory item by returning the item and deleting item after usage
	
	procedure Drop (key : in Integer; List : in out List_Type);
	--deletes item from inventory
	
	procedure DisplayList (List : in List_Type);
	--Traverses thru inventory displaying each item on screen alphabetically 
	
	procedure readItem(itemID : in Integer; name : out nameType; itemType : out Integer; effects : out valueArray);
	
	procedure saveInventory(List : in List_Type; File : File_Type);
	
	function isEmpty (List : in List_Type) return Boolean;
	--checks whether inventory is empty
	 
	function getName (itemID : in Integer) return NameType;
	
	function getSlotName (List : in List_Type; slot : in integer) return String;
	
	function getSlotId (List : in List_Type; slot : in integer) return Integer;
	
	
	private
		type Node_Ptr is access inventoryItem;
	
		type List_Type is record
			Head : Node_Ptr;  -- Designates first node in the linked list
		end record;	
	
end inventory_list;