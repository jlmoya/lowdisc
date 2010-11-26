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
  [ this.v , this.maxcol , this.lastq , this.count , this.recipd ] = lowdisc_sobolstart ( dimension )
  //
  // We ignore the first element in the sequence, which is [0 0] in dimension 2.
  // Our Sobol sequence starts with [0.5 0.5] in 2 dimensions.
  // Avoid interactions by directly skipping one element (does not change the index and 
  // avoid interactions with leap).
  //
  [ this.count , this.lastq ] = lowdisc_sobolskip ( 1 , this.lastq , dimension , this.count , this.v )
  //
  skip = ldbase_cget ( this.baseobj , "-skip" )
  if ( skip > 0 ) then
    // Skip (i.e. ignore) as many elements as required.
    // This is as fast as it can be (based only on macros).
    // Vectorized call to lowdisc_bitxor : this is the best that we can do.
    [ this.count , this.lastq ] = lowdisc_sobolskip ( skip , this.lastq , dimension , this.count , this.v )
    this.baseobj = ldbase_indexset ( this.baseobj , skip )
  end
endfunction


