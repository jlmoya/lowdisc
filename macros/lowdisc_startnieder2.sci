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
function this = lowdisc_startnieder2 ( this )
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
    NR_cj(1:dim,1:nbits) = lowdisc_niedercalcc2 ( dim );
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
endfunction

