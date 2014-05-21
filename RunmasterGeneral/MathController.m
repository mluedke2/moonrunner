//
//  MathController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/20/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "MathController.h"

@implementation MathController

static bool const isMetric = NO;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

+ (MathController *)defaultController {
    static MathController* s_mathController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_mathController = [[MathController alloc] init];
    });
    return s_mathController;
}

- (NSString *)stringifyDistance:(float)meters {
    
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

- (NSString *)stringifySecondCount:(NSNumber *)seconds {
    
    int remainingSeconds = seconds.intValue;
    
    int hours = remainingSeconds / 3600;
    
    remainingSeconds = remainingSeconds - hours * 3600;
    
    int minutes = remainingSeconds / 60;
    
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
        
    } else if (minutes > 0) {
        return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
        
    } else {
        return [NSString stringWithFormat:@"%isec", remainingSeconds];
    }
}

- (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds {
    
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

@end
