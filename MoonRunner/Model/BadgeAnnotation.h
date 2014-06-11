//
//  BadgeAnnotation.h
//  MoonRunner
//
//  Created by Matt Luedke on 6/11/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BadgeAnnotation : MKPointAnnotation

//@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//@property (nonatomic, readonly, copy) NSString *title;
//@property (nonatomic, readonly, copy) NSString *subtitle;
@property (strong, nonatomic) NSString *imageName;

@end
