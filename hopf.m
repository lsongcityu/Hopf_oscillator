function dxydt = hopf(t,state)
%% ״ֵ̬
    x = state(1:4);
    y = state(5:8);
%parameter
    alpha = 50;
    %��ֵԽ��ʱ��hopf����Խ��õ��ȶ��Ĳ��Ρ�����ֵ�Ƚ�Сʱ��
    %������Ҫ�����ܳ�һ��ʱ����ܵõ���̬�����������ܴ�ʱ����Ȼ�ܹ�Ѹ�ٵõ��ȶ��������
    %���������׶β������źŻ�ǳ����������ᳬ���涨�ķ�ֵ��ʵ��ʹ���п��ܻ��ִ�������һ���𺦣�
    
    %��������Ӧ�ø���ִ����������ѡȡ�ʵ��Ħ�ֵ��
    miu = [1,1,1,1];         %�񶯷�ֵ��miu�Ŀ���
    omega = 10*2*pi;  %��Ƶ�ʣ�ԲƵ��omega=2*pi*f)
    
    %�ǶԳ��˶�Ӱ������
    beta = 0.5;  
    a = 5; %���ھ���omega_up��down֮���ת���ٶ�
    omega_up = omega/(1-beta)/2;
    omega_down = omega/beta/2;
    omega = omega_up./(exp(-a*y)+1) + omega_down./(exp(a*y)+1);
    
    %��ͬlimb֮�����λ���(���universal frame�����ɶ����)
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