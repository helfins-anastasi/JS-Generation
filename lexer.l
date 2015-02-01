%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <iostream>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    	bool inString = false;
	void yyerror(const char *);
%}

%x string
%x comment
%x string_

%%

[ \t\n]         {}

"("		{ std::cout << "(" << std::endl; return T;}
")"		{ std::cout << ")" << std::endl; return T;}
","		{ std::cout << "," << std::endl; return T;}
"{"		{ std::cout << "{" << std::endl; return T;}
"}"		{ std::cout << "}" << std::endl; return T;}
";"		{ std::cout << ";" << std::endl; return T;}
"="		{ std::cout << "=" << std::endl; return T;}
"?"		{ std::cout << "?" << std::endl; return T;}
":"		{ std::cout << ":" << std::endl; return T;}
"|"		{ std::cout << "|" << std::endl; return T;}
"^"		{ std::cout << "^" << std::endl; return T;}
"&"		{ std::cout << "&" << std::endl; return T;}
"+"		{ std::cout << "+" << std::endl; return T;}
"-"		{ std::cout << "-" << std::endl; return T;}
"."		{ std::cout << "." << std::endl; return T;}
"["		{ std::cout << "[" << std::endl; return T;}
"]"		{ std::cout << "]" << std::endl; return T;}
"<"		{ std::cout << "<" << std::endl; return T;}
">"		{ std::cout << ">" << std::endl; return T;}
"*"		{ std::cout << "*" << std::endl; return T;}
"/"		{ std::cout << "/" << std::endl; return T;}
"!"		{ std::cout << "!" << std::endl; return T;}
"\\"		{ std::cout << "\\" << std::endl; return T;}
[']		{ std::cout << "'" << std::endl;
		  if(inString) inString = false; 
		  else { BEGIN(string_); inString=true; }  }
"\""		{ std::cout << "\"" << std::endl;
		  if(inString) inString = false; 
		  else { BEGIN(string); inString=true; }   }
"/*"		{ std::cout << "COMMENT" <<std::endl;BEGIN(comment);}
if		{ std::cout << "if" << std::endl; return T;}
in		{ std::cout << "in" << std::endl; return T;}
do		{ std::cout << "do" << std::endl; return T;}
for		{ std::cout << "for" << std::endl; return T;}
var		{ std::cout << "var" << std::endl; return T;}
new		{ std::cout << "new" << std::endl; return T;}
let		{ std::cout << "let" << std::endl; return T;}
try		{ std::cout << "try" << std::endl; return T;}
else		{ std::cout << "else" << std::endl; return T;}
with		{ std::cout << "with" << std::endl; return T;}
this		{ std::cout << "this" << std::endl; return T;}
true		{ std::cout << "true" << std::endl; return T;}
null		{ std::cout << "null" << std::endl; return T;}
case		{ std::cout << "case" << std::endl; return T;}
void		{ std::cout << "void" << std::endl; return T;}
while		{ std::cout << "while" << std::endl; return T;}
break		{ std::cout << "break" << std::endl; return T;}
false		{ std::cout << "false" << std::endl; return T;}
catch		{ std::cout << "catch" << std::endl; return T;}
throw		{ std::cout << "throw" << std::endl; return T;}
yield		{ std::cout << "yield" << std::endl; return T;}
super		{ std::cout << "super" << std::endl; return T;}
const		{ std::cout << "const" << std::endl; return T;}
return		{ std::cout << "return" << std::endl; return T;}
"delete"       	{ std::cout << "delete" << std::endl; return T;}
switch		{ std::cout << "switch" << std::endl; return T;}
typeof		{ std::cout << "typeof" << std::endl; return T;}
import		{ std::cout << "import" << std::endl; return T;}
delete		{ std::cout << "delete" << std::endl; return T;}
export		{ std::cout << "export" << std::endl; return T;}
default		{ std::cout << "default" << std::endl; return T;}
finally		{ std::cout << "finally" << std::endl; return T;}
continue	{ std::cout << "continue" << std::endl; return T;}
function	{ std::cout << "function" << std::endl; return T;}
debugger	{ std::cout << "debugger" << std::endl; return T;}
undefined	{ std::cout << "undefined" << std::endl; return T;}
instanceof	{ std::cout << "instanceof" << std::endl; return T;}
"use strict"	{ std::cout << "use strict" << std::endl; return T;}

[0-9]*		{ std::cout  <<  "NUMBER"  <<  std::endl;  return T;}

class|extends|enum|await { yyerror("invalid keyword"); }

<string>[^"]* 	{ std::cout << "STRING_LITERAL" << std::endl; BEGIN(0); return T;}
<string_>[^']*	{ std::cout << "STRING_LITERAL" << std::endl; BEGIN(0); return T;}
<string>["]	{ std::cout << "\"" << std::endl; BEGIN(0); inString = false; }
<string_>[']	{ std::cout << "'"  << std::endl; BEGIN(0); inString = false; }

<comment>"*/"	{BEGIN(0);}
<comment>.	{}

[_a-zA-Z$][_a-zA-Z0-9$]* {std::cout << "IDENTIFIER" << std::endl; return T;}

.               { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
