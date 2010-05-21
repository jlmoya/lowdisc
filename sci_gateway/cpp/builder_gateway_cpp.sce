// ====================================================================
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2009 - Digiteo - Michael Baudin
// This file is released into the public domain
// ====================================================================


gateway_path = get_absolute_file_path("builder_gateway_cpp.sce");

libname = "lowdiscgateway";
namelist = [
  "_lowdisc_startup"  "sci_lowdisc_startup"
  "_lowdisc_shutdown" "sci_lowdisc_shutdown"
  ..
  "_lowdisc_sobolf"        "sci_lowdisc_sobolf"
  "_lowdisc_sobolfstart"   "sci_lowdisc_sobolfstart"
  "_lowdisc_sobolfstop"    "sci_lowdisc_sobolfstop"
  "_lowdisc_sobolfdimget"  "sci_lowdisc_sobolfdimget"
  "_lowdisc_sobolfisstart" "sci_lowdisc_sobolfisstart"
  ..
  "_lowdisc_haltonf"        "sci_lowdisc_haltonf"
  "_lowdisc_haltonfstart"   "sci_lowdisc_haltonfstart"
  "_lowdisc_haltonfstop"    "sci_lowdisc_haltonfstop"
  "_lowdisc_haltonfdimget"  "sci_lowdisc_haltonfdimget"
  "_lowdisc_haltonfbaseget" "sci_lowdisc_haltonfbaseget"
  "_lowdisc_haltonfseedget" "sci_lowdisc_haltonfseedget"
  "_lowdisc_haltonfleapget" "sci_lowdisc_haltonfleapget"
  "_lowdisc_haltonfisstart" "sci_lowdisc_haltonfisstart"
  ..
  "_lowdisc_faurefbaseget" "sci_lowdisc_faurefbaseget"
  "_lowdisc_fauref"        "sci_lowdisc_fauref"
  "_lowdisc_faurefstart"   "sci_lowdisc_faurefstart"
  "_lowdisc_faurefstop"    "sci_lowdisc_faurefstop"
  "_lowdisc_faurefisstart" "sci_lowdisc_faurefisstart"
  "_lowdisc_faurefdimget"  "sci_lowdisc_faurefdimget"
  ..
  "_lowdisc_revhaltf"        "sci_lowdisc_revhaltf"
  "_lowdisc_revhaltfstart"   "sci_lowdisc_revhaltfstart"
  "_lowdisc_revhaltfstop"    "sci_lowdisc_revhaltfstop"
  "_lowdisc_revhaltfbaseget" "sci_lowdisc_revhaltfbaseget"
  "_lowdisc_revhaltfdimget"  "sci_lowdisc_revhaltfdimget"
  "_lowdisc_revhaltfisstart" "sci_lowdisc_revhaltfisstart"
  ..
  "_lowdisc_niedf"         "sci_lowdisc_niedf"
  "_lowdisc_niedfstart"    "sci_lowdisc_niedfstart"
  "_lowdisc_niedfstop"     "sci_lowdisc_niedfstop"
  "_lowdisc_niedfbaseget"  "sci_lowdisc_niedfbaseget"
  "_lowdisc_niedfdimget"   "sci_lowdisc_niedfdimget"
  "_lowdisc_niedfskipget"  "sci_lowdisc_niedfskipget"
  "_lowdisc_niedfisstart"  "sci_lowdisc_niedfisstart"
];
files = [
  "gw_lowdisc_support.cpp"
  "sci_lowdisc_startup.cpp"
  "sci_lowdisc_shutdown.cpp"
  ..
  "sci_lowdisc_sobolf.cpp"
  "sci_lowdisc_sobolfstart.cpp"
  "sci_lowdisc_sobolfstop.cpp"
  "sci_lowdisc_sobolfdimget.cpp"
  "sci_lowdisc_sobolfisstart.cpp"
  ..
  "sci_lowdisc_haltonf.cpp"
  "sci_lowdisc_haltonfdimget.cpp"
  "sci_lowdisc_haltonfbaseget.cpp"
  "sci_lowdisc_haltonfseedget.cpp"
  "sci_lowdisc_haltonfleapget.cpp"
  "sci_lowdisc_haltonfstart.cpp"
  "sci_lowdisc_haltonfstop.cpp"
  "sci_lowdisc_haltonfisstart.cpp"
  ..
  "sci_lowdisc_fauref.cpp"
  "sci_lowdisc_faurefbaseget.cpp"
  "sci_lowdisc_faurefstart.cpp"
  "sci_lowdisc_faurefstop.cpp"
  "sci_lowdisc_faurefisstart.cpp"
  "sci_lowdisc_faurefdimget.cpp"
  ..
  "sci_lowdisc_revhaltf.cpp"
  "sci_lowdisc_revhaltfstart.cpp"
  "sci_lowdisc_revhaltfstop.cpp"
  "sci_lowdisc_revhaltfbaseget.cpp"
  "sci_lowdisc_revhaltfdimget.cpp"
  "sci_lowdisc_revhaltfisstart.cpp"
  ..
  "sci_lowdisc_niedf.cpp"
  "sci_lowdisc_niedfstart.cpp"
  "sci_lowdisc_niedfstop.cpp"
  "sci_lowdisc_niedfdimget.cpp"
  "sci_lowdisc_niedfbaseget.cpp"
  "sci_lowdisc_niedfskipget.cpp"
  "sci_lowdisc_niedfisstart.cpp"
  ];


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

