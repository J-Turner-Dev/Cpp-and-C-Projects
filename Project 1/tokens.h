// Original Source by: Dr. Duane J. Jarc
// Modified by: Joshua Turner
// Class: UMGC - CMSC 430 Compiler Theory and Design
// Professor: Dr. Duane J. Jarc
// Assignment: Project 1
// File: tokens.h
// Date: October 31, 2021

// Purpose: This file contains the enumerated type definition for tokens

enum Tokens {RELOP = 256, ADDOP, MULOP, ANDOP, BEGIN_, BOOLEAN, END, ENDREDUCE,
	FUNCTION, INTEGER, IS, REDUCE, RETURNS, IDENTIFIER, INT_LITERAL, ARROW, CASE, 
	ELSE, ENDCASE, ENDIF, IF, OTHERS, REAL, WHEN, THEN, NOTOP, OR, REMOP, EXPOP, 
	REAL_LITERAL, BOOL_LITERAL};
