//
//  BadgeController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "BadgeController.h"

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

- (NSArray *)medalStatusForRuns:(NSArray *)runArray {
    
    return runArray;
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
