//
//  RJTagCell.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 02.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@end
