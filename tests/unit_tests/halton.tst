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
// Check the Halton sequence in dimension 1
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = 0.5;
shift = norm(computed-expected)/norm(expected);
if shift > 1.e-6 then pause,end
// Terms #2 to #6
[rng,computed]=lowdisc_terms(rng,5);
expected= [
    0.25 
    0.75    
    0.125   
    0.625   
    0.375  
];
assert_close ( computed, expected, %eps );
rng = lowdisc_destroy(rng);
clear rng;

//
// Check the Halton sequence in dimension 2
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
rng = lowdisc_configure(rng,"-dimension",2);
rng = lowdisc_startup (rng);
// Term #1
[rng,computed] = lowdisc_next (rng);
expected = [0.5 1.0/3.0];
assert_close ( computed, expected, %eps );
// Terms #2 to #6
[rng,computed]=lowdisc_terms(rng,5);
expected= [
    1./4. 2./3. 
    3./4. 1./9.    
    1./8. 4./9. 
    5./8. 7./9. 
    3./8. 2./9. 
];
assert_close ( computed, expected, %eps );
rng = lowdisc_destroy(rng);
clear rng;

//
// Try an extended list of primes, so that one can manage problems up to 200 dimensions
//
rng = lowdisc_new();
rng = lowdisc_configure(rng,"-method","halton");
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
rng = lowdisc_configure(rng,"-primeslist",myprimes);
rng = lowdisc_configure(rng,"-dimension",200);
rng = lowdisc_startup (rng);
for i = 1:10
  [rng,computed] = lowdisc_next (rng);
end
rng = lowdisc_destroy(rng);
clear rng;

