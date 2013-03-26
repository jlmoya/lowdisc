// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//


function lowdisc_plotelembox(varargin)
    // Plot elementary box
    // 
    // Calling Sequence
    // lowdisc_plotelembox(b,d)
    // lowdisc_plotelembox(b,d,u)
    //
    // Parameters
    // b : a matrix of doubles, integer value, the basis
    // d: a matrix of doubles, integer value, the log-b of number of divisions in direction 1 and 2
    // u : a npoints-by-2 matrix of doubles, the point set to plot. Default is to plot no point set.
    // 
    // Description
    // Plot the elementary interval with volume prod(b.^d). 
    // This interval has b(1)^d(1) divisions in direction 1 and 
    // b(2)^d(2) divisions in direction 2.
    //
    // The values of b and d are expanded as need. 
    // For example, b can be a 1-by-1 matrix and d can 
    // be a 2-by-1 matrix.
    // In this case, b is expanded to match the size of d.
    //
    // If the point set u is provided, we plot it.
    //
    // Examples
    // // Plot an elementary interval with volume 2^3
    // lowdisc_plotelembox(2,[2 1])
    //
    // // Use a different basis for each direction.
    // // This is useful for Halton sequence.
    // scf();
    // lowdisc_plotelembox([2 3],[2 1])
    //
    // // Plot all elementary intervals with volume b^m=2^3
    // b = 2;
    // m = 3;
    // C = [
    //    0.    3.  
    //    1.    2.  
    //    2.    1.  
    //    3.    0.  
    // ];
    // n = size(C,"r");
    // for i = 1 : n
    //     scf();
    //     lowdisc_plotelembox(b,C(i,:));
    // end
    //
    // Bibliography
    // "Random number generation and quasi-Monte Carlo methods", H. Niederreiter, CBMS-NSF Series in Applied Mathematics, No. 63, SIAM, Philadelphia, 1992.
    //
    // Authors
    // Copyright (C) 2012 - Michael Baudin

    [lhs,rhs]=argn()
    apifun_checkrhs ( "lowdisc_plotelembox" , rhs , 2:3 )
    apifun_checklhs ( "lowdisc_plotelembox" , lhs , 0:1 )
    //
    b = varargin ( 1 )
    d = varargin ( 2 )
    u = apifun_argindefault ( varargin , 3 , [] )
    //
    // Check Type
    apifun_checktype ( "lowdisc_plotelembox" , b , "b" , 1 , "constant" )
    apifun_checktype ( "lowdisc_plotelembox" , d , "d" , 2 , "constant" )
    apifun_checktype ( "lowdisc_plotelembox" , u , "u" , 3 , "constant" )
    //
    [ b , d ] = apifun_expandvar ( b , d )
    //
    if (u<>[]) then
        npoints = size(u,"r")
    else
        npoints = 0
    end
    //
    for j = 1:b(1)^d(1)-1
        plot([j j]/(b(1)^d(1)),[0 1],"r-")
    end
    for j = 1:b(2)^d(2)-1
        plot([0 1],[j j]/(b(2)^d(2)),"r-")
    end
    h = gca();
    h.data_bounds=[0,0;1,1];
    h.isoview="on";
    invvol = (b(1)^d(1))*(b(2)^d(2))
    strtitle= "Volume=1/"+string(invvol)+..
    ", b=("+strcat(string(b),",")+..
    "), d=("+strcat(string(d),",")+")";
    if (u<>[]) then
        plot(u(:,1),u(:,2),"bo")
    end
    if (npoints>0) then
        strtitle = strtitle  + ", "+string(npoints)+" points"
    end
    xtitle(strtitle,"X1","X2")
endfunction
