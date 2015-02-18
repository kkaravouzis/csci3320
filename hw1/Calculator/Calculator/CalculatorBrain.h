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
- (double)performOperation:(NSString *)operation;
- (void) clear;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

@end
