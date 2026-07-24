/* =========================
   GLOBAL INIT (SERVER/WORLD)
========================= */

/* =========================
   CORE GLOBAL STATE
========================= */

if (isNil "ASF_Balance") then { ASF_Balance = 0; };
if (isNil "IslandTaxRate") then { IslandTaxRate = 0.10; };


/* =========================
   BROTHERHOOD VARIABLES
========================= */

if (isNil "BH_RankIndex") then { BH_RankIndex = 0; };

/* =========================
   BSG RANKS
========================= */

BSG_Ranks = [
    [0,"Civilian"],
    [500,"Black Survivor"],
    [2500,"Scout"],
    [5000,"Pathfinder"],
    [10000,"Homesteader"],
    [25000,"Ranger"],
    [50000,"Pioneer"],
    [100000,"Black Survival Expert"],
    [250000,"BSG Ghost"]
];


/* =========================
   BUSINESS POSITIONS
========================= */

ChickenRun_Pos = [5771.515,10157.225,0];
Alvinos_Pos = [5800,10100,0];
CoffeeShop1_Pos = [5820,10120,0];
CoffeeShop2_Pos = [5830,10120,0];
CoffeeShop3_Pos = [5840,10120,0];
Dispensary1_Pos = [5850,10120,0];
Dispensary2_Pos = [5860,10120,0];
Dispensary3_Pos = [5870,10120,0];
RenoClub_Pos = [5840,10140,0];
SendCash_Pos = [5860,10160,0];

/* =========================
   TAX FUNCTION (GLOBAL)
========================= */

ApplyIslandTax_fnc = {
 params ["_gross"];
 private _tax = round (_gross * IslandTaxRate);
 ASF_Balance = ASF_Balance + _tax;
 [_gross - _tax,_tax]
};

/* =========================
   BUSINESS OWNERSHIP (GLOBAL DEFAULTS)
========================= */

if (isNil "Owns_ChickenRun") then { Owns_ChickenRun = false; };
if (isNil "Owns_Alvinos") then { Owns_Alvinos = false; };
if (isNil "Owns_CoffeeShop1") then { Owns_CoffeeShop1 = false; };
if (isNil "Owns_CoffeeShop2") then { Owns_CoffeeShop2 = false; };
if (isNil "Owns_CoffeeShop3") then { Owns_CoffeeShop3 = false; };
if (isNil "Owns_Dispensary1") then { Owns_Dispensary1 = false; };
if (isNil "Owns_Dispensary2") then { Owns_Dispensary2 = false; };
if (isNil "Owns_Dispensary3") then { Owns_Dispensary3 = false; };
if (isNil "Owns_RenoClub") then { Owns_RenoClub = false; };
if (isNil "Owns_SendCash") then { Owns_SendCash = false; };
if (isNil "Owns_CaribIsland") then { Owns_CaribIsland = false; };
if (isNil "Owns_Apartment1") then {Owns_Apartment1 = false;};
if (isNil "Owns_Apartment2") then {Owns_Apartment2 = false;};
if (isNil "Owns_Apartment3") then {Owns_Apartment3 = false;};
if (isNil "Owns_Apartment4") then {Owns_Apartment4 = false;};
if (isNil "Owns_Apartment5") then {Owns_Apartment5 = false;};
if (isNil "Owns_Area1") then {Owns_Area1 = false;};
if (isNil "Owns_Area2") then {Owns_Area2 = false;};
if (isNil "Owns_Area3") then {Owns_Area3 = false;};


if (isNil "Island_SupaSkunk") then { Island_SupaSkunk = 0; };

if (isNil "Island_MaxStorage") then { Island_MaxStorage = 50000; };

if (isNil "Island_ProductionRate") then { Island_ProductionRate = 5; };


/* =========================
   BUSINESS STOCK GLOBAL INIT
========================= */

if (isNil "Produce_Chicken") then { Produce_Chicken = 0; };
if (isNil "Produce_Beef") then { Produce_Beef = 0; };
if (isNil "Produce_Weed") then { Produce_Weed = 0; };
if (isNil "Produce_Alcohol") then { Produce_Alcohol = 0; };

/* =========================
   BUSINESS INCOME LOOP
========================= */

[] spawn {
 while {true} do {

  sleep 40;

  if (Owns_ChickenRun && Produce_Chicken > 0) then {
   Produce_Chicken = Produce_Chicken - 1;
   DF_BankBalance = DF_BankBalance + 250;
  };

  if (Owns_Alvinos && Produce_Beef > 0) then {
   Produce_Beef = Produce_Beef - 1;
   DF_BankBalance = DF_BankBalance + 200;
  };

  if (Owns_RenoClub && Produce_Alcohol > 0) then {
   Produce_Alcohol = Produce_Alcohol - 1;
   DF_BankBalance = DF_BankBalance + 500;
  };

 };
};



/* =========================
   APARTMENT RENT LOOP
========================= */

[] spawn {
 while {true} do {

  sleep 600;

  private _rent = 0;

  if (Owns_Apartment1) then { _rent = _rent + 5000; };
  if (Owns_Apartment2) then { _rent = _rent + 10000; };
  if (Owns_Apartment3) then { _rent = _rent + 20000; };
  if (Owns_Apartment4) then { _rent = _rent + 15000; };
  if (Owns_Apartment5) then { _rent = _rent + 15000; };

  if (_rent > 0) then {
   DF_BankBalance = DF_BankBalance + _rent;
   profileNamespace setVariable ["DF_BankBalance", DF_BankBalance];
   saveProfileNamespace;
   hint format ["Apartment rent received: $%1", _rent];
  };

 };
};

/* =========================
   SENDCASH BTC GENERATION
========================= */

[] spawn {
 while {true} do {
  sleep 60;

  if (Owns_SendCash) then {
   if (isNil "Global_BTC") then { Global_BTC = 0; };
   Global_BTC = Global_BTC + 0.0003;
  };
 };
};

/* =========================
   SIMPLE RIVAL SPAWN SYSTEM
========================= */

SpawnRivalsAtPos_fnc = {
 params ["_pos"];

 private _grp = createGroup east;

 for "_i" from 1 to 3 do {
  private _unit = _grp createUnit ["O_G_Soldier_F", _pos, [], 0, "FORM"];
  _unit setCombatMode "RED";
  _unit setBehaviour "COMBAT";
 };

 _grp move _pos;
};

[] spawn {
 while {true} do {

  sleep 300;

  if (Owns_ChickenRun) then {
   [ChickenRun_Pos] call SpawnRivalsAtPos_fnc;
  };

  if (Owns_Alvinos) then {
   [Alvinos_Pos] call SpawnRivalsAtPos_fnc;
  };

  if (Owns_CoffeeShop) then {
   [CoffeeShop_Pos] call SpawnRivalsAtPos_fnc;
  };

 };
};

BSM_fnc_recruit = {

    PlayerFaction = "BSM";
    BSM_RankIndex = 0;

    [] call RefreshPanels_fnc;

    hint "Welcome to BlackStar Mafia";

};


Brotherhood_fnc_recruit = {

    PlayerFaction = "BROTHERHOOD";

    BH_RankIndex = 0;

    if (isNil "BH_Respect") then { BH_Respect = 0; };
    if (isNil "BH_Missions") then { BH_Missions = 0; };
    if (isNil "BH_Kills") then { BH_Kills = 0; };
    if (isNil "BH_Territories") then { BH_Territories = 0; };
    if (isNil "BH_Reputation") then { BH_Reputation = 0; };

    [] call RefreshPanels_fnc;

    hint "Welcome to The Brotherhood";

};



missionNamespace setVariable ["rangeActive", false, true];
missionNamespace setVariable ["totalHits", 0, true];

missionNamespace setVariable ["aiHits", 0, true];
missionNamespace setVariable ["aiActive", false, true];
[] execVM "ApartmentIncome.sqf"; 

[] execVM "rent2.sqf";

/* =========================
   END INIT
========================= */