// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 1988 - Bennett Fox
//
// This file must be used under the terms of the GNU LGPL license.

function lowdisc_proj2d ( nsim , n , u , dimensions )
  // Plots 2 dimensional projections.
  //
  // Calling Sequence
  //   lowdisc_proj2d ( nsim , n , u , dimensions )
  //
  // Parameters
  //    nsim : a floating point integer, the number of experiments.
  //    n : a floating point integer, the spatial dimension.  
  //    u : a nsim x n matrix of doubles, the numbers in the interval [0,1]^n
  //    dimensions : a p x 1 matrix of floating point integers, dimensions to plot.
  //
  // Description
  // Plots the 2 dimensionnal projections of u,
  // with size nsim x n, where nsim is the number of 
  // simulations and n is the dimension of the space.
  //
  // Examples
  // callf = 1.e2;
  // n = 6;
  // ldseq = "haltonf";
  // strict = %t;
  // [ evalf , u ] = intprb_ldgen ( callf , n , ldseq , strict );
  // plot2Dproj ( u , 1 : n )
  //
  // Authors
  //   Michael Baudin - 2010 - DIGITEO

  n = size(u,"c")
  useddim = size(dimensions,"*")
  
  p = 0  
  for i = 1 : useddim
    for j = 1 : useddim
      if ( j > i ) then
        p = p + 1
        iu = dimensions(i)
        ju = dimensions(j)
        subplot ( useddim - 1 , useddim - 1 , p )
        plot ( u(:,iu) , u(:,ju) , "+" )
        ttle = "Projection (x" + string(iu) + ",x" + string(ju) + ")"
        xlab = "x" + string(iu)
        ylab = "x" + string(ju)
        xtitle ( ttle )
      end
    end
    p = p + i
  end
endfunction

