// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

function C = lowdisc_combinesum(m)
    // Search 2D combinations with given sum.
    //
    // Calling Sequence
    // C = lowdisc_combinesum(m)
    //
    // Parameters
    // C : a n-by-2 matrix, where n is the number of combinations
    //
    // Description
    // Search all combinations of (d(1),d(2)) 
    // which sum to m=3, with d(1),d(2) in {0,1,2,..,m}.
    //
    // Examples
    // // Search combinations (d(1),d(2)) which sum to 3.
    // C = lowdisc_combinesum(3)
	//
	// Bibliography
	// Applications of Scrambled Low Discrepancy Sequences to Exotic Options, K.S. Tan, P.P. Boyle, International AFIR Colloquium Proceedings, Australia, 1997
	//
	// Authors
	// Copyright (C) 2012 - Michael Baudin
	
    [lhs,rhs]=argn()
    apifun_checkrhs ( "lowdisc_combinesum" , rhs , 1:1 )
    apifun_checklhs ( "lowdisc_combinesum" , lhs , 0:1 )
    //

    C = specfun_combinerepeat(0:m,2);
    C = C';
    k = find(sum(C,"c")==m);
    C = C(k,:);
endfunction
