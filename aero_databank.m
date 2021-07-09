function [CD,CY,CL,Cl,Cm,Cn] = aero_databank(X,U,aircraft, flag, deltaXcg)
%flag = 0 Padrão
%flag = 1 -> Letra D)
    CL_0 = 0.308;
    CL_alpha = 0.133;
    CL_q = 16.7;
    CL_it = 0.0194;
    CL_delta_e = 0.00895; 
    
    Cm_0 = 0.017;
    Cm_alpha = -0.0402;
    Cm_q = -57;
    Cm_it = -0.0935;
    Cm_delta_e = -0.0448;
    
    CD_0 = 0.02207;
    CD_alpha = 0.00271;
    CD_alpha2 = 6.03e-4;
    CD_q2 = 35.904;
    CD_it = -4.2e-4;
    CD_it2 = 1.34e-4;
    CD_delta_e2 = 4.61e-5;
    CD_beta2 = 1.6e-4;
    CD_p2 = 0.5167;
    CD_r2 = 0.5738;
    CD_delta_a2 = 3e-5;
    CD_delta_r2 = 1.81e-5;
    
    CY_beta = 0.0228;
    CY_p = 0.084;
    CY_r = -1.21;
    CY_delta_a = 2.36e-4;
    CY_delta_r = -5.75e-3;
    
    Cl_beta = -3.66e-3;
    Cl_p = -0.661;
    Cl_r = 0.254;
    Cl_delta_a = -2.87e-3;
    Cl_delta_r = 6.76e-4;
    
    Cn_beta = 5.06e-3;
    Cn_p = -0.219;
    Cn_r = -0.634;
    Cn_delta_a = 1.5e-4;
    Cn_delta_r = -3.26e-3;
    if flag == 1
        %Letra D - 
        Cm_q = Cm_q - deltaXcg*(Cm_alpha*180/pi - CL_q) - deltaXcg^2*CL_alpha*180/pi;
        CL_q = CL_q - deltaXcg*(CL_alpha*180/pi); %CL_alpha_rad
        Cm_it = Cm_it + deltaXcg*CL_it;
        Cm_delta_e = Cm_delta_e + deltaXcg*CL_delta_e;
        %Nossas alterações
        Cm_alpha = Cm_alpha + deltaXcg*CL_alpha;
        Cm_0 = Cm_0 + deltaXcg*CL_0;
    end

V = X(1);
alpha_deg = X(2);
q_deg_s = X(3);
beta_deg = X(7);
p_deg_s = X(9);
r_deg_s = X(10);

i_t_deg = U(3);
delta_e_deg = U(4);
delta_a_deg = U(5);
delta_r_deg = U(6);

% alpha_rad = alpha_deg*pi/180;
% beta_rad = beta_deg*pi/180;

p_rad_s = p_deg_s*pi/180;
q_rad_s = q_deg_s*pi/180;
r_rad_s = r_deg_s*pi/180;

% i_t_rad = i_t_deg*pi/180;
% delta_e_rad = delta_e_deg*pi/180;
% delta_a_rad = delta_a_deg*pi/180;
% delta_r_rad = delta_r_deg*pi/180;

c = aircraft.c;
b = aircraft.b;

CL = CL_0 + ...
    CL_alpha*alpha_deg + ...
    CL_q*(q_rad_s*c/(2*V))+ ...
    CL_it*i_t_deg+ ...
    CL_delta_e*delta_e_deg;

Cm = Cm_0 + ...
    Cm_alpha*alpha_deg + ...
    Cm_q*(q_rad_s*c/(2*V))+ ...
    Cm_it*i_t_deg+ ...
    Cm_delta_e*delta_e_deg;

CD = CD_0 + ...
    CD_alpha*alpha_deg + ...
    CD_alpha2*alpha_deg^2 + ...
    CD_q2*(q_rad_s*c/(2*V))^2 + ...
    CD_it*i_t_deg + ...
    CD_it2*i_t_deg^2 + ...
    CD_delta_e2*delta_e_deg^2 + ...
    CD_beta2*beta_deg^2 + ...
    CD_p2* + (p_rad_s*b/(2*V))^2 + ...
    CD_r2* + (r_rad_s*b/(2*V))^2 + ...
    CD_delta_a2*delta_a_deg^2 + ...
    CD_delta_r2*delta_r_deg^2;

CY = CY_beta*beta_deg+ ...
    CY_p*(p_rad_s*b/(2*V))+ ...
    CY_r*(r_rad_s*b/(2*V))+ ...
    CY_delta_a*delta_a_deg + ...
    CY_delta_r*delta_r_deg;

Cl = Cl_beta*beta_deg+ ...
    Cl_p*(p_rad_s*b/(2*V))+ ...
    Cl_r*(r_rad_s*b/(2*V))+ ...
    Cl_delta_a*delta_a_deg+ ...
    Cl_delta_r*delta_r_deg;

Cn = Cn_beta*beta_deg+ ...
    Cn_p*(p_rad_s*b/(2*V))+ ...
    Cn_r*(r_rad_s*b/(2*V))+ ...
    Cn_delta_a*delta_a_deg+ ...
    Cn_delta_r*delta_r_deg;
