// Copyright (C) 2008-2009 - INRIA - Michael Baudin
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
  //   <listitem>"-dimmax" : a floating point integer, the largest dimension available for the sequence.</listitem>
  //   <listitem>"-nbsimmax" : a floating point integer, the largest number of elements available for the sequence.</listitem>
  //   <listitem>"-faureprime" : a floating point integer, the prime integer used in the Faure sequence.</listitem>
  //   <listitem>"-faurefprime" : a floating point integer, the prime integer used in the Faure fast sequence.</listitem>
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
  //     mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
  //   end
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
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

