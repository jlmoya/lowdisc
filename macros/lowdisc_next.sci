// Copyright (C) 2013 - 2014 - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
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
    //   imax: a 1-by-1 matrix of doubles, integer value, the number of terms to retrieve (default imax = 1)
    //   next : a imax-by-s matrix of doubles, the next vector in the sequence. The experiment #i is stored at <literal>next(i,:)</literal> for <literal>i=1,2,...,imax</literal>. The component #j of experiment #i is stored in <literal>next(i,j)</literal> with <literal>j=1,2,...,s</literal>.
    //
    // Description
    //   The current object is updated after the call to next :
    //   both <literal>this</literal> and <literal>next</literal> are mandatory output arguments.
    //   This function is sensitive to the <literal>"-leap"</literal> option.
    //
    //   Fast sequences are based on the intermediate storage of the 
    //   iteration index on a 32 bits C int. This implies 
    //   that these sequences are able to generate at most 
    //   2^32-1 = 4 294 967 295 experiments. 
    //
    //  The number of simulations might be computed so that it 
    //  improves the discrepancy of the sequence.
    //  This is especially true for the Sobol, Faure and Niederreiter sequences.
    //  This can lead to some trouble for non-experts.
    //  For that purpose, we designed the following functions.
    //  <itemizedlist>
    //  <listitem> <literal>lowdisc_haltonsuggest</literal> : provides settings for the Halton sequence,</listitem>
    //  <listitem> <literal>lowdisc_fauresuggest</literal> : provides settings for the Faure sequence,</listitem>
    //  <listitem> <literal>lowdisc_sobolsuggest</literal> : provides settings for the Sobol sequence,</listitem>
    //  <listitem> <literal>lowdisc_niedersuggest</literal> : provides settings for the Niederreiter sequence.</listitem>
    //  </itemizedlist>
    //
    //   This function is sensitive to the <literal>"-coordinate"</literal> option. 
    //   If "-coordinate" is false (the default), then next is a imax-by-s 
    //   matrix of doubles.
    //   If "-coordinate" is false (the default), then next is a imax-by-1 
    //   matrix of doubles. 
    //   In this case it contains the dimension-th coordinate of the sequence.
    //   See lowdisc_configure for more details on this feature.
    //
    // Examples
    //   lds = lowdisc_new("halton");
    //   // Term #1
    //   [lds,computed] = lowdisc_next (lds);
    //   disp(computed)
    //   // Term #2
    //   [lds,computed] = lowdisc_next (lds);
    //   disp(computed)
    //   // Term #3, etc...
    //   [lds,computed] = lowdisc_next (lds);
    //   disp(computed)
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    //   // See the imax parameter in action
    //   lds = lowdisc_new("halton");
    //   // Term #1 to 100
    //   [lds,computed] = lowdisc_next (lds,100);
    //   // Term #101 to 201
    //   [lds,computed] = lowdisc_next (lds,100);
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    //   // See the -leap option in action
    //   lds = lowdisc_new("halton");
    //   lds = lowdisc_configure(lds,"-leap",10);
    //   // Term #1
    //   [lds,computed] = lowdisc_next (lds);
    //   // Term #11
    //   [lds,computed] = lowdisc_next (lds);
    //   // Term #21
    //   [lds,computed] = lowdisc_next (lds);
    //   lds
    //   lds = lowdisc_destroy(lds);
    //
    //   // See the -skip option in action.
    //   lds = lowdisc_new("faure");
    //   lds = lowdisc_configure(lds,"-dimension",4);
    //   // Skip qs^4 - 1 terms, as in TOMS implementation
    //   qs = lowdisc_get ( lds , "-faureprime" );
    //   lds = lowdisc_configure(lds,"-skip", qs^4 - 2);
    //   lds
    //   [lds,computed]=lowdisc_next(lds);
    //   // Terms #1 to #100
    //   [lds,computed]=lowdisc_next(lds,100);
    //   for i = 1:100
    //     mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", ...
    //       i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
    //   end
    //   lds = lowdisc_destroy(lds);
    //
    //   // Configure a list of primes and use it
    //   lds = lowdisc_new("halton");
    //   // Get a table of primes
    //   prarray = number_primes1000 ( );
    //   // Configure the primes list of the sequence
    //   lds = lowdisc_configure(lds,"-primeslist",prarray);
    //   lds = lowdisc_configure(lds,"-dimension",150);
    //   lds = lowdisc_startup (lds);
    //   [lds,next] = lowdisc_next ( lds , 10 );
    //   assert_checkequal ( size(next) , [10 150] );
    //   lds = lowdisc_destroy(lds);
    //
    //   // See the -coordinate option :
    //   // show how to get the 12-th coordinate of the 
    //   // Halton sequence.
    //   lds = lowdisc_new("halton");
    //   lds = lowdisc_configure(lds,"-dimension",12);
    //   lds = lowdisc_configure(lds,"-coordinate",%t);
    //   // Elements #1,...,#5, coordinate index = 12.
    //   [lds,computed] = lowdisc_next (lds,5);
    //   disp(computed)
    //   // Elements #6,...,#10, coordinate index = 12.
    //   [lds,computed] = lowdisc_next (lds,5);
    //   disp(computed)
    //   lds = lowdisc_destroy(lds);
    //   
    // Authors
    // Copyright (C) 2013 - 2014 - Michael Baudin
    // Copyright (C) 2010 - DIGITEO - Michael Baudin
    // Copyright (C) 2008-2009 - INRIA - Michael Baudin
    //

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_next" , rhs , 1:2 )
    apifun_checklhs ( "lowdisc_next" , lhs , 0:2 )
    //
    this = varargin(1)
    imax = apifun_argindefault ( varargin , 2 , 1 )
    //
    apifun_checktype ( "lowdisc_next" , this , "this" , 1 , "LOWDISC" )
    apifun_checktype ( "lowdisc_next" , imax , "imax" , 2 , "constant" )
    apifun_checkscalar ( "lowdisc_next" , imax , "imax" , 2 )
    apifun_checkflint ( "lowdisc_next" , imax , "imax" , 2 )
    apifun_checkgreq ( "lowdisc_next" , imax , "imax" , 2 , 1 )
    //
    // Check that the object is started up
    startedup=lowdisc_get(this , "-startedup" )
    if ( ~startedup ) then
        // The sequence is not startedup : auto-startup
        this = lowdisc_startup (this);
    end
    //
    select this.method
    case "niederreiter" then
        [this,next]     = ldniedf_next ( this , imax )
    case "sobol" then
        [this,next]     = ldsobolf_next ( this , imax )
    case "faure" then
        [this,next]     = ldfauref_next ( this , imax )
    case "halton" then
        [this,next]     = ldhaltonf_next ( this , imax )
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_next" , this.method);
        error(errmsg);
    end
endfunction

function [this,next] = ldfauref_next ( this , imax )
    leap = lowdisc_cget(this , "-leap" )
    index = lowdisc_get(this , "-index" )
    coordinate = lowdisc_cget(this , "-coordinate" )
    next = _lowdisc_faurefnext ( this.sequence.token, index + 1 , imax, leap, coordinate);
    // Leap over (i.e. ignore) as many elements as required
    // Directly set the index.
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function [this,next] = ldhaltonf_next ( this , imax )
    leap = lowdisc_cget(this , "-leap" )
    index = lowdisc_get(this , "-index" )
    next = _lowdisc_haltonfnext ( this.sequence.token, index + 1, imax , leap)
    // Leap over (i.e. ignore) as many elements as required
    // Directly set the index.
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function [this,next] = ldsobolf_next ( this , imax )
    leap = lowdisc_cget ( this , "-leap" )
    scrambling = lowdisc_cget ( this , "-scrambling" )
    index = lowdisc_get ( this , "-index" )
    if (scrambling=="") then
        next = _lowdisc_sobolfnext ( this.sequence.token, index + 1 , imax , leap )
    else
        next = _lowdisc_ssobolnext ( this.sequence.token, imax , leap)
    end
    // Leap over (i.e. ignore) as many elements as required
    // Directly set the index.
    index = index + imax*(leap+1)
    this=ldbase_indexset(this, index )
endfunction

function [this,next] = ldniedf_next ( this , imax )
    leap = lowdisc_cget(this , "-leap" )
    coordinate = lowdisc_cget(this , "-coordinate" )
    next = _lowdisc_niedfnext(this.sequence.token, imax, leap, coordinate);
    // Leap over (i.e. ignore) as many elements as required
    // Directly set the index.
    index = lowdisc_get(this , "-index" )
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function this = ldbase_indexset ( this , index )
    this.sequence.baseobj.index = index
endfunction

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
    // Create the sequence
    // We ignore the first element in the sequence, which is [0 0] in 
    // dimension 2.
    // Our Niederreiter sequence starts with [0.5 0.5] in 2 dimensions.
    // This is why we add 1 to the skip.
    skip = lowdisc_cget(this , "-skip" )
    dimension = lowdisc_cget(this , "-dimension" )
    base = lowdisc_cget(this , "-base" )
    this.sequence.token = _lowdisc_niedfnew(dimension,base, skip + 1 , gfaritfile , gfplysfile );
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
    coordinate = lowdisc_cget(this , "-coordinate" )
    this.sequence.token = _lowdisc_haltonfnew(dimension , ..
    base , seed , scrambling, coordinate)
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
    this.sequence.token = _lowdisc_faurefnew(dimension,qs)
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
    coordinate = lowdisc_cget(this , "-coordinate" )
    if (scrambling=="") then
        this.sequence.token = _lowdisc_sobolfnew(dimension, coordinate)
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
        coordinate = lowdisc_cget(this , "-coordinate" )
        if (seeds==[]) then
            this.sequence.token = _lowdisc_ssobolnew(dimension,iflag,coordinate)
        else
            this.sequence.token = _lowdisc_ssobolnew(dimension,iflag,coordinate,seeds)
        end
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


