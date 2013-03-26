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
    // // Plot all elementary intervals with volume 1/2^3
    // scf();
    // lowdisc_plotbmbox(2,3)
    //
    // // Plot elementary intervals with volume 1/2^3, 
    // // and add Sobol points (insert zero).
    // [ u , evalf ] = lowdisc_ldgen ( 2^4-1 , 2 );
    // u = [0,0;u];
    // scf();
    // lowdisc_plotbmbox(2,3,u);
    //
    // Bibliography
    // "Random number generation and quasi-Monte Carlo methods", H. Niederreiter, CBMS-NSF Series in Applied Mathematics, No. 63, SIAM, Philadelphia, 1992.
    //
    // Authors
    // Copyright (C) 2012 - Michael Baudin

    function [m,n] = lowdisc_subplotdecompose(varargin)
        // Compute the rows and columns of a matrix of subplots
        //
        // Calling Sequence
        // [m,n] = lowdisc_subplotdecompose(p)
        // [m,n] = lowdisc_subplotdecompose(p,f)
        //
        // Parameters
        // p : a 1-by-1 matrix of doubles, integer value, the number of plots 
        // f : a 1-by-1 matrix of doubles, greater than 1, the required ratio n/m (default f=4/3)
        // m : a 1-by-1 matrix of doubles, integer value, the number of rows in the subplot
        // n : a 1-by-1 matrix of doubles, integer value, the number of columns in the subplot
        // 
        // Description
        // Computes the number of rows and columns to plot 
        // p graphics in a m-by-n subplot.
        //
        // These values of m and n should make so that the screen 
        // is correctly occupied by the plots. 
        // On output, the ratio n/m is as close as possible to f. 
        //
        // The default value of f corresponds to 4/3 screens. 
        // For 16/9 screens, we may use f=16/9.
        //
        // Examples
        // [m,n] = lowdisc_subplotdecompose(7)
        //
        // // Print a table of decomposition
        // disp(["p" "m" "n" "m/n"])
        // T = [];
        // for p = 1:20
        //   [m,n] = lowdisc_subplotdecompose(p);
        //   T(p,:)=[p m n n/m];
        // end
        // disp(T)
        //
        // Authors
        // Copyright (C) 2012 - Michael Baudin

        [lhs,rhs]=argn()
        apifun_checkrhs ( "lowdisc_subplotdecompose" , rhs , 1:2 )
        apifun_checklhs ( "lowdisc_subplotdecompose" , lhs , 2:2 )
        //
        p = varargin(1)
        f = apifun_argindefault ( varargin , 2 , 4./3. )
        //
        // Check Type
        apifun_checktype ( "lowdisc_subplotdecompose" , p , "p" , 1 , "constant" )
        apifun_checktype ( "lowdisc_subplotdecompose" , f , "f" , 2 , "constant" )
        //
        // Check Size
        apifun_checkscalar ( "lowdisc_subplotdecompose" , p , "p" , 1 )
        apifun_checkscalar ( "lowdisc_subplotdecompose" , f , "f" , 2 )
        //
        // Check Content
        apifun_checkgreq ( "lowdisc_subplotdecompose" , p , "p" , 1 , 1. )
        apifun_checkflint ( "lowdisc_subplotdecompose" , p , "p" , 1 )
        apifun_checkgreq ( "lowdisc_subplotdecompose" , f , "f" , 2 , 1. )
        //
        m = round(sqrt(p/f))
        m = max(m,1)
        n = floor(p/m)
        if (m*n<p) then
            // Which of m or n should be increased ?
            // Choose the solution which ratio is closest to f.
            f1 = n/(m+1)
            f2 = (n+1)/m
            if (abs(f-f1)<abs(f-f2)) then
                // f1 is closer to the required ratio
                m = m+1
            else
                n = n+1
            end
        end
    endfunction

    function C = lowdisc_combinesum(m)
        // Search 2D combinations with given sum.
        //
        // Calling Sequence
        // C = lowdisc_combinesum(m)
        //
        // Parameters
        // m : a 1-by-1 matrix of doubles, the sum
        // C : a n-by-2 matrix of doubles, where n is the number of combinations
        //
        // Description
        // Search all combinations of (d(1),d(2)) 
        // which sum to m, with d(1),d(2) in {0,1,2,..,m}.
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
