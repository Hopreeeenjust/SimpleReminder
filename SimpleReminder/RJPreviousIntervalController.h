//
//  RJPreviousIntervalController.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJPreviousIntevalProtocol;

@interface RJPreviousIntervalController : UITableViewController
@property (assign, nonatomic) NSInteger selectedInterval;

@property (weak, nonatomic) id <RJPreviousIntevalProtocol> delegate;
@end

@protocol RJPreviousIntevalProtocol <NSObject>
- (void)previousIntervalForReminder:(NSTimeInterval)interval;
@end