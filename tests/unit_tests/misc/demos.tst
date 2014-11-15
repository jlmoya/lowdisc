// Copyright (C) 2012 - 2014 - Michael Baudin
//
// This file must be used under the terms of the GNU LGPL license.
//
// <-- NO CHECK REF --> 

function execdemo(gatewayfilename,skipscript)
    // Executes a demo gateway script.
    //
    // Calling Sequence
    //   execdemo(gatewayfilename,skipscript)
    //
    // Parameters
    // gatewayfilename : a string, the gateway file name
    // skipscript : an array of strings, the list of scripts to ignore
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
        bname=basename(subdemolist(i,2))
        ext=fileext(bname)
        if (or(bname==skipscript)) then
            // Skip this file
            mprintf("- Skipping ""%s"" : %s\n",subdemolist(i,1),bname);
            continue
        end
        if (ext==".gateway") then
            mprintf("> Entering gateway:""%s"" : %s\n",subdemolist(i,1),bname);
            execdemo(subdemolist(i,2))
        else
            mprintf("""%s"": %s\n",subdemolist(i,1),bname);
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
skipscript=[];
execdemo(gatewayfilename)
