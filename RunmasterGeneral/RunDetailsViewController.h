#import <UIKit/UIKit.h>

@class Run;

@interface RunDetailsViewController : UIViewController

@property (strong, nonatomic) Run *detailRun;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
