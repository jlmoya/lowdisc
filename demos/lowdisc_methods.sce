mode(1)
//
// Demo of lowdisc_methods.sci
//

// Get all the available sequences.
seqmat = lowdisc_methods ()
halt()   // Press return to continue
 
// Get the speed, maximum dimension and
// maximum number of calls for all sequences
seqmat = lowdisc_methods ();
mprintf("%-20s %-10s %-10s %-10s\n", "Name" , ..
"Speed" , "Max Dim" , "Max Call" );
for seqname = seqmat'
lds = lowdisc_new(seqname);
speed = lowdisc_get(lds,"-speed");
dimmax = lowdisc_get(lds,"-dimmax");
nbsimmax = lowdisc_get(lds,"-nbsimmax");
mprintf("%-20s %-10s  %-10d %-10d\n", seqname , ..
speed , dimmax , nbsimmax );
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
