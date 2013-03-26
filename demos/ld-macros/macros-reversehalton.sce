// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

// References
//
// "Good permutations for deterministic scrambled Halton 
// sequences in terms of L2-discrepancy", 
// B. Vandewoestyne and R. Cools, Computational and 
// Applied Mathematics 189, 2006
//
// "Gnu Scientific Library, The Reverse Halton Sequence", 
// Olivier Teytaud, 2007

function lowdisc_demosrevhalton()

    //
    // reversehalton --
    //   Returns the next value of the reverse Halton
    //   sequence.
    // Parameters
    //   dimension : the number of variables
    //   index : the index of the element in the sequence
    //   primelist : a matrix of consecutive prime numbers, in increasing order
    //
    function next = reversehalton ( dimension , index , primelist )
        next = zeros(1:dimension);
        for idim=1:dimension
            basis = primelist ( idim );
            next(idim) = vdcinv ( index , basis )
        end
    endfunction
    //
    // vdcinv --
    //   Returns the term #i of the inverted Van Der Corput low discrepancy sequence in 
    //   given basis.
    // Arguments, input
    //   i : the index in the sequence
    //   basis : the basis of the sequence
    // Arguments, output
    //   result : the next element in the sequence, uniform in [0,1]
    //
    function result = vdcinv ( i , basis )
        current = i;
        ib = 1.0 / basis;
        result = 0.0;
        while (current>0)
            digit = modulo ( current , basis );
            current = int ( current / basis );
            if ( digit <> 0 ) then
                result = result + ( basis - digit ) * ib;
            end
            ib = ib / basis;
        end
    endfunction

    function printExpected(expected)
        nrows=size(expected,"r")
        mprintf("Expected:\n");
        for i=1:nrows
            mprintf("#%d = [%s]\n",i,strcat(string(expected(i,:))," "))
        end
    endfunction

    // This makes the sequence available up to dimension 100
    primelist = number_primes100 ( );
    //
    // Maximum number of elements in the sequence
    nbsimmax = 2^52 - 1;
    //
    // Check the Reverse Halton sequence
    //
    dimension=2;
    // Terms #1-7
    mprintf("Reverse Halton:\n")
    for index=0:6
        next = reversehalton ( dimension , index , primelist );
        mprintf("#%d = [%s]\n",index,strcat(string(next)," "))
    end
    expected= [
    0.    0. 
    0.5   2./3.
    1./4. 1./3. 
    3./4. 2./9. 
    1./8. 8./9. 
    5./8. 5./9.
    3./8. 1./9. 
    ];
    printExpected(expected);

    // test in dimension 3 */
    dimension=3;
    // Terms #1-7
    mprintf("Reverse Halton:\n")
    for index=0:6
        next = reversehalton ( dimension , index , primelist );
        mprintf("#%d = [%s]\n",index,strcat(string(next)," "))
    end
    expected= [
    0.    0.    0.
    0.5   2./3. 0.8
    1./4. 1./3. 0.6
    3./4. 2./9. 0.4
    1./8. 8./9. 0.2
    5./8. 5./9. 0.16
    3./8. 1./9. 0.96
    ];
    printExpected(expected);

    // test skip
    dimension=3;
    mprintf("Reverse Halton:\n")
    for index=11:15
        next = reversehalton ( dimension , index , primelist );
        mprintf("#%d = [%s]\n",index,strcat(string(next)," "))
    end
    expected = [
    0.8125       0.4074074    0.92   
    0.1875       0.2962963    0.72   
    0.6875       0.9629630    0.52   
    0.4375       0.6296296    0.32   
    0.9375       0.1851852    0.08   
    ];
    printExpected(expected);
    //
    // Plot the Reverse Halton
    dimension=2;
    nbpoints=2^7;
    next=[];
    for i=1:nbpoints
        quasi = reversehalton ( dimension , i , primelist );
        next(i,:)=quasi;
    end
    //
    scf();
    plot ( next(:,1) , next(:,2) , "bo" )
    strtitle=msprintf("Reverse Halton : %d points",nbpoints)
    xtitle(strtitle,"X1","X2");
    //
    // Load this script into the editor
    //
    m = messagebox(_("View Code?"), "Question", "question", [_("Yes") _("No")], "modal")
    if(m == 1)
        filename = 'macros-reversehalton.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
    end

endfunction
lowdisc_demosrevhalton();
clear lowdisc_demosrevhalton;
