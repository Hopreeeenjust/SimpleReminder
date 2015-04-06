//
//  RJNewEventController.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJEvent;

typedef NS_ENUM(NSInteger, RJTagColor) {
    RJTagColorRed = 0,
    RJTagColorOrange,
    RJTagColorYellow,
    RJTagColorGreen,
    RJTagColorBlue,
    RJTagColorPurple,
    RJTagColorGray,
    RJTagColorNone
};

@interface RJNewEventController : UITableViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (assign, nonatomic) RJTagColor selectedColor;
@property (assign, nonatomic) NSTimeInterval selectedInterval;
@property (strong, nonatomic) NSString *enteredText;
@property (assign, nonatomic) BOOL newEvent;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) RJEvent *currentEvent;
@end
