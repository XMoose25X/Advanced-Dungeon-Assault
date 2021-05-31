package stats is

	Type statType is record
		Level : Integer;
		HP : Integer := 0;
		MaxHP : Integer;
		Magic : Integer;
		MaxMag : Integer;
		Attack : Integer;
		Defense : Integer;
		Agility : Integer;
		XP : Integer;
	end record;
	Procedure Instantiate;
	function rand return Integer;
	
	function randomRange(to : Integer) return Integer;--random range 1..to
	--calculateDamage returns damage dealt; 0 = miss
	function randomZero(to: Integer) return Integer;-- random range 0..to
	
	Procedure calculateDamage(by, to : in out statType; damage : out integer; ignoreDefense : Boolean := false);
	
	procedure setStats(obj : in out statType;HP, MG, ATK, DEF, AGT, LV : Integer);
	
	Procedure addXP(exp : in integer; stats : in out statType);

end stats;