$ontext
CEE 6410 - Water Resources Systems Analysis
Homework #5
Reservoir Operation
THE PROBLEM:
A reservoir is designed to provide hydropower and water for irrigation.
The turbine releases may also be used for irrigation as shown in Figure 1.
At least one unit of water must be kept in the river each month at point A.
The hydropower turbines have a capacity of 4 units of water per month (flows
are constant during any single month), and any other releases must bypass
the tur-bines.  The size of farmed area is very large relative to the amount
of irrigation water available, so there is no upper limit on usable irrigation
water.  The reservoir has a capacity of 9 units, and initial storage is 5 units
of water.  The ending storage must be equal to or greater than the begin-ning storage
                
THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Gabriela SanchoJuarez
gabriela.sancho@usu.edu
October 8th, 2024
$offtext

* 1. DEFINE the SETS
SETS m Months  /m1*m6/
     loc locations /res "Reservoir", hydro "Hydropower", irr "PointC", spill "Spillway", stA "SiteA"/
         ;   

* 2. DEFINE input data

PARAMETERS
    Inflow(m) /m1 2, m2 2, m3 3, m4 4, m5 3, m6 2/
    Hydropower_ben(m) /m1 1.6, m2 1.7, m3 1.8, m4 1.9, m5 2.0, m6 2.0/
    Irrigation_ben(m) /m1 1.0, m2 1.2, m3 1.9, m4 2.0, m5 2.2, m6 2.2/;

* 3. DEFINE the variables
VARIABLES
    X(loc,m)
    VBenefit;
   
* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
BENEFIT Total benefit ($) and objective function value
Reservoir_capacity the reservoir maximum sotrage capacity
Hydropower_capacity the maximm hydrpower turbines capacity
Riverflow_A the minimum flow required in pointA
EndStorage the final storage 
Inflowsto_C the flows to irrigation 
*ResBalance_init the reservoir initial mass balance 
ResBalance the reservoir mass balance
;
BENEFIT..                  VBenefit =E= sum(m, Hydropower_ben(m) * X('hydro', m) + Irrigation_ben(m) * X('irr',m));

Reservoir_capacity(m)..    X('res',m)=L= 9;
Hydropower_capacity(m) ..  X('hydro',m) =L= 4; 
Riverflow_A(m)..           X('stA',m)=G= 1; 
Inflowsto_C(m)..           X('spill',m)+ X('hydro',m) =E= X('stA',m)+ X('irr',m);
EndStorage..               X('res','m6') =G= 5  ;
*Approach #1
*ResBalance(m)..       Storage(t) = Storage(t-1) + Inflow(t) - Spill(t) - Hydropower(t); general equ
*InitialStorage$(ord(t) eq 1)
*Storage(t-1)$(ord(t) gt 1)

* I thought we had to define 2 equations like below, but the code doesnt run properly
*ResBalance_init(m)..   X('res','m6') =E= X('res','m6')$(ord(m) eq 1) + Inflow(m) -  X('spill', m) - X('hydro',m);
*ResBalance(m)..        X('res',m) =E= X('res',m-1)$(ord(m) gt 1) + Inflow(m) -  X('spill', m) - X('hydro',m);
*So I put everything in 1 equation
ResBalance(m)..           X('res',m) =E=  X('res','m6')$(ord(m) eq 1)+ X('res',m-1)$(ord(m) gt 1) + Inflow(m) -  X('spill', m) - X('hydro',m)


* 5. DEFINE the MODEL from the EQUATIONS
MODEL RESERVOIR /ALL/;

* 6. SOLVE the MODEL
* Solve the RESERVOIR model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize BENEFITS
SOLVE RESERVOIR USING LP MAXIMIZING VBenefit;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
