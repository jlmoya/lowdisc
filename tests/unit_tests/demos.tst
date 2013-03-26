// Copyright (C) 2012 - Michael Baudin

//
// This file must be used under the terms of the GNU LGPL license.
// 

// <-- NOT FIXED -->

TOOLBOX_NAME  = "lowdisc";
path = lowdisc_getpath();
demospath = fullfile(path,"demos");

// Get the subdemolist variable from the demos gateway
demosscript = TOOLBOX_NAME+".dem.gateway.sce";
exec(fullfile(demospath,demosscript),-1);
ndemos = size(subdemolist,"r");
for i = 1 : ndemos
	mprintf("%s: exec(%s)\n",subdemolist(i,1),subdemolist(i,2));
	exec(subdemolist(i,2),-1);
end
