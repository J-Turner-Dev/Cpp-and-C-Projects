/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 3
/* File: parser.y
/* Date: November 26, 2021

/* Purpose: This file identifies the tokens and contains the instructions 
			for the grammar that the parser uses to identify 
			syntactically correct input for the language it also contains
			expression precedence within the grammar. */

%{

#include <iostream>
#include <cstring>
#include <vector>
#include <map>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<double> symbols;

double result;
double *parameters = NULL;
int count = 1;
int size = 0;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Operators oper;
	double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token <oper> ADDOP MULOP RELOP REMOP
%token ANDOP NOTOP OROP EXPOP

%token FUNCTION BEGIN_ END RETURNS INTEGER REAL BOOLEAN REDUCE ENDREDUCE
%token IF THEN ELSE ENDIF CASE IS WHEN ARROW OTHERS ENDCASE 


%type <value> body statement_ statement reductions expression relation term
	factor primary binarylogic exponent unarylogic case cases
%type <oper> operator

%%

function:	
	function_header optional_variable body {result = $3;} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';' ;

optional_variable:
	optional_variable variable |
	;

variable:
	IDENTIFIER ':' variabletwo |
	error variabletwo ;

variabletwo:
	type IS statement_ {symbols.insert($<iden>-1, $3);} |
	error statement_ ;

parameters:
	parameters ',' IDENTIFIER ':' type {if(count + 2 <= size)symbols.insert($3, parameters[++count]);} |
	IDENTIFIER ':' type {if(count + 1 <= size)symbols.insert($1, parameters[count]);} |
	;

type:
	INTEGER |
    REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = 0;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
    IF expression THEN statement_ ELSE statement_ ENDIF {$$ = $2 == 0 ? $6 : $4;} |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE {$$ = isnan($4) ? $7 : $4;} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
    expression OROP binarylogic {$$ = $1 || $3;} |
	binarylogic ;

cases:
	cases case {$$ = isnan($1) ? $2 : $1;} |
	{$$ = NAN;} ;

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $2 == $<value>-2 ? $4 : NAN;} |
	error ';' {$$ = NAN;} ;

binarylogic:
	binarylogic ANDOP relation {$$ = $1 && $3;} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;
      
factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
    factor REMOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	exponent ;

exponent:
    unarylogic EXPOP exponent {$$ = pow($1, $3);} |
	unarylogic ;

unarylogic:
	NOTOP unarylogic {$$ = !$2;} |
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	parameters = new double[argc];

	char cmpTrue[] = "true";
	char cmpFalse[] = "false";
	
	// This will increment the size counter so that 
	// it is the same size as the argv array
	while(argv[++size] != NULL);

	// This takes the strings within the argv array and
	// if it is a letter then it will make it lower case
	for(int i = 0; i < argc; i++) {
		for(int j = 0; j < sizeof(argv[i]); j++) {
			char temp = argv[i][j];
			argv[i][j] = tolower(temp);
		}
	}

	// This will check to see if the parameter is a string
	// That says true or false and convert it to 1 or 0
	// Or else it will store the double value of the parameter
	for (int i = 0; i < size; i++) {
		if(!strcmp(argv[i], cmpTrue)) {
			parameters[i] = 1;
		}
		else if (!strcmp(argv[i], cmpFalse)) {
			parameters[i] = 0;
		}
		else {
			parameters[i] = atof(argv[i]);
		}
	}

	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " << result << endl;
	return 0;
} 