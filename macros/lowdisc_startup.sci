// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = lowdisc_startup (this)
  // Startup the sequence.
  //
  // Calling Sequence
  //   this = lowdisc_startup (this)
  //
  // Parameters
  //   this: the current object
  //
  // Description
  //   This command can only be executed once in the lifetime of the object.
  //   This function is sensitive to the "-skip" option.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #2
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the -skip option in action
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","halton");
  //   rng = lowdisc_configure(rng,"-skip",12);
  //   rng = lowdisc_startup (rng);
  //   // Term #13
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #14
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //

  if (this.startedup<>0) then
    errmsg = sprintf( gettext ( "%s: Startup can only be run once." ) , "lowdisc_startup" );
    error(errmsg);
  end
  if (this.verbose<>0) then
    mprintf( "Starting up the sequence." );
  end
  this.startedup = 1;
  //
  // Create the sequence
  //
  select this.method
  case "vandercorput" then
    // Nothing to do
  case "halton" then
    if this.dimension > this.primessize then
      errmsg = sprintf( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes" ),...
        "lowdisc_startup" , this.method,this.dimension,this.primessize);
      error(errmsg);
    end
  case "faure" then
    if (this.dimension>this.fauredimmax) then
      errmsg = sprintf ( gettext ( "%s: The dimension of the problem is %d, which is not available with Faure sequence (maximum is %d)."),...
        "lowdisc_startup" , this.dimension,this.fauredimmax);
      error(errmsg);
    end
  case "reversehalton" then
    if ( this.dimension > this.primessize ) then
      errmsg = sprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"),...
        "lowdisc_startup" , this.method,this.dimension,this.primessize);
      error(errmsg);
    end
  case "sobol" then
    this = lowdisc_startsobol ( this )
  case "niederreiter-base-2" then
    this = lowdisc_startnieder2 ( this )
//
// Fast sequences based on primitives
//
  case "haltonf" then
    seed = this.seed;
    dim = this.dimension;
    _lowdisc_haltondimnumset ( dim )
    _lowdisc_haltonstepset ( 1 )
    _lowdisc_haltonseedset ( dim , zeros ( 1 , dim ) )
    if ( this.dimension > this.primessize ) then
      errmsg = sprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"),...
        "lowdisc_startup" , this.method,this.dimension,this.primessize);
      error(errmsg);
    end
    basis = this.primeslist(1:dim);
    _lowdisc_haltonbaseset ( dim , basis )
  case "reversehaltonf" then
    // TODO
  case "niederreiter-base-2f" then
    // Nothing to do
  case "sobolf" then
    // Nothing to do
  case "fauref" then
    // Nothing to do
  else
    errmsg = sprintf(gettext ( "%s: Unknown method %s" ) , ...
      "lowdisc_startup" , this.method);
    error(errmsg);
  end
  // Initialize the sequence
  this = lowdisc_reset (this);
  // Skip (i.e. ignore) as many elements as required
  // TODO : skip directly when sequence authorizes it.
  if ( this.skip > 0 ) then
    [ this , result ] = lowdisc_terms ( this , this.skip )
  end
endfunction
