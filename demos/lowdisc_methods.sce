mode(1)
//
// Demo of lowdisc_methods.sci
//

halt()   // Press return to continue
 
seqmat = lowdisc_methods ()
halt()   // Press return to continue
 
// Get the maximum dimension for all sequences
seqmat = lowdisc_methods ();
for seqname = seqmat'
lds = lowdisc_new(seqname);
dimmax = lowdisc_get(lds,"-dimmax");
mprintf("Sequence = %-20s\n", seqname );
mprintf( "Maximum Dimension = %5d\n", dimmax );
nbsimmax = lowdisc_get(lds,"-nbsimmax");
mprintf( "Maximum Number of simulations = %5d\n", nbsimmax );
lds = lowdisc_destroy(lds);
end
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_methods.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );
