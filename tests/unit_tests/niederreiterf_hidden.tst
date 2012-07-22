// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

// A word of caution !
// In dimension 4, the programs GENIN and GENIN2 do produce the 
// same results but in different orders:
// GENIN GENIN2
// #1    #1    
// #2    #2    
// #3    #4    
// #4    #3    
// #5    #8
// #6    #7
// #7    #5
// #8    #6
// etc...

//
// Test the "hidden" API
//
start = _lowdisc_niedfisstart ( );
assert_checkequal ( start , 0 );
dim = 4;
base = 2;
skip = 0;
gfaritfile = fullfile(TMPDIR,"gfarit.txt");
gfplysfile = fullfile(TMPDIR,"gfplys.txt");
init = 1;
_lowdisc_niedfstart ( dim , base , skip , gfaritfile , gfplysfile , init );
start = _lowdisc_niedfisstart ( );
assert_checkequal ( start , 1 );
dim2 = _lowdisc_niedfdimget( );
assert_checkequal ( dim2 , dim );
base2 = _lowdisc_niedfbaseget( );
assert_checkequal ( base2 , base );
skip2 = _lowdisc_niedfskipget( );
assert_checkequal ( skip2 , skip );
computed = [];
// Skip first term
imax = 1;
leap = 0;
next = _lowdisc_niedfnext ( imax , leap );
expected = [0.000000      0.000000      0.000000      0.000000];
assert_checkalmostequal ( next , expected , %eps );
for i = 1 : 9;
  next = _lowdisc_niedfnext ( imax , leap );
  computed(i,1:dim) = next;
end
// These values are from TOMS 738 / GENIN
expected= [
  0.500000      0.500000      0.750000      0.875000
  0.250000      0.750000      0.562500      0.765625
  0.750000      0.250000      0.312500      0.140625
  0.125000      0.625000      0.437500      0.546875
  0.625000      0.125000      0.687500      0.421875
  0.375000      0.375000      0.875000      0.281250
  0.875000      0.875000      0.125000      0.656250
  0.062500      0.937500      0.953125      0.234375
  0.562500      0.437500      0.203125      0.859375
];
assert_checkalmostequal ( computed , expected , [], 1.e-5 );
_lowdisc_niedfstop ( );
start = _lowdisc_niedfisstart ( );
assert_checkequal ( start , 0 );



//
// Test the "hidden" API
// Get 10 elements in one single call.
//
dim = 4;
base = 2;
skip = 0;
gfaritfile = fullfile(TMPDIR,"gfarit.txt");
gfplysfile = fullfile(TMPDIR,"gfplys.txt");
init = 1;
_lowdisc_niedfstart ( dim , base , skip , gfaritfile , gfplysfile , init );
imax = 10;
leap = 0;
computed = _lowdisc_niedfnext ( imax , leap );
// These values are from TOMS 738 / GENIN
expected= [
  0.000000      0.000000      0.000000      0.000000
  0.500000      0.500000      0.750000      0.875000
  0.250000      0.750000      0.562500      0.765625
  0.750000      0.250000      0.312500      0.140625
  0.125000      0.625000      0.437500      0.546875
  0.625000      0.125000      0.687500      0.421875
  0.375000      0.375000      0.875000      0.281250
  0.875000      0.875000      0.125000      0.656250
  0.062500      0.937500      0.953125      0.234375
  0.562500      0.437500      0.203125      0.859375
];
assert_checkalmostequal ( computed , expected , [], 1.e-5 );
_lowdisc_niedfstop ( );

//
// Test the "hidden" API
// Get 10 elements in one single call.
// Test leap = 1
//
dim = 4;
base = 2;
skip = 0;
gfaritfile = fullfile(TMPDIR,"gfarit.txt");
gfplysfile = fullfile(TMPDIR,"gfplys.txt");
init = 1;
_lowdisc_niedfstart ( dim , base , skip , gfaritfile , gfplysfile , init );
imax = 5;
leap = 1;
computed = _lowdisc_niedfnext ( imax , leap );
// These values are from TOMS 738 / GENIN
expected= [
  0.000000      0.000000      0.000000      0.000000
  0.250000      0.750000      0.562500      0.765625
  0.125000      0.625000      0.437500      0.546875
  0.375000      0.375000      0.875000      0.281250
  0.062500      0.937500      0.953125      0.234375
];
assert_checkalmostequal ( computed , expected , [], 1.e-5 );
_lowdisc_niedfstop ( );
