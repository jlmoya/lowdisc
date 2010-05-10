// Copyright (C) Paul Bratley, Bennett Fox, Harald Niederreiter
// Copyright (C) 2003 - John Burkardt
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
//    This code is distributed under the GNU LGPL license.

function this = ldnied2_startup (this)
// lowdisc_nieder2 --
//  Startup Niederreiter's sequence.
//
//  Licensing:
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//    31 March 2003
//
//  Author:
//    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
//    MATLAB version by John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
  
  if (this.startedup<>0) then
    errmsg = sprintf( gettext ( "%s: Startup can only be run once." ) , "ldnied2_startup" );
    error(errmsg);
  end
  if (this.verbose) then
    mprintf( "Starting up the sequence." );
  end
  this.startedup = 1;
  //
  // Create the sequence
  //
  // Extract data
  dim = this.dimension;

  maxdim = 20;
  nbits = 31;
  NR_recip = 2.0E+00^(-nbits);
//
//  Initialization.
//
    if ( maxdim < dim )
      error ( sprintf ( gettext ( '%s: Dimension %d is greater than maximum %d') , dim , maxdim ) );
    end
    seed = 0;
//
//  Calculate the C array.
//
    NR_cj(1:dim,1:nbits) = _niedercalcc2 ( dim );
//
//  Set up NEXTQ appropriately, depending on the Gray code of SEED.
//
//  You can do this every time, starting NEXTQ back at 0,
//  or you can do it once, and then carry the value of NEXTQ
//  around from the previous computation.
//
    gray = lowdisc_exor ( seed, seed / 2 );
    NR_nextq(1:dim) = 0;
    r = 0;
    while ( gray ~= 0 )
      if ( rem ( gray, 2 ) ~= 0 )
        for i = 1 : dim
          NR_nextq(i) = lowdisc_exor ( NR_nextq(i), NR_cj(i,r+1) );
        end
      end
      gray = floor ( gray / 2 );
      r = r + 1;
    end
    // Insert data
    this.NR_cj = NR_cj;
    this.NR_seed = seed;
    this.NR_nextq = NR_nextq
    this.NR_recip = NR_recip;
    this.NR_nbits = nbits;
  // Initialize the sequence
  this.sequenceindex = 0;
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  if ( this.skip > 0 ) then
    [ this , result ] = lowdisc_next ( this , this.skip )
  end
endfunction

//  _niedercalcc2 --
//   computes the constants C(I,J,R).
//
//  Discussion:
//    As far as possible, Niederreiter's notation is used.
//
//    For each value of I, we first calculate all the corresponding
//    values of C.  These are held in the array CI.  All these
//    values are either 0 or 1.
//
//    Next we pack the values into the
//    array CJ, in such a way that CJ(I,R) holds the values of C
//    for the indicated values of I and R and for every value of
//    J from 1 to NBITS.  The most significant bit of CJ(I,R)
//    (not counting the sign bit) is C(I,1,R) and the least
//    significant bit is C(I,NBITS,R).
//
//  Licensing:
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//    30 March 2003
//
//  Author:
//    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
//    MATLAB version by John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Reference:
//    R Lidl and Harald Niederreiter,
//    Finite Fields,
//    Cambridge University Press, 1984, page 553.
//
//    Harald Niederreiter,
//    Low-discrepancy and low-dispersion sequences,
//    Journal of Number Theory,
//    Volume 30, 1988, pages 51-70.
//
//  Parameters:
//    Input, integer DIMEN, the dimension of the sequence to be generated.
//
//    Output, integer CJ(MAXDIM,0:NBITS-1), the packed values of
//    Niederreiter's C(I,J,R)
//
//  Local Parameters:
//
//    Local, integer MAXDIM, the maximum dimension that will be used.
//
//    Local, integer MAXE; we need MAXDIM irreducible polynomials over Z2.
//    MAXE is the highest degree among these.
//
//    Local, integer MAXV, the maximum possible index used in V.
//
//    Local, integer NBITS, the number of bits (not counting the sign) in a
//    fixed-point integer.
//
function cj = _niedercalcc2 ( dimen )
  maxdim = 20;
  maxe = 6;
  nbits = 31;
  maxv = nbits + maxe;
//
//  Here we supply the coefficients and the
//  degrees of the first MAXDIM irreducible polynomials over Z2.
//
  irred_deg(1:maxdim) = ...
    [ 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6 ];
  irred(1:maxdim,1:maxe+1) = [ ...
    0,1,0,0,0,0,0; ...
    1,1,0,0,0,0,0; ...
    1,1,1,0,0,0,0; ...
    1,1,0,1,0,0,0; ...
    1,0,1,1,0,0,0; ...
    1,1,0,0,1,0,0; ...
    1,0,0,1,1,0,0; ...
    1,1,1,1,1,0,0; ...
    1,0,1,0,0,1,0; ...
    1,0,0,1,0,1,0; ...
    1,1,1,1,0,1,0; ...
    1,1,1,0,1,1,0; ...
    1,1,0,1,1,1,0; ...
    1,0,1,1,1,1,0; ...
    1,1,0,0,0,0,1; ...
    1,0,0,1,0,0,1; ...
    1,1,1,0,1,0,1; ...
    1,1,0,1,1,0,1; ...
    1,0,0,0,0,1,1; ...
    1,1,1,0,0,1,1];
//
//  Prepare to work in Z2.
//
  [ add, mul, sub ] = _niedersetfld2 ( 0 );
  for i = 1 : dimen
//
//  For each dimension, we need to calculate powers of an
//  appropriate irreducible polynomial:  see Niederreiter
//  page 65, just below equation (19).
//
//  Copy the appropriate irreducible polynomial into PX,
//  and its degree into E.  Set polynomial B = PX ** 0 = 1.
//  M is the degree of B.  Subsequently B will hold higher
//  powers of PX.
//
    e = irred_deg(i);
    px_deg = irred_deg(i);
    for j = 0 : e
      px(j+1) = irred(i,j+1);
    end
    b_deg = 0;
    b(0+1) = 1;
//
//  Niederreiter (page 56, after equation (7), defines two
//  variables Q and U.  We do not need Q explicitly, but we do need U.
//
    u = 0;
    for j = 1 : nbits
//
//  If U = 0, we need to set B to the next power of PX
//  and recalculate V.  This is done by subroutine CALCV2.
//
      if ( u == 0 )
        [ b_deg, b, v ] = _niedercalcv2 ( maxv, px_deg, px, add, mul, sub, b_deg, b );
      end
//
//  Now C is obtained from V.  Niederreiter obtains A from V (page 65,
//  near the bottom), and then gets C from A (page 56, equation (7)).
//  However this can be done in one step.  Here CI(J,R) corresponds to
//  Niederreiter's C(I,J,R).
//
      for r = 0 : nbits-1
        ci(j,r+1) = v(r+u+1);
      end
//
//  Increment U.
//
//  If U = E, then U = 0 and in Niederreiter's
//  paper Q = Q + 1.  Here, however, Q is not used explicitly.
//
      u = u + 1;
      if ( u == e )
        u = 0;
      end
    end
//
//  The array CI now holds the values of C(I,J,R) for this value
//  of I.  We pack them into array CJ so that CJ(I,R) holds all
//  the values of C(I,J,R) for J from 1 to NBITS.
//
    for r = 0 : nbits-1
      term = 0;
      for j = 1 : nbits
        term = 2 * term + ci(j,r+1);
      end
      cj(i,r+1) = term;
    end
  end
endfunction

//  _niedercalcv2 --
//    calculates the constants V(J,R).
//
//  Discussion:
//
//    This program calculates the values of the constants V(J,R) as
//    described in the reference (BFN) section 3.3.  It is called from
//    either CALCC or CALCC2.
//
//    Polynomials stored as arrays have the coefficient of degree N
//    in POLY(N+1).
//
//    A polynomial which is identically 0 is given degree -1.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    31 March 2003
//
//  Author:
//
//    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
//    MATLAB version by John Burkardt
//    Scilab version : 
//       2009 - Digiteo - Michael Baudin
//
//  Reference:
//
//    Paul Bratley, Bennett Fox, Harald Niederreiter,
//    Algorithm 738:
//    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
//    ACM Transactions on Mathematical Software,
//    Volume 20, Number 4, pages 494-495, 1994.
//
//  Parameters:
//
//    Input, integer MAXV gives the dimension of the array V.
//
//    Input, integer PX_DEG, the degree of polynomial PX.
//
//    Input, integer PX(PXDEG+1), the appropriate irreducible polynomial
//    for the dimension currently being considered.  The degree of PX
//    will be called E.
//
//    Input, integer ADD(2,2), MUL(2,2), SUB(2,2), the addition, multiplication, 
//    and subtraction tables, mod 2.
//
//    Input, integer B_DEG, the degree of the polynomial B.
//
//    Input, integer B(B_DEG+1), the polynomial defined in section 2.3 of BFN.  
//    The degree of B implicitly define the parameter J of section 3.3, 
//    by degree(B) = E*(J-1).  On output,
//    B has been multiplied by PX, so its degree is now E * J.
//
//    Output, integer PC_DEG, the degree of the polynomial C = B * PX.
//
//    Output, integer PC(PC_DEG+1), the polynomial C = B * PX.
//
//    Output, integer V(MAXV+1), the computed V array.
//
//  Local Parameters:
//
//    Local, integer ARBIT, indicates where the user can place
//    an arbitrary element of the field of order 2.  This means
//    0 <= ARBIT < 2.
//
//    Local, integer BIGM, is the M used in section 3.3.
//    It differs from the [little] m used in section 2.3,
//    denoted here by M.
//
//    Local, integer NONZER, shows where the user must put an arbitrary
//    non-zero element of the field.  For the code, this means
//    0 < NONZER < 2.
//
function [ pc_deg, pc, v ] = _niedercalcv2 ( maxv, px_deg, px, add, mul, sub, b_deg, b )
  arbit = 1;
  nonzer = 1;
  e = px_deg;
//
//  The polynomial B is PX**(J-1).
//
//  In section 3.3, the values of Hi are defined with a minus sign:
//  don't forget this if you use them later!
//
  bigm = b_deg;
//
//  Multiply B by PX to compute PC = PX**J.
//  In section 2.3, the values of Bi are defined with a minus sign:
//  don't forget this if you use them later!
//
  [ pc_deg, pc ] = _niederplymul2 ( add, mul, px_deg, px, b_deg, b );
  m = pc_deg;
//
//  We don't use J explicitly anywhere, but here it is just in case.
//
  j = m / e;
//
//  Now choose a value of Kj as defined in section 3.3.
//  We must have 0 <= Kj < E*J = M.
//  The limit condition on Kj does not seem very relevant
//  in this program.
//
  kj = bigm;
//
//  Choose values of V in accordance with the conditions in section 3.3.
//
  for r = 0 : kj-1
    v(r+1) = 0;
  end
  v(kj+1) = 1;
  if ( kj < bigm )
    term = sub ( 0+1, b(kj+1)+1 );
//
//  Check the condition of section 3.3,
//  remembering that the B's have the opposite sign.
//
    for r = kj+1 : bigm-1
      v(r+1) = arbit;
      term = sub ( term+1, mul ( b(r+1)+1, v(r+1)+1 )+1 );
    end
//
//  Now V(BIGM) is anything but TERM.
//
    v(bigm+1) = add ( nonzer+1, term+1 );
    for r = bigm+1 : m-1
      v(r+1) = arbit;
    end
  else
    for r = kj+1 : m-1
      v(r+1) = arbit;
    end
  end
//
//  Calculate the remaining V's using the recursion of section 2.3,
//  remembering that the PC's have the opposite sign.
//
  for r = 0 : maxv-m
    term = 0;
    for i = 0 : m-1
      term = sub ( term+1, mul ( pc(i+1)+1, v(r+i+1)+1 )+1 );
    end
    v(r+m+1) = term;
  end
endfunction
// _niederplymul2 --
//    multiplies two polynomials in the field of order 2.
//
//  Discussion:
//
//    Polynomials stored as arrays have the coefficient of degree N in POLY(N+1).
//
//    A polynomial which is identically 0 is given degree -1.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    30 March 2003
//
//  Author:
//
//    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
//    MATLAB version by John Burkardt
//
//  Parameters:
//
//    Input, integer ADD(2,2), MUL(2,2), the addition and multiplication 
//    tables, mod 2.
//
//    Input, integer PA_DEG, the degree of polynomial A.
//
//    Input, integer PA(PA_DEG+1), the coefficients of polynomial A.
//
//    Input, integer PB_DEG, the degree of polynomial B.
//
//    Input, integer PB(PB_DEG+1), the coefficients of polynomial B.
//
//    Output, integer PC_DEG, the degree of polynomial C.
//
//    Output, integer PC(PC_DEG+1), the product polynomial, C = A * B mod 2.
//
function [ pc_deg, pc ] = _niederplymul2 ( add, mul, pa_deg, pa, pb_deg, pb )
  if ( pa_deg == -1 | pb_deg == -1 )
    pc_deg = -1;
  else
    pc_deg = pa_deg + pb_deg;
  end
  for i = 0 : pc_deg
    term = 0;
    for j = max ( 0, i-pa_deg ) : min ( pb_deg, i )
      term = add ( term+1, mul ( pa(i-j+1)+1, pb(j+1)+1 ) + 1 );
    end
    pt(i+1) = term;
  end
  for i = 0 : pc_deg
    pc(i+1) = pt(i+1);
  end
endfunction
//  _niedersetfld2 --
//     sets up arithmetic tables for the finite field of order 2.
//
//  Discussion:
//
//    SETFLD2 sets up addition, multiplication, and subtraction tables
//    for the finite field of order 2.
//
//  Licensing:
//
//    This code is distributed under the GNU LGPL license.
//
//  Modified:
//
//    30 March 2003
//
//  Author:
//
//    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
//    MATLAB version by John Burkardt
//
//  Parameters:
//
//    Input, integer DUMMY, a dummy argument.
//
//    Output, integer ADD(2,2), MUL(2,2), SUB(2,2), the addition, 
//    multiplication, and subtraction tables, mod 2.
//
function [ add, mul, sub ] = _niedersetfld2 ( dummy )
  q = 2;
  p = 2;
  for i = 0 : 1
    for j = 0 : 1
      add(i+1,j+1) = modulo ( i + j, p );
    end
  end
  for i = 0 : 1
    for j = 0 : 1
      mul(i+1,j+1) = modulo ( i * j, p );
    end
  end
  for i = 0 : 1
    for j = 0 : 1
      sub(add(i+1,j+1)+1, i+1) = j;
    end
  end
endfunction

