// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
// This file is released into the public domain

function lowdiscBuildGwCpp()

    gateway_path = get_absolute_file_path("builder_gateway_cpp.sce");

    libname = "lowdiscgateway";
    namelist = [
    "_lowdisc_startup"  "sci_lowdisc_startup"
    "_lowdisc_shutdown" "sci_lowdisc_shutdown"
    ..
    "_lowdisc_sobolfnext"    "sci_lowdisc_sobolfnext"
    "_lowdisc_sobolfstart"   "sci_lowdisc_sobolfstart"
    "_lowdisc_sobolfstop"    "sci_lowdisc_sobolfstop"
    "_lowdisc_sobolfisstart" "sci_lowdisc_sobolfisstart"
    ..
    "_lowdisc_haltonfnext"    "sci_lowdisc_haltonfnext"
    "_lowdisc_haltonfstart"   "sci_lowdisc_haltonfstart"
    "_lowdisc_haltonfstop"    "sci_lowdisc_haltonfstop"
    "_lowdisc_haltonfisstart" "sci_lowdisc_haltonfisstart"
    ..
    "_lowdisc_faurefnext"    "sci_lowdisc_faurefnext"
    "_lowdisc_faurefstart"   "sci_lowdisc_faurefstart"
    "_lowdisc_faurefstop"    "sci_lowdisc_faurefstop"
    "_lowdisc_faurefisstart" "sci_lowdisc_faurefisstart"
    ..
    "_lowdisc_revhaltfnext"    "sci_lowdisc_revhaltfnext"
    "_lowdisc_revhaltfstart"   "sci_lowdisc_revhaltfstart"
    "_lowdisc_revhaltfstop"    "sci_lowdisc_revhaltfstop"
    "_lowdisc_revhaltfisstart" "sci_lowdisc_revhaltfisstart"
    ..
    "_lowdisc_niedfnext"     "sci_lowdisc_niedfnext"
    "_lowdisc_niedfstart"    "sci_lowdisc_niedfstart"
    "_lowdisc_niedfstop"     "sci_lowdisc_niedfstop"
    "_lowdisc_niedfisstart"  "sci_lowdisc_niedfisstart"
    ..
    "_lowdisc_ssobolfnext"    "sci_lowdisc_ssobolfnext"
    "_lowdisc_ssobolfstart"   "sci_lowdisc_ssobolfstart"
    "_lowdisc_ssobolfstop"    "sci_lowdisc_ssobolfstop"
    "_lowdisc_ssobolfisstart" "sci_lowdisc_ssobolfisstart"
    ];
    files = [
    "gw_lowdisc_support.cpp"
    "sci_lowdisc_startup.cpp"
    "sci_lowdisc_shutdown.cpp"
    ..
    "sci_lowdisc_sobolfnext.cpp"
    "sci_lowdisc_sobolfstart.cpp"
    "sci_lowdisc_sobolfstop.cpp"
    "sci_lowdisc_sobolfisstart.cpp"
    ..
    "sci_lowdisc_haltonfnext.cpp"
    "sci_lowdisc_haltonfstart.cpp"
    "sci_lowdisc_haltonfstop.cpp"
    "sci_lowdisc_haltonfisstart.cpp"
    ..
    "sci_lowdisc_faurefnext.cpp"
    "sci_lowdisc_faurefstart.cpp"
    "sci_lowdisc_faurefstop.cpp"
    "sci_lowdisc_faurefisstart.cpp"
    ..
    "sci_lowdisc_revhaltfnext.cpp"
    "sci_lowdisc_revhaltfstart.cpp"
    "sci_lowdisc_revhaltfstop.cpp"
    "sci_lowdisc_revhaltfisstart.cpp"
    ..
    "sci_lowdisc_niedfnext.cpp"
    "sci_lowdisc_niedfstart.cpp"
    "sci_lowdisc_niedfstop.cpp"
    "sci_lowdisc_niedfisstart.cpp"
    ..
    "sci_lowdisc_ssobolfnext.cpp"
    "sci_lowdisc_ssobolfstart.cpp"
    "sci_lowdisc_ssobolfstop.cpp"
    "sci_lowdisc_ssobolfisstart.cpp"
    ];

    ldflags = ""

    if ( getos() == "Windows" ) then
        include2 = "..\..\src\cpp";
        include3 = SCI+"/modules/output_stream/includes";
        cflags = "-DWIN32 -I"""+include2+""" -I"""+include3+"""";
    else
        include1 = gateway_path;
        include2 = gateway_path+"../../src/cpp";
        include3 = SCI+"/../../include/scilab/localization";
        include4 = SCI+"/../../include/scilab/output_stream";
        include5 = SCI+"/../../include/scilab/core";
        cflags = "-I"""+include1+""" -I"""+include2+""" -I"""+include3+...
        """ -I"""+include4+""" -I"""+include5+"""";
    end
    // Caution : the order matters !
    libs = [
    "../../src/cpp/liblowdisc"
    ];

    tbx_build_gateway(libname, namelist, files, gateway_path, libs, ldflags, cflags);

endfunction
lowdiscBuildGwCpp()
clear lowdiscBuildGwCpp
