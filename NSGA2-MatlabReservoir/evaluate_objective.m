function f = evaluate_objective(x, M, V)
%
% function f = evaluate_objective(x, M, V)
%
% Function to evaluate the objective functions for the given input vector x.%
% x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% V is the number of decision variables. 
%
% This functions is basically written by the user who defines his/her own
% objective function. Make sure that the M and V matches your initial user
% input.
%

x = x(1:V) ;
x = x(:)   ;

% --------------------------------------
global opt_setting
q=opt_setting.q;
s0=opt_setting.s0;
%Costi per passo:
[ s, u, r, v, V, g_flo, g_irr, g_hyd, g_rec ] = sim_Test( q, s0, x ) ;
%Funzione obiettivo:
f=[ mean( g_flo(20:end)) mean( g_irr(20:end))  mean( g_hyd(20:end)) mean(g_rec(20:end))];%Il 20 serve per eliminare la fase iniziale di warm-up.
% --------------------------------------

% Check for error
if length(f) ~= M
    disp(length(f));
    disp(M);
    error('The number of decision variables does not match you previous input. Kindly check your objective function');
end