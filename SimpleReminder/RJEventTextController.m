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
    UIColor *green = [UIColor colorWithRed:67.f/255 green:213.f/255 blue:81.f/255 alpha:1.f];
    self.navigationController.navigationBar.tintColor = green;
    
    self.navigationItem.title = NSLocalizedString(@"Text", nil);
    
    CGRect rect = self.view.frame;
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    [self.view addSubview:textView];
    textView.text = self.enteredText;
    textView.delegate = self;
    [textView becomeFirstResponder];
    [self setSettingsForTextView:textView];
    self.textView = textView;
    
//    [self addColorToUIKeyboardButton];
    
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

//-(NSArray*)subviewsOfView:(UIView*)view withType:(NSString*)type{
//    NSString *prefix = [NSString stringWithFormat:@"<%@",type];
//    NSMutableArray *subviewArray = [NSMutableArray array];
//    for (UIView *subview in view.subviews) {
//        NSArray *tempArray = [self subviewsOfView:subview withType:type];
//        for (UIView *view in tempArray) {
//            [subviewArray addObject:view];
//        }
//    }
//    if ([[view description]hasPrefix:prefix]) {
//        [subviewArray addObject:view];
//    }
//    return [NSArray arrayWithArray:subviewArray];
//}
//
//-(void)addColorToUIKeyboardButton{
//    for (UIWindow *keyboardWindow in [[UIApplication sharedApplication] windows]) {
//        for (UIView *keyboard in [keyboardWindow subviews]) {
//            for (UIView *view in [self subviewsOfView:keyboard withType:@"UIKBKeyplaneView"]) {
//                UIView *newView = [[UIView alloc] initWithFrame:[(UIView *)[[self subviewsOfView:keyboard withType:@"UIKBKeyView"] lastObject] frame]];
//                newView.frame = CGRectMake(newView.frame.origin.x + 2, newView.frame.origin.y + 1, newView.frame.size.width - 4, newView.frame.size.height -3);
//                [newView setBackgroundColor:[UIColor greenColor]];
//                newView.layer.cornerRadius = 4;
//                [view insertSubview:newView belowSubview:((UIView *)[[self subviewsOfView:keyboard withType:@"UIKBKeyView"] lastObject])];
//                
//            }
//        }
//    }
//}

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self actionSaveButtonPushed:nil];
        return NO;
    }
    return YES;
}

@end
