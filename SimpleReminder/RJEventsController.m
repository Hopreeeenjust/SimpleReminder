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

@interface RJEventsController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionAddEvent:(id)sender {
    RJNewEventController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RJNewEventController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.title = NSLocalizedString(@"New", nil);
    [self presentViewController:nav animated:YES completion:nil];
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
    if (indexPath.row == 1) {
        cell.tagView.backgroundColor = [UIColor redColor];
        cell.eventTextLabel.text = @"Записаться к Оле на стрижку на четверг утро с пол первого до 10 и не забыть взять с собой зубную щетку с насадкой";
    } else {
        cell.tagView.backgroundColor = [UIColor clearColor];
        cell.eventTextLabel.text = @"К зубному 03.04 в 16-30";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierUntagged = @"EventCell";
    static NSString *identifierTagged = @"EventCellTagged";
    NSString *identifier;
    if (indexPath.row == 0) {
        identifier = identifierUntagged;
    } else {
        identifier = identifierTagged;
    }
    RJEventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
       cell = [[RJEventCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.f;
}

@end
