ReduceInd:=procedure(~F)
	F:=[f: f in F|not IsZero(f)];
	LM:=[LeadingMonomial(f): f in F];
	I:=[1..#F];
	nstep:=0;
	nzeros:=0;
	repeat
		nstep +:=1;
		printf "Step=%o\t Zeros=%o\n",nstep,nzeros;
		max:=0;
		ind:=0;
		for i in I do
			if LM[i] gt max then
				max:=LM[i];
				ind:=i;
			end if;
		end for;
		Exclude(~I,ind);
		for i in I do
			if LM[i] eq max then
				F[i] +:=F[ind];
				if IsZero(F[i]) then
					nzeros +:=1;
					Exclude(~I,i);
				else
					LM[i]:=LeadingMonomial(F[i]);
				end if;
			end if;
		end for;
	until IsZero(max);
	Sort(~F);
end procedure;




MonOfatmostDegree:=function(R,n,d)
  x:=[Name(R,i): i in [1..n]];
  N:=[R!1];
    if d eq 0 then
      return N;
    else
    L:=N;
    e:=1;
    repeat
      for i:=1 to n do
        for g in L do
          if Degree(g) eq e-1 then
            Include(~N,x[i]*g);
          end if;
        end for;
      end for;
      L:=N;
      e +:= 1;
    until e gt d;
  end if;
return L;
end function;


expectedEq:=function(G,n,D)
	M:=0;
	for g in G do
		d:=Degree(g);
		M +:=&+[Binomial(n,i): i in [0..(D-d)]];
	end for;
	return M;
end function;

XL:=function(G,D)
	R:=Parent(G[1]);
	n:=Rank(R);
	FE:=[Name(R,i)^2 +Name(R,i): i in [1..n]];
	time Mon:=&cat[[NormalForm(m,FE): m in MonomialsOfDegree(R,d)]: d in [0..D]];
	time Mon:=SetToSequence(SequenceToSet(Mon));
	time Sort(~Mon);
	time Reverse(~Mon);
	M:=ZeroMatrix(GF(2),expectedEq(G,n,D),&+[Binomial(n,i): i in [0..(D)]]);
	i:=0;
	j:=0;
	printf "Generating the matrix...";
	for g in G do
		if Degree(g) lt D then
      d:=D-Degree(g);
      for l:=#Mon to 1 by -1 do
        if Degree(Mon[l]) le d then
					f:=NormalForm(Mon[l]*g,FE);
					j:=0;
					i+:=1;
					for m in Monomials(f) do
						j:=Index(Mon,m,j+1);
						M[i,j]:=1;
					end for;
        else
          break;
        end if;
      end for;
    end if;
	end for;
	printf "end\n";
	printf "Reducing...";
	time M:=EchelonForm(M);
	RemoveZeroRows(~M);
	printf "end\n";
	printf "Sol:%o\n",[Polynomial(Eltseq(v),Mon): v in Rows(M)[(Nrows(M)-n+1)..Nrows(M)]];
	printf "Nrows:%o\n",Nrows(M);
	return M;
end function;

ReduceMonomial:=function(m)
	e:=Exponents(m);
	for j:=1 to #e do
		if e[j] gt 0 then
			e[j]:=1;
		end if;
	end for;
	return Monomial(Parent(m),e);
end function;

ReduceSequence:=procedure(~L)
	R:=Parent(L[1]);
	n:=Rank(R);
	for i:=1 to #L do
		i;
		for t in Monomials(L[i]) do
			L[i] +:= t;
			e:=[i : i in Exponents(t)];
			for j:=1 to n do
				if e[j] gt 0 then
					e[j]:=1;
				end if;
			end for;
			L[i] +:=Monomial(R,e);
		end for;
	end for;
end procedure;

ReduceSequence:=procedure(~L)
	R:=Parent(L[1]);
	RR:=BooleanPolynomialRing(Rank(R));
	n:=Rank(R);
	for i:=1 to #L do
		i;
		L[i]:=R!(RR!L[i]);
	end for;
end procedure;


ReduceMonomial:=function(m)
	e:=[i : i in Exponents(t)];
	for j:=1 to #e do
		if e[j] gt 0 then
			e[j]:=1;
		end if;
	end for;
	return Monomial(Parent(m),e);
end function;

genEq:=function(G,D)
	R:=Parent(G[1]);
	n:=Rank(R);
	L:=[Zero(R): i in [1..expectedEq(G,n,D)]];
	Mon:=MonOfatmostDegree(R,n,D-Min({Degree(g):g in G}));
	Sort(~Mon);
	L:=[];
	FE:=[x[i]^2 +x[i]: i in [1..n]];
  j:=1;
  c:=0;
  for g in G do
    c+:=1;
		c;
    if Degree(g) lt D then
      d:=D-Degree(g);
      for m in Mon do
        if Degree(m) le d then
					L[j]:=(m*g);
					j +:=1;
        else
          break;
        end if;
      end for;
    end if;
  end for;
	return L;
end function;

getOperations:=procedure(f)
  n:=Rank(Parent(f));
  RR<[S]>:=BooleanPolynomialRing(n,"grevlex");
  for m in Monomials(RR!f) do
    printf "G[i] +:=%o;\n",m;
  end for;
  printf"i +:=1;\n";
end procedure;

getOperationsFromBasis:=procedure(G)
  for g in G do
    getOperations(g);
  end for;
end procedure;
