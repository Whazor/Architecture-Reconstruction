module renderer

import IO;
import \OSType;

void open(str output) {

   	if(os() == "Mac OS X") {
		writeFile(|file:///| + homeDir() + "/Desktop/test.dot", output);
		PID pid = createProcess("/usr/local/bin/dot", ["-Tpdf", "-o"+homeDir()+"/Desktop/test.pdf", homeDir()+"/Desktop/test.dot"]);
		readEntireStream(pid);
		createProcess("/usr/bin/open", [homeDir()+"/Desktop/test.pdf"]);
	}
	
}