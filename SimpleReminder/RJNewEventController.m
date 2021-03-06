//
//  RJNewEventController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJNewEventController.h"
#import "UIView+UITableViewCell.h"
#import "RJPreviousIntervalController.h"
#import "RJEventTextController.h"
#import "RJEvent.h"
#import "RJDataManager.h"
#import "RJVolumeController.h"

#define customGreenColor [UIColor colorWithRed:67.f/255 green:213.f/255 blue:81.f/255 alpha:1.f]

static const NSString *kEventKey = @"EventKey";

@interface RJNewEventController () <RJPreviousIntevalProtocol, RJEventTextProtocol>
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (assign, nonatomic) CGFloat currentRowHeight;
@property (strong, nonatomic) NSArray *tagButtons;
@end

static const CGFloat kRowHeight = 44.f;

BOOL viewDidAppear;

CGRect tagLabelRect;
CGRect tagViewRect;

@implementation RJNewEventController

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancelButtonPushed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.navigationController.navigationBar.tintColor = customGreenColor;
    
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.currentRowHeight = kRowHeight;
    
    self.tagButtons = [NSArray new];
    
    viewDidAppear = NO;
    
    if (self.newEvent) {
        [self setDefaultSettings];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60];
    if (!self.newEvent) {
        [self setEventSettings];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    tagLabelRect = self.tagLabel.frame;
    tagViewRect = self.tagView.frame;
    
    viewDidAppear = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - NSManagedObjectContext

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[RJDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

#pragma mark - Action

- (void)actionCancelButtonPushed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSaveButtonPushed:(UIBarButtonItem *)sender {
    RJEvent *event;
    if (self.newEvent) {
        event = [NSEntityDescription insertNewObjectForEntityForName:@"RJEvent" inManagedObjectContext:self.managedObjectContext];
    } else {
        event = self.currentEvent;
    }
    event.tag = [NSNumber numberWithInteger:self.selectedColor];
    event.previousInterval = [NSNumber numberWithInteger:self.selectedInterval];
    event.text = self.enteredText;
    event.isEnabled = [NSNumber numberWithBool:YES];
    event.date = self.datePicker.date;
    [[RJDataManager sharedManager] saveContext];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    [self scheduleLocalNotification:localNotif forEvent:event onDate:event.date withText:event.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionTagButtonPushed:(UIButton *)sender {
    self.selectedColor = [self.tagButtons indexOfObject:sender];

    [self showTagColor];
    
    [self setStandartRowHeightAndHideButton:sender];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        RJVolumeController *vc = [[RJVolumeController alloc] initWithStyle:UITableViewStyleGrouped];
//        vc.delegate = self;
//        vc.selectedSoundID = self.selectedSoundID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        [self tableView:tableView doubleRowHeightAndShowTagsForRowAtIndexPath:indexPath];
    } else if (indexPath.row == 2) {
        RJPreviousIntervalController *vc = [[RJPreviousIntervalController alloc] initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        vc.selectedInterval = self.selectedInterval;
        [self.navigationController pushViewController:vc animated:YES];
    } else  {
        RJEventTextController *vc = [[RJEventTextController alloc] init];
        vc.enteredText = self.enteredText;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return  self.currentRowHeight;
    } else {
        return kRowHeight;
    }
}

#pragma mark - Methods

- (NSArray *)createButtonsForTags {
    CGFloat buttonWidth = 30.f;
    CGFloat buttonHeight = 30.f;
    NSInteger buttonsCount = [[[RJDataManager sharedManager] tagColors] count];
    CGFloat inset = (CGRectGetWidth(self.tableView.frame) - buttonWidth * buttonsCount) / (buttonsCount + 1);
    CGFloat pointY = kRowHeight + kRowHeight / 2 - buttonHeight / 2;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = RJTagColorRed; i <= RJTagColorNone; i++) {
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectIntegral(CGRectMake(inset * (i + 1) + buttonWidth * i, pointY, buttonWidth, buttonHeight))];
        tagButton.backgroundColor = [[RJDataManager sharedManager] tagColors][i];
        tagButton.layer.cornerRadius = buttonHeight / 2;
        tagButton.clipsToBounds = YES;
        if (i == RJTagColorNone) {
            tagButton.layer.borderWidth = 1.f;
            [tagButton setImage:[UIImage imageNamed:@"ClearColor"] forState:UIControlStateNormal];
        }
        [tagButton addTarget:self action:@selector(actionTagButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:tagButton];
    }
    return array;
}

- (void)addButtonsToCell:(UITableViewCell *)cell {
    for (UIButton *button in self.tagButtons) {
        [cell addSubview:button];
    }
}

- (void)removeButtonsFromCell {
    for (UIButton *button in self.tagButtons) {
        [button removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView doubleRowHeightAndShowTagsForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.currentRowHeight = kRowHeight * 2;
    self.tagButtons = [self createButtonsForTags];
    [tableView endUpdates];
    
    [self performSelector:@selector(addButtonsToCell:) withObject:cell afterDelay:0.3f];
    
    self.tagLabel.frame = tagLabelRect;
    self.tagView.frame = tagViewRect;
    
    [self addTapGestureRecognizer];
}

- (NSString *)showSelectedInterval {
    NSArray *array = @[@0, @(1 * 60), @(5 * 60), @(10 * 60), @(20 * 60), @(30 * 60), @(60 * 60)];
    NSInteger index = [array indexOfObject:[NSNumber numberWithInteger:self.selectedInterval]];
    switch (index) {
        case 0:
            return NSLocalizedString(@"Don't notify", nil);
        case 1:
            return NSLocalizedString(@"A minute before", nil);
        case 2:
            return NSLocalizedString(@"Five minutes before", nil);
        case 3:
            return NSLocalizedString(@"Ten minutes before", nil);
        case 4:
            return NSLocalizedString(@"Twenty minutes before", nil);
        case 5:
            return NSLocalizedString(@"Half an hour before", nil);
        default:
            return NSLocalizedString(@"An hour before", nil);
    }
}

- (void)showTagColor {
    self.tagLabel.text = @"No tag";
    if (self.selectedColor == RJTagColorNone) {
        self.tagLabel.textColor = [UIColor colorWithRed:142.f/255 green:142.f/255 blue:147.f/255 alpha:1.f];
    } else {
        self.tagLabel.textColor = [UIColor clearColor];
    }
    self.tagView.backgroundColor = [[[RJDataManager sharedManager] tagColors] objectAtIndex:self.selectedColor];
    
    if (viewDidAppear) {
        self.tagLabel.frame = tagLabelRect;
        self.tagView.frame = tagViewRect;
    }
    
    CGFloat tagViewHeight = 20.f;
    
    self.tagView.layer.cornerRadius = tagViewHeight / 2;
    self.tagView.clipsToBounds = YES;
}

- (void)setStandartRowHeightAndHideButton:(UIButton *)button {
    [self performSelector:@selector(removeButtonsFromCell) withObject:nil afterDelay:0.1f];
    
    [self.tableView beginUpdates];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if (cell) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    self.currentRowHeight = kRowHeight;
    [self.tableView endUpdates];
    
    [self removeTapGestureRecognizers];
}

- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(setStandartRowHeightAndHideButton:)];
    [self.view addGestureRecognizer:tap];
}

- (void)removeTapGestureRecognizers {
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
}

- (void)setDefaultSettings {
    self.datePicker.date = [NSDate date];
    self.selectedInterval = 0;
    self.enteredText = NSLocalizedString(@"Reminder", nil);
    self.selectedColor = RJTagColorNone;
}

- (void)setEventSettings {
    UITableViewCell *intervalCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    intervalCell.detailTextLabel.text = [self showSelectedInterval];
    
    UITableViewCell *textCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    textCell.detailTextLabel.text = self.enteredText;

    [self showTagColor];
    
    self.datePicker.date = self.selectedDate;
}

#pragma mark - RJRepeatIntevalProtocol

- (void)previousIntervalForReminder:(NSTimeInterval)interval {
    self.selectedInterval = interval;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    cell.detailTextLabel.text = [self showSelectedInterval];
}

#pragma mark - RJEventTextProtocol

- (void)textShouldBeSaved:(NSString *)text {
    self.enteredText = text;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    cell.detailTextLabel.text = text;
}

- (void)scheduleLocalNotification:(UILocalNotification *)localNotif forEvent:(RJEvent *)event onDate:(NSDate *)date withText:(NSString *)text {
    if (localNotif == nil)
        return;
    localNotif.fireDate = date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = text;
    localNotif.alertAction = NSLocalizedString(@"OK", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:event forKey:kEventKey];
//    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


@end
