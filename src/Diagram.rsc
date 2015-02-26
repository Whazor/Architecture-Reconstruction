module \Diagram
import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

import lang::ofg::ast::Java2OFG;
import lang::ofg::ast::FlowLanguage;
import lang::java::m3::TypeHierarchy;

import IO;
import util::ShellExec;
import Rendering;
import Set;
import List;
import String;

str printClass(M3 m, loc cl) {
	return cl.file + "\\l"+
		"|" + "<for(ml <- methods(m, cl)) {><printMethod(m,ml)>\\l<}>"+
		"|" + "<for(fl <- fields(m, cl)) {><printField(m, fl)>\\l<}>";
}

str printMethod(M3 m, loc ml) {
	bool isPrivate = true;
	bool isPublic = false;
	for(mo <- m@modifiers[ml]?[]) {
		visit(mo) { 
			case \public(): {
				isPublic = true;
				isPrivate = false;
			}
			case \private(): isPrivate = true;
		} 
	}
	
	visibility = (isPublic ? "+" : "-");
	
	return visibility + ml.file;
}

str printField(M3 m, loc fl) {
	//return "["+m@typeDependency[fl].file + "] " + fl.file;
	return fl.file;
}

void hello() {
	proj = |project://eLib|;
	m = createM3FromEclipseProject(proj);
	p = createOFG(proj);

	int i = 0;
	int id() { i += 1; return i; } // a local function to generate unique id's
  	
  	int j = 0;
  	int pid() { j += 1; return j; }
  	
	//inf = extractProject(p); // this gets the information about all Java classes in project p
	//inf@classes<1> + carrier(inf@extends); // we add the classes that p depends on
	ids = ( cl : id() | cl <- classes(m) );  // generate a map with id codes
	pids = ( pl : pid() | pl <- packages(m) );
	
	loc combine (list[str] arr) = ( |java+package:///| | it + part | part <- arr ); 
	
	output = "digraph classes {
	       '  fontname = \"Bitstream Vera Sans\"
	       '  fontsize = 8
	       '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
	       '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
	       '"
	       
	       
	       
	       // Association/aggregation, class A { B b; }, A -> B
	       +"
	       ' <for(tuple[loc field, set[loc] types] dub <- [<ma, m@typeDependency[ma]> | ma <- fields(m)], (false | (it || th.scheme == "java+class" && (!startsWith(th.path, "/java"))) | th <- dub.types)) {>
	       '   <for(dto <- dub.types, dto in classes(m)) {>
	       ' 	C<ids[|java+class:///| + dub.field.parent.path]> -\> C<ids[dto]>
	       '   <}>
	       ' <}>
	       '"
	       
	       // Realization, class A implements B {...}
	       +" edge [ arrowhead = \"vee\", style=dashed, fillcolor=\"\" ]
	       ' <for(d <- m@implements, d.to in ids && d.to.parent != d.from.parent) {>
	       ' C<ids[d.from]> -\> C<ids[d.to]> ;
	       ' <}>
	       '"
	       // Generalization, class A extends B {...}
	       +" edge [ arrowhead = \"empty\", style=solid, fillcolor=\"\" ]
	       ' <for(d <- m@extends, d.to in ids) {>
	       ' C<ids[d.from]> -\> C<ids[d.to]> ;
	       ' <}>"+
	       
	       
	       
	       // get all classes without packages
		   " <for(cl <- classes(m), cl.parent == |java+class:///|) {>
	       '		C<ids[cl]> [ label = \"{<printClass(m, cl)>}\", fillcolor=\"#ffe86d\",style=filled ]
	       ' <}>"
	       
	       // get all packages and classes
	       +" <for(pl <- packages(m)) {>
	       ' 	<for(part <- [1..size(drop(1, split("/", pl.path)))]) {>
	       '		subgraph cluster<pids[combine( take(part, drop(1, split("/", pl.path))) )]> {
	       '	<}>
	       '   subgraph cluster<pids[pl]> {
	       '    label = \"Package <pl.file>\"
	       '	fillcolor = \"#fff8d3\"
	       '	style=filled
	       '    
		   ' 	<for(cl <- classes(m), startsWith(cl.path, pl.path)) {>
	       '		C<ids[cl]> [ label = \"{<printClass(m, cl)>}\", fillcolor=\"#ffe86d\",style=filled ]
	       '	<}>
	       ' 	<for(part <- [1..size(drop(1, split("/", pl.path)))]) {>
	       '		}
	       '	<}>
       	   '   }
	       ' <}>"
			
	       
	       +"}";
	       
	       
  	open(output);
	
}