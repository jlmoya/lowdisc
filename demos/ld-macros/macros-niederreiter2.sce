// Copyright (C) 2010 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2003 - John Burkardt
// Copyright (C) 1994 - Paul Bratley, Bennett Fox, Harald Niederreiter
//
//    This code is distributed under the GNU LGPL license.

function lowdisc_demosnied2()
    function [ cj,seed,nextq,recip] = nieder2startup(dimension,dimmax,nbits,maxe)
        // nieder2startup --
        // Startup Niederreiter base 2 sequence
        // 
        // Parameters
        //   dimension : the current dimension
        //   dimmax : the maximum dimension for the Niederreiter sequence. This is expected to be equal to 20, since no more that 20 polynomials are stored in the database.
        //   cj : the values of Niederreiter's C(I,J,R)
        //   seed : sequence number of this call. By default, seed  should be set to zero, i.e. we start from the 0-th element of the sequence. If elements of the sequence are to be skipped, set seed accordingly. 
        //   nextq : The numerators of the next item in the series.  These are like Niederreiter's XI(N) (page 54) except that N is implicit, and the NEXTQ are integers.  To obtain the values of XI(N), multiply by RECIP.
        //   recip : 1.0 / (Q ** NFIGS)
        //   nbits : the number of bits in a fixed-point integer, not counting the sign.
        //

        recip = 2^(-nbits)
        seed = 0
        //
        //  Calculate the C array.
        //
        cj(1:dimension,1:nbits) = niedercalcc2(dimension,dimmax,nbits,maxe)
        //
        //  Set up NEXTQ appropriately, depending on the Gray code of SEED.
        //
        //  You can do this every time, starting NEXTQ back at 0,
        //  or you can do it once, and then carry the value of NEXTQ
        //  around from the previous computation.
        //  Call to bitxor is vectorized.
        //
        gray = bitxor ( seed, seed / 2 )
        nextq(1:dimension) = 0
        r = 0
        while ( gray ~= 0 )
            if ( rem ( gray, 2 ) ~= 0 )
                nextq = bitxor ( nextq, cj(1 : dimension,r+1) )
            end
            gray = floor ( gray / 2 )
            r = r + 1
        end
    endfunction

    //  niedercalcc2 --
    //   computes the constants C(I,J,R).
    //
    //  Discussion:
    //    As far as possible, Niederreiter's notation is used.
    //
    //    For each value of I, we first calculate all the corresponding
    //    values of C.  These are held in the array CI.  All these
    //    values are either 0 or 1.
    //
    //    Next we pack the values into the
    //    array CJ, in such a way that CJ(I,R) holds the values of C
    //    for the indicated values of I and R and for every value of
    //    J from 1 to NBITS.  The most significant bit of CJ(I,R)
    //    (not counting the sign bit) is C(I,1,R) and the least
    //    significant bit is C(I,NBITS,R).
    //
    //  Licensing:
    //    This code is distributed under the GNU LGPL license.
    //
    //  Modified:
    //    30 March 2003
    //
    //  Author:
    //    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
    //    MATLAB version by John Burkardt
    //    Scilab version : 
    //       2009 - Digiteo - Michael Baudin
    //
    //  Reference:
    //    R Lidl and Harald Niederreiter,
    //    Finite Fields,
    //    Cambridge University Press, 1984, page 553.
    //
    //    Harald Niederreiter,
    //    Low-discrepancy and low-dispersion sequences,
    //    Journal of Number Theory,
    //    Volume 30, 1988, pages 51-70.
    //
    //  Parameters:
    //    Input, integer DIMEN, the dimension of the sequence to be generated.
    //
    //    Output, integer CJ(dimmax,0:NBITS-1), the packed values of
    //    Niederreiter's C(I,J,R)
    //
    //  Local Parameters:
    //
    //    Local, integer dimmax, the maximum dimension that will be used.
    //
    //    Local, integer MAXE we need dimmax irreducible polynomials over Z2.
    //    MAXE is the highest degree among these.
    //
    //    Local, integer MAXV, the maximum possible index used in V.
    //
    //    Local, integer NBITS, the number of bits (not counting the sign) in a
    //    fixed-point integer.
    //
    function cj = niedercalcc2(dimension,dimmax,nbits,maxe)
        maxv = nbits + maxe
        //
        //  Here we supply the coefficients and the
        //  degrees of the first dimmax irreducible polynomials over Z2.
        //
        irred_deg(1:dimmax) = ...
        [ 1, 1, 2, 3, 3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6 ]
        irred(1:dimmax,1:maxe+1) = [
        0 1 0 0 0 0 0 
        1 1 0 0 0 0 0
        1 1 1 0 0 0 0
        1 1 0 1 0 0 0
        1 0 1 1 0 0 0
        1 1 0 0 1 0 0
        1 0 0 1 1 0 0
        1 1 1 1 1 0 0
        1 0 1 0 0 1 0
        1 0 0 1 0 1 0
        1 1 1 1 0 1 0
        1 1 1 0 1 1 0
        1 1 0 1 1 1 0
        1 0 1 1 1 1 0
        1 1 0 0 0 0 1
        1 0 0 1 0 0 1
        1 1 1 0 1 0 1
        1 1 0 1 1 0 1
        1 0 0 0 0 1 1
        1 1 1 0 0 1 1
        ]
        //
        //  Prepare to work in Z2.
        //
        [ add, mul, sub ] = niedersetfld2 ( )
        for i = 1 : dimension
            //
            //  For each dimension, we need to calculate powers of an
            //  appropriate irreducible polynomial:  see Niederreiter
            //  page 65, just below equation (19).
            //
            //  Copy the appropriate irreducible polynomial into PX,
            //  and its degree into E.  Set polynomial B = PX ** 0 = 1.
            //  M is the degree of B.  Subsequently B will hold higher
            //  powers of PX.
            //
            e = irred_deg(i)
            px_deg = irred_deg(i)
            for j = 0 : e
                px(j+1) = irred(i,j+1)
            end
            b_deg = 0
            b(0+1) = 1
            //
            //  Niederreiter (page 56, after equation (7), defines two
            //  variables Q and U.  We do not need Q explicitly, but we do need U.
            //
            u = 0
            for j = 1 : nbits
                //
                //  If U = 0, we need to set B to the next power of PX
                //  and recalculate V.  This is done by subroutine CALCV2.
                //
                if ( u == 0 )
                    [ b_deg, b, v ] = niedercalcv2 ( maxv, px_deg, px, add, mul, sub, b_deg, b )
                end
                //
                //  Now C is obtained from V.  Niederreiter obtains A from V (page 65,
                //  near the bottom), and then gets C from A (page 56, equation (7)).
                //  However this can be done in one step.  Here CI(J,R) corresponds to
                //  Niederreiter's C(I,J,R).
                //
                for r = 0 : nbits-1
                    ci(j,r+1) = v(r+u+1)
                end
                //
                //  Increment U.
                //
                //  If U = E, then U = 0 and in Niederreiter's
                //  paper Q = Q + 1.  Here, however, Q is not used explicitly.
                //
                u = u + 1
                if ( u == e )
                    u = 0
                end
            end
            //
            //  The array CI now holds the values of C(I,J,R) for this value
            //  of I.  We pack them into array CJ so that CJ(I,R) holds all
            //  the values of C(I,J,R) for J from 1 to NBITS.
            //
            for r = 0 : nbits-1
                term = 0
                for j = 1 : nbits
                    term = 2 * term + ci(j,r+1)
                end
                cj(i,r+1) = term
            end
        end
    endfunction

    //  niedercalcv2 --
    //    calculates the constants V(J,R).
    //
    //  Discussion:
    //    This program calculates the values of the constants V(J,R) as
    //    described in the reference (BFN) section 3.3.  It is called from
    //    either CALCC or CALCC2.
    //    Polynomials stored as arrays have the coefficient of degree N
    //    in POLY(N+1).
    //    A polynomial which is identically 0 is given degree -1.
    //
    //  Licensing:
    //    This code is distributed under the GNU LGPL license.
    //
    //  Modified:
    //    31 March 2003
    //
    //  Author:
    //    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
    //    MATLAB version by John Burkardt
    //    Scilab version : 
    //       2009 - Digiteo - Michael Baudin
    //
    //  Reference:
    //    Paul Bratley, Bennett Fox, Harald Niederreiter,
    //    Algorithm 738:
    //    Programs to Generate Niederreiter's Low-Discrepancy Sequences,
    //    ACM Transactions on Mathematical Software,
    //    Volume 20, Number 4, pages 494-495, 1994.
    //
    //  Parameters:
    //    Input, integer MAXV gives the dimension of the array V.
    //    Input, integer PX_DEG, the degree of polynomial PX.
    //    Input, integer PX(PXDEG+1), the appropriate irreducible polynomial
    //    for the dimension currently being considered.  The degree of PX
    //    will be called E.
    //    Input, integer ADD(2,2), MUL(2,2), SUB(2,2), the addition, multiplication, 
    //    and subtraction tables, mod 2.
    //    Input, integer B_DEG, the degree of the polynomial B.
    //    Input, integer B(B_DEG+1), the polynomial defined in section 2.3 of BFN.  
    //    The degree of B implicitly define the parameter J of section 3.3, 
    //    by degree(B) = E*(J-1).  On output,
    //    B has been multiplied by PX, so its degree is now E * J.
    //    Output, integer PC_DEG, the degree of the polynomial C = B * PX.
    //    Output, integer PC(PC_DEG+1), the polynomial C = B * PX.
    //    Output, integer V(MAXV+1), the computed V array.
    //
    //  Local Parameters:
    //    Local, integer ARBIT, indicates where the user can place
    //    an arbitrary element of the field of order 2.  This means
    //    0 <= ARBIT < 2.
    //    Local, integer BIGM, is the M used in section 3.3.
    //    It differs from the [little] m used in section 2.3,
    //    denoted here by M.
    //    Local, integer NONZER, shows where the user must put an arbitrary
    //    non-zero element of the field.  For the code, this means
    //    0 < NONZER < 2.
    //
    function [ pc_deg, pc, v ] = niedercalcv2 ( maxv, px_deg, px, add, mul, sub, b_deg, b )
        arbit = 1
        nonzer = 1
        e = px_deg
        //
        //  The polynomial B is PX**(J-1).
        //
        //  In section 3.3, the values of Hi are defined with a minus sign:
        //  don't forget this if you use them later!
        //
        bigm = b_deg
        //
        //  Multiply B by PX to compute PC = PX**J.
        //  In section 2.3, the values of Bi are defined with a minus sign:
        //  don't forget this if you use them later!
        //
        [ pc_deg, pc ] = niederplymul2 ( add, mul, px_deg, px, b_deg, b )
        m = pc_deg
        //
        //  We don't use J explicitly anywhere, but here it is just in case.
        //
        j = m / e
        //
        //  Now choose a value of Kj as defined in section 3.3.
        //  We must have 0 <= Kj < E*J = M.
        //  The limit condition on Kj does not seem very relevant
        //  in this program.
        //
        kj = bigm
        //
        //  Choose values of V in accordance with the conditions in section 3.3.
        //
        for r = 0 : kj-1
            v(r+1) = 0
        end
        v(kj+1) = 1
        if ( kj < bigm )
            term = sub ( 0+1, b(kj+1)+1 )
            //
            //  Check the condition of section 3.3,
            //  remembering that the B's have the opposite sign.
            //
            for r = kj+1 : bigm-1
                v(r+1) = arbit
                term = sub ( term+1, mul ( b(r+1)+1, v(r+1)+1 )+1 )
            end
            //
            //  Now V(BIGM) is anything but TERM.
            //
            v(bigm+1) = add ( nonzer+1, term+1 )
            for r = bigm+1 : m-1
                v(r+1) = arbit
            end
        else
            for r = kj+1 : m-1
                v(r+1) = arbit
            end
        end
        //
        //  Calculate the remaining V's using the recursion of section 2.3,
        //  remembering that the PC's have the opposite sign.
        //
        for r = 0 : maxv-m
            term = 0
            for i = 0 : m-1
                term = sub ( term+1, mul ( pc(i+1)+1, v(r+i+1)+1 )+1 )
            end
            v(r+m+1) = term
        end
    endfunction
    // niederplymul2 --
    //    multiplies two polynomials in the field of order 2.
    //
    //  Discussion:
    //    Polynomials stored as arrays have the coefficient of 
    //    degree N in POLY(N+1).
    //    A polynomial which is identically 0 is given degree -1.
    //
    //  Licensing:
    //    This code is distributed under the GNU LGPL license.
    //
    //  Modified:
    //    30 March 2003
    //
    //  Author:
    //
    //    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
    //    MATLAB version by John Burkardt
    //
    //  Parameters:
    //    Input, integer ADD(2,2), MUL(2,2), the addition and multiplication 
    //    tables, mod 2.
    //    Input, integer PA_DEG, the degree of polynomial A.
    //    Input, integer PA(PA_DEG+1), the coefficients of polynomial A.
    //    Input, integer PB_DEG, the degree of polynomial B.
    //    Input, integer PB(PB_DEG+1), the coefficients of polynomial B.
    //    Output, integer PC_DEG, the degree of polynomial C.
    //    Output, integer PC(PC_DEG+1), the product polynomial, C = A * B mod 2.
    //
    function [ pc_deg, pc ] = niederplymul2 ( add, mul, pa_deg, pa, pb_deg, pb )
        if ( pa_deg == -1 | pb_deg == -1 )
            pc_deg = -1
        else
            pc_deg = pa_deg + pb_deg
        end
        for i = 0 : pc_deg
            term = 0
            for j = max ( 0, i-pa_deg ) : min ( pb_deg, i )
                term = add ( term+1, mul ( pa(i-j+1)+1, pb(j+1)+1 ) + 1 )
            end
            ptn(i+1) = term
        end
        for i = 0 : pc_deg
            pc(i+1) = ptn(i+1)
        end
    endfunction
    //  niedersetfld2 --
    //     sets up arithmetic tables for the finite field of order 2.
    //
    //  Discussion:
    //    SETFLD2 sets up addition, multiplication, and subtraction tables
    //    for the finite field of order 2.
    //
    //  Licensing:
    //    This code is distributed under the GNU LGPL license.
    //
    //  Modified:
    //    30 March 2003
    //
    //  Author:
    //    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
    //    MATLAB version by John Burkardt
    //
    //  Parameters:
    //    Input, integer DUMMY, a dummy argument.
    //    Output, integer ADD(2,2), MUL(2,2), SUB(2,2), the addition, 
    //    multiplication, and subtraction tables, mod 2.
    //
    function [ add, mul, sub ] = niedersetfld2 ( )
        q = 2
        p = 2
        for i = 0 : 1
            for j = 0 : 1
                add(i+1,j+1) = modulo ( i + j , p )
            end
        end
        for i = 0 : 1
            for j = 0 : 1
                mul(i+1,j+1) = modulo ( i * j, p )
            end
        end
        for i = 0 : 1
            for j = 0 : 1
                sub(add(i+1,j+1)+1, i+1) = j
            end
        end
    endfunction


    function [seed,nextq]=nieder2skip(dimension,cj,nextq,seed,nbits,skip )
        // nieder2skip
        //   Discard (i.e. ignore) skip elements in the sequence.
        //   The only difference with next is that we do not generate the quasi vector.
        // Parameters
        //   dimension : the current dimension
        //   cj : the values of Niederreiter's C(I,J,R)
        //   seed : sequence number of this call. By default, seed  should be set to zero, i.e. we start from the 0-th element of the sequence. If elements of the sequence are to be skipped, set seed accordingly. 
        //   nextq : The numerators of the next item in the series.  These are like Niederreiter's XI(N) (page 54) except that N is implicit, and the NEXTQ are integers.  
        //   nbits : the number of bits in a fixed-point integer, not counting the sign.

        for i = 1 : skip
            //
            //  Find the position of the right-hand zero in SEED.  This
            //  is the bit that changes in the Gray-code representation as
            //  we go from SEED to SEED+1.
            //  TODO : vectorize this
            //
            r = bitlo0 ( seed ) - 1
            //
            //  Check that we have not passed 2**NBITS calls.
            //
            if ( nbits <= r )
                error ( msprintf ( gettext ( "%s: Too many calls" ) , "nextnieder2" ) )
            end
            //
            //  Compute the new numerators in vector NEXTQ.
            //  Call to bitxor is vectorized.
            //
            nextq = bitxor ( nextq, cj(1 : dimension,r+1) )
            seed = seed + 1
        end
    endfunction

    function [dimmax,nbits,nbsimmax,maxe]=nied2parameters()
        //
        // Parameters of the algorithm
        //
        // Maximum number of dimensions
        dimmax = 20
        // Number of bits in the representation
        nbits = 31
        // Number maximum of simulations
        nbsimmax = 2^(nbits) - 1
        maxe = 6
    endfunction
    // nextnieder2 --
    //  Returns an element of the Niederreiter sequence base 2.
    //
    //  Licensing:
    //    This code is distributed under the GNU LGPL license.
    //
    //  Modified:
    //    31 March 2003
    //
    //  Author:
    //    Original FORTRAN77 version by Paul Bratley, Bennett Fox, Harald Niederreiter.
    //    MATLAB version by John Burkardt
    //    Scilab version : 
    //       2009 - Digiteo - Michael Baudin
    //
    //  Reference:
    //    Harald Niederreiter,
    //    Low-discrepancy and low-dispersion sequences,
    //    Journal of Number Theory,
    //    Volume 30, 1988, pages 51-70.
    //
    //    "Algorithm 738: Programs to generate Niederreiter's low-discrepancy
    //    sequences", P. Bratley, B. L. Fox, and H. Niederreiter, 1994. ACM Trans.
    //    Math. Softw. 20, 4 (Dec. 1994), 494-495.
    //
    //  Parameters:
    //    Input, integer DIM, the dimension of the sequence to be generated.
    //    Input, integer SEED, the index of the element to compute.
    //    Output, real QUASI(DIM), the next quasirandom vector.
    //    Output, integer SEED_NEW, the next value of the SEED.
    //
    //  Local Parameters:
    //    Local, integer MAXDIM, the maximum dimension that will be used.
    //    Local, integer NBITS, the number of bits (not counting the sign) in a
    //    fixed-point integer.
    //    Local, real RECIP is the multiplier which changes the
    //    integers in NEXTQ into the required real values in QUASI.
    //    Local, integer cj(MAXDIM,NBITS), the packed values of
    //    Niederreiter's C(I,J,R).
    //    Local, integer NR_dim, the spatial dimension of the sequence
    //    as specified on an initialization call.
    //    Local, integer nextq(MAXDIM), the numerators of the next item in the
    //    series.  These are like Niederreiter's XI(N) (page 54) except that
    //    N is implicit, and the nextq are integers.  To obtain
    //    the values of XI(N), multiply by RECIP.
    //
    function [seed,nextq,quasi]=nextnieder2(dimension,cj,nextq,seed,recip,nbits)
        //
        //  Multiply the numerators in NEXTQ by RECIP to get the next
        //  quasi-random vector.
        //
        quasi(1:dimension) = nextq(1:dimension) * recip
        //
        //  Find the position of the right-hand zero in SEED.  This
        //  is the bit that changes in the Gray-code representation as
        //  we go from SEED to SEED+1.
        //
        r = bitlo0 ( seed ) - 1
        //
        //  Check that we have not passed 2**NBITS calls.
        //
        if ( nbits <= r )
            error ( msprintf ( gettext ( "%s: Too many calls" ) , "nextnieder2" ) )
        end
        //
        //  Compute the new numerators in vector NEXTQ.
        //  Call to lowdisc_bitxor is vectorized.
        //
        nextq = bitxor ( nextq, cj(1 : dimension,r+1) )
        seed = seed + 1
    endfunction

    path=lowdisc_getpath();
    exec(fullfile(path,"demos","ld-macros","bithi1.sci"));
    exec(fullfile(path,"demos","ld-macros","bitlo0.sci"));

    function printExpected(expected)
        nrows=size(expected,"r")
        mprintf("Expected:\n");
        for i=1:nrows
            mprintf("#%d = [%s]\n",i,strcat(string(expected(i,:))," "))
        end
    endfunction

    //
    // Test the sequence
    //
    //
    // Check the Niederreiter base 2 sequence, in 2 dimensions
    //
    dimension=2;
    [dimmax,nbits,nbsimmax,maxe]=nied2parameters();
    [cj,seed,nextq,recip]=nieder2startup(dimension,dimmax,nbits,maxe);
    // Terms #1 to #6
    mprintf("Niederreiter base 2:\n")
    for i=1:6
        [seed,nextq,quasi]=nextnieder2(dimension,cj,nextq,seed,recip,nbits);
        mprintf("#%d = [%s]\n",i,strcat(string(quasi)," "))
    end
    expected= [
    0.    0. 
    1./2. 1./2. 
    3./4. 1./4. 
    1./4. 3./4. 
    3./8. 3./8. 
    7./8. 7./8. 
    ];
    printExpected(expected);

    //
    // Check the Niederreiter base 2 sequence in dimension 4
    //
    dimension=4;
    [dimmax,nbits,nbsimmax,maxe]=nied2parameters();
    [cj,seed,nextq,recip]=nieder2startup(dimension,dimmax,nbits,maxe);
    // Term #1-12
    mprintf("Niederreiter base 2:\n")
    for i=1:12
        [seed,nextq,quasi]=nextnieder2(dimension,cj,nextq,seed,recip,nbits);
        mprintf("#%d = [%s]\n",i,strcat(string(quasi)," "))
    end
    expected = [
    0.000000  0.000000  0.000000  0.000000
    0.500000  0.500000  0.750000  0.875000
    0.750000  0.250000  0.312500  0.140625
    0.250000  0.750000  0.562500  0.765625
    0.375000  0.375000  0.875000  0.281250
    0.875000  0.875000  0.125000  0.656250
    0.625000  0.125000  0.687500  0.421875
    0.125000  0.625000  0.437500  0.546875
    0.187500  0.312500  0.515625  0.687500
    0.687500  0.812500  0.265625  0.312500
    0.937500  0.062500  0.828125  0.578125
    0.437500  0.562500  0.078125  0.453125
    ];
    printExpected(expected);
    // Drop terms 12-94
    skip=94-12+1;
    [seed,nextq]=nieder2skip(dimension,cj,nextq,seed,nbits,skip);
    // Terms #95 - 110
    mprintf("Niederreiter base 2:\n")
    for i=1:110-95+1
        [seed,nextq,quasi]=nextnieder2(dimension,cj,nextq,seed,recip,nbits);
        mprintf("#%d = [%s]\n",i,strcat(string(quasi)," "))
    end
    expected= [
    0.054688  0.929688  0.101563  0.509766
    0.039063  0.132813  0.464844  0.214844
    0.539063  0.632813  0.714844  0.839844
    0.789063  0.382813  0.152344  0.074219
    0.289063  0.882813  0.902344  0.949219
    0.414063  0.257813  0.589844  0.496094
    0.914063  0.757813  0.339844  0.621094
    0.664063  0.007813  0.777344  0.355469
    0.164063  0.507813  0.027344  0.730469
    0.226563  0.445313  0.949219  0.527344
    0.726563  0.945313  0.199219  0.402344
    0.976563  0.195313  0.636719  0.636719
    0.476563  0.695313  0.386719  0.261719
    0.351563  0.070313  0.074219  0.808594
    0.851563  0.570313  0.824219  0.183594
    0.601563  0.320313  0.261719  0.917969
    ];
    printExpected(expected);

    //
    // Plot the Niederreiter base 2 sequence, in 2 dimensions
    dimension=2;
    nbpoints=2^7;
    [dimmax,nbits,nbsimmax,maxe]=nied2parameters();
    [cj,seed,nextq,recip]=nieder2startup(dimension,dimmax,nbits,maxe);
    next=[];
    for i=1:nbpoints
        [seed,nextq,quasi]=nextnieder2(dimension,cj,nextq,seed,recip,nbits);
        next(i,:)=quasi';
    end
    //
    scf();
    plot ( next(:,1) , next(:,2) , "bo" )
    strtitle=msprintf("Niederreiter (base 2) : %d points",nbpoints)
    xtitle(strtitle,"X1","X2");

    //
    // Load this script into the editor
    //
    m = messagebox(_("View Code?"), "Question", "question", [_("Yes") _("No")], "modal")
    if(m == 1)
        filename = 'macros-niederreiter2.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
    end
endfunction

lowdisc_demosnied2();
clear lowdisc_demosnied2;
