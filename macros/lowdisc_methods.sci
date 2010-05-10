// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// lowdisc_methods --
//   Returns a vector made of all available methods in the toolbox.
// Arguments
//   <no argument>
//
function methods = lowdisc_methods ()
  methods = [
   "vandercorput" 
   "halton" 
   "haltonf" 
   "reversehaltonf" 
   "niederreiter-base-2f" 
   "sobolf"
   ];
endfunction

