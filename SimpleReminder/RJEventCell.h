//
//  RJEventCell.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSwitch;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@end
