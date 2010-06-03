// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.





function this = ldniedf_configure (this,key,value)

  select key
  case "-verbose" then
    assert_typeboolean ( value );
    this.verbose = value
  case "-dimension" then
    assert_typereal ( value );
    this.dimension = value
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
  case "-base" then
    assert_typereal ( value );
    assert_positive ( value ); 
    this.base = value;
  else
    errmsg = sprintf ( gettext ( "%s: Unknown key %s" ) , ...
    "ldniedf_configure" , key)
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

