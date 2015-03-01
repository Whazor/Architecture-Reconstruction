module \Diagram
import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

import lang::ofg::ast::Java2OFG;
import lang::ofg::ast::FlowLanguage;
import lang::java::m3::TypeHierarchy;

import String;
import List;

import Rendering;
import textualize::Types;
import textualize::Entity;

void construct() {
	proj = |project://eLib|;
	m = createM3FromEclipseProject(proj);
	p = createOFG(proj);
	a = createAstsFromEclipseProject(proj, true);

	// ids for classes/interfaces
	int i = 0;
	int id() { i += 1; return i; } // a local function to generate unique id's
  	ids = ( cl : id() | cl <- classes(m) + interfaces(m) );  // generate a map with id codes
  	
  	// ids for packages
  	int j = 0;
  	int pid() { j += 1; return j; }
	pids = ( pl : pid() | pl <- packages(m) );
	
	// put all the types in a map
	ft = getAllTypes(a);
	
	loc combine (list[str] arr) = ( |java+package:///| | it + part | part <- arr ); 
	
	output = "digraph classes {
	       '  fontname = \"Arial\"
	       '  fontsize = 8
	       '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
	       '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
	       '"	       
	       
	       // Association/aggregation, class A { B b; }, A -> B
	       +"
	       ' <for(tuple[loc field, set[loc] types] dub <- [<ma, m@typeDependency[ma]> | ma <- fields(m)], (false | (it || th.scheme == "java+class" && (!startsWith(th.path, "/java"))) | th <- dub.types)) {>
	       '   <for(dto <- dub.types, dto in (classes(m) )) {>
	       ' 	E<ids[|java+class:///| + dub.field.parent.path]> -\> E<ids[dto]>
	       '   <}>
	       ' <}>
	       '"
	       
	       // Realization, class A implements B {...}
	       +" edge [ arrowhead = \"vee\", style=dashed, fillcolor=\"\" ]
	       ' <for(d <- m@implements, d.to in ids) {>
	       ' E<ids[d.from]> -\> E<ids[d.to]> ;
	       ' <}>
	       '"
	       
	       // Generalization, class A extends B {...}
	       +" edge [ arrowhead = \"empty\", style=solid, fillcolor=\"\" ]
	       ' <for(d <- m@extends, d.to in ids) {>
	       ' E<ids[d.from]> -\> E<ids[d.to]> ;
	       ' <}>"
	       
	       // Dependency, class A depends on B {...}
	       //+" edge [ arrowhead = \"empty\", style=dashed, fillcolor=\"\" ]
	       //' <for(d <- m@extends, d.to in ids) {>
	       //' E<ids[d.from]> -\> E<ids[d.to]> ;
	       //' <}>"
	       
	       // get all classes without packages
		   +" <for(cl <- classes(m), cl.parent == |java+class:///|) {>
	       '		E<ids[cl]> [ label = <printClass(m, ft, cl)>, margin = \"0,0\", fillcolor=\"#ffe86d\",style=filled ]
	       ' <}>"
	       
	       // get all interfaces without packages
		   +" <for(cl <- interfaces(m), cl.parent == |java+interface:///|) {>
	       '		E<ids[cl]> [ label = <printInterface(m, ft, cl)>, margin = \"0,0\", fillcolor=\"#ffe86d\",style=filled ]
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
	       '		E<ids[cl]> [ label = <printClass(m, ft, cl)>, margin = \"0,0\", fillcolor=\"#ffe86d\",style=filled ]
	       '	<}>
		   ' 	<for(cl <- interfaces(m), startsWith(cl.path, pl.path)) {>
	       '		E<ids[cl]> [ label = <printInterface(m, ft, cl)>, margin = \"0,0\", fillcolor=\"#ffe86d\",style=filled ]
	       '	<}>
	       ' 	<for(part <- [1..size(drop(1, split("/", pl.path)))]) {>
	       '		}
	       '	<}>
       	   '   }
	       ' <}>"
			
	       
	       +"}";
	       
	       
  	open(output);
	
}