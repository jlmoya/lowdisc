// Copyright (C) 2012 - Michael Baudin
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

function path = lowdisc_getpath (  )
    // Returns the path to the current module.
    // 
    // Calling Sequence
    //   path = lowdisc_getpath (  )
    //
    // Parameters
    //   path : a 1-by-1 matrix of strings, the path to the current module.
    //
    // Examples
    //   path = lowdisc_getpath (  )
    //
    // Authors
    //   Copyright (C) 2012 - Michael Baudin

    [lhs, rhs] = argn()
    apifun_checkrhs ( "lowdisc_getpath" , rhs , 0 )
    apifun_checklhs ( "lowdisc_getpath" , lhs , 1 )
    
    path = get_function_path("lowdisc_getpath")
    path = fullpath(fullfile(fileparts(path),".."))
endfunction

