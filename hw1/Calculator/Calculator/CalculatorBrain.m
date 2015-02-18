//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kirk Karavouzis on 1/30/15.
//  Copyright (c) 2015 Kirk Karavouzis. All rights reserved.
//

#import "CalculatorBrain.h"
#import "math.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if(_programStack == nil){
        _programStack = [[NSMutableArray alloc]init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Needs implementation";
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

//- (double)popOperand
//{
//    NSNumber *operandObject = [self.programStack lastObject];
//    if(operandObject) [self.programStack removeLastObject];
//    return [operandObject doubleValue];
//}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result=0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if(divisor)result = [self popOperandOffStack:stack] / divisor;
        } else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack]*M_PI/180);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack]*M_PI/180);
        } else if([operation isEqualToString:@"√"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"∏"]){
            result = M_PI;
        } else if([operation isEqualToString:@"+/-"]){
            result = -[self popOperandOffStack:stack];
        }
        
    }
    
    return result;
}
       

- (void) clear{
    [self.programStack removeAllObjects];
}

@end
