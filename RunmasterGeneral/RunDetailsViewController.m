#import <MapKit/MapKit.h>
#import "RunDetailsViewController.h"
#import "Run.h"
#import "MathController.h"
#import "Badge.h"
#import "BadgeController.h"
#import "Location.h"

static float const mapPadding = 1.1f;

@interface RunDetailsViewController () <MKMapViewDelegate>

@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) NSArray *colorMapArray;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;

@end

@implementation RunDetailsViewController

#pragma mark - IBActions

-(IBAction)displayModeToggled:(UISwitch *)sender {
    self.badgeImageView.hidden = !sender.isOn;
    self.infoButton.hidden = !sender.isOn;
    self.mapView.hidden = sender.isOn;
}

-(IBAction)infoButtonPressed:(UIButton *)sender {
    
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.run.distance.floatValue];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:badge.name
                              message:badge.information
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Managing the detail item

- (void)setRun:(Run *)newDetailRun
{
    if (_run != newDetailRun) {
        _run = newDetailRun;
        
        self.locations = [newDetailRun.locations sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]]];
        self.colorMapArray = [MathController colorsForLocations:self.locations];
    }
}

- (void)configureView
{
    self.distanceLabel.text = [MathController stringifyDistance:self.run.distance.floatValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.run.timestamp];
    
    self.paceLabel.text = [MathController stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue];
    
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.run.distance.floatValue];
    self.badgeImageView.image = [UIImage imageNamed:badge.imageName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    [self loadMap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMap {
    
    if (self.run.locations.count > 0) {
        
        self.mapView.hidden = NO;
        
        // set the map bounds
        [self.mapView setRegion:[self mapRegion]];
        
        // make the line(s!) on the map
        for (int i = 1; i < self.locations.count; i++) {
            [self.mapView addOverlay:[self polyLineForLocation:[self.locations objectAtIndex:(i-1)] andLocation:[self.locations objectAtIndex:i]]];
        }
    } else {
        
        // no locations were found!
        self.mapView.hidden = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - MKMapViewDelegate

- (MKCoordinateRegion)mapRegion {
    
    MKCoordinateRegion region;
    Location *initialLoc = self.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * mapPadding;
    region.span.longitudeDelta = (maxLng - minLng) * mapPadding;
    
    return [self.mapView regionThatFits:region];
}

- (MKPolyline *)polyLineForLocation:(Location *)locationA andLocation:(Location *)locationB {
    
    CLLocationCoordinate2D coords[2];
    
    coords[0] = CLLocationCoordinate2DMake(locationA.latitude.doubleValue, locationA.longitude.doubleValue);
    coords[1] = CLLocationCoordinate2DMake(locationB.latitude.doubleValue, locationB.longitude.doubleValue);
    
    return [MKPolyline polylineWithCoordinates:coords count:2];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        
        aRenderer.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        
        MKMapPoint *points = [polyLine points];
        MKMapPoint pointA = points[0];
        MKMapPoint pointB = points[1];
        
        aRenderer.strokeColor = [MathController colorForLineBetweenPoint:MKCoordinateForMapPoint(pointA) andPoint:MKCoordinateForMapPoint(pointB) givenMapArray:self.colorMapArray];
        
        aRenderer.lineWidth = 3;
        
        NSLog(@"strokeColor: %@", aRenderer.strokeColor);
        
        return aRenderer;
    }
    
    return nil;
}

@end
