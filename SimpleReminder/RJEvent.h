//
//  RJEvent.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 31.03.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RJEvent : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * isEnabled;

@end
