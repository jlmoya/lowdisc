// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldrevhalf_configure (this,key,value)
  select key
  case "-primeslist" then
    assert_typereal ( value );
    psize = size(value);
    if (psize(1)<>1) then
      errmsg = msprintf ( gettext ( "%s: The first dimension of the primes list matrix is %d, which is different from 1" ) , ...
        "ldrevhalf_configure" , psize(1))
      error(errmsg)
    end    
    if (psize(2)<1) then
      errmsg = msprintf ( gettext ( "%s: The second dimension of the primes list matrix is %d, which is not positive" ) , ...
        "ldrevhalf_configure" , psize(2))
      error(errmsg)
    end        
    this.primeslist = value;
    this.primessize = psize(2);
  else
    // Delegate to ldbase
    this.baseobj = ldbase_configure ( this.baseobj , key ,value )
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

