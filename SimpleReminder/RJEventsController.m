//
//  RJEventsController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 31.03.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJEventsController.h"
#import "RJDataManager.h"
#import "RJEventCell.h"
#import "RJNewEventController.h"
#import "RJEvent.h"
#import "UIView+UITableViewCell.h"

#define customGreenColor [UIColor colorWithRed:67.f/255 green:213.f/255 blue:81.f/255 alpha:1.f]

#define NewEvents self.tabBarController.tabBar.selectedItem.tag == 0
#define OldEvents self.tabBarController.tabBar.selectedItem.tag == 1

@interface RJEventsController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSPredicate *predicate;
@end

@implementation RJEventsController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);     //to hide header in section 0
    
    self.tabBarController.tabBar.tintColor = customGreenColor;
    
    self.predicate = nil;
    
    if (OldEvents) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Delete all", nil);
        self.navigationItem.title = NSLocalizedString(@"Passed events", nil);
    } else {
        self.navigationItem.title = NSLocalizedString(@"Coming events", nil);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.fetchedResultsController = nil;
    [self.tableView reloadData];
    
    if (OldEvents) {
        [self setOldEventsDisabled];
        [[RJDataManager sharedManager] saveContext];
    }
    
    [self.tableView setEditing:NO];
    
    [self checkButtonsAccessibility];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionAddEvent:(UIBarButtonItem *)sender {
    RJNewEventController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RJNewEventController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.title = NSLocalizedString(@"New", nil);
    vc.newEvent = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)actionEditButtonPushed:(UIBarButtonItem *)sender {
    if (!self.tableView.isEditing) {
        [self.tableView setEditing:YES animated:YES];
//        [self.view setNeedsUpdateConstraints];
//        RJEventCell *cell = (RJEventCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        cell.marginWidth.constant = -40.f;
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self.view layoutIfNeeded];
//                         }];
    } else {
        [self.tableView setEditing:NO animated:YES];
//        [self.view setNeedsUpdateConstraints];
//        RJEventCell *cell = (RJEventCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//        cell.marginWidth.constant = 0.f;
//        [UIView animateWithDuration:0.5
//                         animations:^{
//                             [self.view layoutIfNeeded];
//                         }];
    }
}

- (IBAction)actionSwitchValueChanged:(UISwitch *)sender {
    RJEventCell *cell = (RJEventCell *)[sender superCell];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RJEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    event.isEnabled = [NSNumber numberWithBool:sender.isOn];
    [[RJDataManager sharedManager] saveContext];
}

- (IBAction)actionDeleteAllEvents:(UIBarButtonItem *)sender {
    [self showDeleteEventsAlert];
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJEvent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NewEvents];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [self choosePredicateForFetchRequest];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [super controllerDidChangeContent:controller];
    [self checkButtonsAccessibility];
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(RJEventCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    [timeFormatter setDateFormat:@"HH:mm"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    RJEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.eventTextLabel.text = event.text;
    cell.timeLabel.text = [timeFormatter stringFromDate:event.date];
    cell.dateLabel.text = [dateFormatter stringFromDate:event.date];
    if ([event.isEnabled boolValue]) {
        cell.enabledSwitch.on = YES;
    } else {
        cell.enabledSwitch.on = NO;
    }
    if ([event.tag integerValue] != RJTagColorNone) {
        UIColor *bgColor = [[[RJDataManager sharedManager] tagColors] objectAtIndex:[event.tag integerValue]];
        CALayer *layer = [CALayer layer];
        layer.frame = cell.tagView.bounds;
        layer.backgroundColor = bgColor.CGColor;
        [cell.tagView.layer addSublayer:layer];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierUntagged = @"EventCell";
    static NSString *identifierTagged = @"EventCellTagged";
    NSString *identifier;
    
    RJEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([event.tag integerValue] == RJTagColorNone) {
        identifier = identifierUntagged;
    } else {
        identifier = identifierTagged;
    }
    RJEventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
       cell = [[RJEventCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (OldEvents) {
        cell.enabledSwitch.enabled = NO;
    } else {
        cell.enabledSwitch.enabled = YES;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.isEditing) {
        RJNewEventController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RJNewEventController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.navigationItem.title = NSLocalizedString(@"Edit", nil);
        
        RJEvent *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.selectedDate = event.date;
        vc.selectedColor = [event.tag integerValue];
        vc.enteredText = event.text;
        vc.selectedInterval = [event.repeatInterval integerValue];
        vc.newEvent = NO;
        vc.currentEvent = event;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.05f;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isEditing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Methods

- (NSPredicate *)choosePredicateForFetchRequest {
    NSPredicate *predicate = nil;
    if (NewEvents) {
        predicate = [NSPredicate predicateWithFormat:@"date > %@", [NSDate date]];
    } else if (OldEvents) {
        predicate = [NSPredicate predicateWithFormat:@"date < %@", [NSDate date]];
    }
    return predicate;
}

- (void)setOldEventsDisabled {
    NSArray *oldEventsArray = [self.fetchedResultsController fetchedObjects];
    for (RJEvent *event in oldEventsArray) {
        if ([event.isEnabled boolValue]) {
            [event setIsEnabled:[NSNumber numberWithBool:NO]];
        }
    }
}

- (void)showDeleteEventsAlert {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Attention", nil) message:NSLocalizedString(@"All past events will be deleted. Are you sure?", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deleteAllOldEvents];
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", nil) style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:actionYes];
    [ac addAction:actionNo];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)deleteAllOldEvents {
    NSArray *oldEventsArray = [self.fetchedResultsController fetchedObjects];
    for (RJEvent *event in oldEventsArray) {
        [self.managedObjectContext deleteObject:event];
    }
    [[RJDataManager sharedManager] saveContext];
}

- (void)checkButtonsAccessibility {
    self.editButton.enabled = [[self.fetchedResultsController fetchedObjects] count] != 0;
    self.deleteAllButton.enabled = [[self.fetchedResultsController fetchedObjects] count] != 0;
}

@end
