$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
THE PROBLEM:

An aqueduct constructed to supply water to industrial users has an excess capacity in the
months of June, July, and August of 14,000 acft, 18,000 acft, and 6,000 acft, respectively.
It is proposed to develop not more than 10,000 acres of new land by utilizing the excess
aqueduct capacity for irrigation water deliveries. Two crops, hay and grain, are to be
grown.
Their monthly water requirements (ac-ft/ac) and expected net returns ($/ac) are:

                Monthly Water Requirement (ac-ft)
        June        July        August          Return ($/ac)
Hay      2          1           1                   100       
Grain    1          2           0                   120


Formulate and solve the PRIMAL and DUALs of THE PROBLEM

Gabriela SanchoJuarez
gabriela.sancho@usu.edu

$offtext

* 1. DEFINE the SETS
SETS plnt crops growing /Hay, Grain/
     res resources /WaterJun, WaterJul, WaterAug, Land/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per plant)
          /Hay 100,
           Grain 120/
   b(res) Right hand constraint values (per resource)
          /WaterJun  14000,
           WaterJul  18000,
           WaterAug  6000,
           Land      10000/;
    
TABLE A(plnt,res) Left hand side constraint coefficients
          WaterJun  WaterJul WaterAug  Land
 Hay         2        1        1        1
 Grain       1        2        0        1;

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (Number)
          VPROFIT  total profit ($)
          Y(res)  value of resources used (units specific to variable)
          VREDCOST total reduced cost ($);

* Non-negativity constraints
POSITIVE VARIABLES X,Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   RES_CONS_PRIMAL(res) Resource constraints
   
   REDCOST_DUAL Reduced Cost ($) associated with using resources
   RES_CONS_DUAL(plnt) Profit levels;


*Primal Equations
PROFIT_PRIMAL..            VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONS_PRIMAL(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

*Dual Equations
REDCOST_DUAL..             VREDCOST =E= SUM(res,b(res)*Y(res));
RES_CONS_DUAL(plnt)..      SUM(res,A(plnt,res)*Y(res)) =G= c(plnt);


* 5. DEFINE the MODELS
*PRIMAL model
MODEL PLANT_PRIMAL /PROFIT_PRIMAL, RES_CONS_PRIMAL/;
*Set the options file to print out range of basis information
PLANT_PRIMAL.optfile = 1;

*DUAL model
MODEL PLANT_DUAL /REDCOST_DUAL, RES_CONS_DUAL/;

* 6. SOLVE the MODELS
* Solve the PLANTING PRIMAL model using a Linear Programming Solver to maximize VPROFIT
SOLVE PLANT_PRIMAL USING LP MAXIMIZING VPROFIT;

* Solve the PLANTING DUAL model using a Linear Programming Solver to maximize VPROFIT
SOLVE PLANT_DUAL USING LP MINIMIZING VREDCOST;

* 7 . Dump all data and results to GAMS proprietary file storage .gdx and to Excel
Execute_Unload "HW6-Dual.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls HW6-Dual.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.
