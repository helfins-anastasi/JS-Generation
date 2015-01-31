%option yylineno
%pointer

%{
    #include <cstdlib>
    #include <cerrno>
    #include <climits>
    #include <limits>
    #include "parser.hpp"
    
	void yyerror(const char *);
%}

%%

"("		{ std::cout << "(" << std::endl; }
")"		{ std::cout << ")" << std::endl; }
","		{ std::cout << "," << std::endl; }
"{"		{ std::cout << "{" << std::endl; }
"}"		{ std::cout << "}" << std::endl; }


.               { yyerror("invalid character"); }

%%

int yywrap(void) {
  return 1;
}
