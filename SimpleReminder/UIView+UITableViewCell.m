//
//  UIView+UITableViewCell.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (UITableViewCell *)superCell {
    if (!self.superview) {
        return nil;
    }
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)self.superview;
    }
    return [self.superview superCell];
}

- (void)removeLayerWithName:(NSString *)name {
    NSArray* sublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer *layer in sublayers) {
        if ([layer.name isEqualToString:name]) {
            [layer removeFromSuperlayer];
        }
    }
}

@end
