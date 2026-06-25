// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2005-2009 - John Burkardt
// Copyright (C) 1986 - Bennett Fox

// This file must be used under the terms of the GNU LGPL license.

function lowdisc_demossobol()

    function [ v , maxcol , lastq , count , recipd ] = sobolstart ( dim_num )
        // Initialize the Sobol sequence.
        //
        // Calling Sequence
        //   [ v , maxcol , lastq , count , recipd ] = sobolstart ( dim_num )
        // 
        // Parameters
        //   dim_num : a 1-by-1 matrix of floating point integers, the current number of dimensions. We expect to have 1<= dim_num<= 40, since no more that 40 polynomials are stored in the database.
        //   v : a dimmax-by-logmax matrix of floating point integers, table of direction numbers. We have <literal>dimmax = 40</literal> and <literal>logmax = 30</literal>. Each row corresponds to a primitive polynomial. The numbers in <literal>v</literal> are actually binary fractions.
        //   maxcol : a 1-by-1 matrix of floating point integers, number of bits in atmost
        //   lastq : a dim_num-by-1 matrix of floating point integers, the numerators of the last vector generated
        //   count : a 1-by-1 matrix of floating point integers, the index of the element in the sequence
        //   recipd : a 1-by-1 matrix of doubles, (1/denominator) for the numerators <literal>lastq</literal>
        //
        // Description
        //   Returns the initial data for use in a Sobol sequence.
        //
        //   In the algorithm, the variable atmost is the maximum number of calls to the generator.
        //   We have 
        //
        //   <literal>atmost = 2^logmax - 1</literal> 
        //
        //   with <literal>logmax = 30</literal>.
        //   This leads to atmost = 1.074 x 10^9.
        //
        //   This routine is designed to be used with the <literal>sobolnext</literal> 
        //   and <literal>sobolskip</literal> functions.
        //
        // Authors
        // Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
        // Copyright (C) 2008-2009 - INRIA - Michael Baudin
        // Copyright (C) 2005-2009 - John Burkardt
        // Copyright (C) 1986 - Bennett Fox

        dimmax = 40
        logmax = 30
        //
        //  Initialize (part of) V.
        //
        v(1:dimmax,1:logmax) = zeros(dimmax,logmax)
        v(1:40,1) = [ ...
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1 ]'
        v(3:40,2) = [ ...
        1, 3, 1, 3, 1, 3, 3, 1, ...
        3, 1, 3, 1, 3, 1, 1, 3, 1, 3, ...
        1, 3, 1, 3, 3, 1, 3, 1, 3, 1, ...
        3, 1, 1, 3, 1, 3, 1, 3, 1, 3 ]'
        v(4:40,3) = [ ...
        7, 5, 1, 3, 3, 7, 5, ...
        5, 7, 7, 1, 3, 3, 7, 5, 1, 1, ...
        5, 3, 3, 1, 7, 5, 1, 3, 3, 7, ...
        5, 1, 1, 5, 7, 7, 5, 1, 3, 3 ]'
        v(6:40,4) = [ ...
        1, 7, 9,13,11, ...
        1, 3, 7, 9, 5,13,13,11, 3,15, ...
        5, 3,15, 7, 9,13, 9, 1,11, 7, ...
        5,15, 1,15,11, 5, 3, 1, 7, 9 ]'
        v(8:40,5) = [ ...
        9, 3,27, ...
        15,29,21,23,19,11,25, 7,13,17, ...
        1,25,29, 3,31,11, 5,23,27,19, ...
        21, 5, 1,17,13, 7,15, 9,31, 9 ]'
        v(14:40,6) = [ ...
        37,33, 7, 5,11,39,63, ...
        27,17,15,23,29, 3,21,13,31,25, ...
        9,49,33,19,29,11,19,27,15,25 ]'
        v(20:40,7) = [ ...
        13, ...
        33,115, 41, 79, 17, 29,119, 75, 73,105, ...
        7, 59, 65, 21,  3,113, 61, 89, 45,107 ]'
        v(38:40,8) = [ ...
        7, 23, 39 ]'
        //
        //  Set POLY.
        //
        spoly(1:40)= [ ...
        1,   3,   7,  11,  13,  19,  25,  37,  59,  47, ...
        61,  55,  41,  67,  97,  91, 109, 103, 115, 131, ...
        193, 137, 145, 143, 241, 157, 185, 167, 229, 171, ...
        213, 191, 253, 203, 211, 239, 247, 285, 369, 299 ]
        //
        atmost = 2^logmax - 1
        //
        //  Find the number of bits in ATMOST.
        //
        maxcol = bithi1 ( atmost )
        //
        //  Initialize row 1 of V.
        //
        v(1,1:maxcol) = 1
        //
        //  Initialize the remaining rows of V.
        //
        for i = 2 : dim_num
            //
            //  The bit pattern of the integer POLY(I) gives the form
            //  of polynomial I.
            //
            //  Find the degree of polynomial I from binary encoding.
            //
            j = spoly(i)
            m = 0
            while ( 1 )
                j = floor ( j / 2 )
                if ( j <= 0 )
                    break
                end
                m = m + 1
            end
            //
            //  We expand this bit pattern to separate components of the logical array INCLUD.
            //
            j = spoly(i)
            for k = m : -1 : 1
                j2 = floor ( j / 2 )
                includ(k) = ( j ~= 2 * j2 )
                j = j2
            end
            //
            //  Calculate the remaining elements of row I as explained
            //  in Bratley and Fox, section 2.
            //
            for j = m + 1 : maxcol
                newv = v(i,j-m)
                l = 1
                for k = 1 : m
                    l = 2 * l
                    if ( includ(k) )
                        newv = bitxor ( newv, l * v(i,j-k) )
                    end
                end
                v(i,j) = newv
            end
        end
        //
        //  Multiply columns of V by appropriate power of 2.
        //
        l = 1
        for j = maxcol-1 : -1 : 1
            l = 2 * l
            v(1:dim_num,j) = v(1:dim_num,j) * l
        end
        //
        //  RECIPD is 1/(common denominator of the elements in V).
        //
        recipd = 1.0 / ( 2 * l )
        //
        //     SET UP FIRST VECTOR AND VALUES FOR "GOSOBL"
        //
        count = 0
        lastq(1:dim_num) = 0
    endfunction


    function [ count , lastq ] = sobolskip ( skip , lastq , dim_num , count , v )
        // Skip elements in the Sobol sequence.
        //
        // Calling Sequence
        //   [ count , lastq ] = sobolskip ( skip , lastq , dim_num , count , v )
        //
        // Parameters
        //   skip : a 1 x 1 matrix of floating point integers, the number of elements to discard
        //   dim_num : a 1 x 1 matrix of floating point integers, the number of dimensions
        //   lastq : a dim_num x 1 matrix of floating point integers, the numerators of the last vector generated
        //   count : a 1 x 1 matrix of floating point integers, the index of the element in the sequence
        // 
        // Description
        //   This functions skips elements in the Sobol sequence.
        //   
        //   The only difference with <literal>sobolnext</literal> is that we do not generate the 
        //   vector <literal>quasi</literal>.
        //
        //   This routine is designed to be used with the <literal>sobolnext()</literal> 
        //   and <literal>sobolstart</literal> functions.
        //
        // Authors
        // Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
        // Copyright (C) 2008-2009 - INRIA - Michael Baudin
        // Copyright (C) 2005-2009 - John Burkardt
        // Copyright (C) 1986 - Bennett Fox

        for i = 1 : skip
            l = bitlo0 ( count )
            lastq = bitxor ( lastq, v(1 : dim_num,l) )
            count = count + 1
        end
    endfunction


    function [ quasi , lastq , count ] = sobolnext ( count , maxcol , dim_num , lastq , v , recipd )
        // Generates a new quasirandom Sobol vector.
        //
        // Calling Sequence
        //   [ quasi , lastq , count ] = sobolnext ( count , maxcol , dim_num , lastq , v , recipd )
        //
        // Parameters
        //   count : a 1 x 1 matrix of floating point integers. On input : the index of the element to compute. On output, the updated value of the index of the element.
        //   maxcol : a 1 x 1 matrix of floating point integers,number of bits in atmost
        //   dim_num : a 1 x 1 matrix of floating point integers, the current number of dimensions. We expect to have 1<= dim_num<= 40, since no more that 40 polynomials are stored in the database.
        //   lastq : a dim_num x 1 matrix of floating point integers, the numerators of the last vector generated
        //   v : a dimmax x logmax matrix of floating point integers, table of direction numbers. Each row corresponds to a primitive polynomial. The numbers in v are actually binary fractions.
        //   recipd : a 1 x 1 matrix of doubles, (1/denominator) for the numerators lastq
        //   quasi : a dim_num x 1 matrix of doubles, the next quasirandom vector.
        //
        //  Description
        //    The routine adapts the ideas of Antonov and Saleev, that is, 
        //    uses a Gray code for the update of the numerators lastq.
        //
        //    Thanks to Francis Dalaudier for pointing out that the range of allowed
        //    values of DIM_NUM should start at 1, not 2!  17 February 2009.
        //
        //  Examples
        // // See the source code
        // edit sobolnext
        // 
        //    // Generates elements of the Sobol sequence in dimension 4
        //    dim_num = 4
        //    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
        //    // Element #0
        //    [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //    disp(quasi')
        //    // Element #1
        //    [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //    disp(quasi')
        //    // Element #2
        //    [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //    disp(quasi')
        //
        //    // Generate 15 elements of the Sobol sequence in dimension 4
        //    dim_num = 4
        //    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
        //    for k = 1 : 15
        //      [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //      mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
        //    end
        //    
        //    // Generate 5 elements of the Sobol sequence in dimension 4,
        //    // skip 5 elements, then generate 5 elements
        //    dim_num = 4
        //    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
        //    for k = 1 : 5
        //      [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //      mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
        //    end
        //    [count,lastq]=sobolskip(5,lastq,dim_num,count,v);
        //    for k = 1 : 5
        //      [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //      mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
        //    end
        //
        //    // Generate some elements and plot them
        //    dim_num = 2;
        //    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
        //    for k = 1 : 2^7-1
        //      [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        //      next(k,1:dim_num) = quasi';
        //    end
        //    scf();
        //    plot ( next(:,1) , next(:,2) , "bo" )
        //    xtitle("Sobol point set","X1","X2");
        //
        //  Authors
        // Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
        // Copyright (C) 2008-2009 - INRIA - Michael Baudin
        // Copyright (C) 2005-2009 - John Burkardt
        // Copyright (C) 1986 - Bennett Fox
        //
        // Bibliography
        //    Antonov, Saleev, USSR Computational Mathematics and Mathematical Physics, Volume 19, 1980, pages 252 - 256.
        //    Paul Bratley, Bennett Fox, Algorithm 659: Implementing Sobol's Quasirandom Sequence Generator, ACM Transactions on Mathematical Software, Volume 14, Number 1, pages 88-100, 1988.
        //    Bennett Fox, Algorithm 647: Implementation and Relative Efficiency of Quasirandom Sequence Generators, ACM Transactions on Mathematical Software, Volume 12, Number 4, pages 362-376, 1986.
        //    Ilya Sobol, USSR Computational Mathematics and Mathematical Physics, Volume 16, pages 236-242, 1977.
        //    Ilya Sobol, Levitan, The Production of Points Uniformly Distributed in a Multidimensional Cube (in Russian), Preprint IPM Akad. Nauk SSSR, Number 40, Moscow 1976.
        //

        //
        //  Find the position of the right-hand zero in count
        //
        l = bitlo0 ( count )
        //
        //  Check that the user is not calling too many times!
        //
        if ( maxcol < l )
            error ( msprintf ( gettext ( "%s: Too many calls. maxcol=%d, l=%d") , "_next_sobol" , l , maxcol ))
        end
        //
        //  Calculate the new components of QUASI.
        //
        quasi(1 : dim_num) = lastq(1 : dim_num) * recipd
        lastq(1 : dim_num) = bitxor ( lastq(1 : dim_num), v(1 : dim_num,l) )
        count = count + 1
    endfunction

    function printExpected(expected)
        nrows=size(expected,"r")
        mprintf("Expected:\n");
        for i=1:nrows
            mprintf("#%d = [%s]\n",i,strcat(string(expected(i,:))," "))
        end
    endfunction

    path=lowdisc_getpath();
    exec(fullfile(path,"demos","ld-macros","bithi1.sci"));
    exec(fullfile(path,"demos","ld-macros","bitlo0.sci"));

    // Generate elements of the Sobol sequence in dimension 2
    mprintf("Sobol:\n")
    dim_num = 2;
    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
    for k = 1 : 7
        [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
    end
    expected= [
    0.  0.
    0.5 0.5
    3./4. 1./4. 
    1./4. 3./4. 
    3./8. 3./8. 
    7./8. 7./8. 
    5./8. 1./8. 
    ];
    printExpected(expected);

    // Generate 10 elements of the Sobol sequence in dimension 4
    mprintf("Sobol:\n")
    dim_num = 4;
    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
    for k = 1 : 10
        [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
    end

    // Generate 5 elements of the Sobol sequence in dimension 4,
    // skip 5 elements, then generate 5 elements
    mprintf("Sobol (skip):\n")
    dim_num = 4;
    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
    for k = 1 : 5
        [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
    end
    [count,lastq]=sobolskip(5,lastq,dim_num,count,v);
    for k = 1 : 5
        [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
    end

    // Generate some elements and plot them
    dim_num = 2;
    npoints=2^7;
    [v,maxcol,lastq,count,recipd]=sobolstart(dim_num);
    next=[];
    for k = 1 : npoints
        [quasi,lastq,count]=sobolnext(count,maxcol,dim_num,lastq,v,recipd);
        next(k,1:dim_num) = quasi';
    end
    scf();
    strtitle=msprintf("Sobol (base 2) : %d points",npoints)
    plot ( next(:,1) , next(:,2) , "bo" )
    xtitle(strtitle,"X1","X2");

    //
    // Load this script into the editor
    //
    m = messagebox(_("View Code?"), "Question", "question", [_("Yes") _("No")], "modal")
    if(m == 1)
        filename = 'macros-sobol.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
    end
endfunction 
lowdisc_demossobol();
clear lowdisc_demossobol;
