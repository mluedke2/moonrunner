//
//  MathController.h
//  RunMaster
//
//  Created by Matt Luedke on 5/20/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MathController : NSObject

+ (NSString *)stringifyDistance:(float)meters;

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

+ (NSArray *)colorsForLocations:(NSArray *)locations;

+ (UIColor *)colorForLineBetweenPoint:(CLLocationCoordinate2D)pointA andPoint:(CLLocationCoordinate2D)pointB givenMapArray:(NSArray *)colorCoordMapArray;

@end
