// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function [this,next] = ldrevhalf_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "lowdisc_next", rhs);
    error(errmsg)
  end
  
  this = varargin(1)
  if ( rhs < 2 ) then
    imax = 1
  else
    imax = varargin(2)
  end

  //
  // Check that the object is started up
  if ( this.startedup == 0 ) then
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call lowdisc_startup first."), "lowdisc_next");
    error(errmsg)
  end
  //
  // Initialize the vector
  next = zeros(imax,this.dimension)
  
  for i=1:imax
    this.sequenceindex = this.sequenceindex + 1;
    next = _lowdisc_revhaltf ( this.sequenceindex )
    next(i,1:this.dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    if ( this.leap > 0 ) then
      for j = 1 : this.leap
        this.sequenceindex = this.sequenceindex + 1;
        next = _lowdisc_revhaltf ( this.sequenceindex )
      end
    end
  end
endfunction

