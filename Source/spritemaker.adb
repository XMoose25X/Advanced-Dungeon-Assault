with Ada.Text_IO, Ada.Integer_Text_IO, display;
use Ada.Text_IO, Ada.Integer_Text_IO, display;

procedure spritemaker is

	procedure showFile(Filename : String) is
		L : Natural;
		line : String(1..250);
		File : File_Type;
	begin
		Open(File, In_File, Filename);
		while(not End_Of_File(File)) loop
			Put(Get_Line(File => File));
			new_line;
		end loop;
		Close(File);
	end showFile;
	

	function LoadSpriteNoFormat(FileName : String) return SpriteType is
			File : File_Type;
			width : Integer;
			height : Integer;
			sprite : SpriteType;
			line: String(1..128);
			color : colorType := colorDefault;
			offset : Positive := 1;
		begin
			--clear garbage data
			width := 127;
			height := 63;
			For Y in Integer range 0..height loop
				For X in Integer range 0..width loop
					sprite.Image(X,Y).char := ' ';
					sprite.color := colorDefault;
				end loop;
			end loop;
			--load sprite
			Open(File, In_File, FileName);
			Get(File => File, Item => width);
			Get(File => File, Item => height);
			sprite.Width := width;
			sprite.Height := height;
			Skip_Line(File);
			For Y in Integer range 0..height-1 loop
				Get_Line(File => File, Item => line, Last => width);
				Width := Width - 1;
				offset := 1;
				For X in Integer range 0..width loop
					sprite.Image(X,Y).char := line(X+offset);
					sprite.Image(X,Y).color := colorDefault;
					put(line(X+offset));
				end loop;
				--Put(" <EOL> ");
				new_line;
			end loop;
			Close(File);
			Return sprite;
		end LoadSpriteNoFormat;

	procedure saveSprite(sprite : SpriteType; FileName : String) is
		File : File_Type;
		width : Natural := sprite.width;
		height : Natural := sprite.height;
	begin
		Create(File, Out_File, FileName);
		Put(File => File, Item => sprite.width , Width => 0);
		Put(File => File, Item => " ");
		Put(File => File, Item => sprite.height, Width => 0);
		New_Line(File);
		For Y in Integer range 0..height loop
			For X in Integer range 0..width loop
				Put(File => File, Item => sprite.Image(X,Y).color);
				Put(File => File, Item => sprite.Image(X,Y).char);
			end loop;
			New_Line(File);
		end loop;
		Close(File);
	end saveSprite;
		
	--paint tools
	procedure boxFill (X,Y,W,H : Integer) is
	begin
		null;--do stuff
	end;
	
	procedure paintFill (sprite : in out SpriteType; color : colorType) is
	begin
		for Y in 0..sprite.Width loop
			For X in 0..sprite.Height loop
				begin
					sprite.image(Y,X).color := color;
				exception
					when others =>
						null;
				end;
			end loop;
		end loop;
	end paintFill;
	
	--handle cursor input
	input : Character;
	cursorX, cursorY : Integer;
	stickey : Boolean := False;
	function cursorInput(wrap : Boolean) return Boolean is
	begin
		if(input = character'val(68)) then--left
			cursorX := cursorX - 1;
		elsif (input = character'val(67)) then--right
			cursorX := cursorX + 1;
		elsif (input = character'val(65)) then--up
			cursorY := cursorY - 1;
		elsif (input = character'val(66)) then--down
			cursorY := cursorY + 1;
		else
			return False;
		end if;
		
		--wrap
		if(wrap = True) then
			if(cursorX < 0) then
				cursorX := Screen_Width;
			elsif (cursorX > Screen_Width) then
				cursorX := 0;
			elsif (cursorY < 0) then
				cursorY := Screen_Height;
			elsif (cursorY > Screen_Height) then
				cursorY := 0;
			end if;
		else --limit
			if(cursorX < 0) then
				cursorX := 0;
			elsif (cursorX > Screen_Width) then
				cursorX := Screen_Width;
			elsif (cursorY < 0) then
				cursorY := 0;
			elsif (cursorY > Screen_Height) then
				cursorY := Screen_Height;
			end if;
		end if;
		
		return  True;
	end;
	
	--display functions
	currentChar : character := ' ';
	currentCol : colorType := colorDefault;
	
	procedure ShowCommands is
		posX : Integer := Screen_Width-14;
		posY : Integer := 2;
	begin
		
		for I in 0..Screen_Height loop
			setPixel(posX-02,I,character'val(186), colorDefault);
			setPixel(posX+14,I,character'val(186), colorDefault);
		end loop;
	
		SetText(posX, posY+00, "Color      ", currentCol);
		SetText(posX, posY+02, "Black   : 0");
		SetText(posX, posY+03, "Red     : 1");
		SetText(posX, posY+04, "Green   : 2");
		SetText(posX, posY+05, "Yellow  : 3");
		SetText(posX, posY+06, "Blue    : 4");
		SetText(posX, posY+07, "Magenta : 5");
		SetText(posX, posY+08, "Cyan    : 6");
		SetText(posX, posY+09, "White   : 7");
		SetText(posX, posY+10, "Shade   : 8");
		SetText(posX, posY+11, "Invert  : 9");
		SetText(posX, posY+12, "Set : Space");
		SetText(posX, posY+13, "Auto    : S");
		SetText(posX, posY+14, "Fill    : F");
		--SetText(posX, posY+15, "\Box Fill: B");
		
		SetText(posX, posY+20, "Save    : -");
		SetText(posX, posY+21, "Quit    : Q");
	end ShowCommands;
		
	line : String(1..250);
	len : Natural;
	editSprite : SpriteType;
	
	useBox : Boolean := False;
	boxStartX : Integer := 0;
	boxStartY : Integer := 0;
		
begin

	put(ASCII.ESC & "[?25l"); -- cursor off (?25h for on)

	cursorX := 0;
	cursorY := 0;

	Initialize(140,50);

	--primary menu
	loop
		WipeScreen;
		setText(4, 12, "What would you like to load?");
		setText(6, 14, "1 - Unformatted sprite");
		setText(6, 15, "2 - Existing Sprite file");
		refresh;
		get_immediate(input);
		exit when input = '1';
		exit when input = '2';
	end loop;
	
	loop
		Put("Enter File to load");
		new_line;
		Get_Line(Item => line, Last => len);
		Put("Loading " & line(1..len));
		new_line;
		
		begin--exception
			if(input = '1') then		
				editSprite := LoadSpriteNoFormat(line(1..len));
				Put("----");
				exit;
			elsif(input = '2') then
				editSprite := LoadSprite(line(1..len));
				Put("----");
			end if;
				exit;
			
		exception
			when others => 
				Put("File does not exist or the file format is incorrect.");
		end;
	end loop;
	
	Put(ASCII.ESC & "[2J");
	loop--editor main
		Get_Immediate(input);
		exit when input = 'q';
		
		if(input = '-') then
			Put("Save as : ");
			new_line;
			Get_Line(Item => line, Last => len);
			saveSprite(editSprite, line(1..len));
			exit;
		end if;
		
		if(cursorInput(True) and stickey = True) then
			if(cursorX >= 0 and cursorX <= editSprite.Width
			and cursorY >= 0 and cursorY <= editSprite.Height) then
				editSprite.image(cursorX,cursorY).color := currentCol;
			end if;
		end if;
		
		if (input = '0') then
			currentCol(9) := '0';
		elsif (input = '1') then
			currentCol(9) := '1';
		elsif (input = '2') then
			currentCol(9) := '2';
		elsif (input = '3') then
			currentCol(9) := '3';
		elsif (input = '4') then
			currentCol(9) := '4';
		elsif (input = '5') then
			currentCol(9) := '5';
		elsif (input = '6') then
			currentCol(9) := '6';
		elsif (input = '7') then
			currentCol(9) := '7';
		elsif (input = '8') then
			if(currentCol(3) = '0') then
				currentCol(3) := '1';
			else
				currentCol(3) := '0';
			end if;
		elsif (input = '9') then
			if(currentCol(5) = '2') then
				currentCol(5) := '0';
			else
				currentCol(5) := '2';
			end if;
		end if;
		
		if(input = 's') then
			stickey := not stickey;
		end if;
		
		if(input = ' ') then
			editSprite.image(cursorX,cursorY).color := currentCol;
		end if;
		
		--fill
		if(input = 'f') then
			paintFill(editSprite, currentCol);
		end if;
		
		clearDisplay;
		
		setSprite(0,0,editSprite);
		--setText(0,0, Integer'Image(character'pos(input)), colorDefault);
		if(screen(cursorX,CursorY).color(5) = '2') then
			screen(cursorX,CursorY).color(5) := '0';
		else
			screen(cursorX,CursorY).color(5) := '2';
		end if;
		--setPixel(cursorX, cursorY, character'val(200), colorDefault);
		
		ShowCommands;
		
		refresh;
	end loop;--main
	
	--quit commands
	put(ASCII.ESC & "[?25h");
	
end spritemaker;