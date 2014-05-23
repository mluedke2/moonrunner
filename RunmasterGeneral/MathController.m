//
//  MathController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/20/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "MathController.h"
#import "Location.h"

static bool const isMetric = NO;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation MathController

+ (NSString *)stringifyDistance:(float)meters {
    
    float unitDivider;
    NSString *unitName;
    
    // metric
    if (isMetric) {
        
        unitName = @"km";
        
        // to get from meters to kilometers divide by this
        unitDivider = metersInKM;
        
    // U.S.
    } else {
        
        unitName = @"mi";
        
        // to get from meters to miles divide by this
        unitDivider = metersInMile;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", (meters / unitDivider), unitName];
}

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat {
    
    int remainingSeconds = seconds;
    
    int hours = remainingSeconds / 3600;
    
    remainingSeconds = remainingSeconds - hours * 3600;
    
    int minutes = remainingSeconds / 60;
    
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
            
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
            
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
            
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds
{
    if (seconds == 0 || meters == 0) {
        return @"0";
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    float unitMultiplier;
    NSString *unitName;
    
    // metric
    if ([defaults boolForKey:@"isMetric"]) {
        
        unitName = @"min/km";
        
        // to get from meters to kilometers divide by this
        unitMultiplier = metersInKM;
        
    // U.S.
    } else {
        
        unitName = @"min/mi";
        
        // to get from meters to miles divide by this
        unitMultiplier = metersInMile;
    }
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", paceMin, paceSec, unitName];
}

+ (NSArray *)colorsForLocations:(NSArray *)locations
{
    // make array of all speeds, find slowest+fastest
    NSMutableArray *speeds = [NSMutableArray array];
    double slowestSpeed = DBL_MAX;
    double fastestSpeed = 0.0;
    
    for (int i = 1; i < locations.count; i++) {
        Location *firstLoc = [locations objectAtIndex:(i-1)];
        Location *secondLoc = [locations objectAtIndex:i];
        
        CLLocation *firstLocCL = [[CLLocation alloc] initWithLatitude:firstLoc.latitude.doubleValue longitude:firstLoc.longitude.doubleValue];
        CLLocation *secondLocCL = [[CLLocation alloc] initWithLatitude:secondLoc.latitude.doubleValue longitude:secondLoc.longitude.doubleValue];
        
        double distance = [secondLocCL distanceFromLocation:firstLocCL];
        double time = [secondLoc.timestamp timeIntervalSinceDate:firstLoc.timestamp];
        double speed = distance/time;
        
        slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed;
        fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed;
        
        [speeds addObject:[NSNumber numberWithDouble:speed]];
    }
    
    // now knowing the slowest+fastest, assign a color to each
    double middleSpeed = (slowestSpeed + fastestSpeed)/2;
    
    // RGB for red (slowest)
    CGFloat r_red = 1.0f;
    CGFloat r_green = 20/255.0f;
    CGFloat r_blue = 44/255.0f;
    
    // RGB for yellow (middle)
    CGFloat y_red = 1.0f;
    CGFloat y_green = 215/255.0f;
    CGFloat y_blue = 0.0f;

    // RGB for green (fastest)
    CGFloat g_red = 0.0f;
    CGFloat g_green = 146/255.0f;
    CGFloat g_blue = 78/255.0f;
    
    NSMutableArray *colors = [NSMutableArray array];
    
    for (NSNumber *speed in speeds) {
        
        // between red and yellow
        if (speed.doubleValue < middleSpeed) {
            double ratio = (speed.doubleValue - slowestSpeed) / (middleSpeed - slowestSpeed);
            CGFloat red = ratio * (y_red - r_red);
            CGFloat green = ratio * (y_green - r_green);
            CGFloat blue = ratio * (y_blue - r_blue);
            [colors addObject:[UIColor colorWithRed:red green:green blue:blue alpha:1.0f]];
            
        // between yellow and green
        } else {
            double ratio = (speed.doubleValue - middleSpeed) / (fastestSpeed - middleSpeed);
            CGFloat red = ratio * (g_red - y_red);
            CGFloat green = ratio * (g_green - y_green);
            CGFloat blue = ratio * (g_blue - y_blue);
            [colors addObject:[UIColor colorWithRed:red green:green blue:blue alpha:1.0f]];
        }
    }
    
    return colors;
}

+ (UIColor *)colorForLineBetweenPoint:(CLLocationCoordinate2D)pointA andPoint:(CLLocationCoordinate2D)pointB givenMapArray:(NSArray *)colorCoordMapArray {
    
    
    NSUInteger index = [colorCoordMapArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        // TODO: match the two points
    
        return YES;
    }];
    
    if (index == NSNotFound) {
        return [UIColor clearColor];
    }
    
    return [[colorCoordMapArray objectAtIndex:index] objectForKey:@"color"];
}

@end
