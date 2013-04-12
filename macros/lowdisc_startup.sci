// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin

// This file must be used under the terms of the 
// GNU LGPL license.

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
    //   This function is sensitive to the <literal>"-skip"</literal> and 
    //   <literal>"-leap"</literal> options.
    //
    //   The mathematical definition of some sequences (e.g. Sobol, Niederreiter, Faure) imply
    //   that the first element of the sequence is the zero vector. 
    //   In this implementation, this zero vector is ignored at startup and all sequences 
    //   start with a non-zero vector.
    //
    // Examples
    //   lds = lowdisc_new("halton");
    //   lds = lowdisc_startup (lds);
    //   // Term #1
    //   [lds,computed] = lowdisc_next (lds);
    //   // Term #2
    //   [lds,computed] = lowdisc_next (lds);
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    //   // See the -skip option in action
    //   lds = lowdisc_new("halton");
    //   lds = lowdisc_configure(lds,"-skip",12);
    //   lds = lowdisc_startup (lds);
    //   // Term #13
    //   [lds,computed] = lowdisc_next (lds);
    //   // Term #14
    //   [lds,computed] = lowdisc_next (lds);
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    // Authors
    // Copyright (C) 2013 - Michael Baudin
    // Copyright (C) 2010 - DIGITEO - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    //

    select this.method
    case "reversehalton" then
        this.sequence     = ldrevhalf_startup ( this.sequence )
    case "niederreiter" then
        this.sequence     = ldniedf_startup ( this.sequence )
    case "sobol" then
        this.sequence     = ldsobolf_startup ( this.sequence )
    case "faure" then
        this.sequence     = ldfauref_startup ( this.sequence )
    case "halton" then
        this.sequence     = ldhaltonf_startup ( this.sequence )
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_startup" , this.method);
        error(errmsg);
    end
endfunction

function this = ldniedf_startup (this)
    // ldniedf_startup --
    //  Startup Fast Niederreiter's sequence.
    //
    //  Licensing:
    //    This code is distributed under the GNU LGPL license.
    //
    //  Author:
    //       2010 - Digiteo - Michael Baudin
    //

    this.baseobj = ldbase_startup ( this.baseobj )
    //
    // Compute the init flag.
    // If the two files already exist, there is no need to generate them again: set init to zero.
    if ( fileinfo ( this.gfaritfile ) <> [] & fileinfo ( this.gfplysfile ) <> [] ) then
        init = 0
    else
        init = 1
    end
    //
    // Create the sequence
    // We ignore the first element in the sequence, which is [0 0] in dimension 2.
    // Our Niederreiter sequence starts with [0.5 0.5] in 2 dimensions.
    // This is why we add 1 to the skip.
    skip = ldbase_cget ( this.baseobj , "-skip" )
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    _lowdisc_niedfstart ( dimension , this.base , skip + 1 , this.gfaritfile , this.gfplysfile , init );
    //
    // Initialize the sequence at the right place
    this.baseobj = ldbase_indexset ( this.baseobj , skip )
endfunction

function this = ldhaltonf_startup (this)

    this.baseobj = ldbase_startup ( this.baseobj )
    //
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    if ( dimension > this.primessize ) then
        errmsg = msprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"), "ldhaltonf_startup" , "fast Halton",dimension,this.primessize);
        error(errmsg);
    end
    //
    base = this.primeslist(1:dimension)
    seed = zeros(1,dimension)
    //
    if (this.scrambling=="") then
        _lowdisc_haltonfstart ( dimension , base , seed , 1 )
    else
        _lowdisc_haltonfstart ( dimension , base , seed , 2 )
    end
    //
    skip = ldbase_cget ( this.baseobj , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Set the seed accordingly and skip directly the elements.
        this.baseobj = ldbase_indexset ( this.baseobj , skip )
    else
    end
endfunction

function this = ldfauref_startup (this)

    this.baseobj = ldbase_startup ( this.baseobj )
    //
    // Create the sequence
    //
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    k = find(this.primeslist>=dimension,1)
    if (k == []) then
        errmsg = msprintf( gettext ( "%s: Faure Fast sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldfauref_startup" , dimension);
        error(errmsg);
    end
    //
    qs = this.primeslist(k)
    _lowdisc_faurefstart ( dimension , qs )
    //
    skip = ldbase_cget ( this.baseobj , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Directly set the index.
        this.baseobj = ldbase_indexset ( this.baseobj , skip )
    end

endfunction

function this = ldsobolf_startup (this)

    this.baseobj = ldbase_startup ( this.baseobj )
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    _lowdisc_sobolfstart ( dimension );
    skip = ldbase_cget ( this.baseobj , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Directly set the index.
        this.baseobj = ldbase_indexset ( this.baseobj , skip )
    end
endfunction

function this = ldrevhalf_startup (this)
    this.baseobj = ldbase_startup ( this.baseobj )
    dimension = ldbase_cget ( this.baseobj , "-dimension" )
    if (dimension>this.primessize) then
        errmsg = msprintf( gettext ( "%s: Reverse Halton sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldrevhalf_startup" , dimension);
        error(errmsg);
    end
    //
    _lowdisc_revhaltfstart ( dimension , this.primeslist(1:dimension) )
    //
    skip = ldbase_cget ( this.baseobj , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Directly set the index.
        this.baseobj = ldbase_indexset ( this.baseobj , skip )
    end
endfunction

function this = ldbase_startup (this)
    if (this.startedup) then
        errmsg = msprintf( gettext ( "%s: Startup can only be run once." ) , "ldbase_startup" );
        error(errmsg);
    end
    if (this.verbose) then
        mprintf( "Starting up the sequence." );
    end
    this.startedup = %t;
    this.index = 0;
endfunction

function this = ldbase_indexset ( this , index )
  this.index = index
endfunction


