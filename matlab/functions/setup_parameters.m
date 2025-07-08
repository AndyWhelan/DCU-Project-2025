function P = setup_parameters()
%---Special Parameter Markings-------------------------------------------------------
% --> A derived parameter,
%   [+] Uncontentious parameter
%   [n] Numerical parameter
%---[!] Parameters of interest-------------------------------------------------------
%       ! 1. r_spread  Receiver patch length (set to 10% of strip length currently)
%       ! 2. t_y       (t_y/r_y) Antenna heights relative to the strip
%       ! 3. t_x       Tx horizontal position critical for receiving specular rays
%       ! 4  S         Effective roughness parameter, interesting at S=1 and S~0.4
%---[?] Contentious choices----------------------------------------------------------
%       ? a. r_x0      First Rx is 10 to the right of the strip start
%       ? b. r_y       Rx's are at a height of 1 wrt strip
%------------------------------------------------------------------------------------

   % Source wave---------------------------------------------------------------------
   P.P0 = 1;                                     % [+]  Source power
   % Strip dimensions----------------------------------------------------------------
   P.w_len = 100.0;                              % [+]  Strip length
   P.w_x0 = 0;                                   % [+]  Strip start
   P.w_xe = P.w_x0 + P.w_len;                    % -->  Strip end
   P.N_strip = 20;                               % [n]  # Calc points along strip
   % Rx antennas--------------------------------------------------------------------
   P.r_x0 = P.w_x0 + 10;                         % ? a. First Rx
   P.r_spread = 0.1 * P.w_len;                   % ! 1. Rx spread (r_xe - r_x0)
   P.N_rx  = 100;                                % [n]  Number of receivers
   P.r_y = 1;                                    % ? b. Rx height wrt strip
   P.r_xe = P.r_x0 + P.r_spread;                 % -->  Last Rx
   P.dx_r = P.r_spread / P.N_rx;                 % -->  dx along Rx-line
   P.r_x = zeros(1, P.N_rx);                     % -->  Rx positions (prealloc)
   for( N = 1:P.N_rx )
      P.r_x( N ) = P.r_x0 + (N-0.5) * P.dx_r;    % -->  Rx positions
   end
   % Tx antenna----------------------------------------------------------------------
   P.t_y = 0.5 * P.r_y;                          % ! 2. Tx height
   P.t_x = 9.5;                                  % ! 3. Tx position
   % Effective Roughness Model Parameters--------------------------------------------
   P.S = 1.0;                                    % ! 4. Effective Roughness
   P.R = 1.0 - P.S;                              % --> Specular reflectance reduction
end
