// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

function lowdisc_plotbmbox(varargin)
    // Plot all elementary boxes with volume b^m
    // 
    // Calling Sequence
    // lowdisc_plotbmbox(b,m)
    // lowdisc_plotbmbox(b,m,u)
    //
    // Parameters
    // b : a 1-by-1 matrix of doubles, integer value, the basis
    // m : a 1-by-1 matrix of doubles, integer value, the m parameter in the (t,m,s)-net
    // u : a npoints-by-2 matrix of doubles, the point set to plot. Default is to plot no point set.
    // 
    // Description
    // Plot all the elementary intervals with volume b^m. 
    // Compute all decompositions d which sum to m. 
    // Then plot the elementary intervals in base b with 
    // directions d.
    //
    // If the point set u is provided, we plot it.
    //
    // Examples
    // // Plot all elementary intervals with volume 2^3
    // scf();
    // lowdisc_plotbmbox(2,3)
    //
    // // Plot elementary intervals with volume 2^3, 
    // // and add Faure points (insert zero).
    // [ u , evalf ] = lowdisc_ldgen ( 2^4-1 , 2 , "fauref" , %t );
    // u = [0,0;u];
    // scf();
    // lowdisc_plotbmbox(2,3,u);
    //
    // Bibliography
    // "Random number generation and quasi-Monte Carlo methods", H. Niederreiter, CBMS-NSF Series in Applied Mathematics, No. 63, SIAM, Philadelphia, 1992.
    //
    // Authors
    // Copyright (C) 2012 - Michael Baudin

    [lhs,rhs]=argn()
    apifun_checkrhs ( "lowdisc_plotbmbox" , rhs , 2:3 )
    apifun_checklhs ( "lowdisc_plotbmbox" , lhs , 0:1 )
    //
    b = varargin ( 1 )
    m = varargin ( 2 )
    u = apifun_argindefault ( varargin , 3 , [] )
    //
    // Check Type
    apifun_checktype ( "lowdisc_plotbmbox" , b , "b" , 1 , "constant" )
    apifun_checktype ( "lowdisc_plotbmbox" , m , "m" , 2 , "constant" )
    apifun_checktype ( "lowdisc_plotbmbox" , u , "u" , 3 , "constant" )
    //
    C = lowdisc_combinesum(m);
    pmax = size(C,"r");
    [mm,nn] = lowdisc_subplotdecompose(pmax)
    for p = 1 : pmax
        subplot(mm,nn,p)
        lowdisc_plotelembox(b,C(p,:),u);
    end
endfunction
