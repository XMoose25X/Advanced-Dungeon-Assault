with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Integer_Text_IO;

package body stats is

	Package RNG is new Ada.Numerics.Discrete_Random(Integer);
	Use RNG;
	
	Gen : Generator;

	Procedure Instantiate is
	begin
		Reset(Gen);
	End Instantiate;
	
	function randomRange(to : Integer) return Integer is
	begin
		return Random(Gen) mod to + 1;
	end randomRange;

	function randomZero(to: Integer) return Integer is
	begin
		return Random(Gen) mod to;
	end randomZero;
	
	function "*" (L:Integer; R:Float) return Integer is
	begin
		return Integer(Float(L) * R);
	end "*";

	function rand return Integer is
	begin
		return RNG.Random(Gen);
	end rand;
	
	
	Procedure calculateDamage(by, to : in out statType; damage : out integer; ignoreDefense : Boolean := false) is
	
		defensePercent : Integer;
		hit : Integer;
	
	begin
	
		defensePercent := (100*to.defense)/to.MaxHP;
		hit := randomRange(200);
		if (ignoreDefense = false) then
			damage := by.attack - (defensePercent * by.attack)/100;
			if damage < 1 then
				damage := 1;
			end if;
		else
			hit := 200;
			damage := by.attack;
		end if;
		
		if hit > to.agility then
			to.HP := to.HP - damage;
				if to.HP < 0 then
					to.HP := 0;
				end if;
		else
			damage := 0;
		end if;
	end calculateDamage;
	
	procedure setStats(obj : in out statType;HP, MG, ATK, DEF, AGT, LV : Integer) is
	begin
		obj.Level := LV;
		obj.HP := HP;
		obj.MaxHP := HP;
		obj.Magic := MG;
		obj.MaxMag := MG;
		obj.Attack := ATK;
		obj.Defense := DEF;
		obj.Agility := AGT;
		obj.XP := 0;
	end setStats;

	Procedure addXP(exp : in integer; stats : in out statType) is
	
		xpTilNextLvl : Integer := (50 + (stats.Level * 50));
		magicBuffs : Integer;
		attackBuffs : Integer;
		defenseBuffs : Integer;
		currHPpercent : Integer;
		currMagPercent : Integer;
	
	begin
	
		stats.XP := stats.XP + exp;
		magicBuffs := stats.MaxMag - (90 + (stats.Level * 10));
		attackBuffs := stats.attack - (stats.Level * 10);
		defenseBuffs := stats.defense - (stats.Level * 5);
		
		loop
			exit when stats.XP < xpTilNextLvl;
			stats.Level := stats.Level + 1;
			stats.XP := stats.XP - xpTilNextLvl;
			xpTilNextLvl := (50 + (stats.Level * 50));
			
			currHPpercent := (100*stats.HP)/stats.MaxHP;
			currMagPercent := (100*stats.Magic)/stats.MaxMag;
		
			
			stats.MaxHP := (90 + (stats.Level * 10));
			stats.MaxMag := (90 + (stats.Level * 10));
			--put(" Magic Buffs:");
			--put(magicBuffs);
			stats.MaxMag := stats.MaxMag + magicBuffs; 
			stats.attack := (stats.Level * 10);
			--put(" Attack Buffs:");
			--put(attackBuffs);
			stats.attack := stats.attack + attackBuffs;
			stats.defense := (stats.Level * 5);
			--put(" Defense Buffs:");
			--put(defenseBuffs);
			stats.defense := stats.defense + defenseBuffs;
			stats.agility := (stats.Level * 2);
			
			stats.HP := (currHPpercent * stats.MaxHP)/100;
			stats.Magic := (currMagPercent * stats.MaxMag)/100;
		
		end loop;
		
	end addXP;
end stats;