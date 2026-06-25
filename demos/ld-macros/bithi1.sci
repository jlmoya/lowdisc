// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function bit = bithi1 ( n )
    // Returns the position of the high one bit base 2 in an integer.
    //
    // Calling Sequence
    //   bit = bithi1 ( n )
    //
    //  Parameters
    //    n : a 1-by-1 matrix of floating point integers, the integer to be measured. n should be nonnegative.  If n is nonpositive, the value will always be 0.
    //    bit : a 1-by-1 matrix of floating point integers, the high 1 bit in the base 2 expansion of n
    //
    //  Description
    //    This routine is not vectorized, i.e. it does not take a column matrix n as input argument, but only
    //    a 1-by-1 matrix.
    //
    //  Examples
    //    // n = 22 writes [1 0 1 1 0]' in base 2
    //    number_tobary(22)'
    //    // Hence, the high 1 bit is 5, 
    //    // i.e. the highest 1 bit is at index 5.
    //    bithi1 ( 22 )
    //
    //  // Compute the high 1 bit for several integers
    //  mprintf("%5s %25s %5s\n","N","Binary","bit");
    //  mprintf("-------------------------------------\n");
    //  nmat =  [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 1023 1024 1025];
    //  for n = nmat
    //    bit = bithi1 ( n );
    //    d = number_tobary ( n , 2 );
    //    mprintf("%5d %25s %5d\n",n,strcat(string(d)," "),bit);
    //  end
    //
    //  Authors
    //    2008-2009 - INRIA - Michael Baudin (Scilab version)
    //    2010 - 2011 - Digiteo - Michael Baudin
    //

    d = number_tobary(n)
    bit = size(d,"*")
endfunction

if (%f) then
    //
    // Check the bithi1 function
    //
    computed = [];
    ilist =  [
    22      
    96      
    83     
    56      
    41     
    6     
    26      
    11     
    4     
    64     
    ];
    expected =  [
    5
    7
    7
    6
    6
    3
    5
    4
    3
    7
    ];
    for i = 1:size(ilist,"*")
        j = ilist(i);
        computed ( $ + 1 ) = bithi1 (j );
    end
    assert_checkequal ( computed , expected );


end
