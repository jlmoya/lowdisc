// Copyright (C) 2012 - 2014 - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

function execdemo(gatewayfilename)
    // Executes a demo gateway script.
    //
    // Calling Sequence
    //   execdemo(gatewayfilename)
    //
    // Parameters
    // gatewayfilename : a string, the gateway file name
    //
    // Description
    // Executes all the scripts described within a gateway 
    // file, and, recursively, the gateways inside.
    // The graphics windows created by each script are deleted 
    // automatically.
    //
    exec(gatewayfilename,-1);
    ndemos = size(subdemolist,"r");
    for i = 1 : ndemos
        ext=fileext(basename(subdemolist(i,2)))
        if (ext==".gateway") then
            mprintf("\n> Entering gateway:%s : \n %s\n",subdemolist(i,1),subdemolist(i,2));
            execdemo(subdemolist(i,2))
        else
            mprintf("\n%s: \n  %s\n",subdemolist(i,1),subdemolist(i,2));
            exec(subdemolist(i,2),-1);
            // Delete the graphics windows created by the script
            currentfigs=winsid()
            for i=1:size(currentfigs,"*")
                delete(gcf())
            end
        end
    end
endfunction

//////////////////

TOOLBOX_NAME  = "lowdisc";
path = lowdisc_getpath();
demospath = fullfile(path,"demos");

// Get the subdemolist variable from the demos gateway
demosscript = TOOLBOX_NAME+".dem.gateway.sce";
gatewayfilename=fullfile(demospath,demosscript)
execdemo(gatewayfilename)
