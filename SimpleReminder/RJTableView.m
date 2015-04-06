//
//  RJTableView.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 05.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJTableView.h"
#import "RJEventCell.h"

@implementation RJTableView

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        self.editButton.title = NSLocalizedString(@"Done", nil);
    } else {
        self.editButton.title = NSLocalizedString(@"Edit", nil);
    }
}

@end
