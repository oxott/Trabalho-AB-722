function [F_prop_b,M_prop_b,Tl, Tr] = prop_loads(X,U, aircraft)

n_rho = aircraft.n_rho;
Tmax = aircraft.Tmax;

i_l_rad = aircraft.i_l_deg*pi/180;
tau_l_rad = deg2rad(aircraft.tau_l_deg);
x_l = aircraft.x_l;
y_l = aircraft.y_l;
z_l = aircraft.z_l;

i_r_rad = aircraft.i_r_deg*pi/180;
tau_r_rad = deg2rad(aircraft.tau_r_deg);
x_r = aircraft.x_r;
y_r = aircraft.y_r;
z_r = aircraft.z_r;

h = X(5);
rho = ISA(h);

throttle_l = U(1);
throttle_r = U(2);
Tl = throttle_l*Tmax*(rho/1.225)^n_rho;
Tr = throttle_r*Tmax*(rho/1.225)^n_rho;
C_tau_l = DCM(3, tau_l_rad);
C_tau_r = DCM(3, tau_r_rad);
C_iota_l = DCM(2,i_l_rad);
C_iota_r = DCM(2,i_r_rad);
C_lb = C_iota_l*C_tau_l;
C_rb = C_iota_r*C_tau_r;

F_prop_l = C_lb.'*[Tl; 0; 0];
F_prop_r = C_rb.'*[Tr; 0; 0];
F_prop_b = F_prop_l + F_prop_r;

M_prop_b = skew([x_l; y_l; z_l])*F_prop_l + skew([x_r; y_r; z_r])*F_prop_r;
end
