module textualize::Entity

import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

import textualize::Method;
import textualize::Field;
//import IO;
import Set;
import List;
//

bool sortLocs(loc a, loc b) {
	return a.file < b.file;
}

str printClass(M3 m, map[loc, str] ft, loc cl) {
	return "\<\<TABLE BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"3\"\>
		   	'\<TR\>\<TD\><cl.file>\</TD\>\</TR\>
			'
			'<(size(methods(m, cl)) > 0 ? "\<HR/\>" : "")>
			'<for(fl <- sort(fields(m, cl), sortLocs)) {>
			'   \<TR\>\<TD ALIGN=\"LEFT\"\><printField(m,ft,fl)>\</TD\>\</TR\>
			'<}>
			'
			'<(size(fields(m, cl)) > 0 ? "\<HR/\>" : "")>
			'<for(ml <- sort(methods(m, cl), sortLocs)) {>
			'   \<TR\>\<TD ALIGN=\"LEFT\"\><printMethod(m, ft, ml, true)>\</TD\>\</TR\>
			'<}>
			'\</TABLE\>\>";
}
str printInterface(M3 m, map[loc, str] ft, loc cl) {
	return "\<\<TABLE BORDER=\"0\" CELLPADDING=\"0\" CELLSPACING=\"3\"\>
			'\<TR\>\<TD\>interface\<BR/\><cl.file>\</TD\>\</TR\>
			'
			'<(size(methods(m, cl)) > 0 ? "\<HR/\>" : "")>
			'<for(fl <- sort(fields(m, cl), sortLocs)) {>
			'   \<TR\>\<TD ALIGN=\"LEFT\"\><printField(m,ft,fl)>\</TD\>\</TR\>
			'<}>
			'
			'<(size(fields(m, cl)) > 0 ? "\<HR/\>" : "")>
			'<for(ml <- sort(methods(m, cl), sortLocs)) {>
			'   \<TR\>\<TD ALIGN=\"LEFT\"\><printMethod(m, ft, ml, false)>\</TD\>\</TR\>
			'<}>
			'\</TABLE\>\>";
}
