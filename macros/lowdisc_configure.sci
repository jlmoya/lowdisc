// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = lowdisc_configure (this,key,value)
  // Configure a field of the object and returns the modified object.
  //
  // Calling Sequence
  //   this = lowdisc_configure (this,key,value)
  //
  // Parameters
  //   this: the current object
  //   key: a string. The name of the option to get. All options which can be set with lowdisc_configure can be get with lowdisc_cget.
  //   value: the value associated with the key. Its type depends on the value of the key.
  //
  // Description
  //   This command allows to configure the state of the current object.
  //   It requires to take the current object both as an input
  //   and output argument.
  //  The following keys are available.
  //  <itemizedlist>
  //   <listitem>"-verbose" : a boolean, the verbose mode (default : %f).</listitem>
  //   <listitem>"-dimension" : a positive floating point integer, 
  //     the dimension of the space, i.e.
  //     the size of the vector returned by the command lowdisc_next (default = 1).</listitem>
  //   <listitem>"-method" : a string, the low discrepancy sequence (default = "halton").</listitem>
  //   <listitem>"-vandercorputbasis" : a positive floating point integer, greater or equal to 2, 
  //     the basis used in the Van Der Corput sequence (default = 2).
  //     The value is expected to be . It should be a prime number, but that
  //     is not checked by the configure method.</listitem>
  //   <listitem>"-primeslist" : a row array of positive floating point integers, 
  //     at matrix of prime numbers used in the several low discrepancy sequences.
  //     The expected matrix must have a 1xn shape, with n an integer greater than 2.
  //     The default list is made of the 100 first prime numbers, from 2 to 541, which
  //     enables the user to generate sequences up to 100 dimensions.
  //     If a larger dimension problem is to process, that feature should enable users to
  //     customize the list to meet the required dimension.
  //     The user should be warned that the Halton sequence may produce poor convergence
  //     rate if the dimension is larger than 15.</listitem>
  //   <listitem>"-sequenceindex" : a positive floating point integer,
  //     the starting index of the low discrepancy sequences.
  //     When a sequence is created this setting is initialized to 0.
  //     Whenever the randonumber_next method is called, the sequence index
  //     is updated and incremented with 1. If this option is passed to the lowdisc_cget
  //     method, it allows to know the number of vectors which have allready
  //     been generated.
  //     If this option is set, it allows to modify the behaviour of the low discrepancy
  //     sequences, which take into account this index to produce the next element
  //     in the sequence.
  //     The -sequenceindex optin should therefore generally not be set, 
  //     except in specific situations
  //     where the user has particular requirements on the low discrepancy
  //     sequence to generate.</listitem>
  //   <listitem>"-skip" : a positive floating point integer, 
  //     the number of terms to skip at startup. 
  //     When the sequence is started up with the lowdisc_startup method,
  //     the algorithm generates skip elements, which are immediately
  //     discarded. This option allows to start the simulation at a later
  //     point in the sequence. 
  //     For example, Fox recommends to skip the qs^4 - 2 first terms in the 
  //     Faure sequence, where qs is the prime number associated with the 
  //     sequence. This number can be retrieved with 
  //     qs = lowdisc_get ( rng , "-faureprime" ).</listitem>
  //   <listitem>"-leap" : a positive floating point integer, 
  //     the number of elements to ignore from element to element (default = 0).
  //     Each time the lowdisc_next function is called, the immediate element
  //     is retrieved. Then, in order to prepare for the next call,
  //     there are leap elements which are generated and immediately
  //     discarded. This option allows to generate alternative 
  //     sequences based on the same basic generator.</listitem>
  //  </itemizedlist>
  //
  //   Because of the limitation of floating point integers, 
  //   the lowdisc_next function is able to generate at most 
  //   2^52  = 4 503 599 627 370 496 experiments.
  //   Fast sequences are based on the intermediate storage of the 
  //   iteration index on a 32 bits C int. This implies 
  //   that these sequences are able to generate at most 
  //   2^32-1 = 4 294 967 295 experiments. 
  //
  //   Some sequences are limited in the maximum number of dimensions, 
  //   because they use internally fixed tables of parameters (e.g. the Sobol 
  //   sequence).
  //   Some other sequences can be extended with the "-primeslist" option.
  //   The "-primeslist" option can be configure with a table of 
  //   primes computed with the lowdisc_primes100(), lowdisc_primes1000()
  //   or lowdisc_primes10000() functions. The maximum dimension 
  //   which can be attained with these tables depends on the sequence.
  //   See the specific settings of each sequence below for detail.
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
  //   rng = lowdisc_configure(rng,"-dimension",3);
  //   method = lowdisc_cget(rng,"-method")
  //   nbdim = lowdisc_cget(rng,"-dimension")
  //   i = lowdisc_cget(rng,"-sequenceindex")
  //   verbose = lowdisc_cget(rng,"-verbose")
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

  select key
  case "-verbose" then
    assert_typeboolean ( value );
    this.verbose = value
  case "-dimension" then
    assert_typereal ( value );
    this.dimension = value
  case "-method" then
    assert_typestring ( value )
    this.method = value
    select this.method
    case "vandercorput" then
      // Nothing to do.
    case "halton" then
      // Nothing to do.
    case "faure" then
      // Nothing to do.
    case "reversehalton" then
      // Nothing to do.
    case "sobol" then
      // Nothing to do.
    case "niederreiter-base-2" then
      // Nothing to do.
//
// Fast sequences based on primitives
//
    case "reversehaltonf" then
      // Nothing to do.
    case "niederreiter-base-2f" then
      // Nothing to do.
    case "sobolf" then
      // Nothing to do.
    case "fauref" then
      // Nothing to do.
    case "haltonf" then
      // Nothing to do.
    else
      errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , ...
        "lowdisc_configure" , this.method);
      error(errmsg);
    end
  case "-vandercorputbasis" then
    assert_typereal ( value );
    if (value<2) then
      errmsg = sprintf ( gettext ( "%s: The value %d is expected to be greater than 2" ) , ...
        "lowdisc_configure" , value)
      error(errmsg)
    end    
    this.vdcbasis = value;
  case "-primeslist" then
    assert_typereal ( value );
    psize = size(value);
    if (psize(1)<>1) then
      errmsg = sprintf ( gettext ( "%s: The first dimension of the primes list matrix is %d, which is different from 1" ) , ...
        "lowdisc_configure" , psize(1))
      error(errmsg)
    end    
    if (psize(2)<1) then
      errmsg = sprintf ( gettext ( "%s: The second dimension of the primes list matrix is %d, which is not positive" ) , ...
        "lowdisc_configure" , psize(2))
      error(errmsg)
    end        
    this.primeslist = value;
    this.primessize = psize(2);
  case "-sequenceindex" then
    // TODO : remove this option - the use should not be able to write this setting.
    assert_typereal ( value );
    assert_positive ( value ); 
    this.sequenceindex = value;
  case "-skip" then
    assert_typereal ( value );
    assert_positive ( value ); 
    this.skip = value;
  case "-leap" then
    assert_typereal ( value );
    assert_positive ( value ); 
    this.leap = value;
  else
    errmsg = sprintf ( gettext ( "%s: Unknown key %s" ) , ...
    "lowdisc_configure" , key)
    error(errmsg)
  end
endfunction
// Generates an error if the given variable is not of type real
function assert_typereal ( var )
  if ( type ( var ) <> 1 ) then
    errmsg = msprintf(gettext("%s: Expected real variable but got %s instead"),"assert_typereal", typeof(var) );
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
// Generates an error if the given variable is not of type function (macro)
function assert_typefunction ( var )
  if ( type ( var ) <> 13 ) then
    errmsg = msprintf(gettext("%s: Expected function but got %s instead"),"assert_typefunction", typeof(var) );
    error(errmsg);
  end
endfunction
// Generates an error if the given variable is not of type boolean
function assert_typeboolean ( var )
  if ( type ( var ) <> 4 ) then
    errmsg = msprintf(gettext("%s: Expected boolean but got %s instead"),"assert_typeboolean", typeof(var) );
    error(errmsg);
  end
endfunction
// Generates an error if the value corresponding to an option is unknown.
function unknownValueForOption ( value , optionname )
      errmsg = msprintf(gettext("%s: Unknown value %s for %s option"),"unknownValueForOption",value , optionname );
      error(errmsg);
endfunction
// Generates an error if the given variable is not positive
function assert_positive ( value )
  if ( and ( value < 0 ) ) then
    errmsg = msprintf(gettext("%s: Expected positive variable but got [%s] instead"),"assert_positive", strcat ( string(value) , " " ) );
    error(errmsg);
  end
endfunction

