module textualize::Method

import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

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
	
	if (isStatic){
		return "\<u\>" + visibility + ml.file + "\</u\>";
	}
		
	return visibility + ml.file + ((ml in ft) ? (" : " +ft[ml]) : "");
}