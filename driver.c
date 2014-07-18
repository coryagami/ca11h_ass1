#include "token.h"

/*
union yy{
  int semantic_value;
  float fvalue;
} yylval, yyval;
*/

//#include "lex.yy.c"

extern float yylval;
extern vector<string> string_table;

char output1[100][20]={"EOFtoken", "SEMItoken", "COLONtoken", "COMMAtoken",
     "DOTtoken", "LPARENtoken", "RPARENtoken", "LTtoken", 
     "GTtoken", "EQtoken", "MINUStoken",
     "PLUStoken", "TIMEStoken", "DOTDOTtoken", 
     "COLEQtoken", "LEtoken", "GEtoken", "NEtoken",
     "IDtoken", "ICONSTtoken", "FCONSTtoken", 
     "CCONSTtoken", "SCONSTtoken", "ANDtoken", "ARRAYtoken",
     "BEGINtoken", "CONSTtoken", "DIVIDEtoken",
     "DOWNTOtoken", "INTtoken", "ELSEtoken",
     "ELSIFtoken", "ENDtoken", "ENDIFtoken", 
     "ENDLOOPtoken", "ENDRECtoken",
     "EXITtoken", "FORtoken", "FORWARDtoken", 
     "FUNCTIONtoken", "IFtoken", "IStoken",
     "LOOPtoken", "NOTtoken", "OFtoken", 
     "ORtoken", "PROCEDUREtoken", "PROGRAMtoken",
     "RECORDtoken", "REPEATtoken", "FLOATtoken",  "RETURNtoken", 
     "THENtoken", "TOtoken", "TYPEtoken",
     "UNTILtoken", "VARtoken", "WHILEtoken", "PRINTtoken"};

main()
{	
	int i;
	while((i=yylex()) != EOFnumber)
	{
		switch(i)
		{
			case IDnumber:
				{cout << setw(14) << output1[i] << ", " << string_table[yylval] << endl; break;}
			case ICONSTnumber:
				{cout << setw(14) << output1[i] << ", " << yylval << endl; break;}
			case FCONSTnumber:
				{
					cout << setw(14) << fixed << setprecision(6) << output1[i] << ", " << yylval;
					cout << std::resetiosflags(std::ios::fixed) << endl;
				 	break;
				}
			case SCONSTnumber:
				{cout << setw(14) << output1[i] << ", '" << string_table[yylval].c_str() << "'\n"; break;}
			case CCONSTnumber:
				{
					cout << setw(14) << output1[i] << ", ";
					switch((int)yylval) {
					case '\n': cout << "'\\n'\n"; break;
					case '\t': cout << "'\\t'\n"; break;
					case '\\': cout << "'\\\\'\n"; break;
					case '\'': cout << "'\\''\n"; break;
					default: cout << "'" << string_table[yylval] << "'" << "\n";
					}
					break;
				}
			default:
				{cout << setw(14) << output1[i] << endl; break;}
		}
	}
	cout << setw(14) << output1[0] << endl;
}






/*
    int i;
    while ((i=yylex())!=EOFnumber) {
        switch(i) {
	case IDnumber :
            printf("%14s, %s\n", 
                   output1[i-100], string_buff+yylval.semantic_value);
            break;
	case SCONSTnumber:
            printf("%14s, string='%s'\n", 
                   output1[i-100],string_buff+yylval.semantic_value);
            break;
	  case ICONSTnumber :
            printf("%14s, %d\n",output1[i-100],yylval.semantic_value);
            break;
	  case FCONSTnumber :
            printf("%14s, %f\n",output1[i-100],yylval.fvalue);
            break;
	  case CCONSTnumber :
            printf("%14s, ", output1[i-100]);
            switch(yylval.semantic_value) {
	    case '\n' : printf("%s\n", "'\\n'"); break;
	    case '\t' : printf("%s\n", "'\\t'"); break;
            case '\\' : printf("%s\n", "'\\\\'"); break;
            case '\'' : printf("%s\n", "'\\''"); break;
            default : printf("'%c'\n",  yylval.semantic_value); 
	    }
            break;
          default :
            printf("%14s\n",output1[i-100]);
	  }
            
      }
      printf("%14s\n","EOFtoken");
*/
