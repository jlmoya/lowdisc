
//
// lowdisc_startsobol --
//   Startup the sobol random number generator.
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
function this = lowdisc_startsobol ( this )
  // Extract data
  dim_num = this.dimension

  dimmax = 40;
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
//  Check parameters.
//
  if ( dimmax < dim_num )
    error ( sprintf ( gettext ( "%s: Dimension %d is greater than maximum %d\n" ) , dim_num , dimmax , "lowdisc_startsobol"));
  end
  if ( dim_num < 1 )
    error ( sprintf ( gettext ( "%s: Dimension %d is lower than 1\n" ) , dim_num , "lowdisc_startsobol"));
  end
  atmost = 2^logmax - 1;
//
//  Find the number of bits in ATMOST.
//
  maxcol = lowdisc_bithi1 ( atmost );
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
          newv = lowdisc_xor ( newv, l * v(i,j-k) );
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
// We drop the first element in the sequence, which is [0.0 0.0] in dimension 2.
// Our Sobol sequence starts with [0.5 0.5] in 2 dimensions
//
  [ this , quasi ] = lowdisc_sobol ( this );
endfunction

