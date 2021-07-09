function[F_aero_b, M_aero_b] = aero_loads(X, U, aircraft, C_ba)
   
[CD,CY,CL,Cl,Cm,Cn] = aero_databank(X,U, aircraft);

V = X(1);
h = X(5);

rho = ISA(h);

q_bar = 0.5*rho*V^2;

S = aircraft.S;
b = aircraft.b;
c = aircraft.c;

D = q_bar*S*CD;
Y = q_bar*S*CY;
L = q_bar*S*CL;

F_aero_a = [-D -Y -L]';
F_aero_b = C_ba*F_aero_a;

l = q_bar*S*b*Cl;
m = q_bar*S*c*Cm;
n = q_bar*S*b*Cn;

M_aero_b = [l m n]';
end