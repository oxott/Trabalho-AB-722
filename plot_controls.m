figure

subplot(231)
plot(T,U(:,1)*100, T,U(:,2)*100)
legend('Left', 'Right')
xlabel('t [s]')
ylabel('Throttle [%]')

subplot(232)
plot(T,U(:,3))
xlabel('t [s]')
ylabel('i_t [deg]')

subplot(233)
plot(T,U(:,5))
xlabel('t [s]')
ylabel('\delta_a [deg]')

subplot(234)
plot(T,Y(:,2), T,Y(:,3))
legend('Left', 'Right')
xlabel('t [s]')
ylabel('Thrust [N]')


subplot(235)
plot(T,U(:,4))
xlabel('t [s]')
ylabel('\delta_e [deg]')

subplot(236)
plot(T,U(:,6))
xlabel('t [s]')
ylabel('\delta_r [deg]')
