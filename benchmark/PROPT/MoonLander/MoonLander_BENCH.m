%% Moonlander Example
%
% Arthur Bryson - Dynamic Optimization
%
%% Problem description
% Example about landing an object.

% Copyright (c) 2007-2008 by Tomlab Optimization Inc.

%% Problem setup
toms t
toms t_f
p = tomPhase('p', t, 0, t_f, 60);
setPhase(p);

tomStates altitude speed
tomControls thrust

% Initial guess
x0 = {t_f == 1.5
    icollocate({
    altitude == 0
    speed == 0
               })
    collocate(thrust == 0)};

% Box constraints
cbox = {
    0  <= t_f                   <= 1000
    -20  <= icollocate(altitude) <= 20
    -20  <= icollocate(speed)    <= 20
    0  <= collocate(thrust)    <= 3};

% Boundary constraints
cbnd = {initial({altitude == 10; speed == -2})
    final({altitude == 0; speed == 0})};

% ODEs and path constraints
gravity         = 1.5;
ceq = collocate({
    dot(altitude) == speed
    dot(speed)    == -gravity + thrust});

% Objective
objective = integrate(thrust);

%% Solve the problem
options = struct;
options.name = 'Moon Lander';
options.solver= 'knitro';
options.PriLevOpt = 1;
%options.ALG = 3;
%options.derivatives = 'automatic';
solution = ezsolve(objective, {cbox, cbnd, ceq}, x0, options);
t  = subs(collocate(t),solution);
altitude = subs(collocate(altitude),solution);
speed  = subs(collocate(speed),solution);
thrust = subs(collocate(thrust),solution);

%% Plot result
subplot(2,1,1)
plot(t,altitude,'*-',t,speed,'*-');
legend('altitude','speed');
title('Moon Lander state variables');

subplot(2,1,2)
plot(t,thrust,'+-');
legend('thrust');
title('Moon Lander control');

%% Save results