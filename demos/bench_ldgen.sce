// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.


mprintf("Measures the performances of low discrepancy sequences.\n")
mprintf("Compares with uniform random number generators.\n")
mprintf("The column Nb/T indicates the number of generated doubles\n")
mprintf("by unit of time: larger is better.\n\n")

// Check the performances of all sequences
callf = 1000;
n = 4;
strict = %t;
seqmat = lowdisc_methods ();
mprintf("%-20s %10s %10s %10s\n","Name","Eval f", "Time (s)", "Nb/T")
k = 0;
// Test slow sequences
for ldseq = ["halton" "faure" "reversehalton" "sobol" "niederreiter-base-2"]
  k = k + 1;
  t1 = tic();
  [ evalf , u ] = lowdisc_ldgen ( callf/2 , n , ldseq , strict );
  // Add %eps to the timing to prevent a zero timing.
  perf(k) = toc() + %eps;
  bynb(k) = (n * evalf) / perf(k);
  mprintf("%-20s %10d %10.3f %10d\n",ldseq,evalf,perf(k),bynb(k))
end
// Test fast sequences
for ldseq = ["haltonf" "fauref" "reversehaltonf" "sobolf" "niederreiterf"]
  k = k + 1;
  t1 = tic();
  [ evalf , u ] = lowdisc_ldgen ( 100*callf , n , ldseq , strict );
  perf(k) = toc() + %eps;
  bynb(k) = (n * evalf) / perf(k);
  mprintf("%-20s %10d %10.3f %10d\n",ldseq,evalf,perf(k),bynb(k))
end
// Add random number generators for comparison
for rngen = [ "mt", "kiss", "clcg2", "clcg4", "urand", "fsultra" ]
  k = k + 1;
  grand ( "setgen" , rngen );
  t1 = tic();
  u = grand ( 100*callf , n , "def" );
  perf(k) = toc() + %eps;
  bynb(k) = (n * 100*callf) / perf(k);
  mprintf("%-20s %10d %10.3f %10d\n",rngen,100*callf,perf(k),bynb(k))
end

//
// Load this script into the editor
//
filename = "bench_ldgen.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

