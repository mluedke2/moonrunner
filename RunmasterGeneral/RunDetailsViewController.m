#import "RunDetailsViewController.h"
#import "Run.h"
#import "MathController.h"
#import "Badge.h"
#import "BadgeController.h"

@interface RunDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@property (nonatomic, weak) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, weak) IBOutlet UIButton *infoButton;

@end

@implementation RunDetailsViewController

#pragma mark - IBActions

-(IBAction)infoButtonPressed:(UIButton *)sender {
    
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.detailRun.distance.floatValue];
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:badge.name
                              message:badge.desc
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Managing the detail item

- (void)setDetailRun:(Run *)newDetailRun
{
    if (_detailRun != newDetailRun) {
        _detailRun = newDetailRun;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    self.distanceLabel.text = [MathController stringifyDistance:self.detailRun.distance.floatValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.detailRun.timestamp];
    
    self.paceLabel.text = [MathController stringifyAvgPaceFromDist:self.detailRun.distance.floatValue overTime:self.detailRun.duration.intValue];
    
    Badge *badge = [[BadgeController defaultController] bestBadgeForDistance:self.detailRun.distance.floatValue];
    self.badgeImageView.image = [UIImage imageNamed:badge.imageName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
