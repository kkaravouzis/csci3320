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
    
    //clear '=' sign from enteredText display
    [self checkEqualSign];
    
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
    //clear equal sign from enteredText display
    [self checkEqualSign];
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    
    //add operation to display, except for +/- operation. 
    if (![operation hasPrefix:@"+/-"]) {
        self.enteredText.text = [[[self.enteredText.text stringByAppendingString:@" "] stringByAppendingString:operation] stringByAppendingString:@"="];
    }
    
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


- (IBAction)signPressed:(UIButton *)sender {
    double currentValue = [self.display.text doubleValue];
    
    //if the displayed value is negative remove the minus sign, otherwise add  a minus sign to the display   
    if (currentValue)
    {
        if(currentValue < 0 ){
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    }
    //if the operation is performed on a result, send to brain to process
    if (!self.userIsInTheMiddleOfEnteringANumber){
        [self operationPressed:sender];
    }
}

- (IBAction)piPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    
    [self operationPressed:sender];

}

- (void) checkEqualSign
{
    if ([self.enteredText.text hasSuffix:@"="]){
        self.enteredText.text = [self.enteredText.text stringByReplacingOccurrencesOfString:@"=" withString:@"" ];
    }
}

@end
