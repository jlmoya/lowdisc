// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function lowdisc_proj2d ( varargin )
    // Plots 2 dimensional projections.
    //
    // Calling Sequence
    //   lowdisc_proj2d ( u )
    //   lowdisc_proj2d ( u , dimensions )
    //
    // Parameters
    //    u : a nsim-by-n matrix of doubles, the numbers in the interval [0,1]^n, where nsim is the number of simulations and n is the dimension of the space.
    //    dimensions : a p-by-1 matrix of floating point integers, dimensions to plot (default=1:n).
    //
    // Description
    // Plots the required two dimensionnal projections of u.
    // 
    // This function allows to see all the 2 dimensionnal projections 
    // of a multivariate vector u.
    //
    // Examples
    // callf = 100;
    // n = 6;
    // [ u , evalf ] = lowdisc_ldgen ( callf , n );
    // // See all possible projections.
    // scf();
    // lowdisc_proj2d ( u )
    // // See all projections for dimensions 2,3,6.
    // scf();
    // lowdisc_proj2d ( u , [2,3,6] )
    // // See projection (3,6)
    // scf();
    // lowdisc_proj2d ( u , [3,6] )
    // // In this case, we could also use :
    // scf();
    // plot( u(:,3) , u(:,6) , "bo" )
    //
    // Authors
    // Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
    // Copyright (C) 2013 - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_proj2d" , rhs , 1:2 )
    apifun_checklhs ( "lowdisc_proj2d" , lhs , 1 )
    //
    u = varargin(1)
    n = size(u,"c")
    dimensions=apifun_argindefault ( varargin,2,1:n)
    //
    // Check type
    apifun_checktype ( "lowdisc_proj2d" , u , "u" , 1 , "constant" )
    apifun_checktype ( "lowdisc_proj2d" , dimensions , "dimensions" , 2 , "constant" )
    //
    // Check size
    apifun_checkvector ( "lowdisc_proj2d" , dimensions , "dimensions" , 2 )
    //
    // Check content
    apifun_checkgreq ( "lowdisc_proj2d" , dimensions , "dimensions" , 2 , 1 )
    apifun_checkloweq ( "lowdisc_proj2d" , dimensions , "dimensions" , 2 , n )
    apifun_checkflint ( "lowdisc_proj2d" , dimensions , "dimensions" , 2 )
    //
    nsim = size(u,"r")
    useddim = size(dimensions,"*")
    //
    p = 0  
    for i = 1 : useddim
        for j = 1 : useddim
            if ( j > i ) then
                p = p + 1
                iu = dimensions(i)
                ju = dimensions(j)
                subplot ( useddim - 1 , useddim - 1 , p )
                drawlater()
                plot ( u(:,iu) , u(:,ju) )
                ttle = "Projection (x" + string(iu) + ",x" + string(ju) + ")"
                xlab = "x" + string(iu)
                ylab = "x" + string(ju)
                xtitle ( ttle )
                h = gcf()
                h.children.children.children.mark_mode = "on"
                h.children.children.children.mark_size = 2
                h.children.children.children.line_mode = "off"
                drawnow()
            end
        end
        p = p + i
    end
endfunction

