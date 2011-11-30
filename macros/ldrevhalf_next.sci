// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = ldrevhalf_next ( varargin )

  [lhs,rhs]=argn();
  if ( rhs > 2 ) then
    errmsg = msprintf(gettext("%s: Unexpected number of input arguments : %d provided while from 1 or 2 are expected."), "ldrevhalf_next", rhs);
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
    errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldrevhalf_startup first."), "ldrevhalf_next");
    error(errmsg)
  end
  //
  dimension = ldbase_cget ( this.baseobj , "-dimension" )
  leap = ldbase_cget ( this.baseobj , "-leap" )
  index = ldbase_get ( this.baseobj , "-index" )
  next = _lowdisc_revhaltfnext ( index + 1 , imax, leap )
  index = index + imax*(leap+1)
  this.baseobj = ldbase_indexset ( this.baseobj , index )
endfunction

