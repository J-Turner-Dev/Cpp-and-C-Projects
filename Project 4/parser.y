/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 4
/* File: parser.y
/* Date: December 09, 2021

/* Purpose: This file identifies the tokens and contains the instructions 
			for the grammar that the parser uses to identify 
			syntactically correct input for the language it also contains
			expression precedence within the grammar */

%{

#include <string>
#include <vector>
#include <map>

#include <iostream>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;

%}

%define parse.error verbose

%union
{
	CharPtr iden;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL NOTOP

%token ADDOP MULOP RELOP REMOP
%token ANDOP OROP EXPOP

%token FUNCTION BEGIN_ END RETURNS BOOLEAN INTEGER REAL REDUCE ENDREDUCE
%token IF THEN ELSE ENDIF CASE IS WHEN ARROW OTHERS ENDCASE

%type <type> type statement statement_ reductions expression binarylogic relation term
	factor primary exponent unarylogic body function_header function case cases

%%

function:	
	function_header optional_variable body {checkAssignment($1, $3, "Function Return");} ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' {$$ = $5;} |
	error ';' {$$ = MISMATCH;} ;

optional_variable:
	optional_variable variable |
	;

variable:
	IDENTIFIER ':' variabletwo |
	error variabletwo ;

variabletwo:
	type IS statement_ 
		{checkAssignment($1, $3, "Variable Initialization");
		symbols.find($<iden>-1, $1) ? appendError(DUPLICATE_IDENTIFIER, $<iden>-1) 
		: symbols.insert($<iden>-1, $1);} |
	error statement_ ;

parameters:
	parameters ',' IDENTIFIER ':' type |
	IDENTIFIER ':' type |
	;

type:
	INTEGER {$$ = INT_TYPE;} |
	REAL {$$ = REAL_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkIfStatement($2, $4, $6);} |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE {$$ = checkCase($2, $4, $7);} ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;

cases:
	cases case {$$ = $1 == NONE ? $2 : checkWhen($1, $2);} |
	{$$ = NONE;} ;

case:
	WHEN INT_LITERAL ARROW statement_ {$$ = $4;} |
	error ';' {$$ = MISMATCH;} ;

expression:
	expression OROP binarylogic {$$ = checkLogical($1, $3);} |
	binarylogic ;

binarylogic:
	binarylogic ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);} |
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP primary  {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent {$$ = checkRemainder($1, $3);} |
	exponent ;

exponent:
	unarylogic EXPOP exponent {$$ = checkArithmetic($1, $3);} |
	unarylogic ;

unarylogic:
	NOTOP unarylogic {$$ = checkLogical($1, $2);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)){appendError(UNDECLARED, $1); $$=MISMATCH;}} ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 