// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 1988 - Bennett Fox
//
// This file must be used under the terms of the GNU LGPL license.

function [nsim,skip,leap] = lowdisc_haltonsuggest ( varargin )
    // Returns favorable parameters for Halton sequence.
    //
    // Calling Sequence
    //   [nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin )
    //
    // Parameters
    //    dim : a floating point integer, the spatial dimension.  
    //    nsimmin : a floating point integer, the minimum required number of simulations. Default nsimmin = 1.
    //    nsim : a floating point integer, the number of simulations to perform, with nsim >= nsimmin.
    //    skip : a floating point integer, the number of initial elements to skip in the sequence.
    //    leap : a floating point integer, the number of elements to ignore each time an element is generated.
    //
    // Description
    //    This routine provides favorable parameters to be used with a Halton sequence.
    //    There are very few suggestions to use with this sequence.
    //
    //    We return nsim = nsimmin.
    //    We return skip = 0.
    // 
    //    For dimension less or equal to 999, the leap value is p-1, 
    //    where p is the (dim+1)-th prime number.
    //    If not we return leap = 0.
    //
    //    Note
    //
    //    In versions up to v0.4, we used settings suggested in :
    //    "Computational investigations of low-discrepancy sequences", Kocis,
    //    L. and Whiten, W. J. 1997. ACM Trans. Math. Softw. 23, 2 (Jun. 1997),
    //    266-294. Especially p. 274.
    //    This leaded to leap=409 for dimensions less than 400. 
    //    In this case, large hyper-rectangles were unfilled by the sequence, 
    //    so that the sequence was no uniform anymore.
    //    If dimension is smaller than 400, we return leap = 409. 
    //
    //    Other authors have suggested to consider the number of 
    //    simulations as a product of the bases.
    //    See "On the Optimal Halton Sequence", Chi, Mascagni and Warknock, Mathematics and 
    //    Computers in Simulation 70 (2005) 9?21.
    //    In low dimensions, we could use "nsim = prod ( prmat ( 1 : n ) )"
    //    where n is the number of dimensions and prmat is a matrix of primes, as 
    //    computed from "prmat = lowdisc_primes100 ( )".
    //    The problem is that this function grows extremely fast, and 
    //    becomes unusable for n greater than 10.
    //
    // Examples
    //
    // // See the suggestions in dimension 4.
    // dim = 8;
    // nsimmin = 1000;
    // [nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin )
    // // In dimension 500, we do not have any leap to suggest
    // dim = 500;
    // nsimmin = 1000;
    // [nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin )
    //
    // // Use the Halton sequence in dimension 4.
    // dim = 4;
    // nsimmin = 1000;
    // [nsim,skip,leap] = lowdisc_haltonsuggest ( dim , nsimmin );
    // lds = lowdisc_new("halton");
    // lds = lowdisc_configure(lds,"-dimension",dim);
    // lds = lowdisc_configure(lds,"-skip",skip);
    // lds = lowdisc_configure(lds,"-leap",leap);
    // [lds,computed]=lowdisc_next(lds,nsim);
    // lds = lowdisc_destroy(lds);
    // 
    // // See the number of simulations as the product of the 
    // // primes used in the Halton sequence.
    // // It is assumed that leap = 0, skip = 0.
    // prmat = number_primes100 ( );
    // for n = 1 : 15
    //   disp([n prod(1:n)])
    // end
    //
    //  Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - DIGITEO - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    // Copyright (C) 1988 - Bennett Fox
	//
	// Bibliography
	// qrandset, Leap property, http://www.mathworks.fr/fr/help/stats/qrandset.leap.html
    //

    // check the number of input arguments
    [lhs,rhs]=argn();
    if ( rhs<>2 ) then
        error(msprintf(gettext("%s: Wrong number of input argument(s): %d expected.\n"),"lowdisc_haltonsuggest",2))
    end
    // Get arguments
    dim = varargin(1)
    nsimmin = varargin(2)
    // Check dim
    if ( dim < 1 ) then
        errmsg = msprintf(gettext("%s: The dim argument should be greater than 1, but is equal to %d."), "lowdisc_haltonsuggest", dim);
        error(errmsg)
    end
    // Check nsimmin
    if ( nsimmin < 1 ) then
        errmsg = msprintf(gettext("%s: The nsimmin argument should be greater than 1, but is equal to %d."), "lowdisc_haltonsuggest", nsimmin);
        error(errmsg)
    end
    // Compute nsim
    nsim = nsimmin
    // Compute skip and leap
    skip = 0
    if ( dim <= 999 ) then
        m = number_primes1000 ( )
        leap = m(dim+1)-1
    else
        leap = 0
    end
endfunction

