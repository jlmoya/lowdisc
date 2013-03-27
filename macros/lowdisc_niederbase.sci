// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function base = lowdisc_niederbase ( dim )
    // Returns optimal base for Niederreiter sequence.
    //
    //
    // Calling Sequence
    //   base = lowdisc_niederbase ( dim )
    //
    // Parameters
    //    dim : a floating point integer, the spatial dimension.
    //    base : a floating point integer, the optimal base to be used in Niederreiter's sequence.
    //
    // Description
    //    This routine provides favorable parameters to be used with a Niederreiter sequence.
    //    
    //    We use suggestions from :
    //
    //    "Algorithm 738: Programs to generate Niederreiter's low-discrepancy
    //    sequences", P. Bratley, B. L. Fox, and H. Niederreiter, 1994. ACM Trans.
    //    Math. Softw. 20, 4 (Dec. 1994), 494-495.
    //
    //    which is based on the paper :
    //
    //    "Implementation and Tests of Low Discrepancy Sequences",
    //    Paul Bratley, Bennett Fox, Harald Niederreiter,
    //    ACM Transactions on Modeling and Computer Simulation,
    //    Volume 2, Number 3, July 1992, pages 195-213.
    //    
    //    The citation p. 202, section "Optimal bases", is the following.
    //    "For each s, he chooses a base b = b(s) to minimize B(s,b) [...].
    //    His values of Cs are the smallest currently known. The corresponding 
    //    values of b(s) do not necessarily minimize the actual discrepancy for 
    //    practical values of N. This may explain why taking b = 2 in his sequences
    //    gave results ranging from roughly as accurate to far more accurate than 
    //    for b = b(s) for the values of N ans s used in our experiments, for the 
    //    integrals tried.[...] His table 1 [Niederreiter,1988] gives the value b(s)
    //    which minimizes B(s,b) for 2<= s<= 20."
    //    Later, p.204, we find an explanation for the limitation s <= 12 :
    //    "A more fundamental problem is that the factor Delta(N)/N in the Koksma-
    //    Hlawka error bound for quasi-Monte Carlo integration becomes huge for 
    //    s > 12, say, and practical values of N. [...] For these reasons,
    //    our current program restricts s to at most 12."
    //
    //    The reference cited is :
    //
    //    "Low-discrepancy and low-dispersion sequences", 
    //    Harald Niederreiter, Journal of Number Theory, 
    //    Volume 30, Issue 1, September 1988, Pages 51-70 
    //
    //    We return the optimal base for 1<= s<= 12 and we return base = 2 if not.
    //
    // Examples
    //
    // // See the optimal base for various dimensions.
    // base = lowdisc_niederbase ( 1 )
    // base = lowdisc_niederbase ( 2 )
    // base = lowdisc_niederbase ( 3 )
    // base = lowdisc_niederbase ( 12 )
    // // For dim >= 12, the base is set to 2.
    // base = lowdisc_niederbase ( 13 )
    //
    // // See the optimal base for various dimensions.
    // for dim = 1 : 15
    //   base = lowdisc_niederbase ( dim );
    //   mprintf("dim=%5d, base=%5d\n",dim,base)
    // end
    //
    // // Use the optimal base in dimension 4.
    // dim = 4;
    // base = lowdisc_niederbase ( dim );
    // lds = lowdisc_new("niederreiter");
    // lds = lowdisc_configure(lds,"-dimension",dim);
    // lds = lowdisc_configure(lds,"-base",base);
    // lds = lowdisc_startup (lds);
    // [lds,computed]=lowdisc_next(lds,10);
    // lds = lowdisc_destroy(lds);
    // disp(computed)
    //
    //  Authors
    // Copyright (C) 2010 - DIGITEO - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    //

    dimmax = 12
    // Compute base
    // base_table(dim) is the optimal base for dimension dim
    // Note : 
    //   The original table is (OPTBAS(I), I = 2,MAXDIM) / 2,3,3,5,7,7,9,9,11,11,13/ with MAXDIM=12
    //   Thus, the original fortran array was starting at dim = 2.
    //   Here we add dimension 1, which for which the optimal base is set to base 2.
    base_table = [2,2,3,3,5,7,7,9,9,11,11,13]
    if ( 1 <= dim & dim <= dimmax ) then
        base = base_table(dim)
    else
        base = 2
    end
endfunction

