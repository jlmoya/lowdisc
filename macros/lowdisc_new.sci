// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = lowdisc_new ( varargin )
  // Create a new object.
  //
  // Calling Sequence
  //   this = lowdisc_new ( method )
  //
  // Parameters
  //   this: the current object
  //   method: a string, the low discrepancy sequence (default = "halton")
  //
  // Description
  //   This function requires to take the current object both as an input
  //   and an output argument.
  //
  //  The following is the list of possible values for "-method".
  //  <itemizedlist>
  //  <listitem>"vandercorput" : the Van Der Corput low 
  //    discrepancy sequence. 
  //    It is available only in 1 dimension (i.e. the -dimension option must be
  //    set to 1, the default). It uses the basis which is associated with
  //    the "-vandercorputbasis" option.
  //    This sequence is able to generate at most 2^52  = 4 503 599 627 370 496 experiments.
  //    This is a macro-based algorithm.</listitem>
  //  <listitem>"halton" : the Halton low discrepancy sequence.
  //    This sequence is sensitive to the "-primeslist" option.
  //    By default, it is able to generate experiments in dimension at most 100.
  //    This sequence is able to generate at most 2^52  = 4 503 599 627 370 496 experiments.
  //    To extend the number of dimensions, please configure the "-primeslist" option.
  //    The maximum dimension which can be obtained is equal to the number of 
  //    different primes in the prime table. 
  //    This is a macro-based algorithm.</listitem>
  //  <listitem>"faure" : the Faure low discrepancy sequence. 
  //    This sequence is sensitive to the "-primeslist" option.
  //    By default, it is able to generate experiments in dimension at most 541.
  //    This sequence is able to generate at most 2^52  = 4 503 599 627 370 496 experiments.
  //    To extend the number of dimensions, please configure the "-primeslist" option.
  //    The maximum dimension which can be obtained is equal to the maximum 
  //    prime number in the prime table. 
  //    This is a macro-based algorithm.</listitem>
  //  <listitem>"reversehalton" : the Reverse Halton sequence of Vandewoestyne and Cools.
  //    This sequence is sensitive to the "-primeslist" option.
  //    By default, it is able to generate experiments in dimension at most 100.
  //    This sequence is able to generate at most 2^52  = 4 503 599 627 370 496 experiments.
  //    To extend the number of dimensions, please configure the "-primeslist" option.
  //    The maximum dimension which can be obtained is equal to the number of 
  //    different primes in the prime table. 
  //    This is a macro-based algorithm. </listitem>
  //  <listitem>"sobol" : the Sobol sequence. 
  //    It is able to generate experiments in dimension at most 40.
  //    This sequence is able to generate at most 2^30-1  = 1 073 741 823 experiments.
  //    There is no way to extend the number of dimensions or the number of 
  //    experiments.
  //    This is a macro-based algorithm. 
  //    The current implementation is a Scilab port of the source code in Matlab 
  //    by John Burkardt. The original source code was created by Bennett Fox in Fortran.
  //    </listitem>
  //  <listitem>"niederreiter-base-2" : The Niederreiter Base 2 sequence. 
  //    This is a macro-based algorithm. 
  //    It is able to generate experiments in dimension at most 20.
  //    This sequence is able to generate at most 2^32 - 1  = 4 294 967 295 experiments.
  //    There is no way to extend the number of dimensions or the number of 
  //    experiments.
  //    The implementation is a Scilab port of the Matlab source code by John Burkardt.
  //    Original Fortran 77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
  //    </listitem>
  //  <listitem>"reversehaltonf" : the Reverse Halton sequence of Vandewoestyne and Cools.
  //    This sequence is sensitive to the "-primeslist" option.
  //    By default, it is able to generate experiments in dimension at most 100.
  //    This sequence is able to generate at most 2^32 - 1  = 4 294 967 295 experiments.
  //    To extend the number of dimensions, please configure the "-primeslist" option.
  //    The maximum dimension which can be obtained is equal to the number of 
  //    different primes in the prime table. 
  //    This fast algorithm is based on a compiled C source code. </listitem>
  //  <listitem>"niederreiter-base-2f" : The Niederreiter Base 2 sequence. 
  //    This fast algorithm is based on a compiled C source code. </listitem>
  //  <listitem>"sobolf" : the Sobol sequence. 
  //    It is able to generate experiments in dimension at most 1111.
  //    This sequence is able to generate at most 2^30-1  = 1 073 741 823 experiments.
  //    There is no way to extend the number of dimensions or the number of 
  //    experiments.
  //    This fast algorithm is based on a compiled C source code. 
  //    The implementation is a modification of the C source code by John Burkardt.
  //    Original Fortran 77 version by Bennett Fox.
  //    </listitem>
  //  <listitem>"fauref" : the Faure sequence.
  //    This sequence is sensitive to the "-primeslist" option.
  //    By default, it is able to generate experiments in dimension at most 541.
  //    This sequence is able to generate at most 2^32 - 1  = 4 294 967 295 experiments.
  //    To extend the number of dimensions, please configure the "-primeslist" option.
  //    The maximum dimension which can be obtained is equal to the maximum 
  //    prime number in the prime table. 
  //    This fast algorithm is based on a compiled C source code. </listitem>
  //  <listitem>"haltonf" : the Halton sequence. 
  //    This sequence is sensitive to the "-primeslist" option.
  //    By default, it is able to generate experiments in dimension at most 100.
  //    This sequence is able to generate at most 2^32 - 1  = 4 294 967 295 experiments.
  //    To extend the number of dimensions, please configure the "-primeslist" option.
  //    The maximum dimension which can be obtained is equal to the number of 
  //    different primes in the prime table. 
  //    This fast algorithm is based on a compiled C source code. </listitem>
  //  </itemizedlist>
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","faure");
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

  [lhs,rhs]=argn();
  if ( rhs > 1 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "lowdisc_new", rhs);
    error(errmsg)
  end
  
  if ( rhs < 1 ) then
    method = "halton"
  else
    method = varargin(1)
  end

  this = tlist([
    "LOWDISC"
    "method"
    "sequence"
    ])
  assert_typestring ( method )
  this.method = method
  select this.method
  case "halton" then
    this.sequence     = ldhalton_new ()
  case "faure" then
    this.sequence     = ldfaure_new ()
  case "reversehalton" then
    this.sequence     = ldrevhal_new ()
  case "sobol" then
    this.sequence     = ldsobol_new ()
  case "niederreiter-base-2" then
    this.sequence     = ldnied2_new ()
  case "reversehaltonf" then
    this.sequence     = ldrevhalf_new ()
  case "niederreiter-base-2f" then
    this.sequence     = ldnied2f_new ()
  case "sobolf" then
    this.sequence     = ldsobolf_new ()
  case "fauref" then
    this.sequence     = ldfauref_new ()
  case "haltonf" then
    this.sequence     = ldhaltonf_new ()
  else
    errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_new" , this.method);
    error(errmsg);
  end
endfunction

// Generates an error if the given variable is not of type string
function assert_typestring ( var )
  if ( type ( var ) <> 10 ) then
    errmsg = msprintf(gettext("%s: Expected string variable but got %s instead"),"assert_typestring", typeof(var) );
    error(errmsg);
  end
endfunction

