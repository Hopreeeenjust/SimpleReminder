//
//  RJPreviousIntervalController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 03.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJPreviousIntervalController.h"

@interface RJPreviousIntervalController ()
@property (strong, nonatomic) NSIndexPath *selectedPath;
@property (strong, nonatomic) NSArray *intervalsArray;
@end

@implementation RJPreviousIntervalController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *green = [UIColor colorWithRed:67.f/255 green:213.f/255 blue:81.f/255 alpha:1.f];
    self.navigationController.navigationBar.tintColor = green;
    
    self.navigationItem.title = NSLocalizedString(@"Notify", nil);
    
    [[UITableViewCell appearance] setTintColor:green];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.intervalsArray = @[@0, @(1 * 60), @(2 * 60), @(3 * 60), @(5 * 60), @(10 * 60), @(15 * 60)];
    self.selectedPath = [NSIndexPath indexPathForRow:[self.intervalsArray indexOfObject:[NSNumber numberWithInteger:self.selectedInterval]] inSection:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:self.selectedPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Don't notify", nil);
    } else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"A minute before", nil);
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"Five minutes before", nil);
    } else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"Ten minutes before", nil);
    } else if (indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedString(@"Twenty minutes before", nil);
    } else if (indexPath.row == 5) {
        cell.textLabel.text = NSLocalizedString(@"Half an hour before", nil);
    } else {
        cell.textLabel.text = NSLocalizedString(@"An hour before", nil);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedPath != indexPath) {
        UITableViewCell *oldSelectedCell = [tableView cellForRowAtIndexPath:self.selectedPath];
        oldSelectedCell.accessoryType = UITableViewCellAccessoryNone;
        UITableViewCell *newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        newSelectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    self.selectedPath = indexPath;
}

#pragma mark - Actions

- (void)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    [self.delegate previousIntervalForReminder:[self intervalForSelectedRowAtIndexPath:self.selectedPath]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Methods

- (NSInteger)intervalForSelectedRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.intervalsArray objectAtIndex:indexPath.row] integerValue];
}

@end
