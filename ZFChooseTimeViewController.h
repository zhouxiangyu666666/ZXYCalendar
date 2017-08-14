

#import <UIKit/UIKit.h>

typedef void(^chooseDate)(NSArray*goDate,NSArray*backDate);

/**
 *  时间选择器
 */
@interface ZFChooseTimeViewController : UIViewController

@property (nonatomic, copy) chooseDate selectedDate;

/**
 *  返回选中时间
 *
 *  @param listDate 时间
 */
-(void)backDate:(chooseDate)listDate;



@end
