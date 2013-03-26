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
  //   This function is sensitive to the <literal>"-skip"</literal> and 
  //   <literal>"-leap"</literal> options.
  //
  //   The mathematical definition of some sequences (e.g. Sobol, Niederreiter, Faure) imply
  //   that the first element of the sequence is the zero vector. 
  //   In this implementation, this zero vector is ignored at startup and all sequences 
  //   start with a non-zero vector.
  //
  // Examples
  //   lds = lowdisc_new("halton");
  //   lds = lowdisc_startup (lds);
  //   // Term #1
  //   [lds,computed] = lowdisc_next (lds);
  //   // Term #2
  //   [lds,computed] = lowdisc_next (lds);
  //   lds
  //   lds = lowdisc_destroy(lds);
  //
  //   // See the -skip option in action
  //   lds = lowdisc_new("halton");
  //   lds = lowdisc_configure(lds,"-skip",12);
  //   lds = lowdisc_startup (lds);
  //   // Term #13
  //   [lds,computed] = lowdisc_next (lds);
  //   // Term #14
  //   [lds,computed] = lowdisc_next (lds);
  //   lds
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //
  
  select this.method
  case "reversehalton" then
    this.sequence     = ldrevhalf_startup ( this.sequence )
  case "niederreiter" then
    this.sequence     = ldniedf_startup ( this.sequence )
  case "sobol" then
    this.sequence     = ldsobolf_startup ( this.sequence )
  case "faure" then
    this.sequence     = ldfauref_startup ( this.sequence )
  case "halton" then
    this.sequence     = ldhaltonf_startup ( this.sequence )
  else
    errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_startup" , this.method);
    error(errmsg);
  end
endfunction

