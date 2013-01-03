//
//  INOAppDelegate.m
//  NSRegexTester
//
//  Created by Aaron Vegh on 2012-12-31.
//  Copyright (c) 2012 Aaron Vegh. All rights reserved.
//

#import "INOAppDelegate.h"

@implementation INOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.regexOptions setFloatingPanel:YES];
    NSFont * defaultFont = [NSFont fontWithName:@"Inconsolata" size:14.0];
    [self.testText setFont:defaultFont];
    [self.matchText setFont:defaultFont];
    [self.regexField setFont:defaultFont];
    NSURLRequest * localRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"regex_ref" ofType:@"html"]]];
    [[self.referenceView mainFrame] loadRequest:localRequest];
    
    defaultFont = nil;
}

- (IBAction)testExpression:(id)sender
{
    [[self.matchText textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    
    NSError * error;
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:[self.regexField stringValue] options:self.options error:&error];
    
    NSRange testRange = NSMakeRange(0, [[[self.testText textStorage] string] length]);
    
    NSMutableAttributedString * resultString = [[NSMutableAttributedString alloc] initWithString:[[self.testText textStorage] string]];
    NSFont * defaultFont = [NSFont fontWithName:@"Inconsolata" size:14.0];
    [resultString addAttribute:NSFontAttributeName value:defaultFont range:NSMakeRange(0, [[[self.testText textStorage] string] length])];
    defaultFont = nil;
    
    [regex enumerateMatchesInString:[[self.testText textStorage] string] options:0 range:testRange usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
        NSRange matchRange = [match range];
        [resultString addAttribute:NSBackgroundColorAttributeName value:[NSColor yellowColor] range:matchRange];
    }];
    
    [[self.matchText textStorage] setAttributedString:resultString];
    
}

- (IBAction)showOptions:(id)sender
{
    if(! [self.regexOptions isVisible] )
        [self.regexOptions makeKeyAndOrderFront:sender];
}

- (IBAction)updateOptions:(id)sender {
    self.options = 0;
    for (NSButtonCell * cell in [sender selectedCells]) {
        self.options = self.options | (1 << [cell tag] - 1);
    }
}

- (IBAction)showReference:(id)sender {
    if(! [self.referenceWindow isVisible] )
        [self.referenceWindow makeKeyAndOrderFront:sender];
}

@end
