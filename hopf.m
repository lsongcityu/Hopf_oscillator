function dxydt = hopf(t,state)
%% 状态值
    x = state(1:4);
    y = state(5:8);
%parameter
    alpha = 50;
    %α值越大时，hopf振荡器越快得到稳定的波形。当该值比较小时，
    %振荡器需要经过很长一段时间才能得到稳态输出，而当其很大时，虽然能够迅速得到稳定的输出，
    %但在收敛阶段产生的信号会非常尖锐，甚至会超过规定的幅值，实际使用中可能会对执行器造成一定损害，
    
    %所以我们应该根据执行器的特性选取适当的α值。
    miu = [1,1,1,1];         %振动幅值是miu的开方
    omega = 10*2*pi;  %振动频率（圆频率omega=2*pi*f)
    
    %非对称扑动影响因子
    beta = 0.5;  
    a = 5; %用于决定omega_up和down之间的转换速度
    omega_up = omega/(1-beta)/2;
    omega_down = omega/beta/2;
    omega = omega_up./(exp(-a*y)+1) + omega_down./(exp(a*y)+1);
    
    %不同limb之间的相位耦合(针对universal frame四自由度输出)
    phase = pi;
    theta = [0,0,phase,phase;...
             0,0,phase,phase;...
             -phase,-phase,0,0;...
             -phase,-phase,0,0];
    r = x.^2 + y.^2;
    %initialise
    dxdt = zeros(1,4);
    dydt = zeros(1,4);
    %%
    %calculation
    for i = 1:4
        couple_x = 0;
        couple_y = 0;
        for j = 1:4
            couple_x = couple_x + cos(theta(i,j))*x(j) - sin(theta(i,j))*y(j);
            couple_y = couple_y + sin(theta(i,j))*x(j) + cos(theta(i,j))*y(j);
        end
        dxdt(i) = alpha*(miu(i)^2-r(i))*x(i) - omega(i)*y(i) + couple_x;
        dydt(i) = alpha*(miu(i)^2-r(i))*y(i) + omega(i)*x(i) + couple_y;
    end
    dxydt = [dxdt';dydt'];
end