// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt


//
// assert_close --
//   Returns 1 if the two real matrices computed and expected are close,
//   i.e. if the relative distance between computed and expected is lesser than epsilon.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_close ( computed, expected, epsilon )
  if expected==0.0 then
    shift = norm(computed-expected);
  else
    shift = norm(computed-expected)/norm(expected);
  end
  if shift < epsilon then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction
//
// assert_equal --
//   Returns 1 if the two real matrices computed and expected are equal.
// Arguments
//   computed, expected : the two matrices to compare
//   epsilon : a small number
//
function flag = assert_equal ( computed , expected )
  if computed==expected then
    flag = 1;
  else
    flag = 0;
  end
  if flag <> 1 then pause,end
endfunction


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
seqmat = lowdisc_methods ();
for seqname = seqmat'
  mprintf("==============================\n")
  lds = lowdisc_new(seqname);
  dimmax = lowdisc_get(lds,"-dimmax");
  dimension = dimmax + 1;
  mprintf("Sequence=%s, Dimension=%d/%d\n",seqname,dimension,dimmax)
  lds = lowdisc_configure(lds,"-dimension",dimension);
  cmd = "lds = lowdisc_startup (lds);";
  ierr = execstr(cmd,"errcatch");
  assert_equal ( or(ierr==[10000 999]) , %t );
  errmsg = lasterror();
  mprintf("Error (code=%d): %s\n",ierr,errmsg);
  lds = lowdisc_destroy(lds);
end

