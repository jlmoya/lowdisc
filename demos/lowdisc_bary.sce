mode(1)
//
// Demo of lowdisc_bary.sci
//

lowdisc_bary ( 4 , 2 )                  // [1 0 0]'
lowdisc_bary ( 4 , 2 , "bigendian" )    // [0 0 1]'
lowdisc_bary ( 4 , 2 )                  // [1 0 0]'
lowdisc_bary ( 4 , 2 , "littleendian" ) // [1 0 0]'
lowdisc_bary ( 4 , 2 , "bigendian" )    // [0 0 1]'
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_bary.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );
