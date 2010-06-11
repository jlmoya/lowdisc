// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt



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
// Check the Halton sequence in dimension 1
//
lds = lowdisc_new("halton");
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
assert_close ( computed , 0.5 , %eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,5);
expected= [
    0.25 
    0.75    
    0.125   
    0.625   
    0.375  
];
assert_close ( computed, expected, %eps );
lds = lowdisc_destroy(lds);


//
// Check the Halton sequence in dimension 2
//
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",2);
lds = lowdisc_startup (lds);
// Term #1
[lds,computed] = lowdisc_next (lds);
expected = [0.5 1.0/3.0];
assert_close ( computed, expected, %eps );
// Terms #2 to #6
[lds,computed]=lowdisc_next(lds,5);
expected= [
    1./4. 2./3. 
    3./4. 1./9.    
    1./8. 4./9. 
    5./8. 7./9. 
    3./8. 2./9. 
];
assert_close ( computed, expected, %eps );
lds = lowdisc_destroy(lds);


//
// Try an extended list of primes, so that one can manage problems up to 200 dimensions
//
lds = lowdisc_new("halton");
myprimes = [
  2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 101 103 107 ...
  109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199 211 223 227 229 233 ...
  239 241 251 257 263 269 271 277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373 ...
  379 383 389 397 401 409 419 421 431 433 439 443 449 457 461 463 467 479 487 491 499 503 509 ...
  521 523 541 547 557 563 569 571 577 587 593 599 601 607 613 617 619 631 641 643 647 653 659 ...
  661 673 677 683 691 701 709 719 727 733 739 743 751 757 761 769 773 787 797 809 811 821 823 ...
  827 829 839 853 857 859 863 877 881 883 887 907 911 919 929 937 941 947 953 967 971 977 983 ...
  991 997 1009 1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091 1093 1097 1103 ...
  1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193 1201 1213 1217 1223
];
lds = lowdisc_configure(lds,"-primeslist",myprimes);
lds = lowdisc_configure(lds,"-dimension",200);
lds = lowdisc_startup (lds);
for i = 1:10
  [lds,computed] = lowdisc_next (lds);
end
lds = lowdisc_destroy(lds);

//
// Check the result against TOMS 647 data in dimension 4
//
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
// Skip 1 term, as in TOMS implementation
lds = lowdisc_configure(lds,"-skip", 1);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,100);
expected = [
0.250000      0.666667      0.400000      0.285714
0.750000      0.111111      0.600000      0.428571
0.125000      0.444444      0.800000      0.571429
0.625000      0.777778      0.040000      0.714286
0.375000      0.222222      0.240000      0.857143
0.875000      0.555556      0.440000      0.020408
0.062500      0.888889      0.640000      0.163265
0.562500      0.037037      0.840000      0.306122
0.312500      0.370370      0.080000      0.448980
0.812500      0.703704      0.280000      0.591837
0.187500      0.148148      0.480000      0.734694
0.687500      0.481481      0.680000      0.877551
0.437500      0.814815      0.880000      0.040816
0.937500      0.259259      0.120000      0.183673
0.031250      0.592593      0.320000      0.326531
0.531250      0.925926      0.520000      0.469388
0.281250      0.074074      0.720000      0.612245
0.781250      0.407407      0.920000      0.755102
0.156250      0.740741      0.160000      0.897959
0.656250      0.185185      0.360000      0.061224
0.406250      0.518519      0.560000      0.204082
0.906250      0.851852      0.760000      0.346939
0.093750      0.296296      0.960000      0.489796
0.593750      0.629630      0.008000      0.632653
0.343750      0.962963      0.208000      0.775510
0.843750      0.012346      0.408000      0.918367
0.218750      0.345679      0.608000      0.081633
0.718750      0.679012      0.808000      0.224490
0.468750      0.123457      0.048000      0.367347
0.968750      0.456790      0.248000      0.510204
0.015625      0.790123      0.448000      0.653061
0.515625      0.234568      0.648000      0.795918
0.265625      0.567901      0.848000      0.938776
0.765625      0.901235      0.088000      0.102041
0.140625      0.049383      0.288000      0.244898
0.640625      0.382716      0.488000      0.387755
0.390625      0.716049      0.688000      0.530612
0.890625      0.160494      0.888000      0.673469
0.078125      0.493827      0.128000      0.816327
0.578125      0.827160      0.328000      0.959184
0.328125      0.271605      0.528000      0.122449
0.828125      0.604938      0.728000      0.265306
0.203125      0.938272      0.928000      0.408163
0.703125      0.086420      0.168000      0.551020
0.453125      0.419753      0.368000      0.693878
0.953125      0.753086      0.568000      0.836735
0.046875      0.197531      0.768000      0.979592
0.546875      0.530864      0.968000      0.002915
0.296875      0.864198      0.016000      0.145773
0.796875      0.308642      0.216000      0.288630
0.171875      0.641975      0.416000      0.431487
0.671875      0.975309      0.616000      0.574344
0.421875      0.024691      0.816000      0.717201
0.921875      0.358025      0.056000      0.860058
0.109375      0.691358      0.256000      0.023324
0.609375      0.135802      0.456000      0.166181
0.359375      0.469136      0.656000      0.309038
0.859375      0.802469      0.856000      0.451895
0.234375      0.246914      0.096000      0.594752
0.734375      0.580247      0.296000      0.737609
0.484375      0.913580      0.496000      0.880466
0.984375      0.061728      0.696000      0.043732
0.007813      0.395062      0.896000      0.186589
0.507812      0.728395      0.136000      0.329446
0.257812      0.172840      0.336000      0.472303
0.757812      0.506173      0.536000      0.615160
0.132812      0.839506      0.736000      0.758017
0.632812      0.283951      0.936000      0.900875
0.382812      0.617284      0.176000      0.064140
0.882812      0.950617      0.376000      0.206997
0.070313      0.098765      0.576000      0.349854
0.570312      0.432099      0.776000      0.492711
0.320312      0.765432      0.976000      0.635569
0.820312      0.209877      0.024000      0.778426
0.195312      0.543210      0.224000      0.921283
0.695312      0.876543      0.424000      0.084548
0.445312      0.320988      0.624000      0.227405
0.945312      0.654321      0.824000      0.370262
0.039063      0.987654      0.064000      0.513120
0.539062      0.004115      0.264000      0.655977
0.289062      0.337449      0.464000      0.798834
0.789062      0.670782      0.664000      0.941691
0.164062      0.115226      0.864000      0.104956
0.664062      0.448560      0.104000      0.247813
0.414062      0.781893      0.304000      0.390671
0.914062      0.226337      0.504000      0.533528
0.101562      0.559671      0.704000      0.676385
0.601562      0.893004      0.904000      0.819242
0.351562      0.041152      0.144000      0.962099
0.851562      0.374486      0.344000      0.125364
0.226562      0.707819      0.544000      0.268222
0.726562      0.152263      0.744000      0.411079
0.476562      0.485597      0.944000      0.553936
0.976562      0.818930      0.184000      0.696793
0.023438      0.263374      0.384000      0.839650
0.523438      0.596708      0.584000      0.982507
0.273438      0.930041      0.784000      0.005831
0.773438      0.078189      0.984000      0.148688
0.148438      0.411523      0.032000      0.291545
0.648438      0.744856      0.232000      0.434402
];
assert_close ( computed , expected , 1.e-5 );
lds = lowdisc_destroy(lds);

// Configure a list of primes and use it
lds = lowdisc_new("halton");
prarray = lowdisc_primes1000 ( );
lds = lowdisc_configure(lds,"-primeslist",prarray);
lds = lowdisc_configure(lds,"-dimension",150);
lds = lowdisc_startup (lds);
[lds,next] = lowdisc_next ( lds , 10 );
assert_equal ( size(next) , [10 150] );
lds = lowdisc_destroy(lds);

//
// Check skip
//
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-skip", 10);
lds = lowdisc_startup (lds);
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 10 );
[lds,computed]=lowdisc_next(lds,10);
expected = [
    0.8125     0.7037037    0.28    0.5918367  
    0.1875     0.1481481    0.48    0.7346939  
    0.6875     0.4814815    0.68    0.8775510  
    0.4375     0.8148148    0.88    0.0408163  
    0.9375     0.2592593    0.12    0.1836735  
    0.03125    0.5925926    0.32    0.3265306  
    0.53125    0.9259259    0.52    0.4693878  
    0.28125    0.0740741    0.72    0.6122449  
    0.78125    0.4074074    0.92    0.7551020  
    0.15625    0.7407407    0.16    0.8979592  
];
assert_close ( computed , expected , 1.e-5 );
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 20 );
lds = lowdisc_destroy(lds);

//
// Check leap
//
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-leap", 1);
lds = lowdisc_startup (lds);
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 0 );
[lds,computed]=lowdisc_next(lds,10);
expected = [
    0.5          0.3333333    0.2      0.1428571  
    0.75         0.1111111    0.6      0.4285714  
    0.625        0.7777778    0.04     0.7142857  
    0.875        0.5555556    0.44     0.0204082  
    0.5625       0.0370370    0.84     0.3061224  
    0.8125       0.7037037    0.28     0.5918367  
    0.6875       0.4814815    0.68     0.8775510  
    0.9375       0.2592593    0.12     0.1836735  
    0.53125      0.9259259    0.52     0.4693878  
    0.78125      0.4074074    0.92     0.7551020  
];
assert_close ( computed , expected , 1.e-5 );
index = lowdisc_get ( lds , "-index" );
assert_equal ( index , 20 );
lds = lowdisc_destroy(lds);

// Check performance for large values of skip
t1 = timer();
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-skip", 1.e7);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
t2 = timer();
assert_equal ( (t2-t1)<1. , %t );

// Check performance for large values of leap
t1 = timer();
lds = lowdisc_new("halton");
lds = lowdisc_configure(lds,"-dimension",4);
lds = lowdisc_configure(lds,"-leap", 1.e7);
lds = lowdisc_startup (lds);
[lds,computed]=lowdisc_next(lds,10);
lds = lowdisc_destroy(lds);
t2 = timer();
assert_equal ( (t2-t1)<1. , %t );


