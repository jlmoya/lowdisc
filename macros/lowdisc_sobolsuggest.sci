// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 1988 - Bennett Fox
//
// This file must be used under the terms of the GNU LGPL license.

function [nsim,skip,leap] = lowdisc_sobolsuggest ( varargin )
    // Returns favorable parameters for Sobol sequences.
    //
    //
    // Calling Sequence
    //   [nsim,skip,leap] = lowdisc_sobolsuggest ( dim )
    //   [nsim,skip,leap] = lowdisc_sobolsuggest ( dim , nsimmin )
    //   [nsim,skip,leap] = lowdisc_sobolsuggest ( dim , nsimmin , purpose )
    //
    // Parameters
    //    dim : a floating point integer, the spatial dimension.  
    //    nsimmin : a floating point integer, the minimum required number of simulations. Default nsimmin = 1.
    //    purpose : a floating point integer, the purpose of the simulation. If purpose = 1, then the target is integration. If purpose = 2; then the target is global optimization. Default purpose = 1.
    //    nsim : a floating point integer, the number of simulations to perform, with nsim >= nsimmin.
    //    skip : a floating point integer, the number of initial elements to skip in the sequence.
    //    leap : a floating point integer, the number of elements to ignore each time an element is generated.
    //
    // Description
    //    This routine provides favorable parameters to be used with a Sobol sequence.
    //
    //    We use settings suggested in :
    //    "Algorithm 647: Implementation and Relative Efficiency of Quasirandom
    //    Sequence Generators", B. L. Fox, ACM Transactions on Mathematical Software, 
    //    Volume 12, Number 4, pages 362-376, 1986.
    //
    //    We compute tau from the lowdisc_soboltau function.
    //    For spatial dimensions 1 through 13, tau is non-trivial. For other dimensions, tau=0
    //    and a warning is generated.
    //    For integration problems, we take 
    //
    //    <literal>k = max ( ceil(log2(nsimmin)) , 2*dim , tau + dim - 1 )</literal>
    //
    //    For optimization problems, we take 
    //
    //    <literal>k = max ( ceil(log2(nsimmin)) , tau + 1 ).</literal>
    //
    //    We consider nsim = 2**k.
    //
    //    When the number of dimensions is greater than 6, the number 
    //    of suggested simulations is huge. For example, in dimension 10,
    //    the recommended number of simulations is ~10^9.
    //    In this case, the user might want to use nsim = 2^ceil(log2(nsimmin))
    //    instead.
    //
    //    We return skip = 0 and leap = 0.
    //
    //    We might also be interested by the experiments in :
    //    "Computational investigations of low-discrepancy sequences", Kocis,
    //    L. and Whiten, W. J. 1997. ACM Trans. Math. Softw. 23, 2 (Jun. 1997),
    //    266-294. Especially p. 277.
    //    The citation p. 277 is the following.
    //    "Experimenting with the Sobol sequence resulted in finding that the 
    //    Sobol sequence leaped can be created with leaps satisfying condition leap=2^m
    //    where m is positive integer. The first coordinate of the Antonov-Saleev version
    //    of the Sobol sequence leaped generated this way has to be either omitted,
    //    or scaled as x1 -> x1*(L/2), and the second coordinate of the Sobol sequence 
    //    leaped is either omitted or scaled as x2 -> x2 * 2."
    //
    // Examples
    //
    // // See the minimum number of simulations 
    // // for integration in dimension 4.
    // [nsim,skip,leap] = lowdisc_sobolsuggest ( 4 )
    // // See the number of simulations larger than 1000 
    // // for integration in dimension 4
    // [nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , 1000 )
    // // See the number of simulations larger than 100 
    // // for global optimization in dimension 4
    // [nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , 100 , 2 )
    // // In dimension 14, the value of tau is not available
    // [nsim,skip,leap] = lowdisc_sobolsuggest ( 14 , [] , 1 )
    // // Caution : with global optimization purpose and 
    // // default minimum number of simulations, 
    // // this generates a very small number of simulations
    // [nsim,skip,leap] = lowdisc_sobolsuggest ( 14 , [] , 2 )
    //
    // // See the recommended number of simulations in dimension 4
    //  mprintf("%20s %20s\n","N Min","N Recommended");
    //  for nsimmin = logspace(1,10,10)
    //    [nsim,skip,leap] = lowdisc_sobolsuggest ( 4 , nsimmin );
    //    mprintf("%20.0f %20.0f\n",nsimmin,nsim);
    //  end
    //
    // // Use the minimum recommended number of simulations 
    // // for integration in dimension 4.
    // // Use Sobol
    // dim = 4;
    // [nsim,skip,leap] = lowdisc_sobolsuggest ( dim );
    // lds = lowdisc_new("sobol");
    // lds = lowdisc_configure(lds,"-dimension",dim);
    // lds = lowdisc_configure(lds,"-skip",skip);
    // lds = lowdisc_configure(lds,"-leap",leap);
    // [lds,experiments]=lowdisc_next(lds,nsim);
    // lds = lowdisc_destroy(lds);
    // disp(computed)
    //
    // // Display recommended number of simulations 
    // // for integration in various dimensions.
    // // It grows extremely fast.
    // mprintf("%-10s %-10s %-10s %-10s\n", ..
    //   "dim", "nsim", "skip", "leap");
    // for dim = 1:13 
    //   [nsim,skip,leap] = lowdisc_sobolsuggest ( dim , [] , 1 );
    //   mprintf("%-10s %-10s %-10s %-10s\n", ..
    //     string(dim), string(nsim), string(skip), string(leap));
    // end
    //
    //  Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - DIGITEO - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    // Copyright (C) 1988 - Bennett Fox
    //

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
        // tau = lowdisc_soboltau ( dim )
        // skip = 2^(tau + dim - 1);
        // lds = lowdisc_configure(lds,"-skip", skip);
        // [lds,computed]=lowdisc_next(lds,10);
        // lds = lowdisc_destroy(lds);
        //
        //  Authors
        //   John Burkardt - 2009 - MATLAB version
        //   Bennett Fox - 1988 - Original FORTRAN77 version
        //   Michael Baudin - 2010 - DIGITEO
        //

        [lhs, rhs] = argn()
        apifun_checkrhs ( "lowdisc_soboltau" , rhs , 1:1 )
        apifun_checklhs ( "lowdisc_soboltau" , lhs , 1 )
        //
        apifun_checktype ( "lowdisc_soboltau" , dim , "dim" , 1 , "constant" )
        apifun_checkscalar ( "lowdisc_soboltau" , dim , "dim" , 1 )
        apifun_checkflint ( "lowdisc_soboltau" , dim , "dim" , 1 )
        apifun_checkgreq ( "lowdisc_soboltau" , dim , "dim" , 1 , 1 )
        //
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


    // check the number of input arguments
    [lhs,rhs]=argn();
    if ( rhs<1 | rhs>3 ) then
        error(msprintf(gettext("%s: Wrong number of input argument(s): %d to %d expected.\n"),"lowdisc_sobolsuggest",1,3))
    end
    // Get arguments
    dim = varargin(1)
    nsimmin = 1
    if ( rhs >= 2 ) then
        if ( varargin(2) <> [] ) then
            nsimmin = varargin(2)
        end
    end
    purpose = 1
    if ( rhs >= 3 ) then
        if ( varargin(3) <> [] ) then
            purpose = varargin(3)
        end
    end
    // Check dim
    if ( dim < 1 ) then
        errmsg = msprintf(gettext("%s: The dim argument should be greater than 1, but is equal to %d."), "lowdisc_sobolsuggest", dim);
        error(errmsg)
    end
    // Check nsimmin
    if ( nsimmin < 1 ) then
        errmsg = msprintf(gettext("%s: The nsimmin argument should be greater than 1, but is equal to %d."), "lowdisc_sobolsuggest", nsimmin);
        error(errmsg)
    end
    // Check purpose
    if ( and(purpose<>[1 2] ) ) then
        errmsg = msprintf(gettext("%s: The purpose argument should be equal to 1 or 2, but is equal to %d."), "lowdisc_sobolsuggest", purpose);
        error(errmsg)
    end
    // Compute nsim
    tau = lowdisc_soboltau ( dim )
    lnsim = ceil(log2(nsimmin))
    if ( purpose == 1 ) then
        k = max([lnsim,2*dim,tau+dim-1])
    else
        k = max([lnsim,tau+1])
    end
    nsim = 2^k
    // Compute skip and leap
    skip = 0
    leap = 0
endfunction

