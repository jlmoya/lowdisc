// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the 
// GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// Scrambled Sobol sequence

lds=lowdisc_new("sobol");
lds=lowdisc_configure(lds,"-scrambling","Owen");
lds=lowdisc_destroy(lds);

// Must generate an error:
lds=lowdisc_new("sobol");
lds=lowdisc_configure(lds,"-dimension",50);
instr="lds=lowdisc_configure(lds,""-scrambling"",""Owen"")";
expectedmsg="ldsobolf_configure: Unable to set -scrambling option: current dimension is 50, but maximum dimension available for Owen is 40";
assert_checkerror ( instr , expectedmsg );
lds=lowdisc_destroy(lds);

// Must generate an error:
lds=lowdisc_new("sobol");
lds=lowdisc_configure(lds,"-scrambling","Owen");
instr="lds=lowdisc_configure(lds,""-dimension"",50)";
expectedmsg="ldsobolf_configure: Expected that all entries of input argument value at input #3 are lower or equal than 40, but entry #1 is equal to 50.";
assert_checkerror ( instr , expectedmsg );
lds=lowdisc_destroy(lds);

// Must generate an error:
lds=lowdisc_new("sobol");
instr="lds=lowdisc_configure(lds,""-dimension"",2000)";
expectedmsg="ldsobolf_configure: Expected that all entries of input argument value at input #3 are lower or equal than 1111, but entry #1 is equal to 2000.";
assert_checkerror ( instr , expectedmsg );
lds=lowdisc_destroy(lds);
//
path = lowdisc_getpath (  );
dataset=fullfile(path,"tests","unit_tests","ssobol-iflag1-s2-n50.csv");
expected = csvRead(dataset," ",".",[],[],"/#(.*)/");
lds=lowdisc_new("sobol");
lds=lowdisc_configure(lds,"-dimension",2);
lds=lowdisc_configure(lds,"-scrambling","Owen");
lds = lowdisc_startup (lds);
[lds,computed] = lowdisc_next (lds,50);
lds=lowdisc_destroy(lds);
assert_checkalmostequal(expected,computed,[],1.e-5);

if (%f) then
dim=5;
iflag=0;
leap=0;
imax=1;
seq = _lowdisc_ssobolnew ( dim , iflag )
quasi = _lowdisc_ssobolnext ( seq, imax , leap )
_lowdisc_ssoboldestroy(seq)

t = _lowdisc_ssoboltokens()
end
