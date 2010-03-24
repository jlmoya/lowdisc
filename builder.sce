// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//
// builder.sce --
//   Builder for the Low Discrepancy Scilab Toolbox
//
mode(-1);
lines(0);
setenv('DEBUG_SCILAB_DYNAMIC_LINK','YES')
try
 getversion('scilab');
catch
 error(gettext('Scilab 5.0 or more is required.'));  
end;
// ====================================================================
if ~with_module('development_tools') then
  error(msprintf(gettext('%s module not installed."),'development_tools'));
end
// ====================================================================
TOOLBOX_NAME = 'lowdiscrepancy';
TOOLBOX_TITLE = 'Low Discrepancy Toolbox';
// ====================================================================
toolbox_dir = get_absolute_file_path('builder.sce');

tbx_builder_macros(toolbox_dir);
tbx_builder_src(toolbox_dir);
tbx_builder_gateway(toolbox_dir);
tbx_builder_help(toolbox_dir);
tbx_build_loader(TOOLBOX_NAME, toolbox_dir);

clear toolbox_dir TOOLBOX_NAME TOOLBOX_TITLE;
// ====================================================================
