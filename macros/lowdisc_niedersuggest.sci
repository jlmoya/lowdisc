// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function [nsim,skip,leap] = lowdisc_niedersuggest ( varargin )
  // Returns favorable parameters for Niederreiter sequence.
  //
  //
  // Calling Sequence
  //   [nsim,skip,leap] = lowdisc_niedersuggest ( dim )
  //   [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base )
  //   [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , nsimmin )
  //
  // Parameters
  //    dim : a floating point integer, the spatial dimension.
  //    base : a floating point integer, the optimal base to be used in Niederreiter's sequence. Default base = 2.
  //    nsimmin : a floating point integer, the minimum required number of simulations. Default nsimmin = 1.
  //    nsim : a floating point integer, the number of simulations to perform, with nsim >= nsimmin.
  //    skip : a floating point integer, the number of initial elements to skip in the sequence.
  //    leap : a floating point integer, the number of elements to ignore each time an element is generated.
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
  //    The citation p. 203, section "The Leading Zeros Phenomenon", is the following.
  //    "This leading zeros phenomenon can be alleviated by throwing away
  //    a certain number of initial terms of the sequence q1, q2, ... Clearly, the
  //    number thus skipped should be some power of b. The argument in the previous 
  //    paragraph indicates that this power should be at least the maximum value of e,
  //    which grows like log(s) as noted earlier."
  //
  //    The reference cited is :
  //
  //    "Low-discrepancy and low-dispersion sequences", 
  //    Harald Niederreiter, Journal of Number Theory, 
  //    Volume 30, Issue 1, September 1988, Pages 51-70 
  //
  //    We use the table of powers [0 12,8,8,6,6,6,4,4,4,4,4,4] from Algorithm 738.
  //    If the base is smaller than 13, we set pb = power_table(base). If not, we set pb = 4.
  //    We compute k = max ( [ pb , ceil(log(nsimmin)/log(base)) ] ) so that the 
  //    number of simulations is greater than nsimmin.
  //    We compute nsim = b^k.
  //    If the base is lower than 13, we compute skip = base ^ pb. If not, we compute skip = 10000.
  //    We return leap = 0.
  //
  // Examples
  //
  // // See the suggested number of simulations in dimension 4.
  // // See "Algorithm 659", p97, Table II
  // dim = 4;
  // // See with default base = 2.
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim );
  // // See with base = 5.
  // base = 5;
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 10000 );
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 50000 );
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base , 100000 );
  // // Set the number of simulations, but use default base
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim , [] , 100000 );
  //
  // // Use the fast Niederreiter in arbitrary base, 
  // // optimal base, minimum number of simulations in dimension 4.
  // dim = 4;
  // base = lowdisc_niederbase ( dim );
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim , base );
  // lds = lowdisc_new("niederreiterf");
  // lds = lowdisc_configure(lds,"-dimension",dim);
  // lds = lowdisc_configure(lds,"-base",base);
  // lds = lowdisc_configure(lds,"-skip",skip);
  // lds = lowdisc_configure(lds,"-leap",leap);
  // lds = lowdisc_startup (lds);
  // [lds,computed]=lowdisc_next(lds,nsim);
  // lds = lowdisc_destroy(lds);
  //
  // // Use the slow Base 2 Niederreiter and minimum number of simulations in dimension 4.
  // dim = 4;
  // [nsim,skip,leap] = lowdisc_niedersuggest ( dim );
  // lds = lowdisc_new("niederreiter-base-2");
  // lds = lowdisc_configure(lds,"-dimension",dim);
  // lds = lowdisc_configure(lds,"-skip",skip);
  // lds = lowdisc_configure(lds,"-leap",leap);
  // lds = lowdisc_startup (lds);
  // [lds,computed]=lowdisc_next(lds,nsim);
  // lds = lowdisc_destroy(lds);
  //
  //  Authors
  //   Michael Baudin - 2010 - DIGITEO
  //   Paul Bratley, Bennett Fox, Harald Niederreiter - 1994
  //

  // check the number of input arguments
  [lhs,rhs]=argn();
  if ( rhs<1 | rhs>3 ) then
    error(msprintf(gettext("%s: Wrong number of input argument(s): %d to %d expected.\n"),"lowdisc_niedersuggest",1,3))
  end
  // Get arguments
  dim = varargin(1)
  base = 2
  if ( rhs >= 2 ) then
    if ( varargin(2) <> [] ) then
      base = varargin(2)
    end
  end
  nsimmin = 1
  if ( rhs >= 3 ) then
    if ( varargin(3) <> [] ) then
      nsimmin = varargin(3)
    end
  end
  // Check dim
  if ( dim < 1 ) then
    errmsg = msprintf(gettext("%s: The dim argument should be greater than 1, but is equal to %d."), "lowdisc_niedersuggest", dim);
    error(errmsg)
  end
  // Check nsimmin
  if ( nsimmin < 1 ) then
    errmsg = msprintf(gettext("%s: The nsimmin argument should be greater than 1, but is equal to %d."), "lowdisc_niedersuggest", nsimmin);
    error(errmsg)
  end
  // Compute nsim
  // power_table(base) is the minimum power k for the base
  // Note:
  //   The original table is (POWER(I), I = 2,MAXBAS) / 12,8,8,6,6,6,4,4,4,4,4,4 / with MAXBAS = 13
  //   Thus, the original fortran array was starting at base = 2.
  //   In order to access directly to the power, we add the value 0 at index 1.
  //   This value will never been used, since base >= 2.
  maxbas = 13
  power_table = [0 12,8,8,6,6,6,4,4,4,4,4,4]
  if ( base <= maxbas ) then
    pb = power_table(base)
  else
    pb = 4
  end
  k = max ( [ pb , ceil(log(nsimmin)/log(base)) ] )
  nsim = base^k
  // Compute skip and leap
  if ( base <= maxbas ) then
    skip = base ^ pb
  else
    skip = 10000
  end
  leap = 0
endfunction

