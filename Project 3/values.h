/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 3
/* File: values.h
/* Date: November 26, 2021

/* Purpose:  This file contains function definitions for the evaluation functions */

typedef char* CharPtr;
enum Operators {LESS, MORE, LESS_EQUAL, MORE_EQUAL, EQUAL, NOT_EQUAL, ADD, MULTIPLY, SUBTRACT, DIVIDE, REM};

double evaluateReduction(Operators operator_, double head, double tail);
int evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);