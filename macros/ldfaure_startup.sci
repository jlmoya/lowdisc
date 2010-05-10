// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = ldfaure_startup (this)

  if (this.startedup<>0) then
    errmsg = sprintf( gettext ( "%s: Startup can only be run once." ) , "lowdisc_startup" );
    error(errmsg);
  end
  if (this.verbose) then
    mprintf( "Starting up the sequence." );
  end
  this.startedup = 1;
  //
  // Create the sequence
  //
    k = find(this.primeslist>=this.dimension,1)
    if (k == []) then
      errmsg = sprintf( gettext ( "%s: Faure sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
        "lowdisc_startup" , this.dimension);
      error(errmsg);
    end
  // Initialize the sequence
  this.sequenceindex = 0;
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  if ( this.skip > 0 ) then
    [ this , result ] = ldfaure_next ( this , this.skip )
  end
endfunction

