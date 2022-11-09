
D:=5;

L:=3;tap:=[1]; t:=44;
//L:=5;tap:=[2]; t:=272;

//L:=7; tap:=[6,5,4,2,1];

//L:=37;tap:=[31,30,26,24,19,13,12,8,6];

load "WGAlg.m";
load "utils.m";   


SetMemoryLimit(4*10^9);
M:=t*31;
Key:=[Random(GF(2)): i in [1..n]];
Z:=WGPRNG(Key,t);
G:=[Zero(R): i in [1..M]];
S:=x;
wgEq(~G,S,Z,t);
time M:=XL(G,D);
Nrows(M);

