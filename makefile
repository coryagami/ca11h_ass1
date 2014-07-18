LEX:
	lex -i lexer.l
	g++ -o pasclex driver.c lex.yy.c -lfl
