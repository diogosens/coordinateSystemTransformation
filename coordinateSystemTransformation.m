%Diogo Filipe Sens (diogosens@gmail.com)
%Flight Mechanics - Aerospace Engineering - Universidade de Brasília
%Coordinate System Transformation

clear; clc
%------------------------------Interface-----------------------------------
userInput = -1;
while userInput ~= 0
    disp('Coordinate System Transformation');
    disp(' ');
    disp('__1 NED System to Body System');
    disp('__2 Body System to NED System');
    disp('__3 Aerodynamic System to Body System');
    disp('__4 Body System to Aerodynamic System ');
    disp('__5 ECEF System to NED System');
    disp('__6 NED System to ECEF System ');
    disp('__7 Latitude/Longitude System to ECEF System');
    disp('__8 ECEF System to Latitude/Longitude System');
    disp('__9 ECEF System to ENU System');
    disp('_10 ENU System to ECEF System');
    disp('__0 Exit');
    disp(' ');
    prompt = 'Choose the operarion: ';
    userInput = input(prompt);
    
    if userInput == 1 %NED System to Body System
        %Input values
        prompt = setPrompt(1);
        Vned = input(prompt); %Vector in NED system
        Vned = Vned(:);
        prompt = setPrompt(2);
        vectorAngle_ned_b = input(prompt);
        vectorAngle_ned_b = vectorAngle_ned_b(:);
        %Rotation Matrix
        vectorSequence_ned_b = [1 ; 2 ; 3]; %sequence (3-2-1)
        D_ned_b = sequentialRotation(vectorSequence_ned_b, vectorAngle_ned_b);
        %Output value
        Vb = D_ned_b * Vned %Vector in body system
        disp('Press any key to continue');
        pause; clc

    elseif userInput == 2 %Body System to NED System
        %Input values
        prompt = setPrompt(3);
        Vb = input(prompt); %Vector in Body system
        Vb = Vb(:);
        prompt = setPrompt(2);
        vectorAngle_b_ned = input(prompt);
        vectorAngle_b_ned = vectorAngle_b_ned(:);
        %Rotation Matrix
        vectorSequence_b_ned = [1 ; 2 ; 3]; %sequence (3-2-1)
        Dprov = sequentialRotation(vectorSequence_b_ned, vectorAngle_b_ned);
        D_b_ned = Dprov';
        %Output value
        Vned = D_b_ned * Vb %Vector in body system
        disp('Press any key to continue');
        pause; clc
        
    elseif userInput == 3 %Aerodynamic System to Body System
        %Input values
        prompt = setPrompt(4);
        Va = input(prompt); %Vector in aerodynamic system
        Va = Va(:);
        prompt = setPrompt(5);
        vectorAngle_a_b = input(prompt); %angle of attack and slip angle
        vectorAngle_a_b(2) = -vectorAngle_a_b(2); %-beta
        vectorAngle_a_b = vectorAngle_a_b(:);
        %Rotation Matrix
        vectorSequence_a_b = [2 ; 3]; %sequence (3-2)
        D_a_b = sequentialRotation(vectorSequence_a_b, vectorAngle_a_b);
        %Output value
        Vb = D_a_b * Va %Vector in body system
        disp('Press any key to continue');
        pause; clc

    elseif userInput == 4 %Body System to Aerodynamic System
        %Input values
        prompt = setPrompt(3);
        Vb = input(prompt); %Vector in aerodynamic system
        Vb = Vb(:);
        prompt = setPrompt(5);
        vectorAngle_b_a = input(prompt);
        vectorAngle_b_a(2) = -vectorAngle_b_a(2); %-beta
        vectorAngle_b_a = vectorAngle_b_a(:);
        %Rotation Matrix
        vectorSequence_b_a = [2 ; 3]; %sequence (3-2)
        Dprov = sequentialRotation(vectorSequence_b_a, vectorAngle_b_a);
        D_b_a = Dprov';
        %Output value
        Va = D_a_b * Vb %Vector in aerodynamic system
        disp('Press any key to continue');
        pause; clc
        
    elseif userInput == 5 %ECEF System to NED System
        %Input values
        prompt = setPrompt(6);
        Vecef = input(prompt); %Vector in ECEF system
        Vecef = Vecef(:);
        prompt = setPrompt(7);
        vectorAngle_ecef_ned = input(prompt);
        vectorAngle_ecef_ned(1) = -vectorAngle_ecef_ned(1);
        vectorAngle_ecef_ned = [vectorAngle_ecef_ned, -90];
        vectorAngle_ecef_ned = vectorAngle_ecef_ned(:);
        %Rotation Matrix
        vectorSequence_ecef_ned = [2 ; 1 ; 2]; %Rotation axis sequence (left to right)
        D_ecef_ned = sequentialRotation(vectorSequence_ecef_ned, vectorAngle_ecef_ned);
        %Output values
        Vned = D_ecef_ned * Vecef %Vector in NED system
        disp('Press any key to continue');
        pause; clc

    elseif userInput == 6 %NED System to ECEF System
        %Input values
        prompt = setPrompt(1);
        Vned = input(prompt); %Vector in NED system
        Vned = Vned(:);
        prompt = setPrompt(7);
        vectorAngle_ned_ecef = input(prompt);
        vectorAngle_ned_ecef(1) = -vectorAngle_ned_ecef(1);
        vectorAngle_ned_ecef = [vectorAngle_ned_ecef, -90];
        vectorAngle_ned_ecef = vectorAngle_ned_ecef(:);
        %Rotation Matrix
        vectorSequence_ned_ecef = [2 ; 1 ; 2]; %Rotation axis sequence (left to right)
        Dprov = sequentialRotation(vectorSequence_ned_ecef, vectorAngle_ned_ecef);
        D_ned_ecef = Dprov';
        %Output values
        Vecef = D_ned_ecef * Vned %Vector in ECEF system
        disp('Press any key to continue');
        pause; clc
        
    elseif userInput == 7 %Latitude/Longitude System to ECEF System
        %Input values
        prompt = setPrompt(7);
        latLong = input(prompt); %latitude and longitude
        latLong = latLong(:);
        prompt = setPrompt(8);
        h = input(prompt); %height
        %Spherial coordinates to cartesian coordinates
        X = [cosd(latLong(1)) * cosd(latLong(2)); ...
             cosd(latLong(1)) * sind(latLong(2)); ...
             sind(latLong(1))];
        R = 6378164; %Earth's radius [m]
        %Output values
        Vecef = (R + h) * X %vector in ECEF system
        disp('Press any key to continue');
        pause; clc
        
    elseif userInput == 8 %ECEF System to Latitude/Longitude System
        %Input values
        prompt = setPrompt(6);
        Vecef = input(prompt);
        %Cartesian coordinates to spherial coordinates 
        R_h = norm(Vecef); %Earth's radius + height
        latitude = atand(Vecef(3) / sqrt(Vecef(1)^2 + Vecef(2)^2)); %phi
        longitude = atand(Vecef(2)/Vecef(1)); %lambda
        R = 6378164; %Earth's radius [m]
        height = R_h - R;
        %Output values
        disp(' ');
        disp('Height [m]:');
        disp(height);
        disp('Latitude:');
        disp(latitude);
        disp('Longitude:');
        disp(longitude);
        disp('Press any key to continue');
        pause; clc

    elseif userInput == 9 %ECEF System to ENU System
        %Input values
        prompt = setPrompt(6);
        Vecef = input(prompt); %Vector in ECEF system
        Vecef = Vecef(:);
        prompt = setPrompt(7);
        vectorAngle_ecef_enu = input(prompt);
        vectorAngle_ecef_enu(1) = -vectorAngle_ecef_enu(1);
        vectorAngle_ecef_enu = vectorAngle_ecef_enu + [90 90]; %[(90 - phi) (90 + lambda)]
        vectorAngle_ecef_enu = vectorAngle_ecef_enu(:);
        %Rotation Matrix
        vectorSequence_ecef_enu = [1 ; 3]; %sequence of axis to rotate
        D_ecef_enu = sequentialRotation(vectorSequence_ecef_enu, vectorAngle_ecef_enu);
        %Output value
        Venu = D_ecef_enu * Vecef %Vector in body system
        disp('Press any key to continue');
        pause; clc

    elseif userInput == 10 %ENU System to ECEF System
        %Input values
        prompt = setPrompt(9);
        Venu = input(prompt); %Vector in aerodynamic system
        Venu = Venu(:);
        prompt = setPrompt(7);
        vectorAngle_enu_ecef = input(prompt);
        vectorAngle_enu_ecef(1) = -vectorAngle_enu_ecef(1);
        vectorAngle_enu_ecef = vectorAngle_enu_ecef + [90 90]; %[(90 - phi) (90 + lambda)]
        vectorAngle_enu_ecef = vectorAngle_enu_ecef(:);
        %Rotation Matrix
        vectorSequence_enu_ecef = [1 ; 3]; %sequence of axis to rotate
        Dprov = sequentialRotation(vectorSequence_enu_ecef, vectorAngle_enu_ecef);
        D_enu_ecef = Dprov';
        %Output value
        Vecef = D_enu_ecef * Venu %Vector in body system
        disp('Press any key to continue');
        pause; clc
        
    elseif userInput == 0
        clear;
        break;
    else
        clc;
    end
end

%----------------------------Functions-------------------------------------

function [D] = rotationMatrix(axis, angle)
    if axis == 1
       D = [1 0 0; 0 cosd(angle) sind(angle); 0 -sind(angle) cosd(angle)];
    elseif axis == 2
       D = [cosd(angle) 0 -sind(angle); 0 1 0; sind(angle) 0 cosd(angle)];
    elseif axis == 3
       D = [cosd(angle) sind(angle) 0; -sind(angle) cosd(angle) 0; 0 0 1];
    end   
end

function [D] = sequentialRotation(vectorSequence, vectorAngle)
    D = eye(3);
    for i = 1 : size(vectorSequence)
       D = D * rotationMatrix(vectorSequence(i), vectorAngle(i));
    end
end

function [prompt] = setPrompt(promptNumber)
    prompts = ["Enter the value of Vned [x y z]: " ... %1
               "Enter the roll, pitch and yaw angles [phi theta psi]: " ... %2
               "Enter the value of Vb [x y z]: " ... %3
               "Enter the value of Va [x y z]: " ... %4
               "Enter the angle of attack and sideslip angle [alpha beta]: " ... %5
               "Enter the value of Vecef [x y z]: " ... %6
               "Enter the values of latitude and longitude [phi lambda]: " ... %7
               "Enter the value of height [m]: " ... %8
               "Enter the value of Venu [x y z]: " %9
              ];
    prompt = convertStringsToChars(prompts(promptNumber));
end