// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function [this,next] = lowdisc_next ( varargin )
  // Returns the next term of the sequence
  //
  // Calling Sequence
  //   [this,next] = lowdisc_next ( this )
  //   [this,next] = lowdisc_next ( this , imax )
  //
  // Parameters
  //   this: the current object
  //   imax: the number of terms to retrieve (default = 1)
  //   next : a matrix of size imax x s, the next vector in the sequence
  //
  // Description
  //   Returns a matrix of values with shape 1 x s, where s is the
  //   dimension of the space.
  //   The current object is updated after the call to next :
  //   both this and next are mandatory output arguments.
  //   This function is sensitive to the "-leap" option.
  //
  // Examples
  //   rng = lowdisc_new("halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #2
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #3, etc...
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the imax parameter in action
  //   rng = lowdisc_new("halton");
  //   rng = lowdisc_startup (rng);
  //   // Term #1 to 100
  //   [rng,computed] = lowdisc_next (rng,100);
  //   // Term #101 to 201
  //   [rng,computed] = lowdisc_next (rng,100);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the -leap option in action
  //   rng = lowdisc_new("halton");
  //   rng = lowdisc_configure(rng,"-leap",10);
  //   rng = lowdisc_startup (rng);
  //   // Term #1
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #11
  //   [rng,computed] = lowdisc_next (rng);
  //   // Term #21
  //   [rng,computed] = lowdisc_next (rng);
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  //   // See the -skip option in action.
  //   rng = lowdisc_new("fauref");
  //   rng = lowdisc_configure(rng,"-dimension",4);
  //   // Skip qs^4 - 1 terms, as in TOMS implementation
  //   qs = lowdisc_get ( rng , "-faurefprime" );
  //   rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
  //   rng
  //   rng = lowdisc_startup (rng);
  //   [rng,computed]=lowdisc_next(rng);
  //   // Terms #1 to #100
  //   [rng,computed]=lowdisc_next(rng,100);
  //   for i = 1:100
  //     mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
  //   end
  //   rng = lowdisc_destroy(rng);
  //   
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //

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

  select this.method
  case "halton" then
    [this.sequence,next]     = ldhalton_next ( this.sequence , imax )
  case "faure" then
    [this.sequence,next]     = ldfaure_next ( this.sequence , imax )
  case "reversehalton" then
    [this.sequence,next]     = ldrevhal_next ( this.sequence , imax )
  case "sobol" then
    [this.sequence,next]     = ldsobol_next ( this.sequence , imax )
  case "niederreiter-base-2" then
    [this.sequence,next]     = ldnied2_next ( this.sequence , imax )
  case "reversehaltonf" then
    [this.sequence,next]     = ldrevhalf_next ( this.sequence , imax )
  case "niederreiterf" then
    [this.sequence,next]     = ldniedf_next ( this.sequence , imax )
  case "sobolf" then
    [this.sequence,next]     = ldsobolf_next ( this.sequence , imax )
  case "fauref" then
    [this.sequence,next]     = ldfauref_next ( this.sequence , imax )
  case "haltonf" then
    [this.sequence,next]     = ldhaltonf_next ( this.sequence , imax )
  else
    errmsg = sprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_next" , this.method);
    error(errmsg);
  end
endfunction

