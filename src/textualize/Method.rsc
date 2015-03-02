module textualize::Method

import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;
import IO;

str printMethod(M3 m, map[loc, str] ft, loc ml, bool privatePrio) {
	bool isPrivate = privatePrio;
	bool isProtected = false;
	bool isPublic = !privatePrio;
	bool isStatic = false;
	
	for(mo <- m@modifiers[ml]?[]) {
		visit(mo) { 
			case \public(): {
				isPublic = true;
				isPrivate = false;
			}
			case \protected():  {
				isProtected = true;
				isPrivate = false;
			}
			case \private(): isPrivate = true;
			case \static(): isStatic = true;
		}
	}
	
	visibility = (isPublic ? "+" : (isProtected ? "#" : "-"));
	ast = getMethodAST(ml);
	list[str] parameters = [ft[s@decl] | s <- ast.parameters];
	name = ast.name + "(" + ("" | it+(it != "" ? ", " : "") + par | par <- parameters) +")";
	
	if (isStatic){
		return "\<u\>" + visibility + name + "\</u\>";
	}

	return visibility + name + ((ml in ft) ? (" : " +ft[ml]) : "");
}