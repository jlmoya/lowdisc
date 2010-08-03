mode(1)
//
// Demo of lowdisc_vandercorput.sci
//

lowdisc_vandercorput ( 0 , 2 ) // 0.0
lowdisc_vandercorput ( 1 , 2 ) // 0.5
lowdisc_vandercorput ( 2 , 2 ) // 0.25
lowdisc_vandercorput ( 3 , 2 ) // 0.75
lowdisc_vandercorput ( 4 , 2 ) // 0.125
lowdisc_vandercorput ( 5 , 2 ) // 0.625
halt()   // Press return to continue
 
// See the terms 0 to 10 in base 2.
for i = 0 : 10
s(i+1) = lowdisc_vandercorput ( i , 2 );
end
disp(s')
halt()   // Press return to continue
 
// See the terms 0 to 10 in base 3.
for i = 0 : 10
s(i+1) = lowdisc_vandercorput ( i , 3 );
end
disp(s')
halt()   // Press return to continue
 
// Plot the terms 0 to 2^7 in base 2
for i = 0 : 2^7
s = lowdisc_vandercorput ( i , 2 );
plot ( s , i , "bo" ) ;
end
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_vandercorput.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );
