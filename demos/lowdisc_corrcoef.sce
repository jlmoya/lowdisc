mode(1)
//
// Demo of lowdisc_corrcoef.sci
//

// Uncorrelated data
x = grand(30,4,"nor",0,1)
// Introduce correlation.
x(:,4) = sum(x,2);
// Compute sample correlation
r = lowdisc_corrcoef ( x )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_corrcoef.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );
