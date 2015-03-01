module textualize::Field

import lang::java::jdt::m3::Core; 
import lang::java::jdt::m3::AST;

import String;

str printField(M3 m, map[loc, str] ft, loc fl) {
	bool isPrivate = true;
	bool isProtected = false;
	bool isPublic = false;
	bool isStatic = false;
	
	str fieldName = fl.file;
	
	for(field <- m@modifiers[fl]?[]) {
		visit(field) { 
			case \public(): {
				isPublic = true;
				isPrivate = false;
			}
			case \protected():  {
				isProtected = true;
				isPrivate = false;
			}
			case \final():  {
				fieldName = toUpperCase(fieldName);
			}
			case \private(): isPrivate = true;
			case \static(): isStatic = true;
		} 
	}
	
	visibility = (isPublic ? "+" : (isProtected ? "#" : "-"));
	
	if (isStatic){
		return "\<u\>" + visibility + fieldName + "\</u\>"  + ((fl in ft) ? (" : " +ft[fl]) : "");
	}
	
	return visibility + fieldName  + ((fl in ft) ? (" : " +ft[fl]) : "");
}