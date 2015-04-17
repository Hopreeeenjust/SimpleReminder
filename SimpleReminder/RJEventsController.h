//
//  RJEventsController.h
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 31.03.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJCoreDataTableViewController.h"

@interface RJEventsController : RJCoreDataTableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteAllButton;

- (IBAction)actionAddEvent:(id)sender;
- (IBAction)actionEditButtonPushed:(id)sender;
- (IBAction)actionSwitchValueChanged:(id)sender;
@end
