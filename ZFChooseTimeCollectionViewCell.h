


#define CYBColorGreen [UIColor colorWithRed:78/255.0 green:147/255.0 blue:232/255.0 alpha:1]
#define YJCorl(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>
#import "occupyModel.h"
typedef void (^searchDetails)(occupyModel* );
@interface ZFChooseTimeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (nonatomic ,strong) NSArray *currentArray;

@property UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIImageView *redSpot;

@property (nonatomic,copy)searchDetails searchDetails;

- (void)updateDay:(NSArray*)number outDate:(NSArray*)outdateArray selected:(NSInteger)judge currentDate:(NSArray*)newArray andWithOccupyArray:(NSMutableArray *)occupyArray;

@end
