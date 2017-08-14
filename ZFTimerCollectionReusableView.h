

#import <UIKit/UIKit.h>

@interface ZFTimerCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (void)updateTimer:(NSArray*)array;

@end
