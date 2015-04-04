//
//  RJEventTextController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJEventTextController.h"

@interface RJEventTextController () <UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@end

@implementation RJEventTextController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Text", nil);
    
    CGRect rect = self.view.frame;
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    [self.view addSubview:textView];
    textView.text = self.enteredText;
    textView.delegate = self;
    [textView becomeFirstResponder];
    [self setSettingsForTextView:textView];
    self.textView = textView;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

#pragma mark - Actions

- (void)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    [self.delegate textShouldBeSaved:self.textView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods 

- (void)setSettingsForTextView:(UITextView *)textView {
    [textView setFont:[UIFont systemFontOfSize:17.f]];
    [textView setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textView setSpellCheckingType:UITextSpellCheckingTypeNo];
    [textView setReturnKeyType:UIReturnKeyDone];
}

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self actionSaveButtonPushed:nil];
        return NO;
    }
    return YES;
}

@end
