// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

function lowdisc_haltonRR2()

    // Reference
    // L. Kocis and W. Whiten. Computational investigations of 
    // low discrepancy sequences.
    // ACM Trans. Mathematical Software, 23:266–294, 1997.

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

    // Reference
    // Generalized Halton Sequences in 2008: 
    // A Comparative Study
    // HENRI FAURE
    // CHRISTIANE LEMIEUX
    // 3. OVERVIEW OF PROPOSED GENERALIZED HALTON SEQUENCES
    // (1) KW [Kocis and Whiten 1997]:
    // For instance, take s = 3. 
    // Then n3 = ceil(log 5/log 2) = 3
    // and so σ corresponds to the permutation [0,4,2,6,1,5,3,7]. 
    // Hence σ1 corresponds to [0,1], σ2 to [0,2,1] 
    // and σ3 to [0,4,2,1,3].
    // [Note From MB : fixed error in the permutation - switched 
    // 5 and 3].

    function sigma=RR2Scrambling(s,i,b)
        // Compute Kocis Whiten Scrambling 
        // for dimension i, with 1<=i<=s
        ns=ceil(log(b(s))/log(2))
        sigma=[];
        for k=1:2^ns
            sigmak=vandercorput(k-1,2)*2^ns
            if (sigmak<b(i)) then
                sigma($+1)=sigmak;
            end
        end
    endfunction

    function r = scrambleVDC(index,b,sigma)
        //   Returns the index-th term of a scrambled 
        // Van Der Corput sequence in base b.
        current = index
        ib = 1.0 / b
        r = 0.0
        while (current>0)
            digit = modulo ( current , b )
            digit=sigma(digit+1)
            current = int ( current / b )
            r = r + digit * ib
            ib = ib / b
        end
    endfunction

    //
    // Print scrambling
    //
    mprintf("RR2 Scrambling - s=3:\n")
    s=3;
    primemat=number_primes100();
    b=primemat(1:s)
    for i=1:s
        sigma=RR2Scrambling(s,i,b);
        disp(sigma')
    end

    // Scrambled VDC in base 3
    mprintf("Scrambled VDC in base 3\n")
    sigma=[0,2,1];
    b=3;
    for index=1:10
        r = scrambleVDC(index,b,sigma);
        mprintf("index=%d, r=%f\n",index,r)
    end
    // Scrambled VDC in base 5
    mprintf("Scrambled VDC in base 5\n")
    sigma=[0,4,2,1,3];
    b=5;
    for index=1:10
        r = scrambleVDC(index,b,sigma);
        mprintf("index=%d, r=%f\n",index,r)
    end
    // Scrambled Halton in dimension 3
    mprintf("Scrambled Halton in dimension 3\n")
    s=3;
    primemat=number_primes100();
    b=primemat(1:s)
    x=[];
    for index=1:10
        for i=1:s
            sigma=RR2Scrambling(s,i,b);
            x(index,i)=scrambleVDC(index,b(i),sigma);
        end
    end
    disp(x)

    // Reference
    // "Simulation Estimation of Mixed Discrete Choice Models 
    // Using Randomized and Scrambled Halton Sequences"
    // Chandra R. Bhat
    // 2.2 The Scrambled Halton sequence
    // An example would be helpful in illustrating the 
    // scrambling procedure of Braaten and Weller. 
    // These researchers suggest the following permutation 
    // of (0,1,2) for the prime 3: (0,2,1). 
    // As indicated earlier, the 5th number in base 3 of 
    // the Halton sequence in digitized form is 0.21. 
    // When the permutation above is applied, the 5th 
    // number in the corresponding scrambled Halton sequence 
    // in digitized form is 0.12 [Note from MB : fixed error in 
    // the text], which when expanded in base 3 translates to 
    // 1/3+2/9=5/9. 
    // The first 8 numbers in the scrambled sequence corresponding 
    // to base 3 are 2/3, 1/3, 2/9, 8/9, 5/9, 1/9, 7/9, 4/9. 
    //   0.6666667  
    //   0.3333333  
    //   0.2222222  
    //   0.8888889  
    //   0.5555556  
    //   0.1111111  
    //   0.7777778  
    //   0.4444444  

    //
    // Load this script into the editor
    //
        filename = 'macros-halton-RR2.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
endfunction 
lowdisc_haltonRR2();
clear lowdisc_haltonRR2;

