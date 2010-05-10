// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function value = lowdisc_get (this,key)
  // Quiery one not-configurable field.
  //
  // Calling Sequence
  //   value = lowdisc_get (this,key)
  //
  // Parameters
  //   this: the current object
  //   key: a string. The name of the option to get. The available options are presented below.
  //   value: the value associated with the key.
  //
  // Description
  //   Returns the option of the given key.
  //  The following keys are available.
  //  <itemizedlist>
  //   <listitem>"-faureprime" : a floating point integer, the prime integer used in the Faure sequence.</listitem>
  //   <listitem>"-faurefprime" : a floating point integer, the prime integer used in the Faure fast sequence.</listitem>
  //  </itemizedlist>
  //
  // Examples
  //
  //  rng = lowdisc_new();
  //  rng = lowdisc_configure(rng,"-method","faure");
  //  rng = lowdisc_configure(rng,"-dimension",4);
  //  // Skip qs^4 - 1 terms, as in TOMS implementation
  //  qs = lowdisc_get ( rng , "-faureprime" );
  //  rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
  //  rng
  //  rng = lowdisc_startup (rng);
  //  // Terms #1 to #100
  //  [rng,computed]=lowdisc_next(rng,100);
  //  for i = 1:100
  //    mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
  //  end
  //  rng = lowdisc_destroy(rng);
  //
  //   // See the -skip option in action in the Faure fast sequence.
  //   rng = lowdisc_new();
  //   rng = lowdisc_configure(rng,"-method","fauref");
  //   rng = lowdisc_configure(rng,"-dimension",4);
  //   // Skip qs^4 - 1 terms, as in TOMS implementation
  //   qs = lowdisc_get ( rng , "-faurefprime" );
  //   rng = lowdisc_configure(rng,"-skip", qs^4 - 2);
  //   rng
  //   rng = lowdisc_startup (rng);
  //   [rng,computed]=lowdisc_next(rng);
  //   // Terms #1 to #100
  //   [rng,computed]=lowdisc_next(rng,100);
  //   for i = 1:100
  //     mprintf ("%8d %14.6f %14.6f %14.6f %14.6f\n", i , computed(i,1) , computed(i,2) , computed(i,3) , computed(i,4) )
  //   end
  //   rng = lowdisc_destroy(rng);
  //
  // Authors
  //   Michael Baudin - 2008-2009 - INRIA
  //   Michael Baudin - 2010 - DIGITEO
  //

  select key
  case "-faureprime" then
    k = find(this.primeslist>=this.dimension,1)
    if (k == []) then
      errmsg = sprintf( gettext ( "%s: The dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
        "lowdisc_get" , this.dimension);
      error(errmsg);
    end
    value  = this.primeslist ( k )
  case "-faurefprime" then
    k = find(this.primeslist>=this.dimension,1)
    if (k == []) then
      errmsg = sprintf( gettext ( "%s: The dimension %d is larger than any prime in the table. Configure the -primeslist option to increase the prime table." ) , ...
        "lowdisc_get" , this.dimension);
      error(errmsg);
    end
    value  = this.primeslist ( k )
  else
    errmsg = sprintf(gettext("%s: Unknown key %s"),"lowdisc_get",key);
    error(errmsg);
  end
endfunction

