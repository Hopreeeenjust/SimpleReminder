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

#define lightPurpleColor [UIColor colorWithRed:177.f/255 green:74.f/255 blue:255.f alpha:1.f]
#define lightBlueColor [UIColor colorWithRed:63.f/255 green:168.f/255 blue:240.f/255 alpha:1.f]

@interface RJEventsController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSArray *tagColors;
@end

@implementation RJEventsController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0f);     //to hide header in section 0
    
    UIColor *green = [UIColor colorWithRed:67.f/255 green:213.f/255 blue:81.f/255 alpha:1.f];
    self.tabBarController.tabBar.tintColor = green;
    
    self.navigationItem.title = NSLocalizedString(@"Reminder", nil);
    
    self.tagColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], lightBlueColor, lightPurpleColor, [UIColor lightGrayColor], [UIColor clearColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView setEditing:NO];
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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
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
        UIColor *bgColor = [self.tagColors objectAtIndex:[event.tag integerValue]];
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

@end
