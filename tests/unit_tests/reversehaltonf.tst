// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Check the Fast Reverse Halton sequence
//
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_configure(lds,"-scrambling","Reverse");

// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [0.5 2./3.];
assert_checkalmostequal ( computed, expected , 10 * %eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,5);
expected= [...
    1./4. 1./3. 
    3./4. 2./9.    
    1./8. 8./9. 
    5./8. 5./9. 
    3./8. 1./9. 
];
assert_checkalmostequal ( computed, expected , 10 * %eps );
lds = lowdisc_destroy(lds);

// test in dimension 2
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_configure(lds,"-scrambling","Reverse");

[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
// should be
// 0.5 0.666667
// 0.25 0.333333
// 0.75 0.222222
// 0.125 0.888889*/
assert_checkalmostequal ( computed, [3.0/4.0 2.0/9.0], 1.e-3 );
[lds,computed] = lowdisc_next (lds);
assert_checkalmostequal ( computed, [1.0/8.0 8.0/9.0], 1.e-3 );
lds = lowdisc_destroy(lds);


// test in dimension 3 */
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",3);
lds = lowdisc_configure(lds,"-scrambling","Reverse");

[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
[lds,computed] = lowdisc_next (lds);
assert_checkalmostequal ( computed, [0.75 2.0/9.0 0.4], 1.e-3 );
[lds,computed] = lowdisc_next (lds);
assert_checkalmostequal ( computed, [0.125 8.0/9.0 0.2], 1e-3 );
lds = lowdisc_destroy(lds);

// test skip
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",3);
lds = lowdisc_configure(lds,"-scrambling","Reverse");
lds = lowdisc_configure(lds,"-skip",10);
[lds,computed] = lowdisc_next (lds,10);
expected = [
    0.8125       0.4074074    0.92   
    0.1875       0.2962963    0.72   
    0.6875       0.9629630    0.52   
    0.4375       0.6296296    0.32   
    0.9375       0.1851852    0.08   
    0.03125      0.8518519    0.88   
    0.53125      0.5185185    0.68   
    0.28125      0.0370370    0.48   
    0.78125      0.7037037    0.28   
    0.15625      0.3703704    0.04   
];
assert_checkalmostequal ( computed, computed, [], 1e-5 );
index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 20 );
lds = lowdisc_destroy(lds);

// test leap
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",3);
lds = lowdisc_configure(lds,"-scrambling","Reverse");
lds = lowdisc_configure(lds,"-leap",1);

index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 0 );
[lds,computed] = lowdisc_next (lds,10);
expected = [
    0.5          0.6666667    0.8    
    0.75         0.2222222    0.4    
    0.625        0.5555556    0.16   
    0.875        0.7777778    0.76   
    0.5625       0.0740741    0.36   
    0.8125       0.4074074    0.92   
    0.6875       0.9629630    0.52   
    0.9375       0.1851852    0.08   
    0.53125      0.5185185    0.68   
    0.78125      0.7037037    0.28   
];
assert_checkalmostequal ( computed, computed, [], 1e-5 );
index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 20 );
lds = lowdisc_destroy(lds);

// Check performance for large values of skip
t1 = timer();
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-scrambling","Reverse");
lds = lowdisc_configure(lds,"-skip", 1.e7);

[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
t2 = timer();
assert_checkequal ( (t2-t1)<1. , %t );

// Check performance for large values of leap
t1 = timer();
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-scrambling","Reverse");
lds = lowdisc_configure(lds,"-leap", 1.e7);

[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
t2 = timer();
assert_checkequal ( (t2-t1)<1. , %t );


