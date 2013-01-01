//
//  INOAppDelegate.h
//  NSRegexTester
//
//  Created by Aaron Vegh on 2012-12-31.
//  Copyright (c) 2012 Aaron Vegh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface INOAppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)testExpression:(id)sender;
- (IBAction)showOptions:(id)sender;
- (IBAction)updateOptions:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTextField *regexField;
@property (strong) IBOutlet NSTextView *testText;
@property (strong) IBOutlet NSTextView *matchText;
@property (strong) IBOutlet NSButton *testButton;
@property (strong) IBOutlet NSButton *optionsButton;
@property (unsafe_unretained) IBOutlet NSPanel *regexOptions;
@property (strong) IBOutlet NSMatrix *optionsMatrix;
@property (assign, readwrite) NSUInteger options;

@end
