// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009-2011 - DIGITEO - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- JVM NOT MANDATORY -->
// <-- ENGLISH IMPOSED -->

//
// Check the sequences for all their available range of dimensions.
//
seqmat = lowdisc_methods ();
for seqname = seqmat'
  lds = lowdisc_new(seqname);
  dimmax = lowdisc_get(lds,"-dimmax");
  lds = lowdisc_destroy(lds);
  dimension = 0;
  mprintf("==============================\n")
  mprintf("Sequence=%s, Maximum Dimension=%d\n",seqname,dimmax)
  // Do not try all dimensions : 
  // Try the first tens : 1, 2, 3, ..., 10
  // Try the maximum.
  // Try 5 random dimensions between 11 and dimmax-1.
  dimmat(1:10) = [1:10];
  dimmat(11) = dimmax;
  dimmat(12:16) = grand(1,5,"uin",11,dimmax-1);
  dimmat = gsort(dimmat,"g","i");
  for dimension = dimmat
    mprintf("Sequence=%s, Dimension=%d/%d\n",seqname,dimension,dimmax)
    lds = lowdisc_new(seqname);
    lds = lowdisc_configure(lds,"-dimension",dimension);
    lds = lowdisc_startup (lds);
    [lds,computed] = lowdisc_next (lds,20);
    lds = lowdisc_destroy(lds);
  end
end

//
// Check the error messages when the sequences go beyond their available range of dimensions.
//
// Map from sequence name to error message
name2error = [
"halton"               "ldhaltonf_startup: The fast Halton method is not available for 101 dimension because the database contains only 100 primes"
"faure"                "ldfauref_startup: Faure Fast sequence : the dimension 542 is larger than any prime in the table. Configure the -primeslist option to increase the prime table."
"reversehalton"        "ldrevhalf_startup: Reverse Halton sequence : the dimension 101 is larger than any prime in the table. Configure the -primeslist option to increase the prime table."
"sobol"                "Lowdisc: Error at the library level:sobol - i4_sobol_start - Fatal Error  The spatial dimension DIM_NUM should satisfy    1 <= DIM_NUM <= 1111  But this input value is DIM_NUM = 1112"
"niederreiter"         "Lowdisc: Error at the library level:niederreiter - INLO - Error!  Bad spatial dimension."
];        

seqmat = lowdisc_methods ();
for seqname = seqmat'
for k = 1 : 2
// Test two times, to check that destroying works well,
// even in case of error.
  mprintf("==============================\n")
  lds = lowdisc_new(seqname);
  dimmax = lowdisc_get(lds,"-dimmax");
  dimension = dimmax + 1;
  mprintf("Sequence=%s, Dimension=%d/%d\n",seqname,dimension,dimmax)
  lds = lowdisc_configure(lds,"-dimension",dimension);
  cmd = "lds = lowdisc_startup (lds);";
  ierr = execstr(cmd,"errcatch");
  assert_checkequal ( or(ierr==[10000 999]) , %t );
  errmsg = lasterror();
  errmsg = strcat(errmsg(:));
  mprintf("Error (code=%d): %s\n",ierr,errmsg);
  k = find(seqname==name2error(:,1));
  expected = name2error(k,2);
  assert_checkequal(errmsg,expected);
  lds = lowdisc_destroy(lds);
end
end
