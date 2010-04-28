// Copyright (C) 2009 - Digiteo - Michael Baudin

// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

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
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","faure");
  //   prarray = lowdisc_primes100 ( );
  //   rng = lowdisc_configure(rng,"-primeslist",prarray);
  //   rng = lowdisc_configure(rng,"-dimension",50);
  //   [rng,next] = lowdisc_next ( rng );
  //   next
  //   rng = lowdisc_destroy(rng);
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

