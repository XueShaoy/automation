%% Ziegler Nichol Tuning
% Generate the Kc and Kp For ziegler nichol tuning
% Shaoyang Xue, 24 April 2018
%% 
function [Kc,Pc] = WPG_ZNtuning(a1,a2,b1,b2)

Kp1 = (1-a2)/b2;
Kp2 = (a1-a2-1)/(b2-b1);

B = b1*Kp1+a1;
C = b2*Kp2+a2;
Ts = input('input Ts: ')
alpha = -B/2;
Wc = (1/Ts)*acos(alpha);

d = B^2 - 4*C;

if d < 0
    Kc = Kp1
    Pc = 2*pi/Wc
elseif d == 0
    Kc = Kp1
    Pc = 2*Ts
else
    Kc = Kp2
    Pc = 2*Ts
end
end