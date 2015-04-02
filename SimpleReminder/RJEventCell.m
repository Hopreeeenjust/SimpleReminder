//
//  RJEventCell.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJEventCell.h"

@implementation RJEventCell

- (void)awakeFromNib {
    self.tagView.layer.cornerRadius = 10;
//    self.priorityView.layer.borderWidth = 0.5f;
    self.tagView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

