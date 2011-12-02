// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = lowdisc_destroy (this)
  // Destroy the current object.
  //
  // Calling Sequence
  //   this = lowdisc_destroy (this)
  //
  // Parameters
  //   this: the current object
  //
  // Description
  //   This function requires to take the current object both as an input
  //   and an output argument.
  //
  // Examples
  //   lds = lowdisc_new("faure");
  //   lds
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

  [lhs, rhs] = argn()
  apifun_checkrhs ( "lowdisc_destroy" , rhs , 1:1 )
  apifun_checklhs ( "lowdisc_destroy" , lhs , 0:1 )
  //
  apifun_checktype ( "lowdisc_cget" , this , "this" , 1 , "LOWDISC" )
  //
  select this.method
  case "halton" then
    this.sequence     = ldhalton_destroy ( this.sequence )
  case "faure" then
    this.sequence     = ldfaure_destroy ( this.sequence )
  case "reversehalton" then
    this.sequence     = ldrevhal_destroy ( this.sequence )
  case "sobol" then
    this.sequence     = ldsobol_destroy ( this.sequence )
  case "niederreiter-base-2" then
    this.sequence     = ldnied2_destroy ( this.sequence )
  case "reversehaltonf" then
    this.sequence     = ldrevhalf_destroy ( this.sequence )
  case "niederreiterf" then
    this.sequence     = ldniedf_destroy ( this.sequence )
  case "sobolf" then
    this.sequence     = ldsobolf_destroy ( this.sequence )
  case "fauref" then
    this.sequence     = ldfauref_destroy ( this.sequence )
  case "haltonf" then
    this.sequence     = ldhaltonf_destroy ( this.sequence )
  else
    errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_destroy" , this.method);
    error(errmsg);
  end
endfunction

