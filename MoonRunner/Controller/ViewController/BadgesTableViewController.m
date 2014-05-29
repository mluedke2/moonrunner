//
//  BadgesTableViewController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/22/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "BadgesTableViewController.h"
#import "BadgeEarnStatus.h"
#import "BadgeDetailsViewController.h"
#import "BadgeCell.h"
#import "Badge.h"
#import "MathController.h"
#import "Run.h"

@interface BadgesTableViewController ()

@property (strong, nonatomic) UIColor *redColor;
@property (strong, nonatomic) UIColor *greenColor;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property CGAffineTransform transform;

@end

@implementation BadgesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.redColor = [UIColor colorWithRed:1.0f green:20/255.0 blue:44/255.0 alpha:1.0f];
    self.greenColor = [UIColor colorWithRed:0.0f green:146/255.0 blue:78/255.0 alpha:1.0f];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.transform = CGAffineTransformMakeRotation(M_PI/8);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.earnStatusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BadgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BadgeCell" forIndexPath:indexPath];
    BadgeEarnStatus *earnStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
    
    if (earnStatus.earnRun) {
        
        cell.nameLabel.textColor = self.greenColor;
        cell.nameLabel.text = earnStatus.badge.name;
        cell.descLabel.textColor = self.greenColor;
        cell.descLabel.text = [NSString stringWithFormat:@"Earned: %@", [self.dateFormatter stringFromDate:earnStatus.earnRun.timestamp]];
        cell.badgeImageView.image = [UIImage imageNamed:earnStatus.badge.imageName];
        cell.silverImageView.transform = self.transform;
        cell.silverImageView.hidden = !earnStatus.silverRun;
        cell.goldImageView.transform = self.transform;
        cell.goldImageView.hidden = !earnStatus.goldRun;
        cell.userInteractionEnabled = YES;
        
    } else {
        cell.nameLabel.textColor = self.redColor;
        cell.nameLabel.text = @"?????";
        cell.descLabel.textColor = self.redColor;
        cell.descLabel.text = [NSString stringWithFormat:@"Run %@ to Earn", [MathController stringifyDistance:earnStatus.badge.distance]];
        cell.badgeImageView.image = [UIImage imageNamed:@"question_badge.png"];
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[BadgeDetailsViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BadgeEarnStatus *earnStatus = [self.earnStatusArray objectAtIndex:indexPath.row];
        [(BadgeDetailsViewController *)[segue destinationViewController] setEarnStatus:earnStatus];
    }
}

@end
