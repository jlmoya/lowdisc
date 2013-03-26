// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function lowdisc_demoshalton()

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
        // Authors
        //   Michael Baudin - 2008-2009 - INRIA
        //   Michael Baudin - 2010 - 2011 - DIGITEO

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

    function next = haltonnext ( dimension , index , primemat )
        // Returns the next element of the Halton sequence.
        //
        // Calling Sequence
        //   next = haltonnext ( dimension , index , primemat )
        //
        // Parameters
        //   dimension : a 1-by-1 matrix of floating point integers, the number of variables
        //   index : a 1-by-1 matrix of floating point integers, the index of the element in the sequence
        //   primemat : a 1-by-1 matrix of floating point integers, a matrix of consecutive primes, in increasing order
        //   next : a 1-by-1 matrix of doubles, the next element in the sequence, in the [0,1) interval
        //
        // Description
        //   Generates the next element of the Halton sequence.
        //
        // Examples
        // // See the source code
        // edit haltonnext
        // 
        // // Get a matrix of 100 primes
        // primemat = number_primes100 ( );
        // dimension = 2;
        // // Generate element #0 of the Halton sequence in dimension 2
        // next = haltonnext ( dimension , 0 , primemat )
        // // Generate element #1 of the Halton sequence in dimension 2
        // next = haltonnext ( dimension , 1 , primemat )
        // // Generate element #2 of the Halton sequence in dimension 2
        // next = haltonnext ( dimension , 2 , primemat )
        // // Generate some elements 
        // for i = 0 : 2^7-1
        //   next(i+1,1:dimension) = haltonnext ( dimension , i , primemat );
        // end
        // // Plot them
        // scf();
        // plot ( next(:,1) , next(:,2) , "bo" )
        // xtitle("Halton point set","X1","X2");
        //
        // Authors
        //   Michael Baudin - 2008-2009 - INRIA
        //   Michael Baudin - 2010 - DIGITEO
        //
        // Bibliography
        //    "Algorithm 247: Radical-Inverse Quasi-Random Point Sequence", J H Halton and G B Smith, Communications of the ACM, Volume 7, 1964, pages 701-702.

        next = zeros(1:dimension)
        for idim = 1 : dimension
            basis = primemat ( idim )
            next(idim) = vandercorput ( index , basis )
        end
    endfunction

    function printExpected(expected)
        nrows=size(expected,"r")
        mprintf("Expected:\n");
        for i=1:nrows
            mprintf("#%d = [%s]\n",i,strcat(string(expected(i,:))," "))
        end
    endfunction

    // Get a matrix of 100 primes
    primemat = number_primes100 ( );
    dimension = 2;
    // Generate some elements
    mprintf("Halton:\n")
    for i = 0 : 6
        quasi=haltonnext ( dimension , i , primemat );
        next(i+1,1:dimension) = quasi;
        mprintf("#%d = [%s]\n",i,strcat(string(quasi)," "))
    end
    expected= [
    0.  0.
    0.5 1./3.
    1/4 2/3 
    3/4 1/9    
    1/8 4/9 
    5/8 7/9 
    3/8 2/9 
    ];
    printExpected(expected);

    //
    // Plot the point set
    nbpoints=2^7;
    for i = 0 : nbpoints
        quasi=haltonnext ( dimension , i , primemat );
        next(i+1,1:dimension) = quasi;
    end
    scf();
    plot ( next(:,1) , next(:,2) , "bo" )
    strtitle=msprintf("Halton : %d points",nbpoints)
    xtitle(strtitle,"X1","X2");
    //
    // Load this script into the editor
    //
    m = messagebox(_("View Code?"), "Question", "question", [_("Yes") _("No")], "modal")
    if(m == 1)
        filename = 'macros-halton.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
    end
endfunction 
lowdisc_demoshalton();
clear lowdisc_demoshalton;

