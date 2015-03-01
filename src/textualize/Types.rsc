module textualize::Types

import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

import lang::ofg::ast::Java2OFG;
import lang::ofg::ast::FlowLanguage;
import lang::java::m3::TypeHierarchy;

import IO;

public map[loc, str] getAllTypes(set[Declaration] decs) {
	map[loc, str] blaat = ();
	visit(decs) {
     	case \field(Type \type, list[Expression] fragments):{
     		loc decl = \fragments[0]@decl;
     		blaat += (decl : getType(\type)); 
     	}   
     	case met:\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl):{
     		loc decl = met@decl;
     		blaat += (decl : getType(\return));
     	}
     	case met:\method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions) : {
     		loc decl = met@decl;
     		blaat += (decl : getType(\return)); 
     	}   
     	case para:\parameter(Type \type, str name, int extraDimensions) :{
    		loc decl = para@decl;
     		blaat += (decl : getType(\type)); 
     	}
     	
   	};
   	return blaat;
}

str getType(Type typ) {

	switch(typ) {
		case arrayType(Type \type): {
			//iprintln(\type@typ);
			visit(\type) {
        		case \simpleName(str name):
        			return name;	
        	}
		}
        case parameterizedType(Type \type):{
        	
        	visit(\type) {
        		
        		case sm:\simpleName(str name): {
					//iprintln(sm@typ);        			
        			return name;	
        			}
        	}
    	}
    	
        case qualifiedType(Type qualifier, Expression simpleName): return "qualifiedType";
        case simpleType(Expression name): visit(name) {
        		case \simpleName(str name):
        			return name;	
    		}
        case unionType(list[Type] types): return "unionType";
        case wildcard(): return "?";
        case upperbound(Type \type): return " extends " + getType(\type);
        case lowerbound(Type \type): return " super " + getType(\type);
        case \int(): return "int";
        case short(): return "short";
        case long(): return "long";
        case float(): return "float";
        case double(): return "double";
        case char(): return "char";
        case string(): return "string";
        case byte(): return "byte";
        case \void(): return "void";
        case \boolean(): return "boolean";
	}
	return "";
}