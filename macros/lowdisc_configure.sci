// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
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
  //
  //  The following keys are available: <literal>"-dimension"</literal>, <literal>"-index"</literal>, 
  // <literal>"-skip"</literal>, <literal>"-leap"</literal>, <literal>"-verbose"</literal>.
  //  <itemizedlist>
  //   <listitem>
  //     <para>
  //     <literal>"-dimension"</literal> : a positive floating point integer, 
  //     the dimension of the space, i.e.
  //     the size of the vector returned by the command lowdisc_next (default = 1).
  //     </para>
  //   </listitem>
  //   <listitem>
  //     <para>
  //     <literal>"-skip"</literal> : a positive floating point integer, 
  //     the number of terms to skip at startup. 
  //     When the sequence is started up with the lowdisc_startup method,
  //     then skip elements are ignored in the sequence, so that the 
  //     next point will be generated at index <literal>skip+1</literal>.
  //     For example, Fox recommends to skip the <literal>qs^4 - 2</literal> first terms in the 
  //     Faure sequence, where qs is the prime number associated with the 
  //     sequence. This number can be retrieved with 
  //     <literal>qs=lowdisc_get(lds,"-faureprime")</literal>.
  //     </para>
  //   </listitem>
  //   <listitem>
  //      <para>
  //      <literal>"-leap"</literal> : a positive floating point integer, 
  //      the number of elements to ignore from element to element (default = 0).
  //      Each time the lowdisc_next function is called, the immediate element
  //      is retrieved. Then, in order to prepare for the next call,
  //      there are leap elements which are generated and immediately
  //      discarded. This option allows to generate alternative 
  //      sequences based on the same basic generator.
  //      </para>
  //    </listitem>
  //    <listitem>
  //      <para>
  //      <literal>"-verbose"</literal> : a boolean, the verbose mode (default : %f).
  //      </para>
  //    </listitem>
  //  </itemizedlist>
  //
  // Some sequences can be configured in order to increase their maximum
  // dimension. These sequences accept the following "-primeslist" option.
  //  <itemizedlist>
  //    <listitem>
  //     <para>
  //     <literal>"-primeslist"</literal> : a 1-by-n array of positive floating point integers, 
  //     where n is greater than 2, 
  //     a matrix of prime numbers used in several low discrepancy sequences.
  //     The default value is made of the 100 first prime numbers, from 2 to 541, which
  //     enables the user to generate sequences up to 100 dimensions.
  //     If a larger dimension problem is to manage, the -primeslist option enables users to
  //     customize the list to meet the required dimension.
  //     The user should be warned that the Halton sequence may produce poor convergence
  //     rate if the dimension is larger than 15.
  //     </para>
  //    </listitem>
  //  </itemizedlist>
  //  The sequences which are sensitive to this option are : "halton", "faure", 
  //  "reversehalton".
  //
  //  For the "niederreiter" sequence (Fast Niederreiter sequence in arbitrary base), 
  //  we can configure the base as following. 
  //  <itemizedlist>
  //  <listitem>
  //     <para>
  //     <literal>"-base"</literal> : a floating point number, greater than 2.
  //     The base can be an odd or even integer.
  //     The default value is 2. 
  //     It may be the smallest prime larger than the dimension as in the 
  //     Faure sequence, although it does not guarantee that this 
  //     leads to a lower discrepancy.
  //     See the <literal>lowdisc_niedersuggest</literal> function for a suggestion of the optimal 
  //     base, depending on the dimension.
  //     </para>
  //  </listitem>
  //  </itemizedlist>
  //
  //  For the "halton" sequence, 
  //  we can configure the scrambling as following. 
  //  <itemizedlist>
  //  <listitem>
  //     <para>
  //     <literal>"-scrambling"</literal> : a 1-by-1 matrix of strings, the empty string "" (no scrambling), 
  //     or "RR2" for the scrambling (digit permutation) of Kocis-Whiten [1].
  //     The "RR2" scrambling can improve the correlation in high dimensions, 
  //     leading to better low-dimensionnal projects.
  //     </para>
  //  </listitem>
  //  </itemizedlist>
  //
  //  Some expertise is required to configure the <literal>skip</literal> and <literal>leap</literal> options.
  //  The <literal>skip</literal> option can improve the Faure, Sobol and Niederreiter sequences.
  //  The <literal>leap</literal> option can improve the Halton sequence, although 
  //  Kocis and Whiten also tried to leap the Faure and Sobol sequences.
  //  This can lead to some trouble for non-experts.
  //  For that purpose, we designed the following functions.
  //  <itemizedlist>
  //  <listitem><para> <literal>lowdisc_haltonsuggest</literal> : provides settings for the Halton sequence,</para></listitem>
  //  <listitem><para> <literal>lowdisc_fauresuggest</literal> : provides settings for the Faure sequence,</para></listitem>
  //  <listitem><para> <literal>lowdisc_sobolsuggest</literal> : provides settings for the Sobol sequence,</para></listitem>
  //  <listitem><para> <literal>lowdisc_niedersuggest</literal> : provides settings for the Niederreiter sequence.</para></listitem>
  //  </itemizedlist>
  //  These functions have been designed to include suggestions by various authors to improve 
  //  the sequences.
  //  In the situation where we have no knowledge of the settings to use, these 
  //  functions may be used. Still, these have not been included as defaults, 
  //  which authorizes a more aware choice of the parameters.
  //
  //  Some sequences are limited in the maximum number of dimensions, 
  //  because they use internally fixed tables of parameters (e.g. the Sobol 
  //  sequence).
  //  Some other sequences can be extended with the <literal>"-primeslist"</literal> option.
  //  The <literal>"-primeslist"</literal> option can be configure with a table of 
  //  primes computed with the <literal>number_primes100()</literal>, <literal>number_primes1000()</literal>
  //  or <literal>number_primes10000()</literal> functions. The maximum dimension 
  //  which can be attained with these tables depends on the sequence.
  //  See the specific settings of each sequence below for detail.
  //
  // Examples
  //   lds = lowdisc_new("faure");
  //   lds = lowdisc_configure(lds,"-dimension",3);
  //   method = lowdisc_cget(lds,"-method")
  //   nbdim = lowdisc_cget(lds,"-dimension")
  //   i = lowdisc_get(lds,"-index")
  //   verbose = lowdisc_cget(lds,"-verbose")
  //   lds
  //   lds = lowdisc_destroy(lds);
  //
  // // See a Scrambled Halton sequence.
  // lds = lowdisc_new("halton");
  // lds = lowdisc_configure(lds,"-dimension",44);
  // lds = lowdisc_configure(lds,"-scrambling","RR2");
  // lds = lowdisc_startup (lds);
  // [lds,u] = lowdisc_next (lds,500);
  // lds = lowdisc_destroy(lds);
  // scf();
  // plot(u(:,43),u(:,44),"b.");
  //
  // Authors
  //   Michael Baudin - 2008 - 2009 - INRIA
  //   Michael Baudin - 2010 - 2011 - DIGITEO
  //
  // Bibliography
  // [1] Kocis, L., and W. J. Whiten. "Computational Investigations of Low-Discrepancy Sequences." ACM Transactions on Mathematical Software. Vol. 23, No. 2, 1997, pp. 266–294.

  [lhs, rhs] = argn()
  apifun_checkrhs ( "lowdisc_configure" , rhs , 3:3 )
  apifun_checklhs ( "lowdisc_configure" , lhs , 1 )
  //
  apifun_checktype ( "lowdisc_configure" , this , "this" , 1 , "LOWDISC" )
  apifun_checktype ( "lowdisc_configure" , key , "key" , 2 , "string" )
  apifun_checkscalar ( "lowdisc_configure" , key , "key" , 2 )
  //
  select this.method
    case "reversehalton" then
      this.sequence     = ldrevhalf_configure ( this.sequence , key , value )
    case "niederreiter" then
      this.sequence     = ldniedf_configure ( this.sequence , key , value )
    case "sobol" then
      this.sequence     = ldsobolf_configure ( this.sequence , key , value )
    case "faure" then
      this.sequence     = ldfauref_configure ( this.sequence , key , value )
    case "halton" then
      this.sequence     = ldhaltonf_configure ( this.sequence , key , value )
    else
      errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_configure" , this.method);
      error(errmsg);
    end
endfunction

