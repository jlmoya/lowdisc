// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
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
  //   rng = lowdisc_new("faure");
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO

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
  case "niederreiter-base-2f" then
    this.sequence     = ldnied2f_destroy ( this.sequence )
  case "sobolf" then
    this.sequence     = ldsobolf_destroy ( this.sequence )
  case "fauref" then
    this.sequence     = ldfauref_destroy ( this.sequence )
  case "haltonf" then
    this.sequence     = ldhaltonf_destroy ( this.sequence )
  else
    errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_destroy" , this.method);
    error(errmsg);
  end
endfunction

