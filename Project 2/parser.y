/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 2
/* File: parser.y
/* Date: November 11, 2021

/* Purpose: This file identifies the tokens and contains the instructions 
			for the grammar that the parser uses to identify 
			syntactically correct input for the language It also contains
			 expression precedence within the grammar. */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER
%token INT_LITERAL REAL_LITERAL BOOL_LITERAL NOTOP

%token ADDOP MULOP REMOP EXPOP RELOP ANDOP OROP

%token FUNCTION BEGIN_ END RETURNS INTEGER REAL BOOLEAN REDUCE ENDREDUCE
%token IF THEN ELSE ENDIF CASE IS WHEN ARROW OTHERS ENDCASE 

%%

function:	
	function_header optional_variable body ;
	
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
	type IS statement_ |
	error statement_ ;

parameters:
	parameters ',' IDENTIFIER ':' type |
	IDENTIFIER ':' type |
	;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE |
	IF expression THEN statement_ ELSE statement_ ENDIF |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ |
	;
		    
expression:
	expression OROP binarylogic |
	binarylogic ;

cases:
	cases case |
	;

case:
	WHEN INT_LITERAL ARROW statement_ |
	error ';' ;
	
binarylogic:
	binarylogic ANDOP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP exponent |
	factor REMOP exponent |
	exponent ;

exponent:
	unarylogic EXPOP exponent |
	unarylogic ;

unarylogic:
	NOTOP unarylogic |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER ;
    
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
