// ====================================================================
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
// This file is released into the public domain
// ====================================================================


gateway_path = get_absolute_file_path("builder_gateway_cpp.sce");

libname = "lowdiscgateway";
namelist = [
  "_lowdisc_startup" "sci_lowdisc_startup"
  "_lowdisc_shutdown" "sci_lowdisc_shutdown"
  "_lowdisc_sobolf" "sci_lowdisc_sobolf"
  "_lowdisc_haltonf" "sci_lowdisc_haltonf"
  "_lowdisc_haltonbaseset" "sci_lowdisc_haltonbaseset"
  "_lowdisc_haltondimnumset" "sci_lowdisc_haltondimnumset"
  "_lowdisc_haltonseedset" "sci_lowdisc_haltonseedset"
  "_lowdisc_haltonstepset" "sci_lowdisc_haltonstepset"
  "_lowdisc_faureprimege" "sci_lowdisc_faureprimege"
  "_lowdisc_fauref" "sci_lowdisc_fauref"
];
// "_lowdisc_nieder2f" "sci_lowdisc_nieder2f"
// "_lowdisc_reversehaltonf" "sci_lowdisc_reversehaltonf"
files = [
  "gw_lowdisc_support.cpp"
  "sci_lowdisc_startup.cpp"
  "sci_lowdisc_shutdown.cpp"
  "sci_lowdisc_sobolf.cpp"
  "sci_lowdisc_haltonbaseset.cpp"
  "sci_lowdisc_haltondimnumset.cpp"
  "sci_lowdisc_haltonf.cpp"
  "sci_lowdisc_haltonseedset.cpp"
  "sci_lowdisc_haltonstepset.cpp"
  "sci_lowdisc_fauref.cpp"
  "sci_lowdisc_faureprimege.cpp"
  ];
//  "sci_lowdisc_nieder2f.cpp"
//  "sci_lowdisc_reversehaltonf.cpp"


ldflags = ""

if ( MSDOS ) then
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

clear tbx_build_gateway;

