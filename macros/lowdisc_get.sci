// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function value = lowdisc_get (this,key)
  // Quiery one not-configurable field.
  //
  // Calling Sequence
  //   value = lowdisc_get (this,key)
  //
  // Parameters
  //   this: the current object
  //   key: a string. The name of the option to get. The available options are presented below.
  //   value: the value associated with the key.
  //
  // Description
  //   Returns the option of the given key.
  //  The following keys are available.
  //  <itemizedlist>
  //   <listitem>
  //     <para>
  //     <literal>"-index"</literal> : a positive floating point integer,
  //     the number of points which have already been generated in the sequence.
  //     When a sequence is created, then index is set to 0.
  //     Whenever the <literal>lowdisc_next</literal> function is called, the index
  //     is updated and incremented with 1. 
  //     If this option is set, the algorithm directly goes to the required 
  //     location in the sequence.
  //     </para>
  //   </listitem>
  //   <listitem>
  //     <para>
  //       <literal>"-dimmax"</literal> : a floating point integer, 
  //       the largest dimension available for the sequence.
  //     </para>
  //   </listitem>
  //   <listitem>
  //     <para>
  //       <literal>"-speed"</literal> : a string, 
  //       the speed of the sequence. 
  //       The <literal>speed</literal> field can be equal to "slow" or "fast".
  //     </para>
  //   </listitem>
  //   <listitem>
  //     <para>
  //       <literal>"-nbsimmax"</literal> : a floating point integer, 
  //       the largest number of elements available for the sequence.
  //     </para>
  //   </listitem>
  //  </itemizedlist>
  //
  // For the "faure" sequence (slow Faure sequence), the 
  // following field is available.
  //  <itemizedlist>
  //   <listitem>
  //     <para>
  //       <literal>"-faureprime"</literal> : a floating point integer, 
  //       the prime integer used in the Faure sequence.
  //       This prime number is computed depending on the dimension of 
  //       the sequence: this is the smallest prime number larger than 
  //       the dimension.
  //       This prime number is used as the base of the Faure sequence.
  //     </para>
  //   </listitem>
  //  </itemizedlist>
  //
  // For the "fauref" sequence (fast Faure sequence), the 
  // following field is available.
  //  <itemizedlist>
  //   <listitem>
  //     <para>
  //       <literal>"-faurefprime"</literal> : a floating point integer, 
  //       the prime integer used in the Faure fast sequence.
  //       This prime number is computed depending on the dimension of 
  //       the sequence: this is the smallest prime number larger than 
  //       the dimension.
  //       This prime number is used as the base of the Faure sequence.
  //     </para>
  //   </listitem>
  //  </itemizedlist>
  //
  // Examples
  //
  //  // Faure sequence: get the base associated with current dimension.
  //   // See the -skip option in action in the Faure fast sequence.
  //   lds = lowdisc_new("fauref");
  //   lds = lowdisc_configure(lds,"-dimension",4);
  //   // Skip qs^4 - 1 terms, as in TOMS implementation
  //   qs = lowdisc_get ( lds , "-faurefprime" );
  //   lds = lowdisc_configure(lds,"-skip", qs^4 - 2);
  //   lds
  //   lds = lowdisc_startup (lds);
  //   [lds,computed]=lowdisc_next(lds);
  //   // Terms #1 to #100
  //   [lds,computed]=lowdisc_next(lds,100);
  //   for i = 1:100
  //     mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", ...
  //       i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
  //   end
  //   i = lowdisc_cget(lds,"-index")
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - 2011 - DIGITEO
  //

  [lhs, rhs] = argn()
  apifun_checkrhs ( "lowdisc_get" , rhs , 2:2 )
  apifun_checklhs ( "lowdisc_get" , lhs , 1 )
  //
  apifun_checktype ( "lowdisc_get" , this , "this" , 1 , "LOWDISC" )
  apifun_checktype ( "lowdisc_get" , key , "key" , 2 , "string" )
  apifun_checkscalar ( "lowdisc_get" , key , "key" , 2 )
  //
  select this.method
  case "halton" then
    value     = ldhalton_get ( this.sequence , key )
  case "faure" then
    value     = ldfaure_get ( this.sequence , key )
  case "reversehalton" then
    value     = ldrevhal_get ( this.sequence , key )
  case "sobol" then
    value     = ldsobol_get ( this.sequence , key )
  case "niederreiter-base-2" then
    value     = ldnied2_get ( this.sequence , key )
  case "reversehaltonf" then
    value     = ldrevhalf_get ( this.sequence , key )
  case "niederreiterf" then
    value     = ldniedf_get ( this.sequence , key )
  case "sobolf" then
    value     = ldsobolf_get ( this.sequence , key )
  case "fauref" then
    value     = ldfauref_get ( this.sequence , key )
  case "haltonf" then
    value     = ldhaltonf_get ( this.sequence , key )
  else
    errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_get" , this.method);
    error(errmsg);
  end
endfunction

