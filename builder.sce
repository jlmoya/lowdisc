// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008-2009 - INRIA - Michael Baudin
// Copyright (C) 2010 - 2011 - DIGITEO - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.

//
// builder.sce --
//   Builder for the Low Discrepancy Scilab Toolbox
//
function lowdiscBuilder()

    mode(-1);
    lines(0);
    setenv("__USE_DEPRECATED_STACK_FUNCTIONS__","YES");
    // Uncomment this line to make a debug version of the Toolbox
    //setenv("DEBUG_SCILAB_DYNAMIC_LINK","YES")
    try
        getversion("scilab");
    catch
        error(gettext("Scilab 5.0 or more is required."));  
    end;
    // ====================================================================
    if ~with_module("development_tools") then
        error(msprintf(gettext("%s module not installed."),"development_tools"));
    end
    // ====================================================================
    TOOLBOX_NAME  = "lowdisc";
    TOOLBOX_TITLE = "Low Discrepancy";
    // ====================================================================
    toolbox_dir = get_absolute_file_path("builder.sce");

    tbx_builder_src(toolbox_dir);
    tbx_builder_gateway(toolbox_dir);
    tbx_builder_macros(toolbox_dir);
    try
        tbx_builder_help(toolbox_dir);
    catch
        disp("lowdisc: help build skipped (CLI mode).");
    end
    tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
    tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

endfunction
lowdiscBuilder();
clear lowdiscBuilder

