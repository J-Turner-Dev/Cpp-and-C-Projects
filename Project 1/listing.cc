// Original Source by: Dr. Duane J. Jarc
// Modified by: Joshua Turner
// Class: UMGC - CMSC 430 Compiler Theory and Design
// Professor: Dr. Duane J. Jarc
// Assignment: Project 1
// File: listing.cc
// Date: October 31, 2021

// Purpose: This file contains the bodies of the functions that produces the 
//          compilation listing

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\n%4d  ",lineNumber);
	printf("\r");
	displayErrors();
	printf("     \n");
	if (totalErrors == 0) {
		printf("Compiled Successfully\n\n");
	}
	else {
		printf("Lexical Errors %4d \n", lexicalErrors);
		printf("Syntax Errors %4d \n", syntaxErrors);
		printf("Semantic Errors %4d \n\n", semanticErrors);
	}
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	if(error=="")
		error = messages[errorCategory] + message;
	else
		error = error.append("\n" + messages[errorCategory] + message);

	if(errorCategory == 0)
		lexicalErrors++;
	if(errorCategory == 1)
		syntaxErrors++;
	if(errorCategory == 2 || errorCategory == 3 || errorCategory == 4)
		semanticErrors++;
	
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s\n", error.c_str());
	error = "";
}