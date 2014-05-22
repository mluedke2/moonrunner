//
//  BadgeEarnStatus.h
//  RunMaster
//
//  Created by Matt Luedke on 5/22/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Badge;
@class Run;

@interface BadgeEarnStatus : NSObject

@property (strong, nonatomic) Badge *badge;
@property (strong, nonatomic) Run *earnRun;
@property (strong, nonatomic) Run *silverRun;
@property (strong, nonatomic) Run *goldRun;
@property (strong, nonatomic) Run *bestRun;

@end
