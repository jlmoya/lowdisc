// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function bit = bitlo0 ( n )
    // Returns the position of the low zero bit base 2 in an integer.
    //
    // Calling Sequence
    //   bit = bitlo0 ( n )
    //
    // Parameters
    //    n : a 1-by-1 matrix of doubles, integer value, positive
    //    bit : the position of the low 0 bit, with 1<= bit <= d+1, where d is the number of digits to represent n in base 2.
    //
    //  Description
    //    Consider the number 11 = "1 0 1 1" in binary. The low zero bit is
    //    the first zero starting from the right. It is located at the index bit=3.
    //    If a number is made only of d ones in base 2, then bit = d+1.
    //
    //    This routine is not vectorized, i.e. it does not take a column matrix n as input argument, but only
    //    a 1-by-1 matrix.
    //
    //    TODO : vectorize this, if possible
    //
    //  Examples
    //  // n = 11 is equal to "1 0 1 1" in binary
    //  d = number_tobary ( 11 , 2 )'
    //  // Hence, the low 0 bit is 3 
    //  // i.e., from the right, the first zero is at index 3.
    //  bit = bitlo0 ( 11 )
    //
    //  // Compute the low 0 bit for several integers
    //  mprintf("%5s %25s %5s\n","N","Binary","bit");
    //  mprintf("-------------------------------------\n");
    //  nmat =  [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 1023 1024 1025];
    //  for n = nmat
    //    bit = bitlo0 ( n );
    //    d = number_tobary ( n , 2 );
    //    mprintf("%5d %25s %5d\n",n,strcat(string(d)," "),bit);
    //  end
    //
    //  Authors
    //    2008-2009 - INRIA - Michael Baudin (Scilab version)
    //    2010 - 2011 - Digiteo - Michael Baudin
    //

    d = number_tobary(n)
    l = size(d,"*")
    k = find(d==0)
    bit = l - max(k) + 1
endfunction

if (%f) then
    //
    // Check the bitlo0 function
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
    ]
    expected =  [
    1
    1
    3
    1
    2
    1
    1
    3
    1
    1
    ];
    for i = 1:size(ilist,"*")
        j = ilist(i);
        computed($+1) = bitlo0 ( j );
    end
    assert_checkequal ( computed , expected );

    // Reproduce the test from the help
    // Column #1 : n
    // Column #2 : bitlo0(n)
    expected = [
    0  1
    1  2
    2  1
    3  3 
    4  1
    5  2
    6  1
    7  4
    8  1
    9  2
    10  1
    11  3
    12  1
    13  2
    14  1
    15  5
    16  1
    17  2
    1023 11
    1024  1
    1025  2
    ];
    computed = [];
    for i = 1:size(expected,"r")
        j = expected(i,1);
        computed($+1) = bitlo0 ( j );
    end
    assert_checkequal ( computed , expected(:,2) );

end
