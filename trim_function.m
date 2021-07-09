function [f, X, U, Y] = trim_function(x, trim_par, aircraft)

%x = [V alpha_deg q_deg_s theta_deg | phi_deg p_deg_s r_deg_s psi_deg |
%     throttle_l throttle_r i_t_deg delta_a_deg delta_r_deg]'

beta_deg_eq = 0;
delta_e_deg_eq = 0;

h = trim_par.h;

X = [
    x(1:4)
    h
    0
    beta_deg_eq
    x(5:8)
    0
    ];

U = [
    x(9:11)
    delta_e_deg_eq
    x(12:13)
    ];

[Xdot,Y] = dynamics(0,X,U, aircraft);

ydot_eq = 0;
V_eq = trim_par.V;
gamma_deg_eq = trim_par.gamma_deg;
xdot_eq = V_eq*cosd(gamma_deg_eq);
hdot_eq = V_eq*sind(gamma_deg_eq);

f = [
    Xdot(1:3)
    Xdot(4) - trim_par.thetadot_deg_s
    Xdot(5) - hdot_eq
    Xdot(6) - xdot_eq
    Xdot(7:10)
    Xdot(11) - trim_par.psidot_deg_s
    Xdot(12) - ydot_eq
    x(9) - x(10) %+ 0.1
    ];
    

end