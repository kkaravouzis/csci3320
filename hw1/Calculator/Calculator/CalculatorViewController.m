//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kirk Karavouzis on 1/30/15.
//  Copyright (c) 2015 Kirk Karavouzis. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL isFloatingPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc]init];
    return _brain;
}		

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text =digit;
        self.userIsInTheMiddleOfEnteringANumber=YES;
    }    
}
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    
    self.enteredText.text = [[self.enteredText.text stringByAppendingString:@" "] stringByAppendingString:operation];
}
    
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.enteredText.text = [[self.enteredText.text stringByAppendingString:@" "] stringByAppendingString:self.display.text];
    }
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.isFloatingPoint = NO;
}

- (IBAction)pointPressed:(UIButton *)sender {
    
    NSRange point = [self.display.text rangeOfString:@"."];
    if(point.location == NSNotFound || !self.isFloatingPoint){
        
        if(!self.userIsInTheMiddleOfEnteringANumber){
            self.display.text = @"0.";
            
        } else {
            self.display.text = [self.display.text stringByAppendingString:@"."];
            
        }
   
    }
    self.userIsInTheMiddleOfEnteringANumber=YES;
    self.isFloatingPoint = YES;

}
- (IBAction)clearPressed {
    self.display.text = @"0";
    self.enteredText.text = @"";
    self.userIsInTheMiddleOfEnteringANumber=NO;
    self.isFloatingPoint=NO;
    [self.brain clear];
}	

- (IBAction)backspacePressed {
    if(self.userIsInTheMiddleOfEnteringANumber){
        int substring = self.display.text.length;
       
        if(substring > 0){
            self.display.text = [self.display.text substringToIndex:substring-1];
        }
        
        if ((substring-1 == 0) || (self.isFloatingPoint && substring-1 == 1)){
            self.userIsInTheMiddleOfEnteringANumber=NO;
            self.display.text = @"0";
        }
    }
}

- (IBAction)signPressed {
    
    double currentValue = [self.display.text doubleValue];
    
    
    if(currentValue < 0 ){
        self.display.text = [self.display.text substringFromIndex:1];
    } else {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
                              
     if (!self.userIsInTheMiddleOfEnteringANumber){
         [self.brain popOperand];
         [self.brain pushOperand:[self.display.text doubleValue]];
    }

}

- (IBAction)piPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    
    [self operationPressed:sender];

}



@end
