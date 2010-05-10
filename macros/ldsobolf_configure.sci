// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function this = ldsobolf_configure (this,key,value)

  select key
  case "-verbose" then
    assert_typeboolean ( value );
    this.verbose = value
  case "-dimension" then
    assert_typereal ( value );
    this.dimension = value
  case "-primeslist" then
    assert_typereal ( value );
    psize = size(value);
    if (psize(1)<>1) then
      errmsg = sprintf ( gettext ( "%s: The first dimension of the primes list matrix is %d, which is different from 1" ) , ...
        "lowdisc_configure" , psize(1))
      error(errmsg)
    end    
    if (psize(2)<1) then
      errmsg = sprintf ( gettext ( "%s: The second dimension of the primes list matrix is %d, which is not positive" ) , ...
        "lowdisc_configure" , psize(2))
      error(errmsg)
    end        
    this.primeslist = value;
    this.primessize = psize(2);
  case "-sequenceindex" then
    // TODO : remove this option - the use should not be able to write this setting.
    assert_typereal ( value );
    assert_positive ( value ); 
    this.sequenceindex = value;
  case "-skip" then
    assert_typereal ( value );
    assert_positive ( value ); 
    this.skip = value;
  case "-leap" then
    assert_typereal ( value );
    assert_positive ( value ); 
    this.leap = value;
  else
    errmsg = sprintf ( gettext ( "%s: Unknown key %s" ) , ...
    "lowdisc_configure" , key)
    error(errmsg)
  end
endfunction
// Generates an error if the given variable is not of type real
function assert_typereal ( var )
  if ( type ( var ) <> 1 ) then
    errmsg = msprintf(gettext("%s: Expected real variable but got %s instead"),"assert_typereal", typeof(var) );
    error(errmsg);
  end
endfunction
// Generates an error if the given variable is not of type string
function assert_typestring ( var )
  if ( type ( var ) <> 10 ) then
    errmsg = msprintf(gettext("%s: Expected string variable but got %s instead"),"assert_typestring", typeof(var) );
    error(errmsg);
  end
endfunction
// Generates an error if the given variable is not of type function (macro)
function assert_typefunction ( var )
  if ( type ( var ) <> 13 ) then
    errmsg = msprintf(gettext("%s: Expected function but got %s instead"),"assert_typefunction", typeof(var) );
    error(errmsg);
  end
endfunction
// Generates an error if the given variable is not of type boolean
function assert_typeboolean ( var )
  if ( type ( var ) <> 4 ) then
    errmsg = msprintf(gettext("%s: Expected boolean but got %s instead"),"assert_typeboolean", typeof(var) );
    error(errmsg);
  end
endfunction
// Generates an error if the value corresponding to an option is unknown.
function unknownValueForOption ( value , optionname )
      errmsg = msprintf(gettext("%s: Unknown value %s for %s option"),"unknownValueForOption",value , optionname );
      error(errmsg);
endfunction
// Generates an error if the given variable is not positive
function assert_positive ( value )
  if ( and ( value < 0 ) ) then
    errmsg = msprintf(gettext("%s: Expected positive variable but got [%s] instead"),"assert_positive", strcat ( string(value) , " " ) );
    error(errmsg);
  end
endfunction

