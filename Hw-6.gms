$ontext
CEE 6410 Fall 2015
Problem 1 Chapter 7 on Bishop et.al., 

Minimize cost to supply water for irrigation, with 2 possible water sources: a dam and a pump
Integer version using INTEGER VARIABLES statement and SOLVE as MIP.
Gabriela Sancho-Juarez
October 21, 2024
$offtext

* 1. DEFINE the SETS

SETS src water supply sources /damHigh "Dam High", damLow "Dam Low", pmp "Pump"/,
     t two seasons /s1 "season 1", s2 "season 2"/;

* 2. DEFINE input data
PARAMETERS
   CapCost(src) capital cost ($ to build)
         /damHigh 10000,
          damLow  6000,
          pmp     8000/
   OpCost(src) operating cost ($ per ac-ft)
         /pmp 20/
   DamMaxCapacity(src) Maximum capacity of source when built (ac-ft)
         /damHigh 700,
          damLow  300/    
   PumpCapacity(src) Maximum capacity of source when built (ac-ft per day)
         /pmp 2.2/
   IrrgDemand(t) Irrigation demand per season (ac-ft per acre)
         /s1 1.0,
          s2 3.0/
   RiverInfl(t) River inflow per season (ac-ft)
        /s1 600,
         s2 200/
   Groundwater(t) water gained in (ac-ft per day *180)
        /S1 2
         s2 2/
   Days(t) Days of each season of the year
       /s1 180,
        s2 180/
   IrrBenefit Revenue estimated in$ per year per acre irrigated
       /300/
* "Integer" variables free within 0 to 1 bounds. 
*   IntUpBnd(src) Upper bound on integer variables (#)
*         /damHigh 1,
*          damLow 1,
*         pmp 1/
*  IntLowBnd(src) Lower bound on integer variables (#)
*          /damHigh 0,
*           damLow 0,
*           pmp 0/;
*   
Groundwater(t) = Groundwater(t)*Days(t);


* 3. DEFINE the variables
VARIABLES I(src) binary decision to use or not each source src (1=yes 0=no)
          X(src) volume of water provided by source src (ac-ft per year)
          TCOST  total capital and operating costs of supply actions ($);
BINARY VARIABLES I;
* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   COST              Total Cost ($) and objective function value
   WaterBalance(t)   Water balance including the 2 seasons (ac-ft)
   DamMaxCap(src)    Maximum capacity of dam when built (ac-ft)
   PumpMaxCap(src)   Maximum capacity of pump when built (ac-ft per year)
   IntUpBound(src)   Upper bound on interger variables (number)
   IntLowBound(src)  Lower bound on integer variables (number);

COST..                 TCOST =E= SUM(src,CapCost(src)*I(src) + OpCost(src)*X('pmp'));
WaterBalance(t)..      RiverInfl(t) + Groundwater(t) =G=   IrrgDemand(t);
DamMaxCap(src) ..      X(src) =L= DamMaxCapacity(src)*I(src); 
PumpMaxCap (src)..     X(src) =L= PumpCapacity(src)*I(src);
IntUpBound(src) ..     I(src) =L= IntUpBnd(src);
IntLowBound(src) ..    I(src) =G= IntLowBnd(src);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL WatSupply /ALL/;

* 6. Solve the Model as an LP (relaxed IP)
SOLVE WatSupply USING MIP MINIMIZING TCOST;

DISPLAY X.L, I.L, TCOST.L;

* Dump all input data and results to a GAMS gdx file
Execute_Unload "Hw-6.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Hw-6.gdx"
