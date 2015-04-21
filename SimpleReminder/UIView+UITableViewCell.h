//
//  UIView+UITableViewCell.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UITableViewCell)
- (UITableViewCell *)superCell;
- (void)removeLayerWithName:(NSString *)name;
@end
