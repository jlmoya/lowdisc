// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function [ evalf , u ] = lowdisc_ldgen ( varargin )
  // Returns uniform numbers from a low discrepancy sequence.
  //
  // Calling Sequence
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n )
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq )
  //   [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq , strict )
  //
  // Parameters
  //   callf : a 1-by-1 matrix of floating point integers, the number of calls to the function.
  //   n: a 1-by-1 matrix of floating point integers, the spatial dimension.
  //   ldseq : a 1-by-1 matrix of strings, the name of the sequence. (default <literal>ldseq = "sobolf"</literal>). The method can be equal to : <literal>"halton"</literal>, <literal>"haltonf"</literal>, <literal>"faure"</literal>, <literal>"fauref"</literal>, <literal>"reversehalton"</literal>, <literal>"reversehaltonf"</literal>, <literal>"sobol"</literal>, <literal>"sobolf"</literal>, <literal>"niederreiter-base-2"</literal>, <literal>"niederreiterf"</literal>. See below for details.
  //   strict : a 1-by-1 matrix of boolean, set to %t to make so that <literal>evalf==callf</literal>. (default = %f)
  //   evalf : a 1-by-1 matrix of floating point integers, the actual number of function evaluations. We have <literal>evalf >= callf</literal>.
  //   u : a evalf-by-n matrix of doubles, the uniform random numbers in <literal>[0,1]^n</literal>.
  //
  // Description
  // In dimension n, generate more than <literal>callf</literal> experiments with
  // low discrepancy sequence <literal>ldseq</literal>.
  //
  // Returns the number of suggested function evaluations <literal>evalf</literal>
  // and the uniform numbers u in <literal>[0,1]^n</literal>.
  //
  // If <literal>strict</literal> is false, then the optimum number of simulations <literal>evalf</literal> is
  // used. 
  // If strict is true, the number of simulations is equal to
  // the required one, that is, we have <literal>evalf == callf</literal>. 
  // In general, using <literal>strict=%f</literal> (i.e. the default) 
  // may produce a set of points with a lower discrepancy, that is, 
  // with greater quality. 
  // On the other hand, the value of <literal>evalf</literal> may be much larger 
  // than the value of <literal>callf</literal>, so that, in practice, 
  // it may be necessary to use <literal>strict=%t</literal>.
  //
  // The sequences which are available are described in depth in the <literal>lowdisc_new</literal> function.
  //
  // Examples
  // // Generate more than 20 points from a 
  // // fast Sobol sequence in dimension 4
  // [ evalf , u ] = lowdisc_ldgen ( 20 , 4 )
  //
  // // Generate more than 20 points from a 
  // // fast Halton sequence in dimension 4
  // callf = 20;
  // n = 4;
  // ldseq = "haltonf";
  // [ evalf , u ] = lowdisc_ldgen ( callf , n , ldseq )
  //
  // // Generate the suggested number of points 
  // // from the fast Faure sequence.
  // [ evalf , u ] = lowdisc_ldgen ( 20 , 4 , "fauref" )
  // // Generate exactly 20 points (this is not 
  // // recommended, it may increase the discrepancy).
  // [ evalf , u ] = lowdisc_ldgen ( 20 , 4 , "fauref" , %t )
  //
  // Authors
  //   Michael Baudin - 2010 - 2011 - DIGITEO
  
  [lhs, rhs] = argn()
  apifun_checkrhs ( "lowdisc_ldgen" , rhs , 2:4 )
  apifun_checklhs ( "lowdisc_ldgen" , lhs , 1:2 )
  //
  callf = varargin(1)
  n = varargin(2)
  ldseq = apifun_argindefault ( varargin , 3 , "sobolf" )
  strict = apifun_argindefault ( varargin , 4 , %f )
  //
  // Check type
  apifun_checktype ( "lowdisc_ldgen" , callf , "callf" , 1 , "constant" )
  apifun_checktype ( "lowdisc_ldgen" , n , "n" , 2, "constant" )
  apifun_checktype ( "lowdisc_ldgen" , ldseq , "ldseq" , 3, "string" )
  apifun_checktype ( "lowdisc_ldgen" , strict , "strict" , 4, "boolean" )
  //
  // Check size
  apifun_checkscalar ( "lowdisc_ldgen" , callf , "callf" , 1 )
  apifun_checkscalar ( "lowdisc_ldgen" , n , "n" , 2 )
  apifun_checkscalar ( "lowdisc_ldgen" , ldseq , "ldseq" , 3 )
  apifun_checkscalar ( "lowdisc_ldgen" , strict , "strict" , 4 )
  //
  // Check content
  apifun_checkflint ( "lowdisc_ldgen" , callf , "callf" , 1 )
  apifun_checkflint ( "lowdisc_ldgen" , n , "n" , 2 )
  availablemethods = [
   "halton" 
   "haltonf" 
   "faure" 
   "fauref" 
   "reversehalton"
   "reversehaltonf" 
   "sobol"
   "sobolf"
   "niederreiter-base-2" 
   "niederreiterf" 
   ];
  apifun_checkoption ( "lowdisc_ldgen" , ldseq , "ldseq" , 3 , availablemethods )
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
  lds = lowdisc_configure(lds,"-skip",skip);
  lds = lowdisc_configure(lds,"-leap",leap);
  lds = lowdisc_startup (lds);
  [lds,u]=lowdisc_next(lds,evalf);
  lds = lowdisc_destroy(lds);
endfunction
