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
}

- (IBAction)testExpression:(id)sender
{
    [[self.matchText textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    
    NSError * error;
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:[self.regexField stringValue] options:self.options error:&error];
    
    NSRange testRange = NSMakeRange(0, [[[self.testText textStorage] string] length]);
    
    NSMutableAttributedString * resultString = [[NSMutableAttributedString alloc] initWithString:[[self.testText textStorage] string]];
    
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
        //NSNumber * tag = [NSNumber numberWithInteger:[cell tag] - 1];
        self.options = self.options | (1 << [cell tag] - 1);
        
    }
}

@end
