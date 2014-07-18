%{
#include "token.h"

extern void lex_error(string msg);
extern int put_string(char *str, bool upper);

/*
union yy{
  int semantic_value;
  float fvalue;
} yylval, yyval;
*/

float yylval;
vector<string> string_table;
int st_index = 0;
int yyline = 1, yycolumn = 1;
%}

delim   [ \t]
ws      {delim}+
letter [a-zA-Z]
digit  [0-9]
id     {letter}({letter}|{digit})*
number {digit}+

int string_buff = 0;

%%

\n						{yyline++; yycolumn = 1;}
[ \t]+					{yycolumn += yyleng;}

(AND|and)						{yycolumn += yyleng; return ANDnumber;}
(ARRAY|array)					{yycolumn += yyleng; return ARRAYnumber;}
(BEGIN|begin)					{yycolumn += yyleng; return BEGINnumber;}
(CONSTANT|constant)				{yycolumn += yyleng; return CONSTnumber;}
(DIV|div)						{yycolumn += yyleng; return DIVnumber;}
(DOWNTO|downto)					{yycolumn += yyleng; return DOWNTOnumber;}
(INTEGER|integer)					{yycolumn += yyleng; return INTnumber;}
(ELSE|else)					{yycolumn += yyleng; return ELSEnumber;}
(ELSIF|elsif)					{yycolumn += yyleng; return ELSIFnumber;}
(END|end)						{yycolumn += yyleng; return ENDnumber;}
(ENDIF|endif)					{yycolumn += yyleng; return ENDIFnumber;}
(ENDLOOP|endloop)					{yycolumn += yyleng; return ENDLOOPnumber;}
(ENDREC|endrec)					{yycolumn += yyleng; return ENDRECnumber;}
(EXIT|exit)					{yycolumn += yyleng; return EXITnumber;}
(FOR|for)						{yycolumn += yyleng; return FORnumber;}
(FORWARD|forward)					{yycolumn += yyleng; return FORWARDnumber;}
(FUNCTION|function)				{yycolumn += yyleng; return FUNCTIONnumber;}
(IF|if)						{yycolumn += yyleng; return IFnumber;}
(IS|is)						{yycolumn += yyleng; return ISnumber;}
(LOOP|loop)					{yycolumn += yyleng; return LOOPnumber;}
(NOT|not)						{yycolumn += yyleng; return NOTnumber;}
(OF|of)						{yycolumn += yyleng; return OFnumber;}
(OR|or)						{yycolumn += yyleng; return ORnumber;}
(PROCEDURE|procedure)				{yycolumn += yyleng; return PROCEDUREnumber;}
(PROGRAM|program)					{yycolumn += yyleng; return PROGRAMnumber;}
(RECORD|record)					{yycolumn += yyleng; return RECORDnumber;}
(REPEAT|repeat)					{yycolumn += yyleng; return REPEATnumber;}
(FLOAT|float)					{yycolumn += yyleng; return FLOATnumber;}
(RETURN|return)					{yycolumn += yyleng; return RETURNnumber;}
(THEN|then)					{yycolumn += yyleng; return THENnumber;}
(TO|to)						{yycolumn += yyleng; return TOnumber;}
(TYPE|type)					{yycolumn += yyleng; return TYPEnumber;}
(UNTIL|until)					{yycolumn += yyleng; return UNTILnumber;}
(VAR|var)						{yycolumn += yyleng; return VARnumber;}
(WHILE|while)					{yycolumn += yyleng; return WHILEnumber;}
(PRINT|print)					{yycolumn += yyleng; return PRINTnumber;}

[a-zA-Z]+[0-9]*			{yylval = put_string(yytext, true); return IDnumber;}
[0-9]+					{yylval = atoi(yytext); yycolumn += yyleng; return ICONSTnumber;}
'[^'\n]*				{ int c;
						if(yyleng == 2)		// <---- we are in a char constant 'x
						{
							yylval = put_string(yytext+1, false);
							c = yyinput();
							if(c != '\'')
								{
									lex_error("unclosed char");
									if(c != 0) unput(c);
								} 
							yycolumn += yyleng;
							return CCONSTnumber;
						}
						if(yyleng == 3)
						{
							if(yytext[1] == '\\' && ((yytext[2] == 'n')||(yytext[2] == 't')||
														yytext[2] == '\'')||(yytext[2] == '\\'))
							{
								yylval = put_string(yytext+1, false);
								c = yyinput();
								if(c != '\'')
								{
									lex_error("unclosed string");
									if(c != 0) unput(c);
								}
								yycolumn += yyleng;
								return CCONSTnumber;
							}
						}
						else
						{
							yylval = put_string(yytext+1, false);
							/*if(yytext[yyleng-1]=='\\')
							{
								yymore();
								yylval = put_string(yytext+1, false);
								yycolumn += yyleng;
								return SCONSTnumber;
							}*/
							c = yyinput();
							if(c != '\'')
								{
									lex_error("unclosed string");
									if(c != 0) unput(c);
								}
							yycolumn += yyleng; 
							return SCONSTnumber;
						}
						}
[0-9]+\.[0-9]+([eE][-+]?[0-9]+)?		{yylval = ::atof(yytext); yycolumn += yyleng; return FCONSTnumber;}


";"						{yycolumn += yyleng; return SEMInumber;}
":"						{yycolumn += yyleng; return COLONnumber;}
","						{yycolumn += yyleng; return COMMAnumber;}
"."						{yycolumn += yyleng; return DOTnumber;}
"("						{yycolumn += yyleng; return LPARENnumber;}
")"						{yycolumn += yyleng; return RPARENnumber;}
"<"						{yycolumn += yyleng; return LTnumber;}
">"						{yycolumn += yyleng; return GTnumber;}
"="						{yycolumn += yyleng; return EQnumber;}
"-"						{yycolumn += yyleng; return MINUSnumber;}
"+"						{yycolumn += yyleng; return PLUSnumber;}
"*"						{yycolumn += yyleng; return TIMESnumber;}
".."						{yycolumn += yyleng; return DOTDOTnumber;}
":="						{yycolumn += yyleng; return COLEQnumber;}
"<="						{yycolumn += yyleng; return LEnumber;}
">="						{yycolumn += yyleng; return GEnumber;}
"<>"						{yycolumn += yyleng; return NEnumber;}

.						{string s(yytext); lex_error("improper character \'" + s + "\'"); yycolumn += yyleng;}

"(*"						{ char c1, c2;
							c2 = yyinput(); if(c2 == '\n'){yyline++; yycolumn=1;}
							if(c2 <= 0) {lex_error("unended comment");}
							else
								{ 
									c1 = c2; c2 = yyinput(); 
									if(c2 == '\n') {yyline++; yycolumn=1;}
									while(((c1 != '*')||(c2 != ')')) && (c2 > 0))
										{
											c1 = c2; c2 = yyinput(); 
											if(c2 == '\n'){yyline++; yycolumn=1;}
											if(c2 <= 0) {lex_error("unended comment");}
										}
								}	
							}

%%

int yywrap()
{  if (feof(stdin)) return 1;
   return 0;
}

int put_string(char *str, bool upper)
{
  string s(str);
  if(upper)
  	boost::to_upper(s);
  string_table.push_back(s);
  st_index++;
  return st_index-1;
}

void lex_error(string msg)
{
  cout << msg << ", line=" << yyline << " column=" << yycolumn << endl;
}
