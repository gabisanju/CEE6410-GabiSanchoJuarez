%% ::: GA OPTIMIZATION(nsga2):::
% Code shared by Andrea Cominola, Politecnico di Milano, Milan, Italy, Spring 2015.
% Most comments are in Italian.

% English comments added by David E. Rosenberg, October 9, 2018

clear all

%Load the inflow time series from a text file
load -ascii Inflow_Test_AR0_1.txt
Inflow_Test_AR0_1=Inflow_Test_AR0_1;

%Set up NSGA-II to run for multiple objectives
%nsga2:algoritmo che funziona per problemi a molti obiettivi.
global opt_setting
opt_setting.q=Inflow_Test_AR0_1(1:150,2); %Allow opt_setting.q (inflow) to be seen across the companion functions
opt_setting.s0=100; %Initial storage
%Set the population size to 100

%% NSGA-II Parameters to set or adjust
pop=200; %Dimensione della popolazione testati ad ogni iterazione (se è alto si ha più 
        %probabilità di trovare l'ottimo, ma si hanno maggiori costi
        %computazionali). In genere si prende una popolazione con un ordine
        %di grandezza maggiore rispetto al numero delle variabili di
        %decisione.
%Set the number of generations to 20
gen=20;%Numero di iterazioni
iters = 10; % Number of iterations (times to run NSGA-II)

%% Problem Parameters
M=4;%Numero di funzioni obiettivo -- Number of objective functions
V=3;%Numero di variabili di decisione -- Number of decision variables

%Range of the decision variables (mininimum to maximum) [bounding box for
%the decision space
%Range delle variabili di decisioni
min_range=[0 50 0];
max_range=[pi/4 150 pi/2];

for i=1:iters %Run iters number of iterations, with different lower bounds for first decision variable
    if i<5
        min_range=[0 50 0];
    else
        min_range=[pi/4 50 0];
    end
    
    disp(i);
    %Run the NSGA-II algorithm
    [ chromosome_0, chromosome, f_intermediate ] = nsga_2(pop,gen,M,V,min_range,max_range);
    %Initial chromosome =>  [x1,x2,x3,J_flo,J_irr]*pop
    chromosome_0; %Matrice con i valori delle V all'inizializzazione e gli obiettivi --> [x1,x2,x3,J_flo,J_irr]*pop; 
    %Final chromosome
    chromosome; %Matrice come la precedente, ma sul finale.
    
    %Pull out results from the chromosome
    u1(:,i)=chromosome(:,1);
    u2(:,i)=chromosome(:,2);
    u3(:,i)=chromosome(:,3);

    J1(:,i)=chromosome(:,4);
    J2(:,i)=chromosome(:,5);
    J3(:,i)=chromosome(:,6);
    J4(:,i)=chromosome(:,7);
end

%Reshape the matrices for easier display in data file
u1=reshape(u1,pop*iters,1);
u2=reshape(u2,pop*iters,1);
u3=reshape(u3,pop*iters,1);

J1=reshape(J1,pop*iters,1);
J2=reshape(J2,pop*iters,1);
J3=reshape(J3,pop*iters,1);
J4=reshape(J4,pop*iters,1);
%% EXTREME POINT GENERATION TRY
for i=1:4 %Iterate over objective functions
    
    if i==1 % irrigation
    xA=[pi/4 150 pi/4];
    elseif i==2 % flood
            xA=[pi/4 50 pi/4];
    elseif i==3 % tourism
            xA=[0 150 0];
    elseif i==4 % hydropower
            xA=[pi/4 150 pi/4];
    else
            xA=[rand(1)*pi/4 rand(1)*150 rand(1)*pi/4];
                xA(2)=max(xA(2),50);
    end
   [ sA, uA, rA, vA, VA, g_flo_A, g_irr_A, g_hyd_A, g_rec_A ] = sim_Test( opt_setting.q, opt_setting.s0, xA ) ;
    
    u1(end+1)=xA(1);
    u2(end+1)=xA(2);
    u3(end+1)=xA(3);
    
    J1(end+1)=mean(g_flo_A(2:end));
    J2(end+1)=mean(g_irr_A(2:end));
    J3(end+1)=mean(g_hyd_A(2:end));
    J4(end+1)=mean(g_rec_A(2:end));

end

disp('done');

%Calculate the dominance rank of all alternatives
NumResults = [J1 J2 J3 J4 u1 u2 u3]; % Four objective functions and then 3 decision variables
NumResultsDom = non_domination_sort_mod(NumResults ,M,V);

%Dump the results to csv file
Headers = {'FloodIntensity' 'UnmetIrrDemand' 'UnmetHydroDemand' 'UnmetRecreationDemand'	'x1' 'x2'	'x3' 'Dominance' };
writetable(cell2table([Headers; num2cell(NumResultsDom(:,1:end-1))]),'HW8_altsNew.csv','writevariablenames',0);

%% COLOR BAR
%Define the colorbar scale
 %Light  To Dark Blue, 10 Steps
   %Row 1 is Light blue (near white)
   % Row 10 is dark blue 
   LightToDarkBlue10Step = [0.9	1	1
        0.8	0.983	1
        0.7	0.95	1
        0.6	0.9	1
        0.5	0.833	1
        0.4	0.75	1
        0.3	0.65	1
        0.2	0.533	1
        0.1	0.4	1
        0	0.25	1];



%% PLOTTING RSULTS as 2D Scatter plot for 2 Objectives

% J1 = 'Flood Intensity'
% J2 = 'Unmet Irrigation Demand'
% J3 = 'Unmet Hydropower Demand'
% J4 = 'Unmet Recreation Demand'

sLabels = {'Flood Intensity' 'Unmet Irrigation Demand' 'Unmet Hydropower Demand' 'Unmet Recreation Demand' 'x1' 'x2' 'x3'};

%2 Objective functions - Substitute J2, J3, J4 on the lines below
xToUse = J1; xLab = sLabels{1};
yToUse = J2; yLab = sLabels{2};
%Try different combinations, e.g.,
figure
scatter(xToUse, yToUse);
hold on
%Add the ideal point in Red fill
scatter(min(xToUse),min(yToUse), 100, 'MarkerFaceColor', 'r')
xlabel(xLab);
ylabel(yLab);


%% PLOTTING RESULTS as 3D Scatter plot (3 Objectives)

figure
hold on
%scatter3(J1, J2, J3, [],'filled'); %Flood, UnmetIrridation, UnmetHydropower demand on X. Y, Z axis
scatter3(J1, J2, J4, [],'filled'); %Flood, UnmetIrridation, UnmetRecreation Demand demand on X. Y, Z axis
%Add the ideal point in Red fill
scatter3(min(J1),min(J2),min(J4),100, 'MarkerFaceColor', 'r');
xlabel('Flood Intensity');
ylabel('Unmet Irrigation Demand');
zlabel('Unmet Hydropower Demand');
hold off


%% PLOTTING RESULTS as 3D Scatter with Color (4 Objectives)

figure
%scatter3(J1, J2, J3, [],J4, 'filled'); %Flood, UnmetIrridation, UnmetHydropower demand on X. Y, Z axis, Unmet Recreation Demand as color
scatter3(J1, J2, J4, [],J3, 'filled'); %Flood, UnmetIrridation, UnmetRecreation Demand demand on X. Y, Z axis, Unmet Hydropower Demand as color
hold on
%Overplot dominence one points in black
Dom1 = NumResultsDom(:,8) == 1;
scatter3(J1(Dom1==1), J2(Dom1==1), J4(Dom1==1), [],J3(Dom1==1), 'MarkerFaceColor', [0 0 0]);

%Add the ideal point in Red fill
scatter3(min(J1),min(J2),min(J4),100, min(J3), 'MarkerFaceColor', 'r');

%hold on;scatter3(J1(end), J2(end), J4(end));
xlabel('Flood Intensity');
ylabel('Unmet Irrigation Demand');
zlabel('Unmet Hydropower Demand');

c = colorbar;
c.Label.String = 'Unmet Recreation Demand';
colormap(LightToDarkBlue10Step);

hold off


%% PLOTTING RESULTS as 2D Scatter plot with color (3 objectives or 2 objectives and 1 decision variable)

%3 Objective functions - Substitute J2, J3, J4 on the lines below and/or
%u1, u2, or u3 for the decision variables

xToUse = J1; xLab = sLabels{1};
yToUse = J2; yLab = sLabels{2};
cToUse = u1; cLabel = sLabels{5};
%Try different combinations, e.g.,
figure
scatter(xToUse, yToUse,[], cToUse);
hold on
%Add the ideal point in Red fill
scatter(min(xToUse),min(yToUse), 100, 'MarkerFaceColor', 'r')
xlabel(xLab);
ylabel(yLab);

c = colorbar;
c.Label.String = cLabel;
colormap(LightToDarkBlue10Step);

