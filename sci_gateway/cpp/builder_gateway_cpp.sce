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
    "_lowdisc_sobolfnew"   "sci_lowdisc_sobolfnew"
    "_lowdisc_sobolfdestroy"    "sci_lowdisc_sobolfdestroy"
    "_lowdisc_sobolftokens" "sci_lowdisc_sobolftokens"
    ..
    "_lowdisc_haltonfnext"    "sci_lowdisc_haltonfnext"
    "_lowdisc_haltonfnew"   "sci_lowdisc_haltonfnew"
    "_lowdisc_haltonfdestroy"    "sci_lowdisc_haltonfdestroy"
    "_lowdisc_haltonftokens" "sci_lowdisc_haltonftokens"
    ..
    "_lowdisc_faurefnext"    "sci_lowdisc_faurefnext"
    "_lowdisc_faurefnew"   "sci_lowdisc_faurefnew"
    "_lowdisc_faurefdestroy"    "sci_lowdisc_faurefdestroy"
    "_lowdisc_faureftokens" "sci_lowdisc_faureftokens"
    ..
    "_lowdisc_niedfnext"     "sci_lowdisc_niedfnext"
    "_lowdisc_niedfnew"    "sci_lowdisc_niedfnew"
    "_lowdisc_niedfdestroy"     "sci_lowdisc_niedfdestroy"
    "_lowdisc_niedftokens"  "sci_lowdisc_niedftokens"
    ..
    "_lowdisc_ssobolnext"    "sci_lowdisc_ssobolnext"
    "_lowdisc_ssobolnew"     "sci_lowdisc_ssobolnew"
    "_lowdisc_ssoboldestroy" "sci_lowdisc_ssoboldestroy"
    "_lowdisc_ssoboltokens"  "sci_lowdisc_ssoboltokens"
    ];
    files = [
    "gw_lowdisc_support.cpp"
    "sci_lowdisc_startup.cpp"
    "sci_lowdisc_shutdown.cpp"
    ..
    "sci_lowdisc_sobolfnext.cpp"
    "sci_lowdisc_sobolfnew.cpp"
    "sci_lowdisc_sobolfdestroy.cpp"
    "sci_lowdisc_sobolftokens.cpp"
    ..
    "sci_lowdisc_haltonfnext.cpp"
    "sci_lowdisc_haltonfnew.cpp"
    "sci_lowdisc_haltonfdestroy.cpp"
    "sci_lowdisc_haltonftokens.cpp"
    ..
    "sci_lowdisc_faurefnext.cpp"
    "sci_lowdisc_faurefnew.cpp"
    "sci_lowdisc_faurefdestroy.cpp"
    "sci_lowdisc_faureftokens.cpp"
    ..
    "sci_lowdisc_niedfnext.cpp"
    "sci_lowdisc_niedfnew.cpp"
    "sci_lowdisc_niedfdestroy.cpp"
    "sci_lowdisc_niedftokens.cpp"
    ..
    "sci_lowdisc_ssobolnext.cpp"
    "sci_lowdisc_ssobolnew.cpp"
    "sci_lowdisc_ssoboldestroy.cpp"
	"sci_lowdisc_ssoboltokens.cpp"
    ..
    "lowdisc_sobol_map.cpp"
    "lowdisc_ssobol_map.cpp"
    "lowdisc_halton_map.cpp"
    "lowdisc_faure_map.cpp"
    "lowdisc_nied_map.cpp"
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
