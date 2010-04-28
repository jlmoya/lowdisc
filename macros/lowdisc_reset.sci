// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_reset --
//   Reset the random number generator.
//   
//
function this = lowdisc_reset (this)
  // Reset the sequence.
  //
  // Calling Sequence
  //   this = lowdisc_reset (this)
  //
  // Parameters
  //   this: the current object
  //
  // Description
  //   This command may be executed several times in the lifetime of the object.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #2
  //   [rng,computed] = lowdisc_next (rng);
  //   // Reset the sequence
  //   this = lowdisc_reset (this);
  //   // Term #1, 
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #2
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //

  this.sequenceindex = 0;
  //
  // Initialize the sequence
  //
  select this.method
  case "vandercorput" then
  case "halton" then
  case "faure" then
  case "reversehalton" then
  case "sobol" then
  case "niederreiter-base-2" then
//
// Fast sequences
//
  case "haltonf" then
    _lowdisc_haltonstepset ( 1 )
  case "reversehaltonf" then
    // todo
  case "niederreiter-base-2f" then
    // todo
  case "sobolf" then
    // Nothing to do
  case "fauref" then
    // Nothing to do
  else
    errmsg = sprintf(gettext ( "%s: Unknown method %s" ) , ...
      "lowdisc_reset" , this.method);
    error(errmsg);
  end
endfunction

