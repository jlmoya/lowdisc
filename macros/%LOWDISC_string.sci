// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





//
// %LOWDISC_string --
//   Returns the string containing the low discrepancy sequence
//
function str = %LOWDISC_string ( this )
    str = []
    k = 1
    str(k) = msprintf("Low Discrepancy Sequence:")
    k = k + 1
    str(k) = msprintf("=========================")
    k = k + 1
    str(k) = msprintf("method: %s\n", _tostring(this.method))
    k = k + 1
    //
    // Get the sequence string
    select this.method
    case "reversehalton" then
        seqstr     = ldrevhalf_string (this.sequence)
    case "niederreiter" then
        seqstr     = ldniedf_string (this.sequence)
    case "sobol" then
        seqstr     = ldsobolf_string (this.sequence)
    case "faure" then
        seqstr     = ldfauref_string (this.sequence)
    case "halton" then
        seqstr     = ldhaltonf_string (this.sequence)
    else
        errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "%LOWDISC_string" , this.method);
        error(errmsg);
    end
    nbrows = size(seqstr,"r")
    for i = 1 : nbrows
        str(k) = seqstr(i)
        k = k + 1
    end
endfunction

function s = _tostring ( x )
    if ( x==[] ) then
        s = "[]"
    else
        n = size ( x , "*" )
        if ( n == 1 ) then
            s = string(x)
        else
            s = "["+strcat(string(x)," ")+"]"
        end
    end
endfunction

function str = ldrevhalf_string ( this )
    str = []
    k = 1
    nbp = size(this.primeslist,"*")
    if ( nbp > 10 ) then
        str(k) = msprintf("Primes List (%d primes): %s %s\n", nbp , _tostring(this.primeslist(1:10)),"...")
    else
        str(k) = msprintf("Primes List (%d primes): %s\n", nbp , _tostring(this.primeslist))
    end
    k = k + 1
    str(k) = msprintf("Maximum number of simulations = %e",this.nbsimmax)
    k = k + 1
    //
    // Get the baseobj string
    objstr = ldbase_string(this.baseobj)
    str(k : k + size(objstr,"r") - 1 ) = objstr
endfunction

function str = ldniedf_string ( this )
  str = []
  k = 1
  str(k) = msprintf("Base: %s\n", _tostring(this.base))
  k = k + 1
  str(k) = msprintf("Gfaritfile: %s\n", _tostring(this.gfaritfile))
  k = k + 1
  str(k) = msprintf("Gfplysfile: %s\n", _tostring(this.gfplysfile))
  k = k + 1
  str(k) = msprintf("Maximum dimension = %d",this.dimmax)
  k = k + 1
  str(k) = msprintf("Maximum number of simulations = %s",string(this.nbsimmax))
  k = k + 1
  //
  // Get the baseobj string
  objstr = ldbase_string(this.baseobj)
  str(k : k + size(objstr,"r") - 1 ) = objstr
endfunction

function str = ldfauref_string ( this )
    str = []
    k = 1
    nbp = size(this.primeslist,"*")
    if ( nbp > 10 ) then
        str(k) = msprintf("Primes List (%d primes): %s %s\n", nbp , _tostring(this.primeslist(1:10)),"...")
    else
        str(k) = msprintf("Primes List (%d primes): %s\n", nbp , _tostring(this.primeslist))
    end
    k = k + 1
    str(k) = msprintf("Maximum number of simulations = %s",string(this.nbsimmax))
    k = k + 1
    //
    // Get the baseobj string
    objstr = ldbase_string(this.baseobj)
    str(k : k + size(objstr,"r") - 1 ) = objstr
endfunction

function str = ldsobolf_string ( this )
    str = []
    k = 1
    str(k) = msprintf("Maximum dimension = %d",this.dimmax)
    k = k + 1
    str(k) = msprintf("Maximum number of simulations = %s",string(this.nbsimmax))
    k = k + 1
    str(k) = msprintf("Scrambling = ""%s""",this.scrambling)
    k = k + 1
    str(k) = msprintf("Token = ""%s""",this.token)
    k = k + 1
    //
    // Get the baseobj string
    objstr = ldbase_string(this.baseobj)
    str(k : k + size(objstr,"r") - 1 ) = objstr
endfunction

function str = ldhaltonf_string ( this )
    str = []
    k = 1
    nbp = size(this.primeslist,"*")
    if ( nbp > 10 ) then
        str(k) = msprintf("Primes List (%d primes): %s %s\n", nbp , _tostring(this.primeslist(1:10)),"...")
    else
        str(k) = msprintf("Primes List (%d primes): %s\n", nbp , _tostring(this.primeslist))
    end
    k = k + 1
    str(k) = msprintf("Maximum number of simulations = %s",string(this.nbsimmax))
    k = k + 1
    str(k) = msprintf("Scrambling = ""%s""",string(this.scrambling))
    k = k + 1
    //
    // Get the baseobj string
    objstr = ldbase_string(this.baseobj)
    str(k : k + size(objstr,"r") - 1 ) = objstr
endfunction

function str = ldbase_string ( this )
    str = []
    k = 1
    str(k) = msprintf("Dimension of space: %s\n", _tostring(this.dimension))
    k = k + 1
    str(k) = msprintf("Index: %s\n", _tostring(this.index))
    k = k + 1
    str(k) = msprintf("Verbose logging: %s\n", _tostring(this.verbose))
    k = k + 1
    str(k) = msprintf("Skip: %s\n", _tostring(this.skip))
    k = k + 1
    str(k) = msprintf("Leap: %s\n", _tostring(this.leap))
    k = k + 1
    str(k) = msprintf("Started Up: %s\n", _tostring(this.startedup))
    k = k + 1
    str(k) = msprintf("Speed: %s\n", _tostring(this.speed))
    k = k + 1
endfunction
