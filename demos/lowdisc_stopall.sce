//
// This help file was automatically generated from lowdisc_stopall.sci using help_from_sci().
// PLEASE DO NOT EDIT
//
mode(1)
//
// Demo of lowdisc_stopall.sci
//

lowdisc_stopall ( )
halt()   // Press return to continue
 
// Example of what can go wrong...
// We create a Fast Reverse Halton sequence.
lds = lowdisc_new("reversehaltonf");
lds = lowdisc_startup (lds);
// We create a Fast Reverse Halton sequence again.
lds = lowdisc_new("reversehaltonf");
lds = lowdisc_startup (lds);
// This creates the error message :
// "Low Discrepancy Module Error ! revhal_startup is already done."
// It would suffice to call lowdisc_destroy(lds).
// But we can use a more brutal function, which resets all sequences.
lowdisc_stopall ( );
// Now it works again.
lds = lowdisc_new("reversehaltonf");
lds = lowdisc_startup (lds);
lds = lowdisc_destroy(lds);
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_stopall.sce";
dname = get_absolute_file_path(filename);
editor ( fullfile(dname,filename) );
