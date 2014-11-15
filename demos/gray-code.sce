// Copyright (C) 2013 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//

//
// Description
// Show the Gray Code:
//
// binary(k)+binary(floor(k/2))
//
// where + is the bitwise xor operator.
//
// References
//   Monte-Carlo methods in Financial Engineering, Paul Glasserman
//   http://en.wikipedia.org/wiki/Gray_code

function lowdisc_demograycode()
    function g=graycode(k)
        k1=number_tobary(k,2)
        l=size(k1,"*")
        k2=number_tobary(floor(k/2),2,"littleendian",l)
        g=bitxor(k1,k2)
        g=number_frombary(g,2)
    endfunction

    mprintf("g(k)=Gray Code\n")
    mprintf("g(k)=binary(k)+binary(floor(k/2))\n")
    l=4;
    for l=1:4
        for k=2^(l-1):2^l-1
            g=graycode(k);
            kbin=number_tobary(k,2,"littleendian",l);
            gbin=number_tobary(g,2,"littleendian",l);
            mprintf("k=%d=%s, g(k)=%s\n", ..
            k,strcat(string(kbin),""),..
            strcat(string(gbin),""))
        end
    end
    //
    // Load this script into the editor
    //
    filename = 'gray-code.sce';
    dname = get_absolute_file_path(filename);
    editor ( dname + filename, "readonly" );
endfunction 
lowdisc_demograycode();
clear lowdisc_demograycode;


