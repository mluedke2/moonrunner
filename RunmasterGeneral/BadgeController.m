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
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"badges" ofType:@"txt"];
        NSString *jsonContent = [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
        NSData *data = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
        controller.badges = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    });
    
    return controller;
}

- (NSArray *)medalStatusForRuns:(NSArray *)runArray {
    
    return runArray;
}


@end
