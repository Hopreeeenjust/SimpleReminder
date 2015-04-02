//
//  RJNewEventController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJNewEventController.h"

@interface RJNewEventController ()

@end

@implementation RJNewEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancelButtonPushed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.minimumDate = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action

- (void)actionCancelButtonPushed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *soundIdentifier = @"Sound";
    static NSString *tagIdentifier = @"Tag";
    static NSString *repeatIdentifier = @"Repeat";
    static NSString *textIdentifier = @"Text";
    NSString *identifier;
    
    if (indexPath.row == 0) {
        identifier = soundIdentifier;
    } else if (indexPath.row == 1) {
        identifier = tagIdentifier;
    } else if (indexPath.row == 2) {
        identifier = repeatIdentifier;
    } else {
        identifier = textIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 7;
}

@end
