//
//  BadgeAnnotation.h
//  MoonRunner
//
//  Created by Matt Luedke on 6/11/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BadgeAnnotation : MKPointAnnotation

@property (strong, nonatomic) NSString *imageName;

@end
