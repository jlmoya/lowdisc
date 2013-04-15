// Copyright (C) 2013 - Michael Baudin
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
    // Examples
    //   lds = lowdisc_new("halton");
    //   lds = lowdisc_startup (lds);
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
    //   lds = lowdisc_startup (lds);
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
    //   lds = lowdisc_startup (lds);
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
    //   qs = lowdisc_get ( lds , "-faurefprime" );
    //   lds = lowdisc_configure(lds,"-skip", qs^4 - 2);
    //   lds
    //   lds = lowdisc_startup (lds);
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
    //   // The primes come row-by-row
    //   prarray = number_primes1000 ( )
    //   // Create a column vector containing all primes.
    //   primtable = prarray';
    //   primtable = primtable(:);
    //   lds = lowdisc_configure(lds,"-primeslist",primtable);
    //   lds = lowdisc_configure(lds,"-dimension",150);
    //   lds = lowdisc_startup (lds);
    //   [lds,next] = lowdisc_next ( lds , 10 );
    //   assert_checkequal ( size(next) , [10 150] );
    //   lds = lowdisc_destroy(lds);
    //   
    // Authors
    // Copyright (C) 2013 - Michael Baudin
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
        errmsg = msprintf(gettext("%s: The sequence is not started up. Call ldfauref_startup first."), "ldfauref_next");
        error(errmsg)
    end
    //
    select this.method
    case "reversehalton" then
        [this,next]     = ldrevhalf_next ( this , imax )
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

function [this,next] = ldrevhalf_next ( this , imax )
    dimension = lowdisc_cget(this , "-dimension" )
    leap = lowdisc_cget(this , "-leap" )
    index = lowdisc_get(this , "-index" )
    next = _lowdisc_revhaltfnext ( index + 1 , imax, leap )
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function [this,next] = ldfauref_next ( this , imax )
    dimension = lowdisc_cget(this , "-dimension" )
    leap = lowdisc_cget(this , "-leap" )
    //
    index = lowdisc_get(this , "-index" )
    next = _lowdisc_faurefnext ( index + 1 , imax, leap);
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function [this,next] = ldhaltonf_next ( this , imax )
    dimension = lowdisc_cget(this , "-dimension" )
    leap = lowdisc_cget(this , "-leap" )
    //
    // Initialize the vector
    index = lowdisc_get(this , "-index" )
    next = _lowdisc_haltonfnext ( index + 1, imax , leap );
    // Leap over (i.e. ignore) as many elements as required
    // Directly set the index.
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function [this,next] = ldsobolf_next ( this , imax )
    dimension = lowdisc_cget ( this , "-dimension" )
    leap = lowdisc_cget ( this , "-leap" )
    scrambling = lowdisc_cget ( this , "-scrambling" )
    index = lowdisc_get ( this , "-index" )
    select scrambling
    case ""
        //
        // Initialize the vector
        next = _lowdisc_sobolfnext ( index + 1 , imax , leap )
    case "Owen"
        next = _lowdisc_ssobolnext ( this.sequence.token, imax , leap )
    else
        errmsg = msprintf( gettext ( "%s: Unknown scrambling %s." ) , "ldsobolf_next" , dimension);
        error(errmsg);
    end
    index = index + imax*(leap+1)
    this=ldbase_indexset(this, index )
endfunction

function [this,next] = ldniedf_next ( this , imax )
    dimension = lowdisc_cget(this , "-dimension" )
    leap = lowdisc_cget(this , "-leap" )
    //
    // Initialize the vector
    next = _lowdisc_niedfnext ( imax , leap );
    // Leap over (i.e. ignore) as many elements as required
    // Directly set the index.
    index = lowdisc_get(this , "-index" )
    index = index + imax*(leap+1)
    this=ldbase_indexset(this,index)
endfunction

function this = ldbase_indexset ( this , index )
    this.sequence.baseobj.index = index
endfunction

