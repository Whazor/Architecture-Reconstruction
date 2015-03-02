module relations::dependencies
import lang::ofg::ast::FlowLanguage;

import IO;
import List;
import Relation;

alias OFG = rel[loc from, loc to];

OFG buildGraph(Program p) 
  = { <as[i], fps[i]> | newAssign(x, cl, c, as) <- p.statements, constructor(c, fps) <- p.decls, i <- index(as) }
  + { <cl + "this", x> | newAssign(x, cl, _, _) <- p.statements }  
  + { <y, x> | assign(x, _, y) <- p.statements }
  + { <as[i], fps[i]> | call(_, _, r, ml, as) <- p.statements, method(ml, fps) <- p.decls, i <- index(as) }
  + { <y, ml + "this"> | call(y, _, _, ml, _) <- p.statements, y != emptyId }
  ;
  
  
OFG prop(OFG g, rel[loc,loc] gen, rel[loc,loc] kill, bool back) {
  OFG IN = { };
  OFG OUT = gen + (IN - kill);
  gi = g<to,from>;
  set[loc] pred(loc n) = gi[n];
  set[loc] succ(loc n) = g[n];
  
  solve (IN, OUT) {
    IN = { <n,\o> | n <- carrier(g), p <- (back ? pred(n) : succ(n)), \o <- OUT[p] };
    OUT = gen + (IN - kill);
  }
  
  return OUT;
}

OFG relations(Program pro) {
	ofg = buildGraph(pro);
	
	gen = {<edge.target, edge.class> | edge:newAssign(target, class, _, _) <- pro.statements};
	return prop(ofg, gen, {}, true);
	
	//gen = {<edge.target, edge.class> | edge:newAssign(target, class, _, _) <- pro.statements};
	//return prop(ofg, gen, {}, false);
}


//void relations(Program pro) {
//
//	//set[loc] succ_ (loc bla) = {
//	//	return	{ bl.receiver | bl : call(target, cast, receiver, method, actualParameters) <- pro.statements, bl.receiver == bla || bla in actualParameters } +
//	//		{ bl.target | bl : assign(target, cast, source) <- pro.statements, bl.source == bla } +
//	//		{ bl.target | bl : newAssign(target, class, ctor, actualParameters) <- pro.statements, bla in bl.actualParameters };
//	//};
//	
//	set[loc] pred_ (loc bla) = {
//		return 
//			{ bl.source | bl : assign(target, _, source) <- pro.statements, bl.target == bla } +
//			{ bl.target | bl : call(target, _, receiver, _, _) <- pro.statements, bl.receiver == bla};
//		;
//		//return	{ bl.receiver | bl : call(target, cast, receiver, method, actualParameters) <- pro.statements, bl.receiver == bla || bla in actualParameters } +
//		//	{ bl.target | bl : assign(target, cast, source) <- pro.statements, bl.source == bla } +
//		//	{ bl.target | bl : newAssign(target, class, ctor, actualParameters) <- pro.statements, bla in bl.actualParameters };
//	};
//	
//	decls = { bl.target | bl : call(target, _, _, _, _) <- pro.statements } +
//			{ bl.target | bl : assign(target, _, _) <- pro.statements } + 
//			{ bl.target | bl : newAssign(target, _, _, _) <- pro.statements } +
//			{ bl.id | bl <- pro.decls };
//	decls = ( decls | it + bl.actualParameters | bl : call(_, _, _, _, actualParameters) <- pro.statements);
//
//	gen = (
//			edge.target : edge.class
//			| edge:newAssign(target, class, _, _) <- pro.statements);
//	
//	set[loc] gen_(loc n) = { return {gen[n]} ? {}; };
//	
//	set[loc] kill_(loc n) = { return {emptyId}; };
//		
//	
//	map[loc, set[loc]] in_ = ( ml : {emptyId} | ml <- decls );
//	map[loc, set[loc]] out_ = ( ml : gen_(ml) + ( in_[ ml ] - kill_( ml ) ) | ml <- decls );
//	
//	bool changed = false;
//	
//	do {
//		changed = false;
//		 for (n <- decls) {
//		 	tmpIn = in_[n];
//		 	tmpOut = out_[n];
//		 	in_[n] = ( {} | it + out_[p]?{emptyId} | p <- pred_(n) );
//		 	out_[n] = gen_(n) + ( in_[ n ] - kill_( n ) );
//		 	
//		 	changed = tmpIn != in_[n] || tmpOut != out_[n] || changed;
//		 }
//	} while (changed);
//	
//	iprintln(out_);
//	
//}
