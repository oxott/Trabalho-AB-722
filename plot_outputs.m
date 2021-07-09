figure(5)

subplot(331)
plot(T,Y(:,1))
hold all
xlabel('t [s]')
ylabel('\gamma [deg]')

subplot(332)
plot(T,Y(:,2))
hold all
xlabel('t [s]')
ylabel('Thrust [N]')

subplot(333)
plot(T,Y(:,4))
hold all
xlabel('t [s]')
ylabel('Mach')

subplot(334)
plot(T,Y(:,5))
hold all
xlabel('t [s]')
ylabel('C_D')

subplot(335)
plot(T,Y(:,6))
hold all
xlabel('t [s]')
ylabel('C_L')

subplot(336)
plot(T,Y(:,7))
hold all
xlabel('t [s]')
ylabel('C_m')

subplot(337)
plot(T,Y(:,8))
hold all
xlabel('t [s]')
ylabel('C_Y')

subplot(338)
plot(T,Y(:,9))
hold all
xlabel('t [s]')
ylabel('C_l')

subplot(339)
plot(T,Y(:,10))
hold all
xlabel('t [s]')
ylabel('C_n')
