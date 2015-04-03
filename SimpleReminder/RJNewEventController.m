//
//  RJNewEventController.m
//  SimpleReminder
//
//  Created by Hopreeeeenjust on 01.04.15.
//  Copyright (c) 2015 Hopreeeeenjust. All rights reserved.
//

#import "RJNewEventController.h"
#import "RJTagCell.h"

typedef NS_ENUM(NSInteger, RJTagColor) {
    RJTagColorRed = 0,
    RJTagColorOrange,
    RJTagColorYellow,
    RJTagColorGreen,
    RJTagColorBlue,
    RJTagColorPurple,
    RJTagColorGray,
    RJTagColorNone
};

#define lightPurpleColor [UIColor colorWithRed:177.f/255 green:74.f/255 blue:255.f alpha:1.f]
#define lightBlueColor [UIColor colorWithRed:63.f/255 green:168.f/255 blue:240.f/255 alpha:1.f]

@interface RJNewEventController ()
@property (assign, nonatomic) CGFloat currentRowHeight;
@property (strong, nonatomic) NSArray *tagButtons;
@property (strong, nonatomic) NSArray *tagColors;
@property (assign, nonatomic) RJTagColor selectedColor;
@end

static const CGFloat kRowHeight = 44.f;

@implementation RJNewEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancelButtonPushed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSaveButtonPushed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    self.currentRowHeight = kRowHeight;
    
    self.tagButtons = [NSArray new];
    self.tagColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor], [UIColor greenColor], lightBlueColor, lightPurpleColor, [UIColor lightGrayColor], [UIColor clearColor]];
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
    static NSString *tagIdentifier = @"Tag";
    static NSString *defaultCellIdentifier = @"Cell";
    NSString *identifier;
    if (indexPath.row == 1) {
        identifier = tagIdentifier;
    } else {
        identifier = defaultCellIdentifier;
    }
    RJTagCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RJTagCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RJTagCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Sound", nil);
        cell.detailTextLabel.text = @"Detail";
    } else if (indexPath.row == 1) {
        cell.defaultLabel.text = @"Tag";
        cell.tagLabel.text = @"fxccsccc";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"Repeat", nil);
        cell.detailTextLabel.text = @"Detail";
    } else  {
        cell.textLabel.text = NSLocalizedString(@"Text", nil);
        cell.detailTextLabel.text = @"Detail";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        [tableView beginUpdates];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.currentRowHeight = kRowHeight * 2;
        self.tagButtons = [self createButtonsForTags];
        [tableView endUpdates];
        [self performSelector:@selector(addButtonsToCell:) withObject:cell afterDelay:0.3f];
    } else if (indexPath.row == 2) {
        
    } else  {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return  self.currentRowHeight;
    } else {
        return kRowHeight;
    }
}

#pragma mark - Actions

- (void)actionTagButtonPushed:(UIButton *)sender {
    self.selectedColor = [self.tagButtons indexOfObject:sender];
    NSLog(@"%ld", self.selectedColor);
}

#pragma mark - Methods

- (NSArray *)createButtonsForTags {
    CGFloat buttonWidth = 30.f;
    CGFloat buttonHeight = 30.f;
    NSInteger buttonsCount = [self.tagColors count];
    CGFloat inset = (CGRectGetWidth(self.tableView.frame) - buttonWidth * buttonsCount) / (buttonsCount + 1);
    CGFloat pointY = kRowHeight + kRowHeight / 2 - buttonHeight / 2;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = RJTagColorRed; i <= RJTagColorNone; i++) {
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectIntegral(CGRectMake(inset * (i + 1) + buttonWidth * i, pointY, buttonWidth, buttonHeight))];
        tagButton.backgroundColor = self.tagColors[i];
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

@end
