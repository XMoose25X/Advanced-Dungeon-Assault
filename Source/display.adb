with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body display is
	
	function "=" (L, R : pixelType) return Boolean is
	begin
		null;
		--do compare
		return (L.char = R.char);
	end "=";
	
	procedure setPixel(X,Y : Integer; char : character; color : colorType := colorDefault) is
	begin
		begin
			Screen(X,Y).char := char;
			Screen(X,Y).color := color;
		exception
			when others =>
				null;
		end;
	end setPixel;
	
	procedure setPixel(X,Y : Integer; pixel : pixelType) is
	begin
		Screen(X,Y) := pixel;
	end setPixel;
	
	function getPixel(X,Y : Integer) return pixelType is
		temp : pixelType := pixelType'('~', colorDefault);
	begin
		if(X >= 0 and X <= Screen_Width and Y >= 0 and Y <= Screen_Height) then
			temp := screen(X,Y);
		end if;
		return temp;
	end getPixel;
	
	function LoadSprite(FileName : String) return SpriteType is
		File : File_Type;
		width : Integer;
		height : Integer;
		sprite : SpriteType;
		line: String(1..2500);
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
		Skip_Line(File);
		sprite.Width := width;
		sprite.Height := height;
		For Y in Integer range 0..sprite.height loop
			Get_Line(File => File, Item => line, Last => width);
			--Put(line(1..width-1));
			width := width;
			--Skip_Line(File);
			offset := 1;
			color := colorDefault;
			For X in Integer range 0..sprite.width-1 loop
				color := Line(X+offset..X+offset+colorType'length-1);
				offset := offset+colorType'length;
				sprite.Image(X,Y).char := line(X+offset);
				sprite.Image(X,Y).color := color;
			end loop;
			exit when End_of_File(File);
			--Put(" <EOL> ");
			new_line;
		end loop;
		Close(File);
		Return sprite;
	end LoadSprite;
	
	procedure SetSprite(posX, posY : Integer; sprite : SpriteType) is
		chr : Character;
		col : colorType;
	begin
		For Y in Integer range 0..sprite.Height-1 loop
			For X in Integer range 0..sprite.Width-1 loop
				if (posX + X <= Screen_Width AND posX + X >= 0 
				AND posY + Y <= Screen_Height AND posY + Y >= 0) then
					chr := sprite.Image(X,Y).char;
					col := sprite.Image(X,Y).color;
					if (Character'Pos(chr) >= 32) then
						setPixel(posX + X, posY + Y, chr, col);
					end if;
				end if;
			end loop;
		end loop;
	end SetSprite;

	--text functions
	procedure setText(posX,posY : Integer; Item : String; color : colorType := colorDefault) is
	begin
		for I in Integer Range 1..Item'length loop
			if(posX + I >= 0 and posX + I <= Screen_Width) then
				setPixel(posX + I, posY, Item(I), color);
			end if;
		end loop;
	end setText;
	
	procedure setText(posX,posY : Integer; Item : Character; color : colorType := colorDefault) is
	begin
		if(posX >= 0 and posX <= Screen_Width) then
			setPixel(posX, posY, Item, color);
		end if;
	end setText;
	
	procedure Initialize(width, height : Integer) is
	begin
	Screen_Width := width;
	Screen_Height := height;
	--Initialize Screen to blank
		For Y in Integer Range 0..Screen_Height loop
			For X in Integer Range 0..Screen_Width loop
				setPixel(X,Y,' ',colorDefault);
			end loop;
		end loop;
	end Initialize;
	
	--Refresh Screen
	procedure Refresh is
	begin
		--clear screen
		--New_Line(100);
		Put(ASCII.ESC & "[;H");
		--fill screen
		For Y in Integer Range 0..Screen_Height loop
			For X in Integer Range 0..Screen_Width loop
				begin
					Put(Screen(X,Y).color);
					if(Character'Pos(Screen(X,Y).char) >= 32) then
						Put(Screen(X,Y).char);
					else
						Put(' ');
					end if;
				exception
					when others =>
						null;
				end;
				Flush;
			end loop;
			New_Line;
		end loop;
	end Refresh;
	
	procedure ClearDisplay is
	begin
		For Y in Integer Range 0..Screen_Height loop
			For X in Integer Range 0..Screen_Width loop
				setPixel(X,Y,' ', colorDefault);
			end loop;
		end loop;
	end ClearDisplay;
	
	procedure WipeScreen is
	begin
		put(ASCII.ESC & "[2J");
	end WipeScreen;

end display;
