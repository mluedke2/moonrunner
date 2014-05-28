//
//  Badge.h
//  RunMaster
//
//  Created by Matt Luedke on 5/21/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Badge : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *information;
@property float distance;

@end
