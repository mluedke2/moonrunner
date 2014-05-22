//
//  BadgeController.h
//  RunMaster
//
//  Created by Matt Luedke on 5/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Badge.h"

@interface BadgeController : NSObject

typedef enum {
    kNone,
    kSilver,
    kGold
} MedalStatus;

+ (BadgeController *)defaultController;

- (NSArray *)medalStatusForRuns:(NSArray *)runArray;

- (Badge *)bestBadgeForDistance:(float)distance;

- (Badge *)nextBadgeForDistance:(float)distance;

@end
