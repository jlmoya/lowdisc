// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function lowdisc_demosvdc()

    function r = vandercorput ( i , b )
        //   Returns the i-th term of the Van Der Corput sequence.
        //
        // Calling Sequence
        //   r = vandercorput ( i , b )
        //
        // Parameters
        //   i : a 1-by-1 matrix of floating point integers, the index in the sequence
        //   b : a 1-by-1 matrix of floating point integers, the b of the sequence
        //   r : a 1-by-1 matrix of floating point doubles, the next element in the sequence, in the [0,1) interval
        //
        // Description
        // This function allows to compute the terms of the Van Der Corput sequence.
        // The current index <literal>i</literal> is decomposed in the b as :
        //
        // <literal>i = d0 b^0 + d1 b^1 + d2 b^2 + ... + dn b^n</literal>
        //
        // with <literal>dn</literal> the last digit in the decomposition.
        // The result <literal>r</literal> is computed by reversing the 
        // digits and scaling by <literal>b^n</literal> :
        //
        // <literal>r = d0 b^-1 + d1 b^-2 + ... + dn b^(-n-1)</literal>
        //
        // Example : <literal>i = 11</literal>. Its binary representation is 1010 because 
        //
        // <literal>11 = 1 * 2^3 + 0 * 2^2 + 1 * 2^1 + 0 * 2^0.</literal>
        //
        // Therefore <literal>d0 = 0, d1 = 1, d2 = 0, d3 = 1.</literal>
        // Then 
        //
        // <literal>r = 0 * 2^-1 + 1 * 2^-2 + 0 * 2^-3 + 1 * 2^-4 = 5/16.</literal>
        //
        // The digits of i are computed with an incremental process, by
        // using the remainder modulo b and dividing by <literal>b</literal>.
        // The digits are therefore computed in the order : d0, d1,..., dn.
        // The result <literal>r</literal> is initialized with value 0.
        // As they are computed, the terms <literal>di*b^(-i-1)</literal> are added to 
        // <literal>r</literal>.
        //
        // The terms <literal>ib = b^(-i-1)</literal>, called inversed basis (or inverse radix in 
        // Halton & Smith 1964 paper) are computed incrementally.
        // The inversed basis <literal>ib</literal> is initialized with value <literal>1/b = b^-1</literal>.
        // It is updated by division by <literal>b</literal>.
        //
        // This algorithm is also explained in :
        //
        //   http://orion.math.iastate.edu/reu/2001/voronoi/halton_sequence.html
        //
        // and used in :
        //
        //   https://people.scs.fsu.edu/~burkardt/m_src/van_der_corput/van_der_corput.html
        //
        // Examples
        // // See the algorithm
        // edit vandercorput
        //
        // vandercorput ( 0 , 2 ) // 0.0
        // vandercorput ( 1 , 2 ) // 0.5
        // vandercorput ( 2 , 2 ) // 0.25
        // vandercorput ( 3 , 2 ) // 0.75
        // vandercorput ( 4 , 2 ) // 0.125
        // vandercorput ( 5 , 2 ) // 0.625
        //
        // // See the terms 0 to 10 in base 2.
        // for i = 0 : 10
        //   s(i+1) = vandercorput ( i , 2 );
        // end
        // disp(s')
        //
        // // See the terms 0 to 10 in base 3.
        // for i = 0 : 10
        //   s(i+1) = vandercorput ( i , 3 );
        // end
        // disp(s')
        //
        // // Plot the terms 0 to 2^7 in base 2
        // scf();
        // for i = 0 : 2^7
        //   s = vandercorput ( i , 2 );
        //   plot ( s , i , "bo" ) ;
        // end
        // xtitle("Van Der Corput sequence","Index","Value");
        //
        // Authors
        //   Michael Baudin - 2008-2009 - INRIA
        //   Michael Baudin - 2010 - 2011 - DIGITEO
        //
        // Bibliography
        //    "Algorithm 247: Radical-Inverse Quasi-Random Point Sequence", J H Halton and G B Smith, Communications of the ACM, Volume 7, 1964, pages 701-702.

        if (b<2) then
            errmsg = msprintf ( gettext ( "%s: Unexpected basis" ) , "_vdc" , b)
            error(errmsg)
        end
        current = i
        ib = 1.0 / b
        r = 0.0
        while (current>0)
            digit = modulo ( current , b )
            current = int ( current / b )
            r = r + digit * ib
            ib = ib / b
        end
    endfunction

    function printExpected(expected)
        nrows=size(expected,"r")
        mprintf("Expected:\n");
        for i=1:nrows
            mprintf("#%d = [%s]\n",i,strcat(string(expected(i,:))," "))
        end
    endfunction

    // See the terms 0 to 10 in base 2.
    mprintf("Van Der Corput Base 2:\n")
    for i = 0 : 10
        x = vandercorput ( i , 2 );
        mprintf("#%d : %f\n",i,x)
    end
    expected=[
    0.0
    0.5
    0.25
    0.75
    0.125
    0.625
    0.375
    0.875
    0.0625
    0.5625
    0.3125
    ];
    printExpected(expected)

    // See the terms 0 to 10 in base 3.
    mprintf("Van Der Corput Base 3:\n")
    for i = 0 : 10
        x = vandercorput ( i , 3 );
        mprintf("#%d : %f\n",i,x)
    end

    // Plot the terms 0 to 2^7 in base 2
    scf();
    npoints=2^7;
    for i = 0 : npoints
        s = vandercorput ( i , 2 );
        plot ( s , i , "bo" ) ;
    end
    strtitle=msprintf("Van Der Corput : %d points",npoints)
    xtitle(strtitle,"Index","Value");

    //
    // Load this script into the editor
    //
    m = messagebox(_("View Code?"), "Question", "question", [_("Yes") _("No")], "modal")
    if(m == 1)
        filename = 'macros-vandercorput.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
    end
endfunction 
lowdisc_demosvdc();
clear lowdisc_demosvdc;
