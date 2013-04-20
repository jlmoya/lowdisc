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
        this= ldrevhalf_startup ( this )
    case "niederreiter" then
        this= ldniedf_startup ( this )
    case "sobol" then
        this= ldsobolf_startup ( this )
    case "faure" then
        this= ldfauref_startup ( this )
    case "halton" then
        this= ldhaltonf_startup ( this )
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_startup" , this.method);
        error(errmsg);
    end
endfunction

function this = ldniedf_startup (this)
    this.sequence.baseobj = ldbase_startup ( this.sequence.baseobj )
    // Compute the init flag.
    // If the two files already exist, there is no need to generate them again: set init to zero.
    gfaritfile=this.sequence.gfaritfile
    gfplysfile=this.sequence.gfplysfile
    if ( fileinfo (gfaritfile) <> [] & fileinfo ( gfplysfile ) <> [] ) then
        init = 0
    else
        init = 1
    end
    // Create the sequence
    // We ignore the first element in the sequence, which is [0 0] in 
    // dimension 2.
    // Our Niederreiter sequence starts with [0.5 0.5] in 2 dimensions.
    // This is why we add 1 to the skip.
    skip = lowdisc_cget(this , "-skip" )
    dimension = lowdisc_cget(this , "-dimension" )
    base = lowdisc_cget(this , "-base" )
    _lowdisc_niedfstart(dimension,base, skip + 1 , gfaritfile , gfplysfile , init );
    //
    // Initialize the sequence at the right place
    if ( skip > 0 ) then
        this=ldbase_indexset(this,skip)
    end
endfunction

function this = ldhaltonf_startup (this)
    this.sequence.baseobj = ldbase_startup ( this.sequence.baseobj )
    //
    dimension = lowdisc_cget(this , "-dimension" )
    primeslist=lowdisc_cget(this,"-primeslist")
    primessize=size(primeslist,"*")
    if ( dimension > primessize ) then
        errmsg = msprintf ( gettext ( "%s: The %s method is not available for %d dimension because the database contains only %d primes"), "ldhaltonf_startup" , "fast Halton",dimension,primessize);
        error(errmsg);
    end
    //
    base = primeslist(1:dimension)
    seed = zeros(1,dimension)
    //
    scrambling=lowdisc_cget(this,"-scrambling")
    if (scrambling=="") then
        scrambling= 1
    elseif (scrambling=="RR2") then
        scrambling= 2
    elseif (scrambling=="Reverse") then
        scrambling= 3
    end
    this.sequence.token = _lowdisc_haltonfnew(dimension , ..
    base , seed , scrambling)
    //
    skip = lowdisc_cget(this , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Set the seed accordingly and skip directly the elements.
        this=ldbase_indexset(this,skip)
    end
endfunction

function this = ldfauref_startup (this)
    this.sequence.baseobj = ldbase_startup ( this.sequence.baseobj )
    dimension = lowdisc_cget ( this , "-dimension" )
    primeslist=lowdisc_cget(this,"-primeslist")
    k = find(primeslist>=dimension,1)
    if (k == []) then
        errmsg = msprintf( gettext ( "%s: Faure Fast sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldfauref_startup" , dimension);
        error(errmsg);
    end
    //
    qs = primeslist(k)
    _lowdisc_faurefstart ( dimension , qs )
    //
    skip = lowdisc_cget(this , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Directly set the index.
        this=ldbase_indexset(this,skip)
    end
endfunction

function this = ldsobolf_startup (this)
    this.sequence.baseobj = ldbase_startup ( this.sequence.baseobj )
    scrambling = lowdisc_cget ( this , "-scrambling" )
    dimension = lowdisc_cget ( this , "-dimension" )
    if (scrambling=="") then
        _lowdisc_sobolfstart ( dimension );
        skip = lowdisc_cget ( this , "-skip" )
        if ( skip > 0 ) then
            // Skip (i.e. ignore) as many elements as required
            // Directly set the index.
            this=ldbase_indexset(this,skip)
        end
    else
        if (scrambling=="Owen") then
            iflag=1
        elseif (scrambling=="Faure-Tezuka") then
            iflag=2
        else
            // "Owen-Faure-Tezuka"
            iflag=3
        end
        seeds=lowdisc_cget(this,"-seeds")
        if (seeds==[]) then
            this.sequence.token = _lowdisc_ssobolnew(dimension,iflag)
        else
            this.sequence.token = _lowdisc_ssobolnew(dimension,iflag,seeds)
        end
    end
endfunction

function this = ldrevhalf_startup (this)
    this.sequence.baseobj = ldbase_startup ( this.sequence.baseobj )
    dimension = lowdisc_cget ( this , "-dimension" )
    primeslist=lowdisc_cget ( this , "-primeslist" )
    primesize=size(primeslist,"*")
    if (dimension>primesize) then
        errmsg = msprintf( gettext ( "%s: Reverse Halton sequence : the dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , "ldrevhalf_startup" , dimension);
        error(errmsg);
    end
    //
    _lowdisc_revhaltfstart ( dimension , primeslist(1:dimension) )
    //
    skip = lowdisc_cget ( this , "-skip" )
    if ( skip > 0 ) then
        // Skip (i.e. ignore) as many elements as required
        // Directly set the index.
        this= ldbase_indexset(this,skip)
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
  this.sequence.baseobj.index = index
endfunction


