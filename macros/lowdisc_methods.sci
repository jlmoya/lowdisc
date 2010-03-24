// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

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

