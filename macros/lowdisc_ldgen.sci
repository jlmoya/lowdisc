// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function [ evalf , u ] = lowdisc_ldgen ( varargin )
  // Returns uniform numbers from a low discrepancy sequence.
  //
  // Calling Sequence
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n )
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq )
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict )
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict , verbose )
  //
  // Parameters
  //   callf : a 1 x 1 matrix of floating point integers, the number of calls to the function.
  //   n: a 1 x 1 matrix of floating point integers, the spatial dimension.
  //   ldseq : a 1 x 1 matrix of strings, the name of the sequence.
  //   strict : a 1 x 1 matrix of boolean, set to %t to make so that evalf==callf. (default = %f)
  //   verbose : a 1 x 1 matrix of boolean, set to %t to enable verbose messages. (default = %f)
  //   evalf : a 1 x 1 matrix of floating point integers, the actual number of function evaluations. We have evalf >= callf.
  //   u : a evalf x n matrix of doubles, the uniform random numbers in [0,1]^n.
  //
  // Description
  // In dimension n, generate more than callf experiments with
  // low discrepancy sequence ldseq.
  //
  // Returns the number of suggested function evaluations evalf
  // and the uniform numbers u in [0,1]^n.
  //
  // If strict is false, then the optimum number of simulations evalf is
  // used. If strict is true, the number of simulations is equal to 
  // the required one, that is, we have evalf == callf.
  //
  // Examples
  // // Generate more than 100 points from a fast Halton sequence in dimension 4
  // callf = 100
  // n = 4
  // ldseq = "haltonf"
  // [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq )
  //
  // // Generate the suggested number of points from the fast Faure sequence.
  // [ evalf , u ] = lowdisc_ldgen ( 100 , 4 , "fauref" )
  // // Generate exactly 100 points (this is not recommended, it may increase the discrepancy).
  // [ evalf , u ] = lowdisc_ldgen ( 100 , 4 , "fauref" , %t )
  //
  // Authors
  //   Michael Baudin - 2010 - DIGITEO
  
  [lhs, rhs] = argn();
  if ( rhs < 2 | rhs > 5 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from %d to %d are expected."), "lowdisc_ldgen", rhs,2,5);
    error(errmsg)
  end
  //
  callf = varargin(1)
  n = varargin(2)
  ldseq = "sobolf"
  if ( rhs >= 3 ) then
    if ( varargin(3) <> [] ) then
      ldseq = varargin(3)
    end
  end
  strict = %f
  if ( rhs >= 4 ) then
    if ( varargin(4) <> [] ) then
      strict = varargin(4)
    end
  end
  verbose = %f
  if ( rhs >= 5 ) then
    if ( varargin(5) <> [] ) then
      verbose = varargin(5)
    end
  end
  //
  assert_type ( callf , "callf" , 1 , "constant" )
  assert_type ( n , "n" , 2, "constant" )
  assert_type ( ldseq , "ldseq" , 3, "string" )
  assert_type ( strict , "strict" , 4, "boolean" )
  assert_type ( verbose , "verbose" , 5, "boolean" )
  //
  lds = lowdisc_new(ldseq);
  lds = lowdisc_configure(lds,"-dimension",n);
  select ldseq
  case "fauref"
    base = lowdisc_get(lds,"-faurefprime");
  case "faure"
    base = lowdisc_get(lds,"-faureprime");
  case "halton"
    // Nothing to do
  case "haltonf"
    // Nothing to do
  case "niederreiter-base-2"
    base = 2
  case "niederreiterf"
    base = lowdisc_niederbase ( n );
  case "reversehalton"
    // Nothing to do
  case "reversehaltonf"
    // Nothing to do
  case "sobol"
    // Nothing to do
  case "sobolf"
    // Nothing to do
  else
    lds = lowdisc_destroy(lds);
    msg = msprintf(gettext("%s: Cannot compute base: Unexpected sequence %s.") , "lowdisc_ldgen" ,ldseq);
    error ( msg )
  end
  if ( strict ) then
    evalf = callf
    skip = 0
    leap = 0
  else
    if ( or ( ldseq == [ "faure" "fauref" ] ) ) then
      [evalf,skip,leap] = lowdisc_fauresuggest ( n , base , callf )
    elseif ( or ( ldseq == [ "halton" "haltonf" ] ) ) then
      [evalf,skip,leap] = lowdisc_haltonsuggest ( n , callf )
    elseif ( or ( ldseq == [ "niederreiter-base-2" "niederreiterf" ] ) ) then
      [evalf,skip,leap] = lowdisc_niedersuggest ( n , base , callf )
    elseif ( or ( ldseq == [ "reversehalton" "reversehaltonf" ] ) ) then
      // No parameter
      evalf = callf
      skip = 0
      leap = 0
    elseif ( or ( ldseq == [ "sobol" "sobolf" ] ) ) then
      // Do not use lowdisc_sobolsuggest which suggests excessively 
      // large number of simulations.
      evalf = 2^ceil(log2(callf))
      skip = 0
      leap = 0
    else
      lds = lowdisc_destroy(lds);
      msg = msprintf(gettext("%s: Cannot compute [evalf,skip,leap] Unexpected sequence %s.") , "lowdisc_ldgen",ldseq);
      error ( msg )
    end
  end
  if ( verbose ) then
    mprintf(gettext("%s: Ldseq = %s.\n"), "lowdisc_ldgen" , string(ldseq) );
    mprintf(gettext("%s: Evalf = %s.\n"), "lowdisc_ldgen" , string(evalf) );
    mprintf(gettext("%s: Skip = %s.\n"), "lowdisc_ldgen" , string(skip) );
    mprintf(gettext("%s: Leap = %s.\n"), "lowdisc_ldgen" , string(leap) );
    mprintf(gettext("%s: Strict = %s.\n"), "lowdisc_ldgen" , string(strict) );
  end
  lds = lowdisc_configure(lds,"-skip",skip);
  lds = lowdisc_configure(lds,"-leap",leap);
  lds = lowdisc_startup (lds);
  [lds,u]=lowdisc_next(lds,evalf);
  lds = lowdisc_destroy(lds);
endfunction

// Generates an error if the given variable is not of expected type
function assert_type ( var , varname , ivar , expectedtype )
  if ( typeof ( var ) <> expectedtype ) then
    errmsg = msprintf(gettext("%s: Expected %s variable for variable %s at input #%d, but got %s instead."),"assert_typereal", expectedtype,varname , ivar , typeof(var) );
    error(errmsg);
  end
endfunction



