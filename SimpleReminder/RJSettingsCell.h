//
//  RJSettingsCell.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 16.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJSettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;
@property (weak, nonatomic) IBOutlet UISwitch *deleteControl;
@property (weak, nonatomic) IBOutlet UILabel *deleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@end
