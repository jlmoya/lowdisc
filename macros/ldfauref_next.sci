// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = ldfauref_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldfauref_next", rhs);
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
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldfauref_startup first."), "ldfauref_next");
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
    onevector = _lowdisc_faurefnext ( index );
    next(i,1:dimension) = onevector
    // Leap over (i.e. ignore) as many elements as required
    // TODO : improve this to leap the elements without actually generating them
    if ( leap > 0 ) then
      for j = 1 : leap
        this.baseobj = ldbase_incr ( this.baseobj )
        index = ldbase_get ( this.baseobj , "-index" )
        onevector = _lowdisc_faurefnext ( index );
      end
    end
  end
endfunction

