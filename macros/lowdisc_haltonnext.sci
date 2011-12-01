// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function next = lowdisc_haltonnext ( dimension , index , primemat )
  // Returns the next element of the Halton sequence.
  //
  // Calling Sequence
  //   next = lowdisc_haltonnext ( dimension , index , primemat )
  //
  // Parameters
  //   dimension : a 1 x 1 matrix of floating point integers, the number of variables
  //   index : a 1 x 1 matrix of floating point integers, the index of the element in the sequence
  //   primemat : a 1 x 1 matrix of floating point integers, a matrix of consecutive primes, in increasing order
  //   next : a 1 x 1 matrix of doubles, the next element in the sequence, in the [0,1) interval
  //
  // Description
  //   Generates the next element of the Halton sequence.
  //
  // Examples
  // // See the source code
  // edit lowdisc_haltonnext
  // 
  // // Get a matrix of 100 primes
  // primemat = lowdisc_primes100 ( );
  // dimension = 2;
  // // Generate element #0 of the Halton sequence in dimension 2
  // next = lowdisc_haltonnext ( dimension , 0 , primemat )
  // // Generate element #1 of the Halton sequence in dimension 2
  // next = lowdisc_haltonnext ( dimension , 1 , primemat )
  // // Generate element #2 of the Halton sequence in dimension 2
  // next = lowdisc_haltonnext ( dimension , 2 , primemat )
  // // Generate some elements 
  // for i = 0 : 2^7-1
  //   next(i+1,1:dimension) = lowdisc_haltonnext ( dimension , i , primemat );
  // end
  // // Plot them
  // scf();
  // plot ( next(:,1) , next(:,2) , "bo" )
  // xtitle("Halton point set","X1","X2");
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //
  // Bibliography
  //    "Algorithm 247: Radical-Inverse Quasi-Random Point Sequence", J H Halton and G B Smith, Communications of the ACM, Volume 7, 1964, pages 701-702.
  
  next = zeros(1:dimension)
  for idim = 1 : dimension
    basis = primemat ( idim )
    next(idim) = lowdisc_vandercorput ( index , basis )
  end
endfunction

