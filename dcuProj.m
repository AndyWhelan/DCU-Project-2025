%{
Geometry setup: 2d wall of fixed length; fixed Tx; mobile Rx:

                  tx = (txD,txH)                                              
                                                                          
                         \                                                
                          \         rxInit = (rxInitD,rxInitH)                  
                           \                                              
                            \                 /                           
                             \               /                            
                              \             /                             
                               \           /                              
                                \         /                               
                  +--------------\       /                                
                  |               \     /                                 
                  | pi/2-angleInc  \   /                                  
                  |                 \ /                                   
      (0,0) -------------------- (reflD,0) ------------------ (lenWall,0)
%}
function D = specReflPoint(txD,txH,rxD,rxH)
    % No check yet that the line joining image to Rx intersects the wall
    imgD = txD;
    imgH = -txH;
    % Equation of line joining image to Rx, setting y to 0
    D = imgD - imgH * ((rxD-imgD)/(rxH-imgH));
end
function A = specAngleInc(txD,txH,rxD,rxH)
    reflD = specReflPoint(txD,txH,rxD,rxH);
    A = pi/2 - atan(rxH/reflD);
end
function T = specAngleTran(txD,txH,rxD,rxH,n1,n2)
    % n1 and n2 are refractive indices
    angleI = specAngleInc(txD,txH,rxD,rxH);
    T = asin((n1*sin(angleI))/n2);
end
function r = specReflCoeff(txD,txH,rxD,rxH,n1,n2,lenWall,perp)
    % perp is a bool, deciding the EM-wave polarization relative to plane
    % of incidence.
    reflD = specReflPoint(txD,txH,rxD,rxH);
    if reflD > lenWall
        r = 0; % since there won't be a real reflection point
    else
        angleI = specAngleInc(txD,txH,rxD,rxH);
        angleT = specAngleTran(txD,txH,rxD,rxH,n1,n2);
        if perp
            r = -(sin(angleI - angleT))/(sin(angleI + angleT));
        else
            r = (tan(angleI - angleT))/(tan(angleI + angleT));
        end
    end
end
function R = specReflectance(txD,txH,rxD,rxH,n1,n2,lenWall,perp)
    r = specReflCoeff(txD,txH,rxD,rxH,n1,n2,lenWall,perp);
    magR = abs(r);
    R = magR * magR;
end
% Plot a range of values for specReflectance for varying rxD,rxH
txD = 2;
txH = 10;
n1 = 1;
n2 = 1.5; % e.g. plaster wall
lenWall = 3*txD;
perp=true;

steps = 200;
% rxD goes from txD to 10*txD
rxD = linspace(0,10*txD,steps);
% rxH goes from 0 to 0.99*txH
rxH = linspace(0, 0.99*txH,steps);
refl = zeros(steps,steps); % initialize
for i=1:steps
    for j=1:steps
        refl(i,j) = specReflectance(txD,txH,rxD(i),rxH(j),n1,n2,lenWall,perp);    
    end
end
surf(rxD,rxH,refl);
title('Spectral Reflectance Coefficient for varying Rx position')
subtitle(['Tx dist: ' int2str(txD), ', Tx height: ' int2str(txH)]);
xlabel('Rx distance')
ylabel('Rx height')
%TODO: clean up subtitle and rethink scaling
%TODO: sensibility checks for graph