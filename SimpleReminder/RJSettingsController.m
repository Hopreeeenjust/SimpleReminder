//
//  RJSettingsController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 15.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJSettingsController.h"
#import "RJSettingsCell.h"
#import "RJDataManager.h"

@interface RJSettingsController ()
@property (strong, nonatomic) UISegmentedControl *sortControl;
@property (strong, nonatomic) UISwitch *deleteSwitch;
@property (strong, nonatomic) NSArray *tagColors;
@end

static NSString *kSettingsColors = @"colors";
static NSString *kSettingsDelete = @"delete";
static NSString *kSettingsSort = @"sort";

@implementation RJSettingsController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Settings", nil);
    
    self.sortControl.selectedSegmentIndex = 0;
    
    self.tagColors = [[RJDataManager sharedManager] tagColors];
    NSArray *colorsArray = [[NSUserDefaults standardUserDefaults] arrayForKey:kSettingsColors];
    if ([colorsArray count] == 0) {
        self.tagColors = [[RJDataManager sharedManager] tagColors];
    } else {
        [[self mutableArrayValueForKey:@"tagColors"] removeAllObjects];
        for (NSData *colorData in colorsArray) {
            UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            [[self mutableArrayValueForKey:@"tagColors"] addObject:color];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortControl.selectedSegmentIndex + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 8;
    }
}

- (void)configureCell:(RJSettingsCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.deleteLabel.text = NSLocalizedString(@"Automaticly delete past events", nil);
    cell.sortLabel.text = NSLocalizedString(@"Sort events", nil);
    cell.tagView.layer.cornerRadius = 15.f;
    cell.tagView.clipsToBounds = YES;
    UIColor *bgColor = [self.tagColors objectAtIndex:indexPath.row];
    CALayer *layer = [CALayer layer];
    layer.frame = cell.tagView.bounds;
    layer.backgroundColor = bgColor.CGColor;
    if ([bgColor isEqual:[UIColor clearColor]]) {
        cell.tagView.backgroundColor = bgColor;
        cell.tagLabel.text = NSLocalizedString(@"Without tag", nil);
    } else {
        cell.tagLabel.text = @"";
    }
    [cell.tagView.layer addSublayer:layer];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    static NSString *deleteIdentifier = @"DeleteCell";
    static NSString *sortIdentifier = @"SortCell";
    static NSString *tagIdentifier = @"TagCell";
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        identifier = deleteIdentifier;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        identifier = sortIdentifier;
    } else {
        identifier = tagIdentifier;
    }

    RJSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return NSLocalizedString(@"Choose the order you want your events to display", nil);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    UIColor *color = [self.tagColors objectAtIndex:sourceIndexPath.row];
    [[self mutableArrayValueForKey:@"tagColors"] removeObjectAtIndex:sourceIndexPath.row];
    [[self mutableArrayValueForKey:@"tagColors"] insertObject:color atIndex:destinationIndexPath.row];
    NSMutableArray *temp = [NSMutableArray array];
    for (UIColor *color in self.tagColors) {
        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
        [temp addObject:colorData];
    }
    [[NSUserDefaults standardUserDefaults] setObject:temp forKey:kSettingsColors];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30.f;
    } else {
        return 20.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20.f;
    } else {
        return 1.f;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.section == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel *label = [UILabel new];
        CGFloat offset = 10.f;
        label.frame = CGRectMake(offset, 0, CGRectGetWidth(tableView.bounds) - offset * 2, 16);
        label.font = [UIFont systemFontOfSize:14];
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = 0.5f;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.text = [self tableView:tableView titleForHeaderInSection:section];
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), [self tableView:tableView heightForHeaderInSection:section]);
        [headerView addSubview:label];
        return headerView;
    }
    return nil;
}

#pragma mark - Actions

- (IBAction)actionSortControlValueChanged:(UISegmentedControl *)sender {
    self.sortControl = sender;
    if (sender.selectedSegmentIndex == 0) {
        [self deleteSectionWithIndex:1];
        [self.tableView setEditing:NO];
    } else {
        [self insertSectionWithIndex:1];
        [self.tableView setEditing:YES];
    }
}

- (IBAction)actionDeleteCSwitchValueChanged:(UISwitch *)sender {
    self.deleteSwitch = sender;
}

#pragma mark - Methods

- (void)insertSectionWithIndex:(NSInteger)index {
    [self.tableView beginUpdates];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)deleteSectionWithIndex:(NSInteger)index {
    [self.tableView beginUpdates];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)saveSetting {
    
}

- (void)loadSettings {
    
}

@end
