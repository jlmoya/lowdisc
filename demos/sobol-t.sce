// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

// Description
// Shows how to compute the T quality parameter of the Sobol 
// sequence.
// The formula is:
//
// t = sum(q(j)-1) + 1 for j=1,2,...,s
//   = sum(q(j)) - s + 1
//
// where q(j) is the degree of the j-th primitive 
// polynomial used to construct the j-th coordinate.
// The table spoly contains integers, which binary representation 
// stores the primitive polynomials.
// Notice that all polynomials in this table have the 
// form:
//
// x^q + c(1)*x^(q-1) + ... + c(q-1)*x + 1 (mod 2)
//
// where q is the degree of the polynomial
// and c(i)=0 or 1, for i=1,2,...,q-1.
// Notice that the first coefficient and the last are 
// always 1 (but intermediate coefficients might be zero).
// 
// For example spoly(8)=37 is the polynomial for dimension 8, 
// which is 8=(1,0,0,1,0,1).
// This is the polynomial:
//
// x^5 + x^2 + 1
//
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman

function lowdisc_demosobolt()
    spoly= [ ...
    1,   3,   7,  11,  13,  19,  25,  37,  59,  47, ...
    61,  55,  41,  67,  97,  91, 109, 103, 115, 131, ...
    193, 137, 145, 143, 241, 157, 185, 167, 229, 171, ...
    213, 191, 253, 203, 211, 239, 247, 285, 369, 299 ]
    smax=size(spoly,"*")

    for s=1:smax
        p=number_tobary(spoly(s),2);
        pstr=strcat(string(p),",");
        deg(s)=size(p,"*")-1;
        t=sum(deg(1:s))-s+1;
        mprintf("s=%d: deg=%d, %d=(%s), t=%d\n",..
        s,deg(s),spoly(s),pstr,t)
    end
    //
    // Load this script into the editor
    //
        filename = 'sobol-t.sce';
        dname = get_absolute_file_path(filename);
        editor ( dname + filename, "readonly" );
endfunction 
lowdisc_demosobolt();
clear lowdisc_demosobolt;


