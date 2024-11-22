function [ s, u, r, v, V, g_flo, g_irr, g_hyd, g_rec ] = sim_Test( q, s0, x )
%

% Initialize variables:
N     = length(q)   ;
q_sim = [ nan; q ]  ;
u = nan*ones(N+1,1) ;
r = nan*ones(N+1,1) ;
s = nan*ones(N+1,1) ;
v = nan*ones(N+1,1) ;
V = nan*ones(N+1,1) ;
s(1)  = s0 ;
delta = 1  ;
% Run simulation:
for t = 1:N
    % compute min and max releasable volumes:
    v(t+1) = max( s(t) - 100, 0 ) ; % v = max( s - 100, 0 )
    V(t+1) = s(t)                 ; % V = s
    % compute decision:
    u(t)   = release_decision( s(t), x );
    % compute release:
    r(t+1) = max( v(t+1) , min( V(t+1) , u(t) ) ) ; 
    % compute future storage:
    s(t+1) = s(t) + delta * ( q_sim(t+1) - r(t+1) ) ;
end
% set parameter values:
w_irr   = 50   ; % m3/d
w_hyd   = 50   ; % m3/d
S       = 1    ; % m2
h_flo   = 50   ; % m
% compute step-costs:
h         = s / S  ; % m
g_flo   = max( h(2:end) - h_flo , 0 ) ; % m
g_irr   = max( w_irr - r(2:end) , 0 ); % m3/d
g_hyd   = max( w_hyd - r(2:end) , 0); %m3/d
g_rec   = max(50 - s(2:end),0);
    
g_flo   = [ NaN; g_flo ] ;
g_irr   = [ NaN; g_irr ] ;
g_hyd   = [ NaN; g_hyd ] ;
g_rec   = [ NaN; g_rec ] ;

