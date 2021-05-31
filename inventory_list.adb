with Ada.Integer_Text_IO;  	Use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;  	Use Ada.Float_Text_IO;
with Ada.Text_IO;			Use Ada.Text_IO;
with display;				Use display;
with Unchecked_Deallocation;

package body inventory_list is

-- inventory system that stores items from items.dat in a linked-list
--  alphabetically.

	itemFile : File_Type;	

	procedure Free is new Unchecked_Deallocation (Object => inventoryItem,
                                                 Name   => Node_Ptr);
	
	procedure SearchInventory (List     :  in List_Type;
                                 Key      :  in Integer;
                                 Found    : out Boolean;
                                 Pred_Loc : out Node_Ptr;
                                 Location : out Node_Ptr) is
	begin
		Location := List.Head;
		Pred_Loc := null;
		loop
			exit when (Location = null or else Key = Location.itemID); 
			Pred_Loc := Location;
			Location := Location.Next;
		end loop;
		-- Found := Location /= null  and then  Key = Location.all.Info;
		if Location /= null then 
			Found := Key = (Location.itemID);
		else
			Found := False;
		end if;
	end SearchInventory;
	
	procedure Clear (List : in out List_Type) is
		To_Recycle : Node_Ptr;      -- Designates a node for recycling
	begin
		loop
			exit when List.Head = null;        -- Exit when list is empty
			To_Recycle := List.Head;           -- Unlink the
			List.Head  := List.Head.Next;      --    the first node
			Free (To_Recycle);                 -- Recycle the node
		end loop;
	end Clear;
	
	procedure Insert (key : in Integer; List : in out List_Type) is
      Have_Duplicate : Boolean;
      Pred_Loc       : Node_Ptr;
      Location       : Node_Ptr;
	  
	  effects : valueArray;
	  itemType : Integer;
	  name : nameType;
	begin
	
		Location := List.Head;
		loop
			exit when Location = null;
			if Location.itemID = key then
				Have_Duplicate := TRUE;
				exit;
			elsif Location.itemID > key then
				exit;
			end if;
			
			Pred_Loc := Location;
			Location := Location.Next; -- Move to next node
			
		end loop;
						  
		if Have_Duplicate then
			Location.quantity := Location.quantity + 1;
			--put("dup found!");
			Have_Duplicate := FALSE;
		elsif Pred_Loc = null then 
			-- Add Item to the head of the linked list
			readItem(itemID => key, name => name, itemType => itemType, effects => effects);
			if name /= "Item not found           " then
				List.Head := new inventoryItem'(itemID => key, name => name, itemType => itemType, quantity => 1, next => List.Head, effects => effects);
			end if;
		else   -- Add at the middle or end of the linked list
			readItem(itemID => key, name => name, itemType => itemType, effects => effects);
			if name /= "Item not found           " then
				Pred_Loc.Next := new inventoryItem'(itemID => key, name => name, itemType => itemType, quantity => 1, next => Location, effects => effects);
			end if;
		end if;
	exception
		when STORAGE_ERROR =>   -- Overflow when no storage available
			raise OVERFLOW;
		--when OTHERS => 
		--	put("Incorrect input");
	end Insert;
	
	procedure useItem (key : in Integer; List : in out List_Type; item : out inventoryItem) is
	
		Pred_Loc       : Node_Ptr;
		Location       : Node_Ptr;
		To_Recycle 	   : Node_Ptr;
		found 		   : Boolean;
		
	begin
	
		Location := List.Head;
		loop
			exit when Location = null;
			if Location.itemID = key then
				found := True;
				exit;
			end if;
			
			Pred_Loc := Location;
			Location := Location.Next; -- Move to next node
			
		end loop;
		
		if found then
			item := Location.all;
			if Location.quantity > 1 then
				Location.quantity := Location.quantity - 1;
			else
				if Location = List.Head then -- beginning of list
					To_Recycle := List.Head;
					List.Head  := List.Head.Next;
					Free (To_Recycle); 
				else					-- middle or end of list
					To_Recycle := Location;
					Pred_Loc.next := Location.next;
					Location := Location.next;
					Free (To_Recycle);
				end if;
			end if;
		else
			item := (itemID => 00, name => "Missing No.              ", itemType => 0, quantity => 0, next => NULL, effects => (0,0,0));
		end if;
	exception	
		when OTHERS => 
			put("Incorrect input");
	end useItem;
	
	procedure Drop (key : in Integer; List : in out List_Type) is
		
		Pred_Loc       : Node_Ptr;
		Location       : Node_Ptr;
		To_Recycle 	   : Node_Ptr;
		found 		   : Boolean;
		
	begin
	
		Location := List.Head;
		loop
			exit when Location = null;
			if Location.itemID = key then
				found := True;
				exit;
			end if;
			
			Pred_Loc := Location;
			Location := Location.Next; -- Move to next node
			
		end loop;
		
		if found then
			if Location.quantity > 1 then
				Location.quantity := Location.quantity - 1;
			else
				if Location = List.Head then -- beginning of list
					To_Recycle := List.Head;
					List.Head  := List.Head.Next;
					Free (To_Recycle); 
				else					-- middle or end of list
					To_Recycle := Location;
					Pred_Loc.next := Location.next;
					Location := Location.next;
					Free (To_Recycle);
				end if;
			end if;
		else
			put("Item not found");
			new_Line;
		end if;
	exception	
		when OTHERS => 
			put("Incorrect input");	
	end Drop;
	--deletes item from inventory
	
	procedure DisplayList (List : in List_Type) is
		
		Location : Node_Ptr;
		counter : Integer := 0;
		
	begin
		Location := List.Head;  -- Start with the first node in the linked list
		if List.Head = NULL then
			put("     Inventory Empty     ");
			new_Line(2);
		else
			loop
				exit when Location = null;
				put(Location.name);
				setText(2,2+counter, Location.name);
				--put(Location.itemID);
				--put(" ");
				put(Location.quantity);
				setText(30,2+counter, Integer'Image(Location.quantity));
				Ada.Text_IO.new_Line;
				Location := Location.all.Next; -- Move to next node
			end loop;
		end if;
		
	
	end DisplayList;
	
	procedure readItem (itemID : in Integer; name : out nameType; itemType : out Integer; effects : out valueArray ) is
	
		currID : Integer;
		junk : character;
	
	begin
	
		Open(File => itemFile, Mode => Ada.Text_IO.In_File, Name => "items.dat");
		
		for i in 1..30 loop
		
			Ada.Integer_Text_IO.Get(File => itemFile, Item => currID);
		
			Ada.Integer_Text_IO.Get(File => itemFile, Item => itemType);
			Ada.Integer_Text_IO.Get(File => itemFile, Item => effects(1));
			Ada.Integer_Text_IO.Get(File => itemFile, Item => effects(2));
			Ada.Integer_Text_IO.Get(File => itemFile, Item => effects(3));
			Ada.Text_IO.Get(File => itemFile, Item => junk);
			Ada.Text_IO.Get(File => itemFile, Item => name);
			--put(name);
			skip_line(File => itemFile);
		
			if itemID = currID then
			
				--put(name);
				exit;
				
			end if;
			
			itemType := 0;
			effects(1) := 0;
			effects(2) := 0;
			effects(3) := 0;
			name := "Item not found           ";
			
			
		end loop;
		
		Close(itemFile);
	
	end readItem;
	
	procedure saveInventory(List : in List_Type; File : File_Type) is
		
		Location : Node_Ptr;
		counter : Integer;
		
	begin
		
		Location := List.Head;  -- Start with the first node in the linked list
		
		loop
			exit when Location = null;
			counter := Location.quantity;
			loop
				put(File, Location.itemID, 0);
				put(File, " ");
				counter := counter - 1;
				exit when counter = 0;
			end loop;
			Location := Location.all.Next; -- Move to next node
		end loop;
		put(File, 00, 0); --marks end of list in saveFile
		
	end saveInventory;
	
	function isEmpty (List : in List_Type) return Boolean is
	
	begin
	
		return List.Head = NULL;
	
	end isEmpty;
	
	function getName (itemID : in Integer) return NameType is
	
		name : nameType;
		iType : integer;
		eff : valueArray;
	
	begin
	
		readItem(itemID, name, iType, eff);
		return name;
	
	end getName;
	
	function getSlotName (List : in List_Type; slot : in integer) return String is
	
		Location : Node_Ptr;
		slotString : String (1..30);
		counter : Integer := 1;
	
	begin
	
		Location := List.Head;  -- Start with the first node in the linked list
		if List.Head = NULL then
			return("        Inventory Empty");
		else
			loop
				if Location = NULL then
					return "0";
				end if;
				slotString := Location.name & "   " & Integer'Image(Location.quantity);
				--put (slotString);
				--new_Line;
				exit when counter = slot;
				counter := counter + 1;
				Location := Location.all.Next; -- Move to next node
			end loop;
			return slotString;
		end if;
	
	end getSlotName;
	
	function getSlotID (List : in List_Type; slot : in integer) return integer is
	
		Location : Node_Ptr;
		slotID : Integer;
		counter : Integer := 1;
	
	begin
	
		Location := List.Head;  -- Start with the first node in the linked list
		if List.Head = NULL then
			return -1;
		else
			loop
				if Location = NULL then
					return -1;
				end if;
				slotID := Location.itemID;
				--put (slotString);
				--new_Line;
				exit when counter = slot;
				counter := counter + 1;
				Location := Location.all.Next; -- Move to next node
			end loop;
			return slotID;
		end if;
	
	end getSlotID;
	
	
end inventory_list;
