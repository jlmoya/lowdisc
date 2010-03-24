
// lowdisc_nieder2 --
//  Returns an element of the Niederreiter sequence base 2.
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
//    Harald Niederreiter,
//    Low-discrepancy and low-dispersion sequences,
//    Journal of Number Theory,
//    Volume 30, 1988, pages 51-70.
//
//  Parameters:
//
//    Input, integer DIM, the dimension of the sequence to be generated.
//
//    Input, integer SEED, the index of the element to compute.
//
//    Output, real QUASI(DIM), the next quasirandom vector.
//
//    Output, integer SEED_NEW, the next value of the SEED.
//
//  Local Parameters:
//
//    Local, integer MAXDIM, the maximum dimension that will be used.
//
//    Local, integer NBITS, the number of bits (not counting the sign) in a
//    fixed-point integer.
//
//    Local, real RECIP is the multiplier which changes the
//    integers in NEXTQ into the required real values in QUASI.
//
//    Local, integer NR_cj(MAXDIM,NBITS), the packed values of
//    Niederreiter's C(I,J,R).
//
//    Local, integer NR_dim, the spatial dimension of the sequence
//    as specified on an initialization call.
//
//    Local, integer NR_nextq(MAXDIM), the numerators of the next item in the
//    series.  These are like Niederreiter's XI(N) (page 54) except that
//    N is implicit, and the NR_nextq are integers.  To obtain
//    the values of XI(N), multiply by RECIP.
//
function [ this , quasi ] = lowdisc_nieder2 ( this )

  // Extract data
  NR_cj = this.NR_cj;
  dim = this.dimension;
  NR_nextq = this.NR_nextq;
  NR_seed = this.NR_seed;
  NR_recip = this.NR_recip;
  nbits = this.NR_nbits;
//
//  Multiply the numerators in NEXTQ by RECIP to get the next
//  quasi-random vector.
//
  quasi(1:dim) = NR_nextq(1:dim) * NR_recip;
  quasi = quasi.';
//
//  Find the position of the right-hand zero in SEED.  This
//  is the bit that changes in the Gray-code representation as
//  we go from SEED to SEED+1.
//
  r = 0;
  i = NR_seed;
  while ( lowdisc_rem ( i, 2 ) ~= 0 )
    r = r + 1;
    i = floor ( i / 2 );
  end
//
//  Check that we have not passed 2**NBITS calls.
//
  if ( nbits <= r )
    error ( sprintf ( gettext ( "%s: Too many calls" ) , "lowdisc_nieder2" ) );
  end
//
//  Compute the new numerators in vector NEXTQ.
//
  for i = 1 : dim
    NR_nextq(i) = lowdisc_exor ( NR_nextq(i), NR_cj(i,r+1) );
  end
  NR_seed = NR_seed + 1;
  // Insert data
  this.NR_nextq = NR_nextq;
  this.NR_seed = NR_seed;

endfunction
