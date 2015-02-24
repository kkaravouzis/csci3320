//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Kirk Karavouzis on 1/30/15.
//  Copyright (c) 2015 Kirk Karavouzis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
//Precondition:  Takes a double value
//Postcondition:  Adds the double value to the program stack

- (double)performOperation:(NSString *)operation;
//Precondition:  NSString representing a calculator operation
//Postcondition: Removes two operands from the program stack
// and performs the mathematical operation specified by the NSString
// operation on the two operands

- (void) clear;
//Precondition: None
//Postcondition: Removes all objects from the program stack

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
//Precondition: An object representing a series of mathematical computations to be performed.
//Postcondition:  Returns an NSString representing a human readable format of the mathematical program passed.

+ (double)runProgram:(id)program;
//Precondition:  An object representing a series of mathematical computations to be performed.
//Postcondition:  Computes a result based on the series of mathematical computations to be performed.

@end
