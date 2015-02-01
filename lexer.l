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
%x comment_

%%

[ \t]  		{}
[\n]		{ std::cout << "\n" << std::endl; }

"("		{ std::cout << "(" << std::endl; }
")"		{ std::cout << ")" << std::endl; }
","		{ std::cout << "," << std::endl; }
"{"		{ std::cout << "{" << std::endl; }
"}"		{ std::cout << "}" << std::endl; }
";"		{ std::cout << ";" << std::endl; }
"="		{ std::cout << "=" << std::endl; }
"?"		{ std::cout << "?" << std::endl; }
":"		{ std::cout << ":" << std::endl; }
"|"		{ std::cout << "|" << std::endl; }
"^"		{ std::cout << "^" << std::endl; }
"&"		{ std::cout << "&" << std::endl; }
"+"		{ std::cout << "+" << std::endl; }
"-"		{ std::cout << "-" << std::endl; }
"."		{ std::cout << "." << std::endl; }
"["		{ std::cout << "[" << std::endl; }
"]"		{ std::cout << "]" << std::endl; }
"<"		{ std::cout << "<" << std::endl; }
">"		{ std::cout << ">" << std::endl; }
"*"		{ std::cout << "*" << std::endl; }
"/"		{ std::cout << "/" << std::endl; }
"!"		{ std::cout << "!" << std::endl; }
"%"		{ std::cout << "%" << std::endl; }
"\\"		{ std::cout << "\\" << std::endl; }
[']		{ std::cout << "'" << std::endl;
		  if(inString) inString = false; 
		  else { BEGIN(string_); inString=true; }  }
"\""		{ std::cout << "\"" << std::endl;
		  if(inString) inString = false; 
		  else { BEGIN(string); inString=true; }   }
"/*"		{ std::cout << "COMMENT" << std::endl; BEGIN(comment); }
"//"		{ std::cout << "COMMENT" << std::endl; BEGIN(comment_); }
if		{ std::cout << "if" << std::endl; }
in		{ std::cout << "in" << std::endl; }
do		{ std::cout << "do" << std::endl; }
for		{ std::cout << "for" << std::endl; }
var		{ std::cout << "var" << std::endl; }
new		{ std::cout << "new" << std::endl; }
let		{ std::cout << "let" << std::endl; }
try		{ std::cout << "try" << std::endl; }
else		{ std::cout << "else" << std::endl; }
with		{ std::cout << "with" << std::endl; }
this		{ std::cout << "this" << std::endl; }
true		{ std::cout << "true" << std::endl; }
null		{ std::cout << "null" << std::endl; }
case		{ std::cout << "case" << std::endl; }
void		{ std::cout << "void" << std::endl; }
while		{ std::cout << "while" << std::endl; }
break		{ std::cout << "break" << std::endl; }
false		{ std::cout << "false" << std::endl; }
catch		{ std::cout << "catch" << std::endl; }
throw		{ std::cout << "throw" << std::endl; }
yield		{ std::cout << "yield" << std::endl; }
super		{ std::cout << "super" << std::endl; }
const		{ std::cout << "const" << std::endl; }
return		{ std::cout << "return" << std::endl; }
"delete"       	{ std::cout << "delete" << std::endl; }
switch		{ std::cout << "switch" << std::endl; }
typeof		{ std::cout << "typeof" << std::endl; }
import		{ std::cout << "import" << std::endl; }
delete		{ std::cout << "delete" << std::endl; }
export		{ std::cout << "export" << std::endl; }
default		{ std::cout << "default" << std::endl; }
finally		{ std::cout << "finally" << std::endl; }
continue	{ std::cout << "continue" << std::endl; }
function	{ std::cout << "function" << std::endl; }
debugger	{ std::cout << "debugger" << std::endl; }
undefined	{ std::cout << "undefined" << std::endl; }
instanceof	{ std::cout << "instanceof" << std::endl; }
"use strict"	{ std::cout << "use strict" << std::endl; }

[0-9]*		{ std::cout  <<  "NUMBER"  <<  std::endl; }

class|extends|enum|await { yyerror("invalid keyword"); }

<string>[^"]* 	{ std::cout << "STRING_LITERAL" << std::endl; BEGIN(0); }
<string_>[^']*	{ std::cout << "STRING_LITERAL" << std::endl; BEGIN(0); }
<string>["]	{ std::cout << "\"" << std::endl; BEGIN(0); inString = false; }
<string_>[']	{ std::cout << "'"  << std::endl; BEGIN(0); inString = false; }

<comment>"*/"	{BEGIN(0);}
<comment>.	{}
<comment_>[\n]  {BEGIN(0); std::cout << "\n" << std::endl; }
<comment_>.     {}

[_a-zA-Z$][_a-zA-Z0-9$]* {std::cout << "IDENTIFIER" << std::endl; }

.               { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
