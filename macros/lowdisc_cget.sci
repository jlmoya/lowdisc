// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function value = lowdisc_cget (this,key)
  // Returns the value associated with the given key.
  //
  // Calling Sequence
  //   value = lowdisc_cget (this,key)
  //
  // Parameters
  //   this: the current object
  //   key: a string. The name of the option to get. All options which can be set with lowdisc_configure can be get with lowdisc_cget.
  //   value: the value associated with the key.
  //
  // Description
  //   This command allows to get the current state of the object,
  //   which has been configured with the lowdisc_configure command.
  //
  // Examples
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","faure");
  //   rng = lowdisc_configure(rng,"-dimension",3);
  //   method = lowdisc_cget(rng,"-method")
  //   nbdim = lowdisc_cget(rng,"-dimension")
  //   i = lowdisc_cget(rng,"-sequenceindex")
  //   verbose = lowdisc_cget(rng,"-verbose")
  //   rng
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2010 - DIGITEO

  select key
  case "-verbose" then
    value = this.verbose;
  case "-dimension" then
    value = this.dimension;
  case "-method" then
    value = this.method;
  case "-sequenceindex" then
    value = this.sequenceindex;
  case "-vandercorputbasis" then
    value = this.vdcbasis;
  case "-primeslist" then
    value = this.primeslist;
  case "-skip" then
    value = this.skip;
  case "-leap" then
    value = this.leap;
  else
    errmsg = sprintf("Unknown key %s",key);
    error(errmsg);
  end
endfunction

