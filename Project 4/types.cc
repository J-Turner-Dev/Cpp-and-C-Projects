/* Original Source by: Dr. Duane J. Jarc
/* Modified by: Joshua Turner
/* Class: UMGC - CMSC 430 Compiler Theory and Design
/* Professor: Dr. Duane J. Jarc
/* Assignment: Project 4
/* File: types.cc
/* Date: December 09, 2021

/* Purpose: This file contains the bodies of the type checking functions */

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue == INT_TYPE && rValue == REAL_TYPE) 
	{
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
	}
	else if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	else if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	else if (left != right)
	{
		return REAL_TYPE;
	}
	return left;
}

Types checkCase(Types caseExpression, Types initialCase, Types currentCase)
{
	if (caseExpression != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case Expression Not Integer");
	}
	return checkWhen(initialCase, currentCase);
}

Types checkIfStatement(Types condition, Types trueStatement, Types falseStatement) 
{
	int mismatch = 0;
	if (condition != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
		mismatch++;
	}
	if (trueStatement != falseStatement) 
	{
		appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
		mismatch++;
	}
	if (mismatch != 0)
	{
		return MISMATCH;
	} 
	else
	{
		return trueStatement;
	}
}

Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
	{
		return MISMATCH;
	}
	else if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
	return BOOL_TYPE;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
	{
		return MISMATCH;
	}
	return BOOL_TYPE;
}

Types checkRemainder(Types left, Types right)
{
	if (left != INT_TYPE || right != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operands");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkWhen(Types initialCase, Types currentCase)
{
	if(initialCase == NONE) 
	{
		return currentCase;
	}
	else if (initialCase == MISMATCH) 
	{
		return MISMATCH;
	}
	else if (initialCase != currentCase) 
	{
		appendError(GENERAL_SEMANTIC, "Case Types Mismatch");
		return MISMATCH;
	}
	return initialCase;
}