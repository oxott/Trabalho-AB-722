clear all
close all
clc

g = 9.80665;

aircraft = struct('S',116,...
                  'c',3.862,...
                  'b',32.757,...
                  'm',55788,...
                  'Ixx',8.215e5,...
                  'Iyy',3.344e6,...
                  'Izz',4.057e6,...
                  'Ixz',1.789e5,...
                  'i_l_deg',2,...
                  'i_r_deg',2,...
                  'x_l',4.899,...
                  'y_l',-5.064,...
                  'z_l',1.435,...
                  'x_r',4.899,...
                  'y_r',5.064,...
                  'z_r',1.435,...
                  'tau_l_deg',1.5,...
                  'tau_r_deg',-1.5,...
                  'Tmax',100e3,...
                  'n_rho',0.8,... 
                  'g',  9.80665);

psidot_deg_s_eq = 0;

trim_par = struct('V',230.15,...
                  'h',11582.4,...
                  'gamma_deg',0,...
                  'thetadot_deg_s',0,...
                  'psidot_deg_s',psidot_deg_s_eq);

% Test case:
Xtest = [
    250
    2
    5
    5
    5000
    0
    2
    10
    10
    15
    10
    0
    ];
Utest = [0.5;0.5; -5; 5; 5; 5];
dynamics(0,Xtest,Utest, aircraft)
%%
% https://www.mathworks.com/help/optim/ug/tolerances-and-stopping-criteria.html
options = optimset('Display','iter','TolX',1e-10,'TolFun',1e-10);
% % Em versões mais novas, pode ser necessário utilizar o seguinte:
% options = optimoptions(@fsolve,'Display','iter','StepTolerance',1e-10,'FunctionTolerance',1e-10);
% % ou:
% options = optimoptions(@fsolve,'Display','iter','TolX',1e-10,'TolFun',1e-10);

%--------------------------------------------------------------------------
% Trimmed flight conditions:

trim_output = struct('X_eq',zeros(13,1),...
                        'U_eq',zeros(5,1),...
                        'Y_eq',zeros(9,1));

x_eq_0 = zeros(13,1);
x_eq_0(1) = trim_par.V;
x_eq = fsolve(@trim_function,x_eq_0,options,trim_par, aircraft);
[~,X_eq,U_eq, Y_eq] = trim_function(x_eq,trim_par,aircraft);

trim_output.X_eq = X_eq;
trim_output.U_eq = U_eq;
trim_output.Y_eq = Y_eq;

fprintf('-----FLIGHT CONDITION -----\n\n');
fprintf('   %-10s = %10.4f %-4s\n','gamma',trim_par.gamma_deg,'deg');
fprintf('   %-10s = %10.4f %-4s\n','theta_dot',trim_par.thetadot_deg_s,'deg/s');
fprintf('   %-10s = %10.4f %-4s\n','psi_dot',trim_par.psidot_deg_s,'deg/s');
fprintf('\n');
fprintf('   %-10s = %10.2f %-4s\n','V',X_eq(1),'m/s');
fprintf('   %-10s = %10.4f %-4s\n','alpha',X_eq(2),'deg');
fprintf('   %-10s = %10.4f %-4s\n','q',X_eq(3),'deg/s');
fprintf('   %-10s = %10.4f %-4s\n','theta',X_eq(4),'deg');
fprintf('   %-10s = %10.1f %-4s\n','h',X_eq(5),'m');
fprintf('\n');
fprintf('   %-10s = %10.4f %-4s\n','beta',X_eq(7),'deg');
fprintf('   %-10s = %10.4f %-4s\n','phi',X_eq(8),'deg');
fprintf('   %-10s = %10.4f %-4s\n','p',X_eq(9),'deg/s');
fprintf('   %-10s = %10.4f %-4s\n','r',X_eq(10),'deg/s');
fprintf('   %-10s = %10.4f %-4s\n','psi',X_eq(11),'deg');
fprintf('\n');
fprintf('   %-10s = %10.2f %-4s\n','throttle left',U_eq(1)*100,'%');
fprintf('   %-10s = %10.2f %-4s\n','throttle right',U_eq(2)*100,'%');
fprintf('   %-10s = %10.2f %-4s\n','Thrust Left',Y_eq(2),'N');
fprintf('   %-10s = %10.2f %-4s\n','Thrust Right',Y_eq(3),'N');
fprintf('   %-10s = %10.4f %-4s\n','i_t',U_eq(3),'deg');
fprintf('   %-10s = %10.4f %-4s\n','delta_e',U_eq(4),'deg');
fprintf('   %-10s = %10.4f %-4s\n','delta_a',U_eq(5),'deg');
fprintf('   %-10s = %10.4f %-4s\n','delta_r',U_eq(6),'deg');
fprintf('\n');
fprintf('   %-10s = %10.4f %-4s\n','Mach',Y_eq(4),'');
fprintf('\n');
fprintf('   %-10s = %10.4f %-4s\n','C_D',Y_eq(5),'');
fprintf('   %-10s = %10.4f %-4s\n','C_L',Y_eq(6),'');
fprintf('   %-10s = %10.4f %-4s\n','C_m',Y_eq(7),'');
fprintf('\n');
fprintf('   %-10s = %10.4f %-4s\n','C_Y',Y_eq(8),'');
fprintf('   %-10s = %10.4f %-4s\n','C_l',Y_eq(9),'');
fprintf('   %-10s = %10.4f %-4s\n','C_n',Y_eq(10),'');
fprintf('\n');
%%
% %--------------------------------------------------------------------------
% % Simulation of trimmed flight conditions:
% dt = 50e-3; %s
% tF = 4*60;    %s
% flag_cond = 1;
% X0 = trim_output.X_eq;
% U0 = trim_output.U_eq;
% T = 0:dt:tF;
% 
% [X,Y] = ode4xy(@dynamics,T,X0, U0, aircraft, flag_cond);
% U = repmat(U0', length(T),1);
% set(0,'DefaultFigureWindowStyle','docked')
% plot_long
% plot_latdir
% plot_controls
% plot_path

%--------------------------------------------------------------------------
% Linearization around trimmed flight conditions:
% lin_output(3) = struct('A',zeros(length(X_eq),length(X_eq)),...
%     'B',zeros(length(X_eq),length(U_eq)),...
%     'C',zeros(length(Y_eq),length(X_eq)),...
%     'D',zeros(length(Y_eq),length(U_eq)));
% 
% step_val = 1e-5;
% 
% for flag_cond=1:3
%     X_eq = trim_output(flag_cond).X_eq;
%     U_eq = trim_output(flag_cond).U_eq;
% 	Y_eq = trim_output(flag_cond).Y_eq;
%     
%     A = zeros(length(X_eq),length(X_eq));
% 	C = zeros(length(Y_eq),length(X_eq));
%     for j=1:length(X_eq)
%         dX = zeros(length(X_eq), 1);
%         dX(j) = step_val;
%         Xdot_plus  = dynamics(0, X_eq + dX, U_eq);
%         Xdot_minus = dynamics(0, X_eq - dX, U_eq);
%         A(:,j) = (Xdot_plus-Xdot_minus)/(2*dX);
%     end
%     
%     B = zeros(length(X_eq),length(U_eq));
% 	D = zeros(length(Y_eq),length(U_eq));
%     for j=1:length(U_eq)
%         To be completed in class!
%     end
%     
%     lin_output(flag_cond).A = A;
%     lin_output(flag_cond).B = B;
%     lin_output(flag_cond).C = C;
%     lin_output(flag_cond).D = D;
%     
% end
