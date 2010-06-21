// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2010 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// assert_close --
//   Returns 1 if the two real matrices computed and expected are close,
//   i.e. if the relative distance between computed and expected is lesser than epsilon.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_close ( computed, expected, epsilon )
  if expected==0.0 then
    shift = norm(computed-expected);
  else
    shift = norm(computed-expected)/norm(expected);
  end
  if shift < epsilon then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction

//
// assert_equal --
//   Returns 1 if the two real matrices computed and expected are equal.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_equal ( computed , expected )
  if computed==expected then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction


//
// Check the Fast Niederreiter sequence 
// Use base 2 - this is the default.
//
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [0.500000      0.500000      0.750000      0.875000];
assert_close ( computed, expected , 10 * %eps );
// Terms #2 to #9
[lds,computed]=lowdisc_next(lds,8);
expected= [...
  0.250000      0.750000      0.562500      0.765625
  0.750000      0.250000      0.312500      0.140625
  0.125000      0.625000      0.437500      0.546875
  0.625000      0.125000      0.687500      0.421875
  0.375000      0.375000      0.875000      0.281250
  0.875000      0.875000      0.125000      0.656250
  0.062500      0.937500      0.953125      0.234375
  0.562500      0.437500      0.203125      0.859375
];
assert_close ( computed, expected , 1.e-4 );
lds = lowdisc_destroy(lds);

//
// Check the Fast Niederreiter sequence 
// Use base 7.
//
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",6);
lds = lowdisc_configure(lds,"-base",7);
base = lowdisc_cget(lds,"-base");
assert_equal ( base , 7 );
lds = lowdisc_startup (lds);
// Terms #1 to #9
[lds,computed]=lowdisc_next(lds,9);
expected= [...
  0.142857       0.142857       0.142857       0.142857       0.142857       0.142857
  0.285714       0.285714       0.285714       0.285714       0.285714       0.285714
  0.428571       0.428571       0.428571       0.428571       0.428571       0.428571
  0.571429       0.571429       0.571429       0.571429       0.571429       0.571429
  0.714286       0.714286       0.714286       0.714286       0.714286       0.714286
  0.857143       0.857143       0.857143       0.857143       0.857143       0.857143
  0.020408       0.877551       0.734694       0.591837       0.448980       0.306122
  0.163265       0.020408       0.877551       0.734694       0.591837       0.448980
  0.306122       0.163265       0.020408       0.877551       0.734694       0.591837
];
assert_close ( computed, expected , 1.e-4 );
lds = lowdisc_destroy(lds);

//
// Test skip
//
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-skip",10);
lds = lowdisc_startup (lds);
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 10 );
[lds,computed]=lowdisc_next(lds,10);
expected= [
    0.8125     0.6875     0.640625    0.09375    
    0.1875     0.3125     0.515625    0.6875     
    0.6875     0.8125     0.265625    0.3125     
    0.4375     0.5625     0.078125    0.453125   
    0.9375     0.0625     0.828125    0.578125   
    0.03125    0.53125    0.734375    0.3457031  
    0.53125    0.03125    0.484375    0.7207031  
    0.28125    0.28125    0.171875    0.6113281  
    0.78125    0.78125    0.921875    0.4863281  
    0.15625    0.15625    0.796875    0.8300781  
];
assert_close ( computed, expected , 1.e-5 );
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 20 );
lds = lowdisc_destroy(lds);

//
// Test leap
//
lds = lowdisc_new("niederreiterf");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-leap",1);
lds = lowdisc_startup (lds);
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 0 );
[lds,computed]=lowdisc_next(lds,10);
expected= [
    0.5        0.5        0.75        0.875      
    0.75       0.25       0.3125      0.140625   
    0.625      0.125      0.6875      0.421875   
    0.875      0.875      0.125       0.65625    
    0.5625     0.4375     0.203125    0.859375   
    0.8125     0.6875     0.640625    0.09375    
    0.6875     0.8125     0.265625    0.3125     
    0.9375     0.0625     0.828125    0.578125   
    0.53125    0.03125    0.484375    0.7207031  
    0.78125    0.78125    0.921875    0.4863281  
];
assert_close ( computed, expected , 1.e-5 );
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 20 );
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
assert_equal ( (t2-t1)<1. , %t );

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
assert_equal ( (t2-t1)<1.e1 , %t );

