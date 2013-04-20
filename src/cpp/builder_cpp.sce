// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008 - INRIA - Simon LIPP
// Copyright (C) 2008 - INRIA - Allan CORNET
// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function lowdiscBuildSrcCpp()

    src_dir = get_absolute_file_path("builder_cpp.sce");

    src_path = "c";
    linknames = ["lowdisc"];
    files = [
    "lowdisc.cpp"
    "lowdisc_shared.cpp"
    "blas1_d.cpp"
    "faure.cpp"
    "halton.cpp"
    "niederreiter.cpp"
    "sobol_i8.cpp"
    "lowdisc_math.cpp"
    "ssobol.cpp"
    ];
    ldflags = "";

    if ( getos() == "Windows" ) then
        cflags = "-DWIN32 -DLIBLOWDISC_EXPORTS";
        libs = [
        ];
    else
        include1 = src_dir;
        cflags = "-I"""+include1+"""";
        libs = [
        ];
    end

    tbx_build_src(linknames, files, src_path, src_dir, libs, ldflags, cflags);

endfunction
lowdiscBuildSrcCpp();
clear lowdiscBuildSrcCpp

