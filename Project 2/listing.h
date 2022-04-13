/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 2
/* File: listing.h
/* Date: November 11, 2021

/* Purpose: This file contains the function prototypes for the
            functions that produce the compilation listing */

enum ErrorCategories
{
    LEXICAL,
    SYNTAX,
    GENERAL_SEMANTIC,
    DUPLICATE_IDENTIFIER,
    UNDECLARED
};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);