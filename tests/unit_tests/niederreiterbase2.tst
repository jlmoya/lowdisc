// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Check the Niederreiter base 2 sequence
//
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [1./2. 1./2.];
assert_checkalmostequal ( computed, expected , 10 * %eps );
// Terms #2 to #5
[lds,computed]=lowdisc_next(lds,4);
expected= [
    3./4. 1./4. 
    1./4. 3./4. 
    3./8. 3./8. 
    7./8. 7./8. 
];
assert_checkalmostequal ( computed, expected , 10 * %eps );
lds = lowdisc_destroy(lds);


//
// Check the Niederreiter base 2 sequence in dimension 4
//
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_startup (lds);
// Term #1-11
[lds,computed] = lowdisc_next (lds,11);
expected = [
   0.500000  0.500000  0.750000  0.875000
   0.750000  0.250000  0.312500  0.140625
   0.250000  0.750000  0.562500  0.765625
   0.375000  0.375000  0.875000  0.281250
   0.875000  0.875000  0.125000  0.656250
   0.625000  0.125000  0.687500  0.421875
   0.125000  0.625000  0.437500  0.546875
   0.187500  0.312500  0.515625  0.687500
   0.687500  0.812500  0.265625  0.312500
   0.937500  0.062500  0.828125  0.578125
   0.437500  0.562500  0.078125  0.453125
];
assert_checkalmostequal ( computed, expected , 10 * %eps );
// Drop terms 12-94
[lds,computed]=lowdisc_next(lds,94-12+1);
// Terms #95 - 110
[lds,computed]=lowdisc_next(lds,110-95+1);
expected= [
   0.054688  0.929688  0.101563  0.509766
   0.039063  0.132813  0.464844  0.214844
   0.539063  0.632813  0.714844  0.839844
   0.789063  0.382813  0.152344  0.074219
   0.289063  0.882813  0.902344  0.949219
   0.414063  0.257813  0.589844  0.496094
   0.914063  0.757813  0.339844  0.621094
   0.664063  0.007813  0.777344  0.355469
   0.164063  0.507813  0.027344  0.730469
   0.226563  0.445313  0.949219  0.527344
   0.726563  0.945313  0.199219  0.402344
   0.976563  0.195313  0.636719  0.636719
   0.476563  0.695313  0.386719  0.261719
   0.351563  0.070313  0.074219  0.808594
   0.851563  0.570313  0.824219  0.183594
   0.601563  0.320313  0.261719  0.917969
];
assert_checkalmostequal ( computed, expected , [], 1.e-5 );
lds = lowdisc_destroy(lds);


//
// Test skip
//
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-skip",10);
lds = lowdisc_startup (lds);
index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 10 );
[lds,computed]=lowdisc_next(lds,10);
expected= [
    0.4375     0.5625     0.078125    0.453125   
    0.3125     0.1875     0.390625    0.96875    
    0.8125     0.6875     0.640625    0.09375    
    0.5625     0.4375     0.203125    0.859375   
    0.0625     0.9375     0.953125    0.234375   
    0.09375    0.46875    0.28125     0.3925781  
    0.59375    0.96875    0.53125     0.5175781  
    0.84375    0.21875    0.09375     0.2519531  
    0.34375    0.71875    0.84375     0.6269531  
    0.46875    0.09375    0.65625     0.1738281  
];
assert_checkalmostequal ( computed, expected , [], 1.e-5 );
index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 20 );
lds = lowdisc_destroy(lds);

//
// Test leap
//
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-leap",1);
lds = lowdisc_startup (lds);
index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 0 );
[lds,computed]=lowdisc_next(lds,10);
expected= [
    0.5        0.5        0.75        0.875      
    0.25       0.75       0.5625      0.765625   
    0.875      0.875      0.125       0.65625    
    0.125      0.625      0.4375      0.546875   
    0.6875     0.8125     0.265625    0.3125     
    0.4375     0.5625     0.078125    0.453125   
    0.8125     0.6875     0.640625    0.09375    
    0.0625     0.9375     0.953125    0.234375   
    0.59375    0.96875    0.53125     0.5175781
    0.34375    0.71875    0.84375     0.6269531  
];
assert_checkalmostequal ( computed, expected , [], 1.e-5 );
index = lowdisc_get ( lds , "-index" );
assert_checkequal ( index , 20 );
lds = lowdisc_destroy(lds);


// Check performance for large values of skip
// This is not so fast : nextq has to be updated.
t1 = timer();
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-skip", 1.e2);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
t2 = timer();
assert_checkequal ( (t2-t1)<10. , %t );

// Check performance for large values of leap
// This is not so fast : nextq has to be updated.
t1 = timer();
lds = lowdisc_new("niederreiter-base-2");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-leap", 1.e2);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
t2 = timer();
assert_checkequal ( (t2-t1)<20 , %t );

