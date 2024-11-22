function u = release_decision( s, x )

Si = [ 0 50/tan(x(1)) x(2)                      200 ]' ;
Ui = [ 0           50   50  50+(200-x(2))*tan(x(3)) ]' ;
u = interp1q(Si,Ui,s) ;
