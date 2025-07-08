% Get power densities (time-averaged) for cylindrical wave point source.
%
% ---MODELS--------------------------------------------------------------------------
% 1. Effective Roughness (ER) Lambertian model 
%    (overall ER contribution is an integral along the points of the wall), and
% 2. Geometrical Optics  (GO).
%
% ---SETUP---------------------------------------------------------------------------
%
%     (r_x0, r_y) ─────────────────────────── (r_x, r_y) ──────────────── (r_xe, r_y)
%                                                 /        
%                (t_x, t_y)                    /           
%                     \                     /              
%                      \                 /                 
%                       \             /                    
%                        \  ╎      /                       
%                         \ ╎   /                          
%                          \╎/                             
% (w_x0,0) ━━━━━━━━━━━━ (w_x, 0) ━━━━━━━━━━━━━━━━━━━━ (w_xe, 0)
% -----------------------------------------------------------------------------------
function dP = ER_Lamb_S_Power_Density( x, ...
                                       P0, ...
                                       r_y, ...
                                       t_x, t_y, ...
                                       dx_r, ...
                                       w_x0, w_xe, ...
                                       N_strip, ...      % Points along strip
                                       S )               % Eff. roughness parameter
% Formula 1.10 in derivations
   w_len = w_xe - w_x0;
   dx_w = w_len / N_strip;
   numerator = t_y * r_y * dx_w ;
   dP = 0;
   for( N = 1:N_strip )
      w_x = w_x0 + (N-0.5)*dx_w;
      denominator = ((t_y)^2 + (w_x - t_x)^2) * ((r_y)^2 + (x - w_x)^2);
      ddP = numerator / denominator;
      dP = dP + ddP;
   end
   dP = dP * P0 * dx_r * (S^2) / (4 * pi);
end
function dP = GO_Power_Density( x, ...           % Position along receiver line
                                P0, ...          % Source power
                                r_y, ...         % Rx antenna height
                                t_x, t_y, ...    % Tx antenna positions
                                dx_r, ...        % dx equivalent for receiver line
                                w_x0, w_xe )     % Start and end of strip
% Formula 1.11 in derivations
   w_spec = t_x + t_y * ( (x - t_x)/(r_y + t_y) );
   if( w_x0 > w_spec || w_spec > w_xe )
      dP = 0;
   else 
      dP = P0 * ( r_y + t_y ) * dx_r / ...
               ( 2 * pi * (x - t_x) * sqrt((x - t_x)^2 + (r_y + t_y)^2) );
   end
end
