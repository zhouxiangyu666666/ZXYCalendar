

#import "ZFTimerCollectionReusableView.h"
#import "ChangeColor.h"
@implementation ZFTimerCollectionReusableView


- (void)updateTimer:(NSArray*)array;
{
    self.timerLabel.text = [NSString stringWithFormat:@"%@年%@月",array[0],array[1]];
    self.timerLabel.textColor=[ChangeColor getColor:@"1CB7FF"];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
