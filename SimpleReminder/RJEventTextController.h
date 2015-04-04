//
//  RJEventTextController.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJEventTextProtocol;

@interface RJEventTextController : UIViewController
@property (strong, nonatomic) NSString *enteredText;
@property (weak, nonatomic) id <RJEventTextProtocol> delegate;
@end

@protocol RJEventTextProtocol <NSObject>
- (void)textShouldBeSaved:(NSString *)text;
@end