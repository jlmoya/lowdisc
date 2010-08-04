mode(1)
//
// Demo of lowdisc_sobolnext.sci
//

// Generates elements of the Sobol sequence in dimension 4
dim_num = 4
[ v , maxcol , lastq , count , recipd ] = lowdisc_sobolstart ( dim_num );
// Element #0
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
disp(quasi')
// Element #1
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
disp(quasi')
// Element #2
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
disp(quasi')
halt()   // Press return to continue
 
// Generate 15 elements of the Sobol sequence in dimension 4
dim_num = 4
[ v , maxcol , lastq , count , recipd ] = lowdisc_sobolstart ( dim_num );
for k = 1 : 15
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
end
halt()   // Press return to continue
 
// Generate 5 elements of the Sobol sequence in dimension 4,
// skip 5 elements, then generate 5 elements
dim_num = 4
[ v , maxcol , lastq , count , recipd ] = lowdisc_sobolstart ( dim_num );
for k = 1 : 5
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
end
[ count , lastq ] = lowdisc_sobolskip ( 5 , lastq , dim_num , count , v );
for k = 1 : 5
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
mprintf("#%d = [%s]\n",k,strcat(string(quasi)," "))
end
halt()   // Press return to continue
 
// Generate some elements and plot them
dim_num = 2;
[ v , maxcol , lastq , count , recipd ] = lowdisc_sobolstart ( dim_num );
for k = 1 : 2^7-1
[ quasi , lastq , count ] = lowdisc_sobolnext ( count , maxcol , dim_num , lastq , v , recipd );
next(i+1,1:dim_num) = quasi';
end
plot ( next(:,1) , next(:,2) , "bo" )
halt()   // Press return to continue
 
//========= E N D === O F === D E M O =========//
//
// Load this script into the editor
//
filename = "lowdisc_sobolnext.sce";
dname = get_absolute_file_path(filename);
editor ( dname + filename );
