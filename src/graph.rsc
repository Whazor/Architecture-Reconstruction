module \graph
import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

import lang::ofg::ast::Java2OFG;
import lang::ofg::ast::FlowLanguage;
import lang::java::m3::TypeHierarchy;

import IO;
import util::ShellExec;
import renderer;

void hello() {
	m = createM3FromEclipseProject(|project://eLib|);
	p = createOFG(|project://eLib|);

	int i = 0;
	int id() { i += 1; return i; } // a local function to generate unique id's
  	
	//inf = extractProject(p); // this gets the information about all Java classes in project p
	//inf@classes<1> + carrier(inf@extends); // we add the classes that p depends on
	ids = ( cl : id() | cl <- classes(m) );  // generate a map with id codes
	
	output = "digraph classes {
	       '  fontname = \"Bitstream Vera Sans\"
	       '  fontsize = 8
	       '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
	       '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
	       '
	       ' <for(cl <- classes(m)) {>
	       ' C<ids[cl]> [ label = \"{<cl.file>}\" ]
	       ' <}>
	       ' 
	       ' <for(d <- m@extends) {>
	       ' C<ids[d.from]> -\> C<ids[d.to]> 
	       ' <}>
	       '}";
  	open(output);
	
}