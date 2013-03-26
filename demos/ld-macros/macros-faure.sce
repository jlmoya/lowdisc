// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

//
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman

function lowdisc_demosfaure()

    //
    // faurenext --
    //   Returns the next term of the Faure sequence
    //
    // Parameters
    //   dimension : the number of variables
    //   index : the number of the element in the sequence
    //   basis : the basis used in the sequence
    //   next : the n x 1 vector of elements
    //
    // Examples
    //   faurenext ( 3 , 4 , 3 ) = [4/9 7/9 1/9]'
    //
    // Description
    //   This implementation is not protected against overflow.
    //   Practically, we did not experience any problem with 
    //   that specific issue.
    //   If that point was being an issue, we could use
    //   as in TOMS 647, the Faure matrix modulo the basis.
    //   To do this, it suffices to pass the basis to the fauremat
    //   function and to use binomialmod instead of binomial.
    //
    // References
    //   Monte-Carlo methods in Financial Engineering, Paul Glasserman
    //
    function next = faurenext(dimension,index,basis)
        digits = number_tobary ( index , basis , "bigendian" )
        r = size ( digits , "r" )
        // Compute a vector made of 1/b, 1/b^2, etc...
        ib = 1.0/basis
        for i = 1:r
            bpwrs(i) = ib
            ib = ib / basis
        end
        // Compute the element #index in the sequence
        for idim = 1 : dimension
            ci = faurematrix ( r , idim - 1 )
            y = ci * digits
            ymodb = modulo ( y , basis )
            // Compute the dimension #idim of element
            next(idim) = ymodb' * bpwrs
        end
    endfunction
    //
    // faurematrix --
    //   Returns the Faure generator rxr matrix C(i).
    // Arguments
    //   r : the number of digits in the base-b expansion of k
    //   i : the index of the coordinate of the point in the sequence,
    //       with i= 1,d and d is the dimension
    //   basis : the basis to use 
    //     The binomial coefficients are computed modulo basis
    // References
    //   Monte-Carlo methods in Financial Engineering, Paul Glasserman
    // Note
    //   If i = 1, we get the Upper Triangular Pascal matrix.
    // Test : 
    // faurematrix(3,2) 
    // expected = [
    //   1 2 4
    //   0 1 4
    //   0 0 1
    // ]
    // faurematrix(2,1) 
    // expected = [
    //   1 1
    //   0 1
    // ]
    // faurematrix(2,2) 
    // expected = [
    //   1 2 
    //   0 1
    // ]
    // faurematrix(5,1)
    // expected = [
    //     1.    1.    1.    1.    1.                        
    //     0.    1.    2.    3.    4.  
    //     0.    0.    1.    3.    6.  
    //     0.    0.    0.    1.    4.  
    //     0.    0.    0.    0.    1.                        
    // ];
    // faurematrix(5,2)
    // expected = [
    //    1    2    4    8     16  
    //    0    1    4    12    32  
    //    0    0    1    6     24  
    //    0    0    0    1     8   
    //    0    0    0    0     1   
    // ];
    //
    function c = faurematrix ( r , i )
        c = zeros(r,r)
        for m = 1:r
            b=specfun_nchoosek ((m:r)-1 , m-1)
            c(m,m:r) = i.^((m:r)-m) .* b
        end
    endfunction

    function printExpected(expected)
        nrows=size(expected,"r")
        mprintf("Expected:\n");
        for i=1:nrows
            mprintf("#%d = [%s]\n",i,strcat(string(expected(i,:))," "))
        end
    endfunction

    // This makes the component available up to dimension 100
    primeslist = number_primes100 ( );
    primessize = size(primeslist,"c");
    // Maximum number of simulations
    nbsimmax = 2^52 - 1;

    //
    // Check the Faure sequence in dimension 3
    //
    dimension=3;
    k=find(primeslist>= dimension,1);
    basis=primeslist(k);
    mprintf("Faure:\n")
    for index=0:8
        next = faurenext(dimension,index,basis);
        mprintf("#%d = [%s]\n",index,strcat(string(next)," "))
    end
    expected= [
    0 0 0
    1/3 1/3 1/3
    2/3 2/3 2/3 
    1/9 4/9 7/9 
    4/9 7/9 1/9 
    7/9 1/9 4/9 
    2/9 8/9 5/9 
    5/9 2/9 8/9 
    8/9 5/9 2/9
    ];
    printExpected(expected);

    //
    // Compare the results against the data extracted from 
    // the TOMS 647 program.
    // Skip basis^4-1 terms, as in TOMS implementation
    // See the skip option.
    //
    mprintf("Faure:\n")
    dimension=3;
    k=find(primeslist>= dimension,1);
    basis=primeslist(k);
    i=basis^4-2;
    for index=i+1:i+7
        next = faurenext(dimension,index,basis);
        mprintf("#%d = [%s]\n",index,strcat(string(next)," "))
    end
    expected = [
    0.987654      0.765432      0.209877
    0.004115      0.460905      0.584362
    0.337449      0.794239      0.917696
    0.670782      0.127572      0.251029
    0.115226      0.905350      0.028807
    0.448560      0.238683      0.362140
    0.781893      0.572016      0.695473
    ];
    printExpected(expected);

    //
    // Plot the point set
    nbpoints=2^7;
    dimension=2;
    k=find(primeslist>= dimension,1);
    basis=primeslist(k);
    for index = 0 : nbpoints
        quasi=faurenext(dimension,index,basis);
        next(index+1,1:dimension) = quasi';
    end
    scf();
    plot ( next(:,1) , next(:,2) , "bo" )
    strtitle=msprintf("Faure : %d points",nbpoints)
    xtitle(strtitle,"X1","X2");
    //
    // Load this script into the editor
    //
    m = messagebox(_("View Code?"), "Question", "question", [_("Yes") _("No")], "modal")
    if(m == 1)
        filename = 'macros-faure.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
    end

endfunction 
lowdisc_demosfaure();
clear lowdisc_demosfaure;


