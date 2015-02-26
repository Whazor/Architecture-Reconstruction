module Rendering

import IO;
import \lib::OSType;
import util::ShellExec;

void open(str output) {

   	if(os() == "Mac OS X") {
		writeFile(|file:///| + homeDir() + "/Desktop/test.dot", output);
		PID pid = createProcess("/usr/local/bin/dot", ["-Tsvg", "-o"+homeDir()+"/Desktop/test.svg", homeDir()+"/Desktop/test.dot"]);
		readEntireStream(pid);
		createProcess("/usr/bin/open", [homeDir()+"/Desktop/test.svg"]);
	}
	
	if(os() == "Windows 8") {
		print(homeDir());
		writeFile(|file:///| + homeDir() + "/Desktop/test.dot", output);
		PID pid = createProcess("C:/Program Files (x86)/Graphviz2.38/bin/dot.exe", ["-Tpdf", "-o"+homeDir()+"/Desktop/test.pdf", homeDir()+"/Desktop/test.dot"]);
		readEntireStream(pid);
		createProcess("C:/Program Files (x86)/Adobe/Reader 11.0/Reader/AcroRd32.exe", [homeDir()+"/Desktop/test.pdf"]);
	}
		
}