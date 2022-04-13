/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 4
/* File: types.h
/* Date: December 09, 2021

/* Purpose: This file contains type definitions and the function
/*          prototypes for the type checking functions */

typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE, NONE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkCase(Types caseExpression, Types initialCase, Types currentCase);
Types checkIfStatement(Types condition, Types trueStatement, Types falseStatement);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkRemainder(Types left, Types right);
Types checkWhen(Types initialCase, Types currentCase);