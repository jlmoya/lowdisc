// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin

// This file must be used under the terms of the GNU LGPL license.

function this = lowdisc_startup (this)
  // Startup the sequence.
  //
  // Calling Sequence
  //   this = lowdisc_startup (this)
  //
  // Parameters
  //   this: the current object
  //
  // Description
  //   This command can only be executed once in the lifetime of the object.
  //   This function is sensitive to the "-skip" option.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #2
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the -skip option in action
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_configure(rng,"-skip",12);
  //   rng = lowdisc_startup (rng);
  //   // Term #13
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #14
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //
  
  select this.method
  case "halton" then
    this.sequence     = ldhalton_startup ( this.sequence )
  case "faure" then
    this.sequence     = ldfaure_startup ( this.sequence )
  case "reversehalton" then
    this.sequence     = ldrevhal_startup ( this.sequence )
  case "sobol" then
    this.sequence     = ldsobol_startup ( this.sequence )
  case "niederreiter-base-2" then
    this.sequence     = ldnied2_startup ( this.sequence )
  case "reversehaltonf" then
    this.sequence     = ldrevhalf_startup ( this.sequence )
  case "niederreiter-base-2f" then
    this.sequence     = ldnied2f_startup ( this.sequence )
  case "sobolf" then
    this.sequence     = ldsobolf_startup ( this.sequence )
  case "fauref" then
    this.sequence     = ldfauref_startup ( this.sequence )
  case "haltonf" then
    this.sequence     = ldhaltonf_startup ( this.sequence )
  else
    errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_startup" , this.method);
    error(errmsg);
  end
endfunction

