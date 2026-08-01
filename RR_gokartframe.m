
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
% vehicle chassis frame. go kart

clear, clc, global RR_VERBOSE, RR_VERBOSE=0; % {0,2} for {less,more} screen output

% parameters defining the structure (in SI)
in=0.0254;                                  % inches-to-meters conversion
mainLength=54*in;                           % length of the main chassis rails
mainWidth=14*in;                            % distance between the main rails
rearWidth=16*in;                            % width of the rear end member
outerOffset=5*in;                           % distance from each main rail to its outer rail
outerLength=27*in;                          % length of each outer rail
transitionLength=(13+13/32)*in;             % length of each angled transition member
noseWidth=8*in;                             % width of the front nose member
noseDiagonal=(7+7/32)*in;                   % length of each front diagonal

% x- and y- locations used in the chassis geometry.
yMain=mainWidth/2;
yRear=rearWidth/2;
yOuter=yMain+outerOffset;
yNose=noseWidth/2;
xFront=0;
xRear=mainLength;
xRearCross=xRear-5*in;
xOuterStart=xRearCross-outerLength;
xTransitionStart=xOuterStart-sqrt(transitionLength^2-outerOffset^2);
xNose=xFront-sqrt(noseDiagonal^2-(yMain-yNose)^2);
xCross1=14*in;
xCross2=34*in;

%The rear-center support is pinned and the front-center support is a roller.
S.P=[xRearCross; 0];  % The columns of {Q,P} denote the x,y locations of each of the {free,pinned} nodes
S.R=[xFront;     0];  % ADDED: one roller-support node is used at the front crossmember
S.R_vec=[0;1];        % ADDED: the roller provides a reaction only in the y direction

%Each column below is one free chassis node. The nose is on the left.
S.Q=[xNose xNose xNose xFront xFront xTransitionStart xTransitionStart xCross1 xCross1 xCross1 xOuterStart xOuterStart xOuterStart xOuterStart xCross2 xCross2 xCross2 xCross2 xCross2 xRearCross xRearCross xRearCross xRearCross xRear xRear xRear;
     yNose 0    -yNose yMain -yMain yMain           -yMain            yMain  0      -yMain yMain       yOuter      -yMain      -yOuter     yMain  yOuter 0      -yMain -yOuter yMain      yOuter     -yMain     -yOuter    yRear 0    -yRear];
% There are p=1 pinned node, r=1 roller node, and q=26 free nodes in this structure

L.U=[0 1000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % External forces on the q free nodes
     0  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; %1000-N x-force at the nose center
% m=20 members, n=q+p+r=26+1+1=28 total nodes

% ADDED: Columns 1-26 correspond to S.Q, column 27 to S.P, and column 28 to S.R.
S.C=[0 0 0 1 0 1 0 1 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0;  % upper main longitudinal rail
     0 0 0 0 1 0 1 0 0 1 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0;  % lower main longitudinal rail
     0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0;  % upper outer longitudinal rail
     0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 0 0 0;  % lower outer longitudinal rail
     1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % upper front diagonal
     1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % front nose member
     0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % lower front diagonal
     0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1;  % front crossmember, no tires
     0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % first interior crossmember
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 1 0 0 0 0 0 0 0 0 0 0;  % second interior crossmember
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 1 0;  % rear crossmember, no tires
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0;  % rear end member
     0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % upper angled transition
     0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % lower angled transition
     0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % upper brace at outer-rail start
     0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;  % lower brace at outer-rail start
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0;  % upper brace at second crossmember
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0;  % lower brace at second crossmember
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0;  % upper brace at rear crossmember
     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0]; % lower brace at rear crossmember
% m x n connectivity of the pin-jointed frame
% Note: members may connect 3 or more nodal points,
% and nodes may have 3 or more members attached,
% in addition to having an applied external load

% Convert the eqns for computing the interior & reaction forces to Ax=b, solve, and plot.
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;
figure(2); RR_Structure_Plot(S,L,x); x_error=norm(A*x-b)

% Also plot the direction of the nullspace vector
L.U=zeros(2,26); xn=null(A);
print -vector -dpdf Vehicle_Chassis_nullspace.pdf
