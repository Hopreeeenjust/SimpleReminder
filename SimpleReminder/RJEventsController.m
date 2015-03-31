//
//  RJEventsController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 31.03.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJEventsController.h"
#import "RJDataManager.h"

@interface RJEventsController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RJEventsController
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *purple = [UIColor colorWithRed:0.625f green:0.166f blue:0.999f alpha:0.67f];
    self.tabBarController.tabBar.tintColor = purple;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *purple = [UIColor colorWithRed:159/255 green:43/255 blue:255/255 alpha:0.67f];
    [[UITabBar appearance] setBarTintColor:purple];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionAddUniversity:(id)sender {

}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RJUniversity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
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

//- (void)configureCell:(RJUniversityInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    RJUniversity *university = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.universityName.text = university.name;
//    cell.universityCountry.text = university.country;
//    cell.universityRank.text = [NSString stringWithFormat:@"Rank: %ld", [university.rank integerValue]];
//    cell.universityStudents.text = [NSString stringWithFormat:@"Students: %ld", [university.students count]];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//}

//- (RJUniversityInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"UniversityCell";
//    RJUniversityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[RJUniversityInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
//    }
//    [self configureCell:cell atIndexPath:indexPath];
//    return cell;
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
