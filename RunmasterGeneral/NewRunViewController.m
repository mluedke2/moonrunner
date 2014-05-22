//
//  NewRunViewController.m
//  RunMaster
//
//  Created by Matt Luedke on 5/19/14.
//  Copyright (c) 2014 Matt Luedke. All rights reserved.
//

#import "NewRunViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MathController.h"
#import "Run.h"
#import "Location.h"
#import "RunDetailsViewController.h"

static NSString * const detailSegueName = @"ShowDetails";

@interface NewRunViewController () <UIActionSheetDelegate, CLLocationManagerDelegate>

@property BOOL soundsOn;
@property int seconds;
@property float distance;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) Run *run;

@property (nonatomic, weak) IBOutlet UILabel *promptLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *distTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *distLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UIButton *soundButton;

@end

@implementation NewRunViewController

#pragma mark - Lifecycle

#pragma mark - IBActions

-(IBAction)startPressed:(id)sender
{
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Location Services Not On!"
                                  message:@"Please turn on Location Services for this app in Settings."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    // hide the start UI
    self.startButton.hidden = YES;
    self.promptLabel.hidden = YES;
    
    // show the running UI
    self.timeLabel.hidden = NO;
    self.timeTitleLabel.hidden = NO;
    self.distLabel.hidden = NO;
    self.distTitleLabel.hidden = NO;
    self.speedLabel.hidden = NO;
    self.speedTitleLabel.hidden = NO;
    self.stopButton.hidden = NO;
    
    self.seconds = 0;
    
    // initialize the timer
	self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(eachSecond) userInfo:nil repeats:YES];
    
    self.distance = 0;
    self.locations = [NSMutableArray array];
    
    [self startLocationUpdates];
}

- (IBAction)stopPressed:(id)sender
{
    // switch UI mode
}

#pragma mark - Private

- (void)startLocationUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    // Movement threshold for new events.
    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.locationManager stopUpdatingLocation];
    
    // save
    if (buttonIndex == 0) {
        [self saveRun];
        [self performSegueWithIdentifier:detailSegueName sender:nil];
        
    // discard
    } else if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    
    NSDate *eventDate = newLocation.timestamp;
    
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 50) {
        
        // update distance
        if (self.locations.count > 0) {
            self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
        }
        
        [self.locations addObject:newLocation];
    }
}






- (void)saveRun
{
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
    
    newRun.timestamp = [NSDate date];
    
    NSMutableSet *locationSet = [NSMutableSet set];
    for (CLLocation *location in self.locations) {
        Location *locationObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
        
        locationObject.timestamp = location.timestamp;
        locationObject.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        locationObject.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        [locationSet addObject:locationObject];
    }
    
    newRun.locations = locationSet;
    self.run = newRun;
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)eachSecond
{
    self.seconds++;
    [self updateLabels];
    [self maybePlaySound];
}

- (void)updateLabels
{
    self.timeLabel.text = [MathController stringifySecondCount:self.seconds usingLongFormat:NO];
        
    self.distLabel.text = [MathController stringifyDistance:self.distance];
    
    self.speedLabel.text = [MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds];
}

- (void) maybePlaySound
{
    // TODO: checkpoint logic
    BOOL justPassedCheckpoint = NO;
    
    if (justPassedCheckpoint && self.soundsOn) {
        [self playSuccessSound];
    }
}

- (void)playSuccessSound
{
    //Get the filename of the sound file:
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/genericsuccess.wav"];
    
    //declare a system sound
    SystemSoundID soundID;
    
    //Get a URL for the sound file
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(filePath), &soundID);
    //Use audio services to play the sound
    AudioServicesPlaySystemSound(soundID);
    
    //also vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:detailSegueName]) {
        [[segue destinationViewController] setRun:self.run];
    }
}

@end
