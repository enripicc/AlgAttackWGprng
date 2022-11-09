n:=7*L;
R<[x]>:=PolynomialRing(GF(2),n,"grevlex");
WGT:=x[2]*x[3]*x[4]*x[5]*x[6]*x[7] + x[1]*x[2]*x[3]*x[4]*x[6] + x[1]*x[2]*x[3]*x[5]*x[6] +
    x[1]*x[2]*x[4]*x[5]*x[6] + x[2]*x[3]*x[4]*x[5]*x[6] + x[1]*x[2]*x[3]*x[5]*x[7] +
    x[1]*x[3]*x[4]*x[5]*x[7] + x[2]*x[3]*x[4]*x[5]*x[7] + x[1]*x[2]*x[3]*x[6]*x[7] +
    x[1]*x[3]*x[4]*x[6]*x[7] + x[2]*x[3]*x[4]*x[6]*x[7] + x[1]*x[4]*x[5]*x[6]*x[7] +
    x[2]*x[4]*x[5]*x[6]*x[7] + x[1]*x[2]*x[3]*x[5] + x[1]*x[2]*x[3]*x[6] + x[2]*x[3]*x[4]*x[6] +
    x[1]*x[2]*x[5]*x[6] + x[2]*x[4]*x[5]*x[6] + x[3]*x[4]*x[5]*x[6] + x[2]*x[3]*x[4]*x[7] +
    x[1]*x[2]*x[5]*x[7] + x[2]*x[3]*x[5]*x[7] + x[1]*x[4]*x[5]*x[7] + x[2]*x[4]*x[5]*x[7] +
    x[2]*x[3]*x[6]*x[7] + x[1]*x[4]*x[6]*x[7] + x[2]*x[5]*x[6]*x[7] + x[3]*x[5]*x[6]*x[7] +
    x[4]*x[5]*x[6]*x[7] + x[1]*x[2]*x[3] + x[1]*x[2]*x[5] + x[1]*x[3]*x[5] + x[2]*x[3]*x[5] +
    x[1]*x[2]*x[6] + x[1]*x[4]*x[6] + x[2]*x[4]*x[6] + x[3]*x[4]*x[6] + x[4]*x[5]*x[6] +
    x[1]*x[2]*x[7] + x[1]*x[4]*x[7] + x[3]*x[4]*x[7] + x[4]*x[5]*x[7] + x[1]*x[6]*x[7] +
    x[3]*x[6]*x[7] + x[5]*x[6]*x[7] + x[3]*x[4] + x[4]*x[5] + x[1]*x[6] + x[4]*x[6] + x[2]*x[7] +
    x[4]*x[7] + x[5]*x[7] + x[1] + x[4] + x[6] + x[7];


load "AlgEq.m";



UpdateLFSR:=procedure(~S)
  b:=S[n];
  S[n]:=S[n-1];
  S[n-1]:=S[n-2];
  S[n-2]:=S[n-3];
  S[n-3]:=S[n-4] +b;
  S[n-4]:=S[n-5] +b;
  S[n-5]:=S[n-6] +b;
  S[n-6]:=b;
  for t in tap do
    j:=(L-t)*7 -6;
    for i:=0 to 6 do
      S[n-6 +i]+:=S[j +i];
    end for;
  end for;
  Rotate(~S,7);
end procedure;

WGPRNG:=function(S,t)
  Z:=[Zero(GF(2)): i in [1..t]];
  for i:=1 to t do
    Z[i]:=Evaluate(WGT,S);
    UpdateLFSR(~S);
  end for;
  return Z;
end function;


wgEq:=procedure(~G,S,Z,t)
  i:=1;
  j:=1;
  repeat
    j;
    if IsZero(Z[j]) then
      InsertEq(~G,~i,S,0);
    else
      InsertEq(~G,~i,S,1);
    end if;
    UpdateLFSR(~S);
    j +:=1;
  until j gt t;
end procedure;
