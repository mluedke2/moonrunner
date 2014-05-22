//
//  RunCell.h
//  RunMaster
//
//  Created by Matt Luedke on 5/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;

@end
