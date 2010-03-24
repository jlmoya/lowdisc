// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// lowdisc_destroy --
//   Destroy a new random number object.
//
function this = lowdisc_destroy (this)
  select this.method
  case "vandercorput" then
    // Nothing to do
  case "halton" then
    // Nothing to do
  case "faure" then
    // Nothing to do
  case "reversehalton" then
    // Nothing to do
  case "sobol" then
  case "niederreiter-base-2" then
//
// Fast sequences
//
  case "haltonf" then
    // Nothing to do
  case "reversehaltonf" then
    // Nothing to do
  case "niederreiter-base-2f" then
    // Nothing to do
  case "sobolf" then
    // Nothing to do
  case "fauref" then
    // Nothing to do
  else
    errmsg = sprintf("Unknown method %s",this.method);
    error(errmsg);
  end

endfunction

