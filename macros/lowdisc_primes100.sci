// Copyright (C) 2009 - Digiteo - Michael Baudin

// This file must be used under the terms of the GNU LGPL license.





function m = lowdisc_primes100 ( )
  //   Returns a matrix containing the 100 first primes.
  //
  // Calling Sequence
  //   m = lowdisc_primes100 ( )
  //
  // Parameters
  //   m: a 1x100 matrix of doubles
  //
  // Description
  //   This function allows to update the table of 
  //   primes associated to the "-primeslist" option, so that
  //   we can use a low discrepancy sequence in higher dimensions.
  //
  // Examples
  //   prarray = lowdisc_primes100 ( );
  //   size(prarray)
  //
  //   lds = lowdisc_new("faure");
  //   prarray = lowdisc_primes100 ( );
  //   lds = lowdisc_configure(lds,"-primeslist",prarray);
  //   lds = lowdisc_configure(lds,"-dimension",50);
  //   [lds,next] = lowdisc_next ( lds );
  //   next
  //   lds = lowdisc_destroy(lds);
  //
  // Bibliography
  //   http://primes.utm.edu/
  //
  // Authors
  //   Michael Baudin - 2010 - DIGITEO

  m = [
      2      3      5      7     11     13     17     19     23     29 
     31     37     41     43     47     53     59     61     67     71 
     73     79     83     89     97    101    103    107    109    113 
    127    131    137    139    149    151    157    163    167    173 
    179    181    191    193    197    199    211    223    227    229 
    233    239    241    251    257    263    269    271    277    281 
    283    293    307    311    313    317    331    337    347    349 
    353    359    367    373    379    383    389    397    401    409 
    419    421    431    433    439    443    449    457    461    463 
    467    479    487    491    499    503    509    521    523    541 
  ]
  m = matrix(m',1,100)
endfunction

