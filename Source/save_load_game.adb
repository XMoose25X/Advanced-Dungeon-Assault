with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO;         use Ada.Text_IO;
with player;              use player;
with inventory_list;      use inventory_list;

package body save_load_game is

    SaveDir : String := "Saves/";

    procedure newGame(player: out Player_Type; dungeon: out Integer) is
    begin
        clearCharacter(player);
        dungeon := 1;
    end newGame;

    procedure saveGame(player: in Player_Type; dungeon: in Integer; fileNum: in Integer)
    is
        save : File_Type;
    begin
        if fileNum = 1 then
            open(save, Out_File, SaveDir & "saveFile1.save");
            put(save, "saveFile1");
        elsif fileNum = 2 then
            open(save, Out_File, SaveDir & "saveFile2.save");
            put(save, "saveFile2");
        elsif fileNum = 3 then
            open(save, Out_File, SaveDir & "saveFile3.save");
            put(save, "saveFile3");
        end if;

        new_line(save);
        put(save, player.weapon.itemID, 2);
        new_line(save);
        put(save, player.helmet.itemID, 2);
        new_line(save);
        put(save, player.chestArmor.itemID, 2);
        new_line(save);
        put(save, player.gauntlets.itemID, 2);
        new_line(save);
        put(save, player.legArmor.itemID, 2);
        new_line(save);
        put(save, player.boots.itemID, 2);
        new_line (save, 2);

        put(save, player.stats.HP, 3);
        put(save, " ");
        put(save, player.stats.MaxHP, 3);
        new_line(save);

        put(save, player.stats.Magic, 3);
        put(save, " ");
        put(save, player.stats.MaxMag, 3);
        new_line(save);

        put(save, player.stats.attack, 3);
        new_line(save);
        put(save, player.stats.defense, 3);
        new_line(save);
        put(save, player.stats.agility, 3);
        new_line(save);

        put(save, player.stats.xp, 3);
        new_line(save);
        put(save, player.stats.level, 3);
        new_line (save, 2);

        saveInventory (player.backpack, save);
        new_line (save, 2);

        put(save, dungeon, 1);

        close (save);
    end saveGame;

    procedure loadGame(player: in out Player_Type; dungeon: in out Integer; fileNum: in Integer)
    is
        save    : File_Type;
        current : Integer;
    begin
        clearCharacter (player);

        if fileNum = 1 then
            open (save, In_File, SaveDir & "saveFile1.save");
        elsif fileNum = 2 then
            open (save, In_File, SaveDir & "saveFile2.save");
        elsif fileNum = 3 then
            open (save, In_File, SaveDir & "saveFile3.save");
        end if;

        skip_line(save);

        --equipment
        for i in Integer range 1 .. 6 loop
            get(save, current);
            if current > 0 then
                Insert (current, player.backpack);
                equipOrUse (current, player);
            end if;
            current := -1;
            skip_line(save);
        end loop;

        skip_line(save);

        --HP
        get(save, player.stats.HP);
        get(save, player.stats.MaxHP);
        skip_line(save);

        --Magic
        get(save, player.stats.Magic);
        get(save, player.stats.MaxMag);
        skip_line(save);

        --attack
        get(save, player.stats.attack);
        skip_line(save);

        --defense
        get(save, player.stats.defense);
        skip_line(save);

        --agility
        get(save, player.stats.agility);
        skip_line(save);

        --xp
        get(save, player.stats.xp);
        skip_line(save);

        --level
        get(save, player.stats.level);
        skip_line(save, 2);

        --inventory
        loop
            get(save, current);
            Insert (current, player.backpack);
            exit when current = 0;
        end loop;
        skip_line(save, 2);

        --dungeon level
        get(save, dungeon);

        close (save);

    end loadGame;

end save_load_game;
