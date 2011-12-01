// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - John Burkardt
// Copyright (C) 1986 - Bennett Fox

// This file must be used under the terms of the GNU LGPL license.


function [ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd )
  // Generates a new quasirandom Sobol vector.
  //
  // Calling Sequence
  //   [ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd )
  //
  // Parameters
  //   count : a 1 x 1 matrix of floating point integers. On input : the index of the element to compute. On output, the updated value of the index of the element.
  //   maxcol : a 1 x 1 matrix of floating point integers,number of bits in atmost
  //   dim_num : a 1 x 1 matrix of floating point integers, the current number of dimensions. We expect to have 1<= dim_num<= 40, since no more that 40 polynomials are stored in the database.
  //   lastq : a dim_num x 1 matrix of floating point integers, the numerators of the last vector generated
  //   v : a dimmax x logmax matrix of floating point integers, table of direction numbers. Each row corresponds to a primitive polynomial. The numbers in v are actually binary fractions.
  //   recipd : a 1 x 1 matrix of doubles, (1/denominator) for the numerators lastq
  //   quasi : a dim_num x 1 matrix of doubles, the next quasirandom vector.
  //
  //  Description
  //    The routine adapts the ideas of Antonov and Saleev, that is, 
  //    uses a Gray code for the update of the numerators lastq.
  //
  //    Thanks to Francis Dalaudier for pointing out that the range of allowed
  //    values of DIM_NUM should start at 1, not 2!  17 February 2009.
  //
  //  Examples
  // // See the source code
  // edit lowdisc_sobolnext
  // 
  //    // Generates elements of the Sobol sequence in dimension 4
  //    dim_num = 4
  //    [v,maxcol,lastq,count,recipd]=lowdisc_sobolstart(dim_num);
  //    // Element #0
  //    [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //    disp(quasi')
  //    // Element #1
  //    [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //    disp(quasi')
  //    // Element #2
  //    [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //    disp(quasi')
  //
  //    // Generate 15 elements of the Sobol sequence in dimension 4
  //    dim_num = 4
  //    [v,maxcol,lastq,count,recipd]=lowdisc_sobolstart(dim_num);
  //    for k = 1 : 15
  //      [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //      mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
  //    end
  //    
  //    // Generate 5 elements of the Sobol sequence in dimension 4,
  //    // skip 5 elements, then generate 5 elements
  //    dim_num = 4
  //    [v,maxcol,lastq,count,recipd]=lowdisc_sobolstart(dim_num);
  //    for k = 1 : 5
  //      [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //      mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
  //    end
  //    [count,lastq]=lowdisc_sobolskip(5,lastq,dim_num,count,v);
  //    for k = 1 : 5
  //      [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //      mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
  //    end
  //
  //    // Generate some elements and plot them
  //    dim_num = 2;
  //    [v,maxcol,lastq,count,recipd]=lowdisc_sobolstart(dim_num);
  //    for k = 1 : 2^7-1
  //      [quasi,lastq,count]=lowdisc_sobolnext(count,maxcol,dim_num,lastq,v,recipd);
  //      next(i+1,1:dim_num) = quasi';
  //    end
  //    scf();
  //    plot ( next(:,1) , next(:,2) , "bo" )
  //    xtitle("Sobol point set","X1","X2");
  //
  //  Authors
  //    1986 - Bennett Fox (Original FORTRAN 77 version)
  //    2009 - John Burkardt (MATLAB version)
  //    2009 - 2011 - Digiteo - Michael Baudin (Scilab version)
  //
  // Bibliography
  //    Antonov, Saleev, USSR Computational Mathematics and Mathematical Physics, Volume 19, 1980, pages 252 - 256.
  //    Paul Bratley, Bennett Fox, Algorithm 659: Implementing Sobol's Quasirandom Sequence Generator, ACM Transactions on Mathematical Software, Volume 14, Number 1, pages 88-100, 1988.
  //    Bennett Fox, Algorithm 647: Implementation and Relative Efficiency of Quasirandom Sequence Generators, ACM Transactions on Mathematical Software, Volume 12, Number 4, pages 362-376, 1986.
  //    Ilya Sobol, USSR Computational Mathematics and Mathematical Physics, Volume 16, pages 236-242, 1977.
  //    Ilya Sobol, Levitan, The Production of Points Uniformly Distributed in a Multidimensional Cube (in Russian), Preprint IPM Akad. Nauk SSSR, Number 40, Moscow 1976.
  //
  
  //
  //  Find the position of the right-hand zero in count
  //
  l = lowdisc_bitlo0 ( count )
  //
  //  Check that the user is not calling too many times!
  //
  if ( maxcol < l )
    error ( msprintf ( gettext ( "%s: Too many calls. maxcol=%d, l=%d") , "_next_sobol" , l , maxcol ))
  end
  //
  //  Calculate the new components of QUASI.
  //
  quasi(1 : dim_num) = lastq(1 : dim_num) * recipd
  lastq(1 : dim_num) = lowdisc_bitxor ( lastq(1 : dim_num), v(1 : dim_num,l) )
  count = count + 1
endfunction


