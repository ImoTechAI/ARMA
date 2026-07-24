hint "Business.sqf Loaded";
Business_Panel_fnc = {

    private _gold = "#FFD700";
    private _green = "#00FF00";
    private _red = "#FF4444";

    if (isNil "Produce_Chicken") then { Produce_Chicken = 0; };
    if (isNil "Produce_Beef") then { Produce_Beef = 0; };
    if (isNil "Produce_Weed") then { Produce_Weed = 0; };
    if (isNil "Produce_Alcohol") then { Produce_Alcohol = 0; };
    if (isNil "Island_SupaSkunk") then { Island_SupaSkunk = 0; };

    {
        if (isNil _x) then { missionNamespace setVariable [_x,false]; };
    } forEach [
        "Owns_ChickenRun","Owns_CoffeeShop1","Owns_CoffeeShop2","Owns_CoffeeShop3",
        "Owns_Dispensary1","Owns_Dispensary2","Owns_Dispensary3",
        "Owns_RenoClub","Owns_Alvinos","Owns_SendCash","Owns_CaribIsland",
        "Owns_Apartment1","Owns_Apartment2","Owns_Apartment3","Owns_Apartment4","Owns_Apartment5"
    ];

    private _state = {
        if (missionNamespace getVariable [_this,false]) then {"<t color='#00FF00'>OWNED</t>"} else {"<t color='#FF4444'>NOT OWNED</t>"};
    };

    hint parseText format [
"<t size='1.6' color='#FFD700'>BUSINESS MANAGEMENT</t><br/><t color='#CCCCCC'>Business Empire Overview</t><br/><br/>
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
"Owns_ChickenRun" call _state,
"Owns_CoffeeShop1" call _state,
"Owns_CoffeeShop2" call _state,
"Owns_CoffeeShop3" call _state,
"Owns_Dispensary1" call _state,
"Owns_Dispensary2" call _state,
"Owns_Dispensary3" call _state,
"Owns_RenoClub" call _state,
"Owns_Alvinos" call _state,
"Owns_SendCash" call _state,
"Owns_CaribIsland" call _state,
"Owns_Apartment1" call _state,
"Owns_Apartment2" call _state,
"Owns_Apartment3" call _state,
"Owns_Apartment4" call _state,
"Owns_Apartment5" call _state,
Produce_Chicken,
Produce_Beef,
Produce_Weed,
Island_SupaSkunk,
Produce_Alcohol];
};

