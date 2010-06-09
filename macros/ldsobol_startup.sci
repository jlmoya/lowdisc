// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2005-2009 - John Burkardt
// Copyright (C) 1986 - Bennett Fox

// This file must be used under the terms of the GNU LGPL license.

function this = ldsobol_startup (this)
  //   Startup the sobol sequence
  //   This command can only be executed once in the lifetime of the object.
  //
  //  Licensing:
  //    This code is distributed under the GNU LGPL license.
  //
  //  Modified:
  //    17 February 2009
  //
  // Authors
  //   Bennett Fox
  //   John Burkardt
  //   Scilab version : 2009 - Digiteo - Michael Baudin
  // 
  // References
  //   "Algorithm 647: Implementation and Relative Efficiency of Quasirandom Sequence Generators", B. L. Fox, 1986. ACM Trans. Math. Softw., 12, 4 (Dec. 1986), 362-376.
  //   "Algorithm 659: Implementing Sobol's quasirandom sequence generator.", P. Bratley and B. L. Fox, 1988. ACM Trans. Math. Softw. 14, 1 (Mar. 1988), 88-100.
  //
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  //
  // Extract data
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  //
  dimmax = this.dimmax
  //
  //  Check dimension
  //
  if ( dimmax < dimension ) then
    errmsg = msprintf ( gettext ( "%s: Dimension %d is greater than maximum %d.\n" ) , "ldsobol_startup" , dimension , dimmax )
    error ( errmsg )
  end
  if ( dimension < 1 ) then
    errmsg = msprintf ( gettext ( "%s: Dimension %d is lower than 1.\n" ) , "ldsobol_startup" , dimension )
    error ( errmsg )
  end
  //
  [ this.v , this.maxcol , this.lastq , this.count , this.recipd ] = _sobolstartup ( dimension , dimmax )
  //
  // We ignore the first element in the sequence, which is [0 0] in dimension 2.
  // Our Sobol sequence starts with [0.5 0.5] in 2 dimensions.
  // Temporarily disable the leap to avoid interactions.
  // Indeed, if leap>0, then this call to next will also ignore leap elements in the 
  // sequence, which is not expected by the user.
  //
  leapold = ldbase_cget ( this.baseobj , "-leap" )
  this.baseobj = ldbase_configure ( this.baseobj , "-leap" , 0 )
  [ this , quasi ] = ldsobol_next ( this )
  this.baseobj = ldbase_configure ( this.baseobj , "-leap" , leapold )
  //
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    // Skip (i.e. ignore) as many elements as required.
    // This is as fast as it can be (based only on macros).
    // Vectorized call to lowdisc_bitxor : this is the best that we can do.
    for count = 1 : skip
      l = lowdisc_bitlo0 ( count )
      this.lastq = lowdisc_bitxor ( this.lastq, this.v(1 : dimension,l) )
    end
    this.count = skip + 1
  end
endfunction

function [ v , maxcol , lastq , count , recipd ] = _sobolstartup ( dimension , dimmax )
  // _sobolstartup --
  //   Initialize the Sobol sequence.
  // 
  // Parameters
  //   dimmax : the maximum dimension for the Sobol sequence. This is expected to be equal to 40, since no more that 40 polynomials are stored in the database.
  //   v : table of direction numbers. Each row corresponds to a primitive polynomial. The numbers in v are actually binary fractions.
  //   maxcol : number of bits in atmost.
  //   lastq : the numerators of the last vector generated
  //   count : sequence number of this call
  //   recipd : (1/denominator) for the numerators lastq
  //
  // Description
  //   atmost : the maximum number of calls to the generator

  logmax = 30
  //
  //  Initialize (part of) V.
  //
  v(1:dimmax,1:logmax) = zeros(dimmax,logmax)
  v(1:40,1) = [ ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]'
  v(3:40,2) = [ ...
  1, 3, 1, 3, 1, 3, 3, 1, ...
  3, 1, 3, 1, 3, 1, 1, 3, 1, 3, ...
  1, 3, 1, 3, 3, 1, 3, 1, 3, 1, ...
  3, 1, 1, 3, 1, 3, 1, 3, 1, 3 ]'
  v(4:40,3) = [ ...
  7, 5, 1, 3, 3, 7, 5, ...
  5, 7, 7, 1, 3, 3, 7, 5, 1, 1, ...
  5, 3, 3, 1, 7, 5, 1, 3, 3, 7, ...
  5, 1, 1, 5, 7, 7, 5, 1, 3, 3 ]'
  v(6:40,4) = [ ...
  1, 7, 9,13,11, ...
  1, 3, 7, 9, 5,13,13,11, 3,15, ...
  5, 3,15, 7, 9,13, 9, 1,11, 7, ...
  5,15, 1,15,11, 5, 3, 1, 7, 9 ]'
  v(8:40,5) = [ ...
  9, 3,27, ...
  15,29,21,23,19,11,25, 7,13,17, ...
  1,25,29, 3,31,11, 5,23,27,19, ...
  21, 5, 1,17,13, 7,15, 9,31, 9 ]'
  v(14:40,6) = [ ...
  37,33, 7, 5,11,39,63, ...
  27,17,15,23,29, 3,21,13,31,25, ...
  9,49,33,19,29,11,19,27,15,25 ]'
  v(20:40,7) = [ ...
  13, ...
  33,115, 41, 79, 17, 29,119, 75, 73,105, ...
  7, 59, 65, 21,  3,113, 61, 89, 45,107 ]'
  v(38:40,8) = [ ...
  7, 23, 39 ]'
  //
  //  Set POLY.
  //
  spoly(1:40)= [ ...
  1,   3,   7,  11,  13,  19,  25,  37,  59,  47, ...
  61,  55,  41,  67,  97,  91, 109, 103, 115, 131, ...
  193, 137, 145, 143, 241, 157, 185, 167, 229, 171, ...
  213, 191, 253, 203, 211, 239, 247, 285, 369, 299 ]
  //
  atmost = 2^logmax - 1
  //
  //  Find the number of bits in ATMOST.
  //
  maxcol = lowdisc_bithi1 ( atmost )
  //
  //  Initialize row 1 of V.
  //
  v(1,1:maxcol) = 1
  //
  //  Initialize the remaining rows of V.
  //
  for i = 2 : dimension
    //
    //  The bit pattern of the integer POLY(I) gives the form
    //  of polynomial I.
    //
    //  Find the degree of polynomial I from binary encoding.
    //
    j = spoly(i)
    m = 0
    while ( 1 )
      j = floor ( j / 2 )
      if ( j <= 0 )
        break
      end
      m = m + 1
    end
    //
    //  We expand this bit pattern to separate components of the logical array INCLUD.
    //
    j = spoly(i)
    for k = m : -1 : 1
      j2 = floor ( j / 2 )
      includ(k) = ( j ~= 2 * j2 )
      j = j2
    end
    //
    //  Calculate the remaining elements of row I as explained
    //  in Bratley and Fox, section 2.
    //
    for j = m + 1 : maxcol
      newv = v(i,j-m)
      l = 1
      for k = 1 : m
        l = 2 * l
        if ( includ(k) )
          newv = lowdisc_bitxor ( newv, l * v(i,j-k) )
        end
      end
      v(i,j) = newv
    end
  end
  //
  //  Multiply columns of V by appropriate power of 2.
  //
  l = 1
  for j = maxcol-1 : -1 : 1
    l = 2 * l
    v(1:dimension,j) = v(1:dimension,j) * l
  end
  //
  //  RECIPD is 1/(common denominator of the elements in V).
  //
  recipd = 1.0 / ( 2 * l )
  //
  //     SET UP FIRST VECTOR AND VALUES FOR "GOSOBL"
  //
  count = 0
  lastq(1:dimension) = 0
endfunction



