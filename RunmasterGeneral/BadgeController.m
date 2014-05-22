//
//  BadgeController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "BadgeController.h"
#import "Badge.h"
#import "Run.h"

static float const silverMultiplier = 1.05;
static float const goldMultiplier = 1.10;

@interface BadgeController ()

@property (strong, nonatomic) NSArray *badges;

@end


@implementation BadgeController

+ (BadgeController *)defaultController {
    
    static BadgeController* controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [[BadgeController alloc] init];
        controller.badges = [self badgeArray];
    });
    
    return controller;
}

+ (NSArray *)badgeArray {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"badges" ofType:@"txt"];
    NSString *jsonContent = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
    NSData *data = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *badgeDicts = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    NSMutableArray *badgeObjects = [NSMutableArray array];
    
    for (NSDictionary *badgeDict in badgeDicts) {
        [badgeObjects addObject:[self badgeForDictionary:badgeDict]];
    }
    
    return badgeObjects;
}

+ (Badge *)badgeForDictionary:(NSDictionary *)dictionary {
    Badge *badge = [Badge new];
    badge.name = [dictionary objectForKey:@"name"];
    badge.desc = [dictionary objectForKey:@"desc"];
    badge.imageName = [dictionary objectForKey:@"imageName"];
    badge.distance = [[dictionary objectForKey:@"distance"] floatValue];
    return badge;
}

- (NSArray *)earnStatusesForRuns:(NSArray *)runs {
    NSMutableArray *earnStatuses;
    
    for (Badge *badge in self.badges) {
        
        Run *earnRun = NULL;
        Run *silverRun = NULL;
        Run *goldRun = NULL;
        Run *bestRun = NULL;
        
        for (Run *run in runs) {
            
            if (run.distance.floatValue > badge.distance) {
                
                // this is when the badge was first earned
                if (earnRun == NULL) {
                    earnRun = run;
                }
                
                double earnRunSpeed = earnRun.distance.doubleValue / earnRun.duration.doubleValue;
                double runSpeed = run.distance.doubleValue / run.duration.doubleValue;
                
                // does it deserve silver?
                if (silverRun == NULL
                    && runSpeed > earnRunSpeed * silverMultiplier) {
                    
                    silverRun = run;
                }
                
                // does it deserve gold?
                if (goldRun == NULL
                    && runSpeed > earnRunSpeed * goldMultiplier) {
                    
                    goldRun = run;
                }
                
                // is it the best for this distance?
                if (bestRun == NULL) {
                    bestRun = run;
                    
                } else {
                    double bestRunSpeed = bestRun.distance.doubleValue / bestRun.duration.doubleValue;
                    
                    if (runSpeed > bestRunSpeed) {
                        bestRun = run;
                    }
                }
            }
        }
        
        [earnStatuses addObject:[NSDictionary dictionaryWithObjectsAndKeys: badge, @"badge", earnRun, @"earnRun", bestRun, @"bestRun", silverRun, @"silverRun", goldRun, @"goldRun", nil]];
    }
    
    return earnStatuses;
}

- (Badge *)bestBadgeForDistance:(float)distance {
    Badge *bestBadge = self.badges.firstObject;
    for (Badge *badge in self.badges) {
        if (distance < badge.distance) {
            break;
        }
        bestBadge = badge;
    }
    return bestBadge;
}

- (Badge *)nextBadgeForDistance:(float)distance {
    Badge *nextBadge;
    for (Badge *badge in self.badges) {
        nextBadge = badge;
        if (distance < badge.distance) {
            break;
        }
    }
    return nextBadge;
}


@end
