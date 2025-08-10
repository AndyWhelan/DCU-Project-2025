clc 
clear all 
close all 

w = 10;
h_0 = 1;
h_final=30;
h_vector = linspace(h_0, h_final, 1000);
%theta_0 = 0;
%theta_final=45;
%thetas = linspace(theta_0, theta_final, 1);
theta_i = 10;
N = 10000;
results = zeros(1,length(h_vector));

for(i=1:length(h_vector))
    h = h_vector(i);
    results( i ) = AverageBounces(w, h, theta_i, N);
end

figure;
hold on;
plot( h_vector, results );

avg = AverageBounces(w, h, theta_i, N);

function AvgBounces = AverageBounces(w, h, theta_i_deg, N_rays)
% Calculates the average number of bounces for rays entering a quadratic indent.
%
% Inputs:
%   w          - Width of the indent.
%   h          - Depth of the indent (must be positive).
%   theta_i_deg- Incident angle in degrees (0 = normal incidence).
%   N_rays     - Number of rays to simulate for the Monte Carlo method.
%
% Output:
%   AvgBounces - The calculated average number of bounces.

% --- 1. Initialization ---

% Convert incident angle to radians for MATLAB trig functions
theta_i_rad = deg2rad(theta_i_deg);

total_bounces = 0;

% Define the parabolic surface function
parabola = @(x) (4*h/w^2) * x.^2 - h;

% Define the incident ray direction (unit vector)
omega_in = [sin(theta_i_rad); -cos(theta_i_rad)];


% --- 2. The Monte Carlo Loop ---

for i = 1:N_rays
    
    % A. Generate an Incident Ray
    % Choose a random starting horizontal position across the indent's mouth
    x_start = w * (rand() - 0.5); % Uniform random number in [-w/2, w/2]
    
    % Start the ray from a point high above the indent for a clean first hit
    ray_origin = [x_start; h]; % Start at y=h
    ray_direction = omega_in;
    
    bounce_count = 0;
    
    % B. The Ray Tracing Sub-Loop
    while true
        
        % Step i: Find the next intersection with the parabola
        % Ray equation: P(t) = ray_origin + t * ray_direction
        % Parabola: y = A*x^2 - h, where A = 4h/w^2
        % (Ax^2 - y - h = 0)
        % A*(ox + t*dx)^2 - (oy + t*dy) - h = 0
        % A*(ox^2 + 2*t*ox*dx + t^2*dx^2) - oy - t*dy - h = 0
        % (A*dx^2)*t^2 + (2*A*ox*dx - dy)*t + (A*ox^2 - oy - h) = 0
        
        A = 4*h/w^2;
        ox = ray_origin(1);
        oy = ray_origin(2);
        dx = ray_direction(1);
        dy = ray_direction(2);
        
        % Quadratic equation coefficients for 't': a*t^2 + b*t + c = 0
        a_t = A * dx^2;
        b_t = 2 * A * ox * dx - dy;
        c_t = A * ox^2 - oy - h;
        
        % Solve for t
        discriminant = b_t^2 - 4*a_t*c_t;
        
        if discriminant < 0
            % No real intersection, ray escapes (should not happen on first bounce)
            break;
        end
        
        t1 = (-b_t + sqrt(discriminant)) / (2*a_t);
        t2 = (-b_t - sqrt(discriminant)) / (2*a_t);
        
        % We need the smallest positive 't' to find the *next* hit point.
        % A small epsilon is used to avoid self-intersection at t=0.
        epsilon = 1e-9;
        if t1 > epsilon && (t1 < t2 || t2 <= epsilon)
            t_hit = t1;
        elseif t2 > epsilon
            t_hit = t2;
        else
            % No forward intersection, ray escapes
            break;
        end
        
        % Calculate the intersection point
        P_hit = ray_origin + t_hit * ray_direction;
        x_hit = P_hit(1);
        
        % Check if the intersection is within the physical indent
        if abs(x_hit) > w/2
            % Ray hits the surface outside the indent, so it has escaped
            break;
        end
        
        % If we get here, a valid bounce occurred
        bounce_count = bounce_count + 1;
        
        
        % Step ii: Calculate Reflection
        % Update ray origin for the next iteration
        ray_origin = P_hit;
        
        % Calculate local normal vector at the hit point
        slope = (8*h/w^2) * x_hit;
        normal = [-slope; 1]; % Normal vector pointing "up"
        normal = normal / norm(normal); % Normalize to unit vector
        
        % Update ray direction using the Law of Reflection
        ray_direction = ray_direction - 2 * dot(ray_direction, normal) * normal;
        
    end % End of while loop (ray tracing)
    
    % C. Accumulate the Result
    total_bounces = total_bounces + bounce_count;
    
end % End of for loop (Monte Carlo)


% --- 3. Final Calculation ---

AvgBounces = total_bounces / N_rays;

end
