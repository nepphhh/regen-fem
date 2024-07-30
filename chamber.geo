// Gmsh project created on Mon Jul 29 21:07:00 2024
Mesh.Format = 1; // msh output format
Mesh.MshFileVersion = 2.2; // Version of the MSH file format to use

cmin = 0.02;
c0 = 0.05;
c1 = 0.1;
c2 = 0.2;
n = 5;

Rc = 0.7;
iwt = 0.05;
ct = 0.1;
owt = 0.25;
Lcyl = 3.93;
R2 = 0.46;
b = 45*Pi/180;
Rt = 0.3;
Lc = 4.71;
R1 = 0.45;
Rn = 0.11;
Te = 15*Pi/180;
Le = 2.17;
Re = 0.875;
//+
//Point(1) =    {0, 0, 0, c};
//Point(1000) = {0, Lc+Le, 0, c};
//Line(1) = {1, 1000};
//+
x1 = Rc;
x2 = Rc+iwt;
x3 = Rc+iwt+ct;
x4 = Rc+iwt+ct+owt;
Point(2) = {x1, 0, 0, c1};
Point(3) = {x2, 0, 0, c0};
Point(4) = {x3, 0, 0, c0};
Point(5) = {x4, 0, 0, c2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
//+
Point(7) = {x1,   Lcyl, 0, c1};
Point(8) = {x2,   Lcyl, 0, c0};
Point(9) = {x3,   Lcyl, 0, c0};
Point(10) = {x4,  Lcyl, 0, c2};
Line(6) = {2, 7};
Line(7) = {3, 8};
Line(8) = {4, 9};
Line(9) = {5, 10};
//+
Point(11) = {x1-R2, Lcyl, 0, c1};
Point(12) = {x2-R2, Lcyl, 0, c0};
Point(13) = {x3-R2, Lcyl, 0, c0};
Point(14) = {x4-R2, Lcyl, 0, c2};
Point(15) = {x1-R2*(1-Cos(b)), Lcyl+R2*Sin(b), 0, c1};
Point(16) = {x2-R2*(1-Cos(b)), Lcyl+R2*Sin(b), 0, c0};
Point(17) = {x3-R2*(1-Cos(b)), Lcyl+R2*Sin(b), 0, c0};
Point(18) = {x4-R2*(1-Cos(b)), Lcyl+R2*Sin(b), 0, c2};
Circle(10) = {7, 11, 15};
Circle(11) = {8, 12, 16};
Circle(12) = {9, 13, 17};
Circle(13) = {10, 14, 18};
//+
x5 = Rt;
x6 = Rt+iwt;
x7 = Rt+iwt+ct;
x8 = Rt+iwt+ct+owt;
Point(19) = {x5, Lc, 0, c1};
Point(20) = {x6, Lc, 0, c0};
Point(21) = {x7, Lc, 0, c0};
Point(22) = {x8, Lc, 0, c2};
//+
Point(23) = {x5+R1, Lc, 0, c1};
Point(24) = {x6+R1, Lc, 0, c0};
Point(25) = {x7+R1, Lc, 0, c0};
Point(26) = {x8+R1, Lc, 0, c2};
Point(27) = {x5+R1*(1-Cos(b)), Lc-R1*Sin(b), 0, c1};
Point(28) = {x6+R1*(1-Cos(b)), Lc-R1*Sin(b), 0, c0};
Point(29) = {x7+R1*(1-Cos(b)), Lc-R1*Sin(b), 0, c0};
Point(30) = {x8+R1*(1-Cos(b)), Lc-R1*Sin(b), 0, c2};
Circle(20) = {19, 23, 27};
Circle(21) = {20, 24, 28};
Circle(22) = {21, 25, 29};
Circle(23) = {22, 26, 30};
Line(24) = {15, 27};
Line(25) = {16, 28};
Line(26) = {17, 29};
Line(27) = {18, 30};
//+
Point(31) = {x5+Rn, Lc, 0, c1};
Point(32) = {x6+Rn, Lc, 0, c0};
Point(33) = {x7+Rn, Lc, 0, c0};
Point(34) = {x8+Rn, Lc, 0, c2};
Point(35) = {x5+Rn*(1-Cos(Te)), Lc+Rn*Sin(Te), 0, c1};
Point(36) = {x6+Rn*(1-Cos(Te)), Lc+Rn*Sin(Te), 0, c0};
Point(37) = {x7+Rn*(1-Cos(Te)), Lc+Rn*Sin(Te), 0, c0};
Point(38) = {x8+Rn*(1-Cos(Te)), Lc+Rn*Sin(Te), 0, c2};
Circle(28) = {19, 31, 35};
Circle(29) = {20, 32, 36};
Circle(30) = {21, 33, 37};
Circle(31) = {22, 24, 38};
//+
x10 = Re;
x11 = Re+iwt;
x12 = Re+iwt+ct;
x13 = Re+iwt+ct+owt;
Point(40) = {x10, Lc+Le, 0, c1};
Point(41) = {x11, Lc+Le, 0, c0};
Point(42) = {x12, Lc+Le, 0, c0};
Point(43) = {x13, Lc+Le, 0, c2};
Line(32) = {35, 40};
Line(33) = {36, 41};
Line(34) = {37, 42};
Line(35) = {38, 43};
//+
Line(36) = {40, 41};
Line(37) = {41, 42};
Line(38) = {42, 43};
//+
Curve Loop(1) = {32, 36, -33, -29, 21, -25, -11, -7, -2, 6, 10, 24, -20, 28};
Plane Surface(1) = {1};
//+
Curve Loop(2) = {7, 11, 25, -21, 29, 33, 37, -34, -30, 22, -26, -12, -8, -3};
Plane Surface(2) = {2};
//+
Curve Loop(3) = {35, -38, -34, -30, 22, -26, -12, -8, 4, 9, 13, 27, -23, 31};
Plane Surface(3) = {3};
//+
Extrude {{0, 1, 0}, {0, 0, 0}, 2*Pi/33} { Surface{1}; }
Extrude {{0, 1, 0}, {0, 0, 0}, 2*Pi/33} { Surface{3}; }
Extrude {{0, 1, 0}, {0, 0, 0}, 2*Pi/33/4} { Surface{2}; }
Extrude {{0, 1, 0}, {0, 0, 0}, 2*Pi/33/2} { Surface{254}; }
Extrude {{0, 1, 0}, {0, 0, 0}, 2*Pi/33/4} { Surface{326}; }
//+
Physical Volume("Channel", 399) = {4};
Physical Volume("Metal", 400) = {1, 3, 5, 2};
//+
Physical Surface("Outlet", 401) = {325};
Physical Surface("Inlet", 402) = {297};
//+
Physical Surface("Top", 403) = {161, 397, 253, 89};
Physical Surface("Bottom", 404) = {133, 225, 61, 369};
//+
Physical Surface("Interior", 405) = {57, 109, 105, 101, 97, 93};
Physical Surface("Exterior", 406) = {129, 181, 177, 173, 169, 165};
//+
Physical Surface("Walls", 407) = {273, 277, 281, 285, 289, 293, 254, 326, 301, 305, 309, 313, 317, 321};
//+
Physical Surface("Symmetry", 408) = {182, 3, 2, 1, 398, 110};
//+
channel_points[] = PointsOf{ Surface{325, 297, 273, 277, 281, 285, 289, 293, 254, 326, 301, 305, 309, 313, 317, 321}; };
Characteristic Length{ channel_points[] } = cmin;
