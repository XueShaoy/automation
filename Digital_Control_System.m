%% Digital Control System V1.1
% Shoyang Xue 05-May-2018
% Function: 
% 1. PID 
% 2. Custom Controller
% 3. OffLine SI (Need Mp,Tp)
% 4. Extract Cofficients and generate Kc, Pc - test
% 5. Plot Step Response, ZP figure, Nyquist diagram, Bode diagram
% 6. I am still considering....
% convert the tf to z domain
% plot PZ, step response, ...
%--------------------------------------%
s = tf('s');
z = tf('z');
Ps = input('Input Plant tf: ')
Ts = input('Input Ts: ');
Pz = c2d(Ps,Ts,'zoh') % convert s to z domain
[z,p,k]=zpkdata(Pz)
while 1
%% Choose funciton
flag1 = input('Choose a function: \n 1.PID control \n 2.Custom controller \n 3.OffLine SI (Need Mp,Tp) \n 4.Extract Cofficients get Kc, Pc\n 5.Step Response and PZ, Bode diagram \n Input the Num:  ');
switch flag1
    case {1}    %1. PID 
    Kp = input('Kp: ');
    Ki = input('Ki: ');
    Kd = input('Kd: ');
    Cz_Kp = tf(Kp,1,Ts);
    Cz_Ki = tf([Ki,0],[1,-1],Ts);
    Cz_Kd = tf([Kd,-Kd],[1,0],Ts);
    Cz_PID = Cz_Kp + Cz_Ki + Cz_Kd %PID Controller
    case {2}    %2. Custom Controller
    Cs = input('Input Controller tf(s domain only): ')
    Cz = c2d(Cs,Ts,'zoh')   %Convert Cs to z domain
    case {3} %3. OffLine SI (Need Mp,Tp)
        Mp = input('Input Mp: ');
        tp = input('Input tp: ');
        zeta = (-log(Mp/100))/(sqrt(pi^2+log(Mp/100)^2))
        Wn = pi/(tp*sqrt(1-zeta^2))
        Ps = tf([Wn^2],[1, 2*zeta*Wn, Wn^2])
    case {4} %4. Extract Cofficients and generate Kc, Pc
        flag3 = input('Choose a tf: \n 1.Ps \n 2.Pz \n 3.CL(z-domain)\n Input the Num:  ');
        switch flag3
            case {1}
            tf_exact = Ps;
            case {2}
            tf_exact = Pz;
            case {3}
            tf_exact = CL;
        end
        [Num,Den]=tfdata(tf_exact,'v');
        a1 = Den(2);
        a2 = Den(3);
        %a3 = Den();
        b1 = Num(2);
        b2 = Num(3);
        %b3 = Num();
        [Kc,Pc] = WPG_ZNtuning(a1,a2,b1,b2);
        
        
        
        
    case {5} %Plot Step Response, ZP figure, Nyquist diagram
        flag_tf_plot = input('Choose which tf to plot: \n 1.Ps\n 2.Pz\n 3.Cs\n 4.Cz\n 5.Close-Loop\n Input the Num:  ');
        switch flag_tf_plot
            case {1} 
                tf_plot = Ps;
            case {2} 
                tf_plot = Pz;
            case {3} 
                tf_plot = Cs;
            case {4}
                tf_plot = Cz;
            case {5} 
                tf_plot = CL;
        end
                subplot(2,2,1), step (tf_plot)
                subplot(2,2,2), pzmap (tf_plot)
                subplot(2,2,3), nyquist(tf_plot)
                subplot(2,2,4), bode(tf_plot)
        
    case {6} %
        
end

%% Close Loop
if flag1 == 1 % PID controller
    open = series(Cz_PID,Pz)    %Series connection of two input/output models.
    CL = feedback(open,1)
elseif  flag1 == 2 % Customed controller
    open = series(Cz,Pz)    %Series connection of two input/output models.
    CL = feedback(open,1)
end
%% Need continue?
if input('Need Continue? y/n: ', 's') == 'N' break; end
end