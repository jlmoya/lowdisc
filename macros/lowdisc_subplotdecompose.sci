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
