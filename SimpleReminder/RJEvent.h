//
//  RJEvent.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RJEvent : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isEnabled;
@property (nonatomic, retain) NSNumber * tag;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * repeatInterval;

@end
