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
    NSFont * defaultFont = [self defaultFont];
    [self.testText setFont:defaultFont];
    [self.matchText setFont:defaultFont];
    [self.regexField setFont:defaultFont];
    [self.regexField setDelegate:self];
    [self.regexField becomeFirstResponder];
    NSURLRequest * localRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"regex_ref" ofType:@"html"]]];
    [[self.referenceView mainFrame] loadRequest:localRequest];
    
    defaultFont = nil;
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    [self testExpression:nil];
}

- (void)textDidChange:(NSNotification *)notification
{
    [self testExpression:nil];
}

- (IBAction)testExpression:(id)sender
{
    [[self.matchText textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    
    NSError * error;
    NSRegularExpression * regex = [[NSRegularExpression alloc] initWithPattern:[self.regexField stringValue] options:self.options error:&error];
    
    NSRange testRange = NSMakeRange(0, [[[self.testText textStorage] string] length]);
    
    NSMutableAttributedString * resultString = [[NSMutableAttributedString alloc] initWithString:[[self.testText textStorage] string]];
    NSFont * defaultFont = [self defaultFont];
	
    [resultString addAttribute:NSFontAttributeName value:defaultFont range:NSMakeRange(0, [[[self.testText textStorage] string] length])];
    defaultFont = nil;
    
    // Use the Golden Angle to get distinct colors with the maximum
    // amount of distance between each other. This is inspired by 
    // nature where plant leaves get the optimal exposure to light by 
    // being turned against each other by that very angle.
    // See <http://www.maths.surrey.ac.uk/hosted-sites/R.Knott/Fibonacci/fibnat.html#leavesperturn>
    CGFloat goldenAngle = 222.49223595;
    __block CGFloat angle = 0;

    [regex enumerateMatchesInString:[[self.testText textStorage] string] 
                            options:0 
                              range:testRange 
                         usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop)
     {
         for (NSUInteger matchIndex = 0; matchIndex < match.numberOfRanges; ++matchIndex)
         {
             NSRange matchRange = [match rangeAtIndex:matchIndex];
             
             // Skip non-matching capture groups.
             if (matchRange.location == NSNotFound) continue;
             
             CGFloat clampedAngle = fmod(angle, 360.0);
             CGFloat hue = clampedAngle / 360.0;
             NSColor *HSBColor = [NSColor colorWithDeviceHue:hue saturation:0.5 brightness:1.0 alpha:0.5];
             angle += goldenAngle;
             
             [resultString addAttribute:NSBackgroundColorAttributeName 
                                  value:HSBColor 
                                  range:matchRange];
         }
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

- (NSFont *)defaultFont {
	NSFont *defaultFont = [NSFont fontWithName:@"Inconsolata" size:14.0f];
	if (!defaultFont) defaultFont = [NSFont fontWithName:@"Menlo" size:14.0f];
	if (!defaultFont) defaultFont = [NSFont systemFontOfSize:14.0f];
	return defaultFont;
}

@end
