//
//  BadgeCell.m
//  RunMaster
//
//  Created by Matt Luedke on 5/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "BadgeCell.h"

@implementation BadgeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
