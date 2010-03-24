// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


//
// lowdisc_display --
//   Display a Random Number generator
//
function lowdisc_display (this)
  mprintf("Low Discrepancy Sequence\n")
  mprintf("Dimension of space: %s\n", string(lowdisc_cget (this,"-dimension")))
  mprintf("Method: %s\n", string(lowdisc_cget (this,"-method")))
  mprintf("Sequence Index: %s\n", string(lowdisc_cget (this,"-sequenceindex")))
  mprintf("Verbose logging: %s\n", string(lowdisc_cget (this,"-verbose")))
  mprintf("Skip: %s\n", string(lowdisc_cget (this,"-skip")))
  mprintf("Leap: %s\n", string(lowdisc_cget (this,"-leap")))
endfunction

