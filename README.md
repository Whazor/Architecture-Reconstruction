# Architecture-Reconstruction
Assignment 2 - Deadline: March 2, 2015, 23:59 Eindhoven time.

https://peach.win.tue.nl/wiki/%3D28/1415-Q3/2IS55/assignment2architecturereconstru/

- [ ] Introduction
- [ ] Input and output
- [ ] The tool chain
- [ ] Apply the tool chain you have developed
- [ ] Discussion
- [ ] Conclusions

## Introduction. 
Explain the purpose of the assignment.

## Input and output.
Input. Discuss the input language of the tool. Which features of Java do you support? Explain why did you decide to support or not to support each one of them. Specifically, do you support 
1. inner classes? 
2. generics?

Output. Discuss the output language of the tool. Explain why did you decide to support or not to support each one of them. Specifically, do you support 
1. named associations such as "subscribes" in http://upload.wikimedia.org/wikipedia/commons/4/4d/UML_role_example.gif?
2. roles of the classes participating in the association relation such as "subscriber" and "subscribed magazine" in the example above?
3. multiplicities such as "0..*" in the example above?

## The tool chain.
a. Tool design. Indicate which components/techniques have you chosen to implement each one of the aforementioned steps, discuss possible design alternatives and motivate your choice. Document any assumptions you made. Describe interfaces between different steps of the tool chain: what kind of information is extracted and in what form is it provided to the architecture reconstruction component? What kind of information is produced by the architecture reconstruction component and how is it provided to the visualisation component?
b. Indicate how the tool chain should be used.

## Apply the tool chain you have developed.
a. Apply the tool to infer the class diagram of the eLib benchmark (the code is available in Tonella and Potrich's book). Present the Object Flow Graphs required to construct the diagram. Evaluate the precision of the tool developed, its performance and visual quality of the class diagram produced. The source code of the eLib benchmark can be downloaded from http://www.win.tue.nl/~aserebre/2IS55/2011-2012/eLib.zip
b. Apply the tool chain to two versions of the CyberNeko HTML Parser. According to its website [http://nekohtml.sourceforge.net/], NekoHTML is a simple HTML scanner and tag balancer that enables application programmers to parse HTML documents and access the information using standard XML interfaces. You should reconstruct the class diagram of versions 0.9.5 [http://sourceforge.net/projects/nekohtml/files/nekohtml/nekohtml-0.9.5/, released in December 2007; focus on Java files in /src/html/org/cyberneko/html/ and eventually its subdirectories] and 1.9.21 [http://sourceforge.net/projects/nekohtml/files/nekohtml/nekohtml-1.9.21/, released in June 2014; focus on Java files /src/org/cyberneko/html/ and eventually its subdirectories]
- Compare the class diagrams you have reconstructed. Describe similarities and differences between the diagrams. What can you learn about the evolution of CyberNeko HTML by comparing the diagrams? Can you relate the changes observed to discussions on nekohtml-user and nekohtml-developer mailing lists (http://sourceforge.net/mailarchive/forum.php?forum_name=nekohtml-user and http://sourceforge.net/mailarchive/forum.php?forum_name=nekohtml-developer) or mentioned on the web-site of CyberNeko?
- Evaluate the precision of the tool developed, its performance and visual quality of the class diagram produced.

## Discussion. 
Based on applying your tool to two case studies identify strengths, weaknesses and limitations of the approach chosen. Relate those to design choices documented in Section 3.

## Conclusions.
