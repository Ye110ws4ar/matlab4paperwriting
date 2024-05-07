global lambda steps L k a;
lambda = input('波长 lambda=');
L = input('腔长 L=');
a = input('镜长 a=');
N1 = input('渡越次数 N1=');
N2 = input('渡越次数 N2=');
N3 = input('渡越次数 N3=');
%% 
k = 2*pi/lambda;
steps = 500;
x = linspace(-a,a,steps);
u_=ones(1,steps);
for m=1:N1
    for mm=1:steps
        u0(mm)=QU(x(mm),u_);
    end
    u_=u0/max(abs(u0));
end
for m=1:N2
    for mm=1:steps
        u1(mm)=QU(x(mm),u_);
    end;
    u_=u1/max(abs(u1));
end
for m=1:N3
    for mm=1:steps
        u2(mm)=QU(x(mm),u_);
    end;
    u_=u2/max(abs(u2));
end
%% 
subplot(2,1,1);
plot(x,abs(u0)/abs(u0(steps/2)),'r');
hold on;
plot(x,abs(u1)/abs(u1(steps/2)),'b');
hold on;
plot(x,abs(u2)/abs(u2(steps/2)),'g');
hold on;
xlabel('x');
ylabel('相对振幅');
legend('80','81','82');
%% 
angle_u0=angle(u0)/pi*180;
angle_u0=angle_u0-angle_u0(steps/2);
angle_u1=angle(u1)/pi*180;
angle_u1=angle_u1-angle_u1(steps/2);
angle_u2=angle(u2)/pi*180;
angle_u2=angle_u2-angle_u2(steps/2);
subplot(2,1,2);
plot(x,angle_u0);
hold on;
plot(x,angle_u1);
hold on;
plot(x,angle_u2);
hold on;
xlabel('x');
ylabel('相对相位');
legend('80','81','82');
%% 
function y=QU(x,u)
global lambda steps L k a;
x_ = linspace(-a,a,steps);
step_length = 2*a/(steps-1);
y=sqrt(1i/(lambda*L)*exp(-1i*k*L))*sum(exp(-1i*k/2/L*(-x_+x).^2).*u)*step_length;
end