// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function [this,next] = ldhalton_next ( varargin )
  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldhalton_next", rhs);
    error(errmsg)
  end
  //
  this = varargin(1)
  if ( rhs < 2 ) then
    imax = 1
  else
    imax = varargin(2)
  end
  //
  // Check that the object is started up
  if ( ~ldbase_get ( this.baseobj , "-startedup" ) ) then
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldhalton_startup first."), "ldhalton_next");
    error(errmsg)
  end
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  leap = ldbase_cget ( this.baseobj , "-leap" )
  //
  // Initialize the vector
  next = zeros(imax,dimension)
  //
  for i=1:imax
    this.baseobj = ldbase_incr ( this.baseobj )
    index = ldbase_get ( this.baseobj , "-index" )
    onevector = lowdisc_haltonnext ( dimension , index , this.primeslist )
    next(i,1:dimension) = onevector
    if ( leap > 0 ) then
      // Leap over (i.e. ignore) as many elements as required
      // Directly set the index.
      this.baseobj = ldbase_indexset ( this.baseobj , index + leap )
    end
  end
endfunction


