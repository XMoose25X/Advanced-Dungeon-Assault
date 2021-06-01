package display is

	--IMPORTANT: This function must be called before any other functions
	--This Initializes the package for use
	procedure Initialize(width, height : Integer);

	--The color type consists of 4 ANSI codes in series [ 0 ; 27 ; 37 ; 40 m
	--A code or string of codes must always begin with the ESC character (ASCII.ESC or Character'Val(27))
	--The Codes are usually 2 digits long and usually start with '[' and end with 'm', but not always
	--Codes in series are separated by ';'
	--References for ANSI codes : http://ascii-table.com/ansi-escape-sequences-vt-100.php
	--						http://pueblo.sourceforge.net/doc/manual/ansi_color_codes.html
	--Below 
	subtype colorType is String(1..13);
	--colors
	colorDefault: constant colorType := ASCII.ESC & "[0;27;37;40m";
	--red
	colorRed	: constant colorType := ASCII.ESC & "[0;27;31;40m";
	colorRedL	: constant colorType := ASCII.ESC & "[1;27;31;40m";
	colorRedI	: constant colorType := ASCII.ESC & "[0;07;31;40m";
	--green
	colorGreen	: constant colorType := ASCII.ESC & "[0;27;32;40m";
	colorGreenL	: constant colorType := ASCII.ESC & "[1;27;32;40m";
	colorGreenI	: constant colorType := ASCII.ESC & "[0;07;32;40m";
	--yellow
	colorYellow	: constant colorType := ASCII.ESC & "[0;27;33;40m";
	colorYellowL: constant colorType := ASCII.ESC & "[1;27;33;40m";
	colorYellowI: constant colorType := ASCII.ESC & "[0;07;33;40m";
	--blue
	colorBlue	: constant colorType := ASCII.ESC & "[0;27;34;40m";
	colorBlueL	: constant colorType := ASCII.ESC & "[1;27;34;40m";
	colorBlueI	: constant colorType := ASCII.ESC & "[0;07;34;40m";
	--magenta
	colorMag	: constant colorType := ASCII.ESC & "[0;27;35;40m";
	colorMagL	: constant colorType := ASCII.ESC & "[1;27;35;40m";
	colorMagI	: constant colorType := ASCII.ESC & "[0;07;35;40m";
	--cyan
	colorCyan	: constant colorType := ASCII.ESC & "[0;27;36;40m";
	colorCyanL	: constant colorType := ASCII.ESC & "[1;27;36;40m";
	colorCyanI	: constant colorType := ASCII.ESC & "[0;07;36;40m";
	--black
	colorBlack	: constant colorType := ASCII.ESC & "[0;27;30;40m";
	colorBlackL	: constant colorType := ASCII.ESC & "[1;27;30;40m";
	colorBlackI	: constant colorType := ASCII.ESC & "[0;07;30;40m";
	--white
	colorWhite	: constant colorType := ASCII.ESC & "[0;27;37;40m";
	colorWhiteL	: constant colorType := ASCII.ESC & "[1;27;37;40m";
	colorWhiteI	: constant colorType := ASCII.ESC & "[0;07;37;40m";

	--A PixelType contains a character and a colorType
	Type PixelType is record
		char : Character;
		color : colorType;
	end record;

	--tests if 2 pixels are the same
	function "=" (L, R : pixelType) return Boolean;
	
	--an imageBox is a 2-dimensional array of pixelType
	Type ImageBox is array(0..127,0..63) of PixelType;
	
	--a sprite is an image that can be placed and moved around on the screen
	Type SpriteType is record
		Width : Integer;
		Height : Integer;
		Image : ImageBox;
		color : colorType;--deprecated
	end record;
	
	--Character constants
	--These Constants contain symbols that look best when using the Terminal font
	--NOTE: these characters must be entered with Character'Val(charID). The compiler will not accept these in strings
	--Refernece for Extended ASCII: http://www.asciitable.com/index/extend.gif
	Char_Block : constant Character := character'val(219);-- Û
	Char_BorderV : constant Character := character'val(186);-- º		Vertical Border
	Char_BorderH : constant Character := character'val(205);-- Í		Horizontal Border
	Char_BorderTL : constant Character := character'val(201);-- É		Top Left Corner
	Char_BorderTR : constant Character := character'val(187);-- »		Top Right Corner
	Char_BorderBL : constant Character := character'val(200);-- È		Bottom Left Corner
	Char_BorderBR : constant Character := character'val(188);-- ¼		Bottom Right Corner

	--screen width and height. These start at 0, so a width of 149 is actually 150 pixels wide
	Screen_Width : Integer := 149;
	Screen_Height : Integer := 39;
	
	--this defines the screen;
	Screen : array(0..Screen_Width,0..Screen_Height) of PixelType;
	
	--sets a pixel on the screen with the piven character and color(optional)
	procedure setPixel(X,Y : Integer; char : character; color : colorType := colorDefault);
	procedure setPixel(X,Y : Integer; pixel : PixelType);
	
	--returns the pixel at the position X,Y
	function getPixel(X,Y : Integer) return PixelType;
	
	--loads a formatted sprite file
	--To format a sprite file, you must use the spritemaker executable and convert an unformatted sprite
	--an unformatted sprite is a text file that contains: (width height) new line (ASCII image)
	function LoadSprite(FileName : String) return SpriteType;
	
	procedure SetSprite(posX, posY : Integer; sprite : SpriteType);
	
	--text functions
	--these set Text on the screen starting at position X,Y; Left Aligned
	procedure setText(posX,posY : Integer; Item : String; color : colorType := colorDefault);
	procedure setText(posX,posY : Integer; Item : Character; color : colorType := colorDefault);
	
	--Refresh Screen
	--This must be called to draw the screen to the console
	--take care not to call this too often, it can be slow
	procedure Refresh;
	
	--ClearDisplay resets the display array to blank spaces
	-- This does NOT clear the screen
	procedure ClearDisplay;
	--WipeScreen physically clears the console
	--This does not reset the display array
	--it is recommended not to use this often, but it is useful
	procedure WipeScreen;
	
Private

end display;
