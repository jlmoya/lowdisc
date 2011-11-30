// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





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
  //  The following keys are available: <literal>"-dimension"</literal>, <literal>"-index"</literal>, 
  // <literal>"-skip"</literal>, <literal>"-leap"</literal>, <literal>"-verbose"</literal>.
  //  <itemizedlist>
  //   <listitem><literal>"-dimension"</literal> : a positive floating point integer, 
  //     the dimension of the space, i.e.
  //     the size of the vector returned by the command lowdisc_next (default = 1).</listitem>
  //   <listitem><literal>"-index"</literal> : a positive floating point integer,
  //     the number of points which have already been generated in the sequence.
  //     When a sequence is created, then index is set to 0.
  //     Whenever the lowdisc_next function is called, the index
  //     is updated and incremented with 1. 
  //     If this option is set, the algorithm directly goes to the required 
  //     location in the sequence.
  //     </listitem>
  //   <listitem><literal>"-skip"</literal> : a positive floating point integer, 
  //     the number of terms to skip at startup. 
  //     When the sequence is started up with the lowdisc_startup method,
  //     then skip elements are ignored in the sequence, so that the 
  //     next point will be generated at index skip+1.
  //     For example, Fox recommends to skip the qs^4 - 2 first terms in the 
  //     Faure sequence, where qs is the prime number associated with the 
  //     sequence. This number can be retrieved with 
  //     qs = lowdisc_get ( lds , "-faureprime" ).</listitem>
  //   <listitem><literal>"-leap"</literal> : a positive floating point integer, 
  //     the number of elements to ignore from element to element (default = 0).
  //     Each time the lowdisc_next function is called, the immediate element
  //     is retrieved. Then, in order to prepare for the next call,
  //     there are leap elements which are generated and immediately
  //     discarded. This option allows to generate alternative 
  //     sequences based on the same basic generator.</listitem>
  //   <listitem><literal>"-verbose"</literal> : a boolean, the verbose mode (default : %f).</listitem>
  //  </itemizedlist>
  //
  // Some sequences can be configured in order to increase their maximum
  // dimension. These sequences accept the following "-primeslist" option.
  //  <itemizedlist>
  //   <listitem>"-primeslist" : a 1-by-n array of positive floating point integers, 
  //     where n is greater than 2, 
  //     a matrix of prime numbers used in several low discrepancy sequences.
  //     The default value is made of the 100 first prime numbers, from 2 to 541, which
  //     enables the user to generate sequences up to 100 dimensions.
  //     If a larger dimension problem is to manage, the -primeslist option enables users to
  //     customize the list to meet the required dimension.
  //     The user should be warned that the Halton sequence may produce poor convergence
  //     rate if the dimension is larger than 15.</listitem>
  //  </itemizedlist>
  //  The sequences which are sensitive to this option are : "halton", "haltonf", "faure", "fauref", 
  //  "reversehalton", "reversehaltonf".
  //
  //  For the "niederreiterf" sequence (Fast Niederreiter sequence in arbitrary base), 
  //  we can configure the base as following. 
  //  <itemizedlist>
  //  <listitem>"-base" : a floating point number, greater than 2.
  //  The base can be an odd or even integer.
  //  The default value is 2. 
  //  It may be the smallest prime larger than the dimension as in the 
  //  Faure sequence, although it does not guarantee that this 
  //  leads to a lower discrepancy.
  //  See the <literal>lowdisc_niedersuggest</literal> function for a suggestion of the optimal 
  //  base, depending on the dimension.
  //  </listitem>
  //  </itemizedlist>
  //
  //  Some expertise is required to configure the skip and leap options.
  //  The skip option can improve the Faure, Sobol and Niederreiter sequences.
  //  The leap option can improve the Halton sequence, although 
  //  Kocis and Whiten also tried to leap the Faure and Sobol sequences.
  //  This can lead to some trouble for non-experts.
  //  For that purpose, we designed the following functions.
  //  <itemizedlist>
  //  <listitem> lowdisc_haltonsuggest : provides settings for the Halton sequence,</listitem>
  //  <listitem> lowdisc_fauresuggest : provides settings for the Faure sequence,</listitem>
  //  <listitem> lowdisc_sobolsuggest : provides settings for the Sobol sequence,</listitem>
  //  <listitem> lowdisc_niedersuggest : provides settings for the Niederreiter sequence.</listitem>
  //  </itemizedlist>
  //  These functions have been designed to include suggestions by various authors to improve 
  //  the sequences.
  //  In the situation where we have no knowledge of the settings to use, these 
  //  functions may be used. Still, these have not been included as defaults, 
  //  which authorizes a more aware choice of the parameters.
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
  // Examples
  //   lds = lowdisc_new("faure");
  //   lds = lowdisc_configure(lds,"-dimension",3);
  //   method = lowdisc_cget(lds,"-method")
  //   nbdim = lowdisc_cget(lds,"-dimension")
  //   i = lowdisc_cget(lds,"-index")
  //   verbose = lowdisc_cget(lds,"-verbose")
  //   lds
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

    select this.method
    case "halton" then
      this.sequence     = ldhalton_configure ( this.sequence , key , value )
    case "faure" then
      this.sequence     = ldfaure_configure ( this.sequence , key , value )
    case "reversehalton" then
      this.sequence     = ldrevhal_configure ( this.sequence , key , value )
    case "sobol" then
      this.sequence     = ldsobol_configure ( this.sequence , key , value )
    case "niederreiter-base-2" then
      this.sequence     = ldnied2_configure ( this.sequence , key , value )
    case "reversehaltonf" then
      this.sequence     = ldrevhalf_configure ( this.sequence , key , value )
    case "niederreiterf" then
      this.sequence     = ldniedf_configure ( this.sequence , key , value )
    case "sobolf" then
      this.sequence     = ldsobolf_configure ( this.sequence , key , value )
    case "fauref" then
      this.sequence     = ldfauref_configure ( this.sequence , key , value )
    case "haltonf" then
      this.sequence     = ldhaltonf_configure ( this.sequence , key , value )
    else
      errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_configure" , this.method);
      error(errmsg);
    end
endfunction

