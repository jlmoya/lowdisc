// Copyright (C) 2013 - Michael Baudin
// Copyright (C) 2008 - INRIA   - Michael Baudin
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function lowdiscBuildSrc()
    src_dir = get_absolute_file_path("builder_src.sce");
    tbx_builder_src_lang("cpp"    , src_dir);
endfunction
lowdiscBuildSrc();
clear lowdiscBuildSrc
