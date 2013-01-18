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

function lowdiscBuildGw()
    sci_gateway_dir = get_absolute_file_path('builder_gateway.sce');
    tbx_builder_gateway_lang("cpp", sci_gateway_dir);
    tbx_build_gateway_loader("cpp", sci_gateway_dir);
    tbx_build_gateway_clean("cpp", sci_gateway_dir);
endfunction
lowdiscBuildGw()
clear lowdiscBuildGw
