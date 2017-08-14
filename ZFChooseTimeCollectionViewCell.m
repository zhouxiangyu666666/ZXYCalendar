

#define CYBColorGreen [UIColor colorWithRed:78/255.0 green:147/255.0 blue:232/255.0 alpha:1]
#define YJCorl(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

#import "ZFChooseTimeCollectionViewCell.h"
@implementation ZFChooseTimeCollectionViewCell
{
    occupyModel *_oModel;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)updateDay:(NSArray*)number outDate:(NSArray*)outdateArray selected:(NSInteger)judge currentDate:(NSArray*)newArray andWithOccupyArray:(NSMutableArray *)occupyArray
{
    _redSpot.backgroundColor=[UIColor whiteColor];
    self.topLineView=[[UIView alloc]initWithFrame:CGRectMake(-1, 0, self.frame.size.width+2, 1)];
    self.topLineView.backgroundColor =[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self.viewForBaselineLayout addSubview:self.topLineView];
    NSInteger p_2 =[number componentsJoinedByString:@""].intValue;
    NSInteger p_1 =[newArray componentsJoinedByString:@""].intValue;
    
    for (occupyModel *omodel in occupyArray) {
        NSArray *dateArray=[omodel.date componentsSeparatedByString:@"-"];
        if ([number[0] isEqualToString:dateArray[0]]&&[number[1] isEqualToString:dateArray[1]]&&[number[2] isEqualToString:dateArray[2]]) {
            _oModel=omodel;
            _redSpot.backgroundColor=[UIColor redColor];
            _redSpot.layer.masksToBounds=YES;
            _redSpot.layer.cornerRadius=6;
            self.userInteractionEnabled=YES;
            UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
            [self addGestureRecognizer:tapClick];
        }
    }
    
    
    
    if ([number[2] integerValue]>0) {
        if (p_1>p_2){
            
            self.number.backgroundColor = [UIColor whiteColor];
             self.number.textColor =YJCorl(200, 200, 200);
          //  [self.occupyImage removeFromSuperview];
            self.userInteractionEnabled = YES;
        }
        if (p_1==p_2) {
            self.number.backgroundColor = [UIColor whiteColor];
            self.number.textColor=[UIColor redColor];
        }
        if (p_1<p_2){
            self.number.backgroundColor = [UIColor whiteColor];
            self.number.textColor =[UIColor grayColor];
          //  [self.occupyImage removeFromSuperview];
            self.userInteractionEnabled = YES;
        }
        
    }
    else{
        _redSpot.backgroundColor=[UIColor whiteColor];
        self.number.backgroundColor = [UIColor whiteColor];
        self.number.textColor =[UIColor whiteColor];
       // [self.occupyImage removeFromSuperview];
        self.userInteractionEnabled = NO;
    }

    if ([number[2] integerValue]>=10) {
        if (p_1==p_2) {
             self.number.text=@"今天";
            self.number.font=[UIFont fontWithName:@"ArialMT" size:12];
        }
        else{
             self.number.text = [NSString stringWithFormat:@"%@",number[2]];
        }
        
    }else{
        if (p_1==p_2) {
            self.number.text=@"今天";
            self.number.font=[UIFont fontWithName:@"ArialMT" size:12];
        }
        else{
    NSString*str =[NSString stringWithFormat:@"%@",number[2]];
    self.number.text = [str stringByReplacingOccurrencesOfString:@"0" withString:@""];
    }
    self.currentArray = number;
    }
}
-(void)tapClick
{
    _searchDetails(_oModel);
}
@end
