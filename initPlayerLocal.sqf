call compile preprocessFileLineNumbers "scripts\business.sqf";

waitUntil { !isNull player && alive player };

/* =========================
   CORE STATE (PLAYER SIDE)
========================= */

if (isNil "PlayerFaction") then { PlayerFaction = "CIV"; };

if (isNil "DF_RankIndex") then { DF_RankIndex = 0; };
if (isNil "BSM_RankIndex") then { BSM_RankIndex = 0; };
if (isNil "BH_RankIndex") then { BH_RankIndex = 0; };
if (isNil "BSG_RankIndex") then { BSG_RankIndex = 0; };
if (isNil "BSG_XP") then { BSG_XP = 0; };
if (isNil "BSG_Rank") then { BSG_Rank = "Civilian"; };

if (isNil "DF_BankBalance") then { DF_BankBalance = 0; };
if (isNil "DF_Cash") then { DF_Cash = 0; };
if (isNil "DF_Weed") then { DF_Weed = 0; };
if (isNil "DF_BTC") then { DF_BTC = 0.0; };


if (isNil "DF_BankBalance") then { DF_BankBalance = 5000; };
if (isNil "DF_Cash") then { DF_Cash = 1000; };
if (isNil "BH_Weed") then { BH_Weed = 0; };
if (isNil "DF_BTC") then { DF_BTC = 0; };
if (isNil "BH_Respect") then { BH_Respect = 0; };
if (isNil "BH_Missions") then { BH_Missions = 0; };
if (isNil "BH_Kills") then { BH_Kills = 0; };
if (isNil "BH_Territories") then { BH_Territories = 0; };
if (isNil "BH_Reputation") then { BH_Reputation = 0; };


if (isNil "ASF_Balance") then { ASF_Balance = 0; };
if (isNil "IslandTaxRate") then { IslandTaxRate = 0.10; };

if (isNil "LastResignTime") then { LastResignTime = -9999; };

if (isNil "Produce_Chicken") then { Produce_Chicken = 0; };
if (isNil "Produce_Weed") then { Produce_Weed = 0; };
if (isNil "Produce_Beef") then { Produce_Beef = 0; };
if (isNil "Produce_Alcohol") then { Produce_Alcohol = 0; };

/* =========================
   CHANGE SIDE
========================= */

ChangePlayerSide_fnc = {
 params ["_side"];
 private _grp = createGroup [_side, true];
 [player] joinSilent _grp;
};

/* =========================
   RANK DATA
========================= */

DF_RankData = [
 ["RECRUIT"],
 ["PRIVATE"],
 ["LANCE CORPORAL"],
 ["CORPORAL"],
 ["SERGEANT"],
 ["STAFF SERGEANT"],
 ["WARRANT OFFICER"],
 ["2ND LIEUTENANT"],
 ["LIEUTENANT"],
 ["CAPTAIN"],
 ["MAJOR"],
 ["LIEUTENANT COLONEL"],
 ["COLONEL"]
];

BSM_RankData = [
 ["Associate"],["Soldier"],["Enforcer"],["Shot Caller"],["Baller"],
 ["OG"],["Lieutenant"],["Capo"],["Underboss"],["Dan"],
 ["Kingpin"],["Godfather"],["Oga"]
];

BSG_RankData = [
 ["Civilian"],
 ["Black Survivor"],
 ["Scout"],
 ["Pathfinder"],
 ["Homesteader"],
 ["Ranger"],
 ["Pioneer"],
 ["Black Survival Expert"],
 ["BSG Ghost"]
];

/* =========================
   SALARIES
========================= */

BSM_SalaryTable = [185,370,740,1295,2220,3700,5550,7400,11100,14800,22200,29600,44400];
DF_SalaryTable  = [50,100,200,350,600,1000,1500,2000,3000,4000,6000,8000,12000];

/* =========================
   TAX
========================= */

ApplyIslandTax_fnc = {
 params ["_gross"];
 private _tax = round (_gross * IslandTaxRate);
 ASF_Balance = ASF_Balance + _tax;
 [_gross - _tax,_tax]
};

/* =========================
   DF PANEL (FINAL)
========================= */

DF_Panel_fnc = {

 private _rankName = toUpper ((DF_RankData select DF_RankIndex) select 0);

 /* ===== SPEC TEXT ===== */

 private _specText = "";

if (missionNamespace getVariable ["DF_Spec_PARA", false]) then {
 _specText = _specText + "PARA | ";
};

if (missionNamespace getVariable ["DF_Spec_SN", false]) then {
 _specText = _specText + "SNIPER | ";
};

if (missionNamespace getVariable ["DF_Spec_ASS", false]) then {
 _specText = _specText + "ASSAULT | ";
};

if (missionNamespace getVariable ["DF_Spec_COM", false]) then {
 _specText = _specText + "COMMANDO | ";
};

if (_specText != "") then {
 _specText = _specText select [0, (count _specText) - 3];
} else {
 _specText = "NONE";
};

 /* ===== RANK IMAGE ===== */

 private _img = switch (_rankName) do {
  case "RECRUIT": {"images\REC.jpg"};
  case "PRIVATE": {"images\PTE.jpg"};
  case "LANCE CORPORAL": {"images\LCPL.jpg"};
  case "CORPORAL": {"images\CPL.jpg"};
  case "SERGEANT": {"images\SGT.jpg"};
  case "STAFF SERGEANT": {"images\SSGT.jpg"};
  case "WARRANT OFFICER": {"images\WO.jpg"};
  case "2ND LIEUTENANT": {"images\2LT.jpg"};
  case "LIEUTENANT": {"images\LT.jpg"};
  case "CAPTAIN": {"images\CAPT.jpg"};
  case "MAJOR": {"images\MAJ.jpg"};
  case "LIEUTENANT COLONEL": {"images\LTCOL.jpg"};
  case "COLONEL": {"images\COL.jpg"};
  case "BSG": {
        BSG_PanelID = player addAction ["View BSG Panel",BSG_Panel_fnc];
    };

    default {"images\default.jpg"};
 };

 /* ===== PARA BADGE (TOP) ===== */

 private _topBadge = "";
 if (!isNil "DF_Spec_PARA") then {
  _topBadge = "<img size='2.8' image='images\dfwings.jpg'/><t size='0.15'><br/></t>";
 };

 /* ===== PANEL DISPLAY ===== */

hint parseText format [
"<t size='1.5' color='#FFD700'>BUSINESS ASSETS</t><br/><br/>
<t color='#FFD700'>BUSINESSES</t><br/>
Chicken Run: %1<br/>
Coffee Shop 1: %2<br/>
Coffee Shop 2: %3<br/>
Coffee Shop 3: %4<br/>
Dispensary 1: %5<br/>
Dispensary 2: %6<br/>
Dispensary 3: %7<br/>
Reno Club: %8<br/>
Alvinos: %9<br/>
SendCash: %10<br/>
Caribbean Island: %11<br/><br/>
<t color='#FFD700'>APARTMENTS</t><br/>
Apartment Block 1: %12<br/>
Apartment Block 2: %13<br/>
Apartment Block 3: %14<br/>
Apartment Block 4: %15<br/>
Apartment Block 5: %16<br/><br/>
<t color='#FFD700'>CURRENT STOCK</t><br/>
Chicken: %17<br/>
Beef: %18<br/>
Weed: %19 g<br/>
SupaSkunk: %20 g<br/>
Alcohol: %21",
_chicken,_coffee1,_coffee2,_coffee3,_disp1,_disp2,_disp3,_reno,_alvinos,_sendCash,_carib,
_apt1,_apt2,_apt3,_apt4,_apt5,
Produce_Chicken,Produce_Beef,Produce_Weed,Island_SupaSkunk,Produce_Alcohol];

};



/* =========================
   PANEL SYSTEM
========================= */

DF_PanelID=-1; BSM_PanelID=-1;
BH_PanelID=-1; BSG_PanelID=-1; Business_PanelID=-1;

RefreshPanels_fnc = {

 { if (_x>=0) then {player removeAction _x} } forEach
 [DF_PanelID,BSM_PanelID,BH_PanelID,BSG_PanelID,Business_PanelID];

 DF_PanelID=-1; BSM_PanelID=-1;
BH_PanelID=-1; BSG_PanelID=-1; Business_PanelID=-1;

 switch (PlayerFaction) do {

  case "DF": {
   DF_PanelID = player addAction ["View DarkFire Panel",DF_Panel_fnc];
   BSG_PanelID = player addAction ["View BSG Panel",BSG_Panel_fnc];
  };

  case "BSM": {
   BSM_PanelID = player addAction ["View Black Star Mafia Panel",BSM_Panel_fnc];
   BSG_PanelID = player addAction ["View BSG Panel",BSG_Panel_fnc];
  };

  case "BROTHERHOOD": {
   BH_PanelID = player addAction ["View Brotherhood Panel",Brotherhood_Panel_fnc];
   BSG_PanelID = player addAction ["View BSG Panel",BSG_Panel_fnc];
  };

  case "BSG": {
        BSG_PanelID = player addAction ["View BSG Panel",BSG_Panel_fnc];
    };

    default {
   BSG_PanelID = player addAction ["View BSG Panel",BSG_Panel_fnc];
  };

 };

 Business_PanelID = player addAction ["View Business Assets",Business_Panel_fnc];
};

/* =========================
   SALARY LOOP (60s)
========================= */

[] spawn {
 waitUntil { !isNil "PlayerFaction" };

 while {true} do {

  sleep 60;

  if (PlayerFaction == "DF") then {
   private _idx = DF_RankIndex min ((count DF_SalaryTable) - 1);
   private _pay = DF_SalaryTable select _idx;
   private _r = [_pay] call ApplyIslandTax_fnc;
   DF_BankBalance = DF_BankBalance + (_r select 0);
  };

  if (PlayerFaction == "BROTHERHOOD") then {
   private _idx = BH_RankIndex min ((count BH_SalaryTable)-1);
   private _pay = BH_SalaryTable select _idx;
   private _r = [_pay] call ApplyIslandTax_fnc;
   DF_BankBalance = DF_BankBalance + (_r select 0);
  };

 };
};


BSG_Ranks = [
    [0,"Civilian"],
    [50,"Black Survivor"],
    [150,"Scout"],
    [300,"Pathfinder"],
    [600,"Homesteader"],
    [1200,"Ranger"],
    [2500,"Pioneer"],
    [5000,"Black Survival Expert"],
    [10000,"BSG Ghost"]
];

BSG_fnc_UpdateRank = {
    private _oldRank = BSG_Rank;
    BSG_RankIndex = 0;
    BSG_Rank = "Civilian";

    {
        if (BSG_XP >= (_x select 0)) then {
            BSG_RankIndex = _forEachIndex;
            BSG_Rank = _x select 1;
        };
    } forEach BSG_Ranks;

    profileNamespace setVariable ["BSG_RankIndex", BSG_RankIndex];
    profileNamespace setVariable ["BSG_Rank", BSG_Rank];
    saveProfileNamespace;

    if (_oldRank != BSG_Rank) then {
        titleText [format ["PROMOTED

%s", toUpper BSG_Rank], "PLAIN DOWN", 2];
        playSound "FD_Start_F";
    };
};

/* =========================
   INIT
========================= */

[] call RefreshPanels_fnc;


//==============================
// BSM Rank System (Bank Balance)
//==============================
BSM_RankData = [
    [0,"Associate"],
    [1000,"Soldier"],
    [5000,"Enforcer"],
    [10000,"Shot Caller"],
    [25000,"Baller"],
    [50000,"OG"],
    [100000,"Lieutenant"],
    [250000,"Capo"],
    [500000,"Underboss"],
    [1000000,"Dan"],
    [2500000,"Kingpin"],
    [5000000,"Godfather"],
    [10000000,"Oga"]
];

BSM_fnc_UpdateRank = {
    private _money = if (!isNil "DF_BankBalance") then {DF_BankBalance} else {
    if (!isNil "ASF_Balance") then {ASF_Balance} else {0}
};
    private _rank = 0;

    {
        if (_money >= (_x select 0)) then {
            _rank = _forEachIndex;
        };
    } forEach BSM_RankData;

    if (isNil "BSM_PlayerRank") then { BSM_PlayerRank = -1; };

    if (isNil "BSM_PlayerRank") then { BSM_PlayerRank = 0; };

    if (_rank > BSM_PlayerRank) then {
        BSM_PlayerRank = _rank;
        BSM_RankIndex = _rank;
        hint format ["PROMOTED!\n\nNew Rank: %1\nBank: $%2",(BSM_RankData select _rank) select 1,_money];
    } else {
        BSM_RankIndex = BSM_PlayerRank;
    };
};

[] spawn {
    while {true} do {
        [] call BSM_fnc_UpdateRank;
        if (PlayerFaction == "BROTHERHOOD") then {
            [] call BH_fnc_UpdateRank;
        };
        sleep 5;
    };
};



if (isNil "BSM_DismissAction") then {

    BSM_DismissAction = player addAction [
        "Dismiss BlackStar Recruits",
        {
            private _guards = units group player select {
                alive _x && {_x getVariable ["WilliamsRecruit", false]}
            };

            {
                [_x] joinSilent grpNull;
                doStop _x;
                _x setBehaviour "AWARE";
                _x setCombatMode "YELLOW";
                _x setSpeedMode "LIMITED";
            } forEach _guards;

            hint format ["%1 BlackStar Recruit(s) dismissed.",count _guards];
        },
        nil,
        1.5,
        true,
        true,
        "",
        "{alive _x && {_x getVariable ['WilliamsRecruit',false]}} count (units group player) > 0"
    ];

};

BH_RankData = [

    [0,"Man of Interest"],
    [50,"Brother"],
    [100,"Soldier"],
    [250,"Enforcer"],
    [500,"Veteran"],
    [1000,"Lieutenant"],
    [2500,"Captain"],
    [5000,"Commander"],
    [10000,"High Council"],
    [25000,"General"]

];

BH_SalaryTable = [
    200,
    400,
    800,
    1200,
    1800,
    2600,
    4000,
    6000,
    9000,
    15000
];







Brotherhood_Panel_fnc = {
    private _rank = (BH_RankData select BH_RankIndex) select 1;
    private _respectColor = if (BH_Respect < 0) then {"#FF0000"} else {"#00FF00"};
    hint parseText format [
"<t align='center' size='1.8' color='#00BFFF'>THE BROTHERHOOD</t><br/><br/><t size='1.2'>Rank:</t><br/><t align='center' size='1.8' color='#FFD700'>%1</t><br/><br/><t size='1.2'>Cash:</t> <t color='#00FF00'>$%2</t><br/><t size='1.2'>Bank:</t> <t color='#00BFFF'>$%3</t><br/><t size='1.2'>BTC:</t> <t color='#FFD700'>%4</t><br/><t size='1.2'>Respect:</t> <t color='%6'>%5</t><br/><t size='1.2'>Missions:</t> %6<br/><t size='1.2'>Kills:</t> %7<br/><t size='1.2'>Territories:</t> %8<br/><t size='1.2'>Reputation:</t> %9",
_rank,DF_Cash,DF_BankBalance,DF_BTC,BH_Respect,BH_Missions,BH_Kills,BH_Territories,BH_Reputation];
};

BH_fnc_UpdateRank = {
    private _oldRank = BH_RankIndex;

    {
        if (BH_Respect >= (_x select 0)) then {
            BH_RankIndex = _forEachIndex;
        };
    } forEach BH_RankData;

    if (BH_RankIndex > _oldRank) then {
        private _rankName = (BH_RankData select BH_RankIndex) select 1;

        [
            format [
                "<t align='center'><img image='Bro.jpg' size='5.5'/><br/><t size='2.4' color='#FFD700'>PROMOTION</t><br/><t size='1.4' color='#FFFFFF'>CONGRATULATIONS</t><br/><br/><t size='2.6' color='#00BFFF'>%1</t><br/><br/><t size='1.2' color='#FFFFFF'>WELCOME TO YOUR NEW RANK</t></t>",
                _rankName
            ],
            0,
            0.2,
            8,
            0.5
        ] spawn BIS_fnc_dynamicText;
        playSound "FD_Finish_F";
    };
};





addMissionEventHandler ["EntityKilled", {

    params ["_killed", "_killer"];

    if (isNull _killer) exitWith {};
    if (!isPlayer _killer) exitWith {};
    if (_killer != player) exitWith {};
    if (PlayerFaction != "BROTHERHOOD") exitWith {};

    BH_Kills = BH_Kills + 1;
    BH_Respect = BH_Respect + 5;

    [] call BH_fnc_UpdateRank;

    hint parseText format [
        "<t align='center' size='1.5' color='#00BFFF'>KILL CONFIRMED</t><br/><br/><t color='#00FF00' size='1.3'>+1 ELIMINATION</t><br/><t color='#FFD700' size='1.3'>+5 RESPECT</t><br/><br/><t color='#FFFFFF'>ELIMINATIONS:</t> <t color='#00FF00'>%1</t><br/><t color='#FFFFFF'>CURRENT RESPECT:</t> <t color='#FFD700'>%2</t>",
        BH_Kills,
        BH_Respect
    ];

}];





if (isNil "NextBTCPayout") then {
    NextBTCPayout = time + 300;
};

if (time >= NextBTCPayout) then {

    NextBTCPayout = time + 300;

    private _earned = 0;

    if (Owns_SendCash) then {
        DF_BTC = DF_BTC + 0.009;
        _earned = _earned + 0.009;
    };

    if (Owns_BTCMine) then {
        DF_BTC = DF_BTC + 0.09;
        _earned = _earned + 0.09;
    };

    if (_earned > 0) then {

        profileNamespace setVariable ["DF_BTC", DF_BTC];
        saveProfileNamespace;

        hint parseText format [
            "<t size='1.4' color='#FFD700'>BTC PAYOUT</t><br/><t color='#00FF00'>+%1 BTC</t><br/><t>Total BTC: %2</t>",
            _earned,
            DF_BTC
        ];

    };

};

[] execVM "rent1.sqf";

DealerPanel_fnc = {

    private _dealer1 = missionNamespace getVariable ["Dealer1",objNull];
    private _d1Stock = if (!isNull _dealer1) then {_dealer1 getVariable ["Dealer_Stock",0]} else {0};
    private _dealer2 = missionNamespace getVariable ["Dealer2",objNull];
    private _d2Stock = if (!isNull _dealer2) then {_dealer2 getVariable ["Dealer_Stock",0]} else {0};
    private _dealer3 = missionNamespace getVariable ["Dealer3",objNull];
    private _d3Stock = if (!isNull _dealer3) then {_dealer3 getVariable ["Dealer_Stock",0]} else {0};

    private _d1Sold = if (!isNull _dealer1) then {_dealer1 getVariable ["Dealer_TotalSold",0]} else {0};
    private _d2Sold = if (!isNull _dealer2) then {_dealer2 getVariable ["Dealer_TotalSold",0]} else {0};
    private _d3Sold = if (!isNull _dealer3) then {_dealer3 getVariable ["Dealer_TotalSold",0]} else {0};

    private _d1State = if (!isNull _dealer1 && {_dealer1 getVariable ["Dealer_Arrested",false]}) then {"JAILED"} else {"ACTIVE"};
    private _d2State = if (!isNull _dealer2 && {_dealer2 getVariable ["Dealer_Arrested",false]}) then {"JAILED"} else {"ACTIVE"};
    private _d3State = if (!isNull _dealer3 && {_dealer3 getVariable ["Dealer_Arrested",false]}) then {"JAILED"} else {"ACTIVE"};

    hintSilent parseText format [
        "<t size='#1.4' color='#00FF00'>DEALER NETWORK</t><br/><br/>"+
        "<t color='#FFD700'>Dealer 1</t><br/>Status: %1<br/>Stock: %2g<br/>Sold: %3g<br/><br/>"+
        "<t color='#FFD700'>Dealer 2</t><br/>Status: %4<br/>Stock: %5g<br/>Sold: %6g<br/><br/>"+
        "<t color='#FFD700'>Dealer 3</t><br/>Status: %7<br/>Stock: %8g<br/>Sold: %9g<br/><br/>"+
        "<t color='#00FFFF'>Total Stock: %10g</t><br/><t color='#00FFFF'>Total Sold: %11g</t>",
        _d1State,_d1Stock,_d1Sold,
        _d2State,_d2Stock,_d2Sold,
        _d3State,_d3Stock,_d3Sold,
        (_d1Stock+_d2Stock+_d3Stock),
        (_d1Sold+_d2Sold+_d3Sold)
    ];
};
