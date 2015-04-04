//
//  RJRepeatIntervalController.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RJRepeatIntevalProtocol;

@interface RJRepeatIntervalController : UITableViewController
@property (assign, nonatomic) NSInteger selectedInterval;

@property (weak, nonatomic) id <RJRepeatIntevalProtocol> delegate;
@end

@protocol RJRepeatIntevalProtocol <NSObject>
- (void)repeatIntervalForReminder:(NSTimeInterval)interval;
@end