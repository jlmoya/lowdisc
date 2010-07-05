// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.




// Check the performances of all sequences
callf = 1000;
n = 4;
strict = %t;
seqmat = lowdisc_methods ();
mprintf("%-20s %10s %10s %10s\n","Name","Eval f", "Time (s)", "T/10^6 Nb")
k = 0;
for ldseq = seqmat'
  k = k + 1;
  t1 = timer();
  [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict );
  perf(k) = timer();
  bynb(k) = 1.e6 * perf(k) / (n * evalf);
  mprintf("%-20s %10d %10.3f %10.1f\n",ldseq,evalf,perf(k),bynb(k))
end
// Add random number generators for comparison
for rngen = [ "mt", "kiss", "clcg2", "clcg4", "urand", "fsultra" ]
  k = k + 1;
  grand ( "setgen" , rngen );
  t1 = timer();
  u = grand ( callf , n , "def" );
  perf(k) = timer();
  bynb(k) = 1.e6 * perf(k) / (n * evalf);
  mprintf("%-20s %10d %10.3f %10.1f\n",rngen,callf,perf(k),bynb(k))
end

//
// Load this script into the editor
//
filename = "bench_ldgen.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );

