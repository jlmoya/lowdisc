// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2003 - John Burkardt
// Copyright (C) 1988 - Bennett Fox
//
// This file must be used under the terms of the GNU LGPL license.

function tau = lowdisc_soboltau ( dim )
  // Returns favorable starting seeds for Sobol sequences.
  //
  //
  // Calling Sequence
  //   tau = lowdisc_soboltau ( dim )
  //
  // Parameters
  //    dim : a floating point integer, the spatial dimension.  If dim is between 1 to 13, the result is non-trivial. If dim is larger than 13, then tau=0.
  //    tau : a floating point integer, the value of tau
  //
  // Description
  //    For spatial dimensions 1 through 13, this routine returns
  //    a "favorable" value tau by which an appropriate starting point
  //    in the Sobol sequence can be determined.
  //
  //    These starting points have the form N = 2**k, where
  //    for integration problems, it is desirable that
  //      k >= max(2dim,tau + dim - 1)
  //    while for optimization problems, it is desirable that
  //      k > tau.
  //    
  //    The 13 values available here are from Bennett Fox,
  //    "Algorithm 647: Implementation and Relative Efficiency of Quasirandom
  //    Sequence Generators", B. L. Fox, ACM Transactions on Mathematical Software, 
  //    Volume 12, Number 4, pages 362-376, 1986.
  //
  //    The citation p. 364 is the following.
  //    "Thus, Sobol' says (personal communication, 1985) that taking
  //    N equal to a power of 2 favors his method. [...]
  //    In the global optimization context, however, one needs only k > tau_s [Sobol',1982],
  //    and this extends the range of interest in favorable values perhaps to s  = 9."
  //
  //    We might also be interested by the experiments in :
  //    "Algorithm 659: Implementing Sobol's quasirandom sequence
  //    generator.", P. Bratley and B. L. Fox, 1988. ACM Trans. Math. Softw. 14, 1
  //    (Mar. 1988), 88-100."
  //    The citation p. 93 is the following.
  //    "As discussed in Sobol' [Sobol',1967,1976], a sequence of s-dimensionnal quasirandom 
  //    vectors theorically has additional uniformity properties whenever n=2^k, with k>=max(2s,taus+s-1), 
  //    where taus is defined in [Sobol',1967]."
  //
  // Examples
  //
  // // Returns 3
  // tau = lowdisc_soboltau ( 4 )
  // // Returns -1
  // tau = lowdisc_soboltau ( 14 )
  // // Generates an error
  // tau = lowdisc_soboltau ( 0 )
  //
  // dim = 4;
  // lds = lowdisc_new("sobol");
  // lds = lowdisc_configure(lds,"-dimension",dim);
  // tau = lowdisc_soboltau ( dim );
  // assert_equal ( tau , 3 );
  // skip = 2^(tau + dim - 1);
  // lds = lowdisc_configure(lds,"-skip", skip);
  // lds = lowdisc_startup (lds);
  // [lds,computed]=lowdisc_next(lds,10);
  // lds = lowdisc_destroy(lds);
  //
  //  Authors
  //   John Burkardt - 2009 - MATLAB version
  //   Bennett Fox - 1988 - Original FORTRAN77 version
  //   Michael Baudin - 2010 - DIGITEO
  //

  // Check dim
  if ( dim < 1 ) then
    errmsg = msprintf(gettext("%s: The dim argument should be greater than 1, but is equal to %d."), "lowdisc_soboltau", dim);
    error(errmsg)
  end

  dim_max = 13
  
  tau_table = [0,  0,  1,  3,  5, 8, 11, 15, 19, 23, 27, 31, 35 ]
  
  if ( 1 <= dim & dim <= dim_max ) then
    tau = tau_table(dim)
  else
    wrnmsg = msprintf(gettext("%s: The dim argument is equal to %d, while the maximum available dimension is %d."), "lowdisc_soboltau", dim , dim_max );
    warning(wrnmsg)
    tau = 0
  end
endfunction

