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
  //   John Burkardt
  //    Scilab version : 
  //       2009 - Digiteo - Michael Baudin
  //
  
  this.baseobj = ldbase_startup ( this.baseobj )
  //
  // Create the sequence
  //
  // Extract data
  dim_num = ldbase_cget ( this.baseobj , "-dimension" )
  //
  dimmax = this.dimmax;
  //
  //  Check dimension
  //
  if ( dimmax < dim_num ) then
    errmsg = msprintf ( gettext ( "%s: Dimension %d is greater than maximum %d.\n" ) , "ldsobol_startup" , dim_num , dimmax );
    error ( errmsg )
  end
  if ( dim_num < 1 ) then
    errmsg = msprintf ( gettext ( "%s: Dimension %d is lower than 1.\n" ) , "ldsobol_startup" , dim_num );
    error ( errmsg )
  end
  //
  logmax = 30;
  //
  //  Initialize (part of) V.
  //
  v(1:dimmax,1:logmax) = zeros(dimmax,logmax);
  v(1:40,1) = [ ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]';
  v(3:40,2) = [ ...
  1, 3, 1, 3, 1, 3, 3, 1, ...
  3, 1, 3, 1, 3, 1, 1, 3, 1, 3, ...
  1, 3, 1, 3, 3, 1, 3, 1, 3, 1, ...
  3, 1, 1, 3, 1, 3, 1, 3, 1, 3 ]';
  v(4:40,3) = [ ...
  7, 5, 1, 3, 3, 7, 5, ...
  5, 7, 7, 1, 3, 3, 7, 5, 1, 1, ...
  5, 3, 3, 1, 7, 5, 1, 3, 3, 7, ...
  5, 1, 1, 5, 7, 7, 5, 1, 3, 3 ]';
  v(6:40,4) = [ ...
  1, 7, 9,13,11, ...
  1, 3, 7, 9, 5,13,13,11, 3,15, ...
  5, 3,15, 7, 9,13, 9, 1,11, 7, ...
  5,15, 1,15,11, 5, 3, 1, 7, 9 ]';
  v(8:40,5) = [ ...
  9, 3,27, ...
  15,29,21,23,19,11,25, 7,13,17, ...
  1,25,29, 3,31,11, 5,23,27,19, ...
  21, 5, 1,17,13, 7,15, 9,31, 9 ]';
  v(14:40,6) = [ ...
  37,33, 7, 5,11,39,63, ...
  27,17,15,23,29, 3,21,13,31,25, ...
  9,49,33,19,29,11,19,27,15,25 ]';
  v(20:40,7) = [ ...
  13, ...
  33,115, 41, 79, 17, 29,119, 75, 73,105, ...
  7, 59, 65, 21,  3,113, 61, 89, 45,107 ]';
  v(38:40,8) = [ ...
  7, 23, 39 ]';
  //
  //  Set POLY.
  //
  spoly(1:40)= [ ...
  1,   3,   7,  11,  13,  19,  25,  37,  59,  47, ...
  61,  55,  41,  67,  97,  91, 109, 103, 115, 131, ...
  193, 137, 145, 143, 241, 157, 185, 167, 229, 171, ...
  213, 191, 253, 203, 211, 239, 247, 285, 369, 299 ];
  //
  atmost = 2^logmax - 1;
  //
  //  Find the number of bits in ATMOST.
  //
  maxcol = _bithi1 ( atmost );
  //
  //  Initialize row 1 of V.
  //
  v(1,1:maxcol) = 1;
  //
  //  Initialize the remaining rows of V.
  //
  for i = 2 : dim_num
    //
    //  The bit pattern of the integer POLY(I) gives the form
    //  of polynomial I.
    //
    //  Find the degree of polynomial I from binary encoding.
    //
    j = spoly(i);
    m = 0;
    while ( 1 )
      j = floor ( j / 2 );
      if ( j <= 0 )
        break;
      end
      m = m + 1;
    end
    //
    //  We expand this bit pattern to separate components of the logical array INCLUD.
    //
    j = spoly(i);
    for k = m : -1 : 1
      j2 = floor ( j / 2 );
      includ(k) = ( j ~= 2 * j2 );
      j = j2;
    end
    //
    //  Calculate the remaining elements of row I as explained
    //  in Bratley and Fox, section 2.
    //
    for j = m + 1 : maxcol
      newv = v(i,j-m);
      l = 1;
      for k = 1 : m
        l = 2 * l;
        if ( includ(k) )
          newv = _xor ( newv, l * v(i,j-k) );
        end
      end
      v(i,j) = newv;
    end
  end
  //
  //  Multiply columns of V by appropriate power of 2.
  //
  l = 1;
  for j = maxcol-1 : -1 : 1
    l = 2 * l;
    v(1:dim_num,j) = v(1:dim_num,j) * l;
  end
  //
  //  RECIPD is 1/(common denominator of the elements in V).
  //
  recipd = 1.0 / ( 2 * l );
  //
  //     SET UP FIRST VECTOR AND VALUES FOR "GOSOBL"
  //
  count = 0;
  lastq(1:dim_num) = 0;
  // Store data in structure
  this.sobolv = v
  this.sobolmaxcol = maxcol
  this.sobollastq = lastq
  this.sobolcount = count
  this.sobolrecipd = recipd
  //
  // We ignore the first element in the sequence, which is [0 0] in dimension 2.
  // Our Sobol sequence starts with [0.5 0.5] in 2 dimensions.
  // Temporarily disable the leap to avoid interactions.
  // Indeed, if leap>0, then this call to next will also ignore leap elements in the 
  // sequence, which is not expected by the user.
  //
  leapold = ldbase_cget ( this.baseobj , "-leap" )
  this.baseobj = ldbase_configure ( this.baseobj , "-leap" , 0 )
  [ this , quasi ] = ldsobol_next ( this );
  this.baseobj = ldbase_configure ( this.baseobj , "-leap" , leapold )
  //
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    [ this , result ] = ldsobol_next ( this , skip )
  end
endfunction


// _xor --
//   calculates the exclusive OR of two integers.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    16 February 2005
//
//  Author:
//
//   John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//
//    Input, integer I, J, two values whose exclusive OR is needed.
//
//    Output, integer K, the exclusive OR of I and J.
//
function k = _xor ( i, j )
  k = 0;
  l = 1;
  //
  i = floor ( i );
  j = floor ( j );
  while ( i ~= 0 | j ~= 0 )
    //
    //  Check the current right-hand bits of I and J.
    //  If they differ, set the appropriate bit of K.
    //
    i2 = floor ( i / 2 );
    j2 = floor ( j / 2 );
    if ( ...
      ( ( i == 2 * i2 ) & ( j ~= 2 * j2 ) ) | ...
      ( ( i ~= 2 * i2 ) & ( j == 2 * j2 ) ) )
      k = k + l;
    end
    i = i2;
    j = j2;
    l = 2 * l;
  end
endfunction

//
// _bithi1 --
//   I4_BIT_HI1 returns the position of the high 1 bit base 2 in an integer.
//
//  Example:
//
//       N    Binary     BIT
//    ----    --------  ----
//       0           0     0
//       1           1     1
//       2          10     2
//       3          11     2 
//       4         100     3
//       5         101     3
//       6         110     3
//       7         111     3
//       8        1000     4
//       9        1001     4
//      10        1010     4
//      11        1011     4
//      12        1100     4
//      13        1101     4
//      14        1110     4
//      15        1111     4
//      16       10000     5
//      17       10001     5
//    1023  1111111111    10
//    1024 10000000000    11
//    1025 10000000001    11
//
//  ilist =  [
//        22      96     
//        83      56     
//        41       6      
//        26      11      
//         4      64      
//         6      45      
//        40      76     
//        80       0     
//        90      35     
//         9       1       
//  ];
//  expected =  [
//    118
//    107
//    47
//    17
//    68
//    43
//    100
//    80
//    121
//    8
//  ];
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    16 February 2005
//
//  Author:
//
//    John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Parameters:
//
//    Input, integer N, the integer to be measured.
//    N should be nonnegative.  If N is nonpositive, the value will always be 0.
//
//    Output, integer BIT, the number of bits base 2.
//
function bit = _bithi1 ( n )
  i = floor ( n );
  bit = 0;
  while ( 1 )
    if ( i <= 0 )
      break;
    end
    bit = bit + 1;
    i = floor ( i / 2 );
  end
endfunction

