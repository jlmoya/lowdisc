// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function value = lowdisc_cget (this,key)
  // Returns the value associated with the given key.
  //
  // Calling Sequence
  //   value = lowdisc_cget (this,key)
  //
  // Parameters
  //   this: the current object
  //   key: a string. The name of the option to get. All options which can be set with <literal>lowdisc_configure</literal> can be get with <literal>lowdisc_cget</literal>.
  //   value: the value associated with the key.
  //
  // Description
  //   This command allows to get the current state of the object,
  //   which has been configured with the <literal>lowdisc_configure</literal> command.
  //
  // Examples
  //   lds = lowdisc_new("faure");
  //   lds = lowdisc_configure(lds,"-dimension",3);
  //   method = lowdisc_cget(lds,"-method")
  //   nbdim = lowdisc_cget(lds,"-dimension")
  //   verbose = lowdisc_cget(lds,"-verbose")
  //   lds
  //   lds = lowdisc_destroy(lds);
  //
  // Authors
  //   Michael Baudin - 2010 - 2011 - DIGITEO

  [lhs, rhs] = argn()
  apifun_checkrhs ( "lowdisc_cget" , rhs , 2:2 )
  apifun_checklhs ( "lowdisc_cget" , lhs , 1 )
  //
  apifun_checktype ( "lowdisc_cget" , this , "this" , 1 , "LOWDISC" )
  apifun_checktype ( "lowdisc_cget" , key , "key" , 2 , "string" )
  apifun_checkscalar ( "lowdisc_cget" , key , "key" , 2 )
  //

  select key
  case "-method" then
    value = this.method;
  else
    select this.method
    case "reversehalton" then
      value     = ldrevhalf_cget ( this.sequence , key )
    case "niederreiter" then
      value     = ldniedf_cget ( this.sequence , key )
    case "sobol" then
      value     = ldsobolf_cget ( this.sequence , key )
    case "faure" then
      value     = ldfauref_cget ( this.sequence , key )
    case "halton" then
      value     = ldhaltonf_cget ( this.sequence , key )
    else
      errmsg = msprintf ( gettext ( "%s: Unknown method %s" ) , "lowdisc_cget" , this.method);
      error(errmsg);
    end
  end
endfunction

