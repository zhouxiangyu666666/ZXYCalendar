


#import "ZFChooseTimeViewController.h"
#import "ZFChooseTimeCollectionViewCell.h"
#import "ZFTimerCollectionReusableView.h"
#import "occupyModel.h"
#import "ChangeColor.h"
#define _WIDTH ([UIScreen mainScreen].bounds.size.width/375)
#define _HIGHT ([UIScreen mainScreen].bounds.size.height/667)
static NSString * const reuseIdentifier = @"ChooseTimeCell";
static NSString * const headerIdentifier = @"headerIdentifier";



@interface ZFChooseTimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDateComponents *comps;
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, strong) NSArray * weekdays;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, strong) NSArray *OutDateArray;
@property (nonatomic, strong) NSArray *selectedData;
@property (nonatomic, strong) NSMutableArray *occupyArray;
@end

@implementation ZFChooseTimeViewController

@synthesize date = newDate;
@synthesize collectionView = datecollectionView;

#pragma mark ---
#pragma mark --- 初始化
- (NSTimeZone*)timeZone
{
    if (_timeZone == nil) {
        [UIColor blueColor];
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    }
    return _timeZone;
}


- (NSArray*)weekdays
{
    
    if (_weekdays == nil) {
        
        _weekdays = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    }
    return _weekdays;
}
- (NSCalendar*)calender
{
    
    if (_calender == nil) {
        
        _calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    return _calender;
}
- (NSDateComponents*)comps
{
    
    if (_comps == nil) {
        
        _comps = [[NSDateComponents alloc] init];
        
    }
    
    return _comps;
}
- (NSDateFormatter*)formatter
{
    
    if (_formatter == nil) {
        
        _formatter =[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}


#pragma mark ---
#pragma mark --- 各种方法
/**
 *  根据当前月获取有多少天
 *
 *  @param dayDate 但前时间
 *
 *  @return 天数
 */
- (NSInteger)getNumberOfDays:(NSDate *)dayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dayDate];
    
    return range.length;
    
}
/**
 *  根据前几月获取时间
 *
 *  @param date  当前时间
 *  @param month 第几个月 正数为前  负数为后
 *
 *  @return 获得时间
 */
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month

{
    [self.comps setMonth:month];
    
    NSDate *mDate = [self.calender dateByAddingComponents:self.comps toDate:date options:0];
    return mDate;
    
}



/**
 *  根据时间获取周几
 *
 *  @param inputDate 输入参数是NSDate，
 *
 *  @return 输出结果是星期几的字符串。
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    [self.calender setTimeZone: self.timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [self.calender components:calendarUnit fromDate:inputDate];
    
    return [self.weekdays objectAtIndex:theComponents.weekday];
    
}
/**
 *  获取第N个月的时间
 *
 *  @param currentDate 当前时间
 *  @param index 第几个月 正数为前  负数为后
 *
 *  @return @“2016年3月”
 */
- (NSArray*)timeString:(NSDate*)currentDate many:(NSInteger)index;
{
    
    NSDate *getDate =[self getPriousorLaterDateFromDate:currentDate withMonth:index];
    
    NSString  *str =  [self.formatter stringFromDate:getDate];
    
    return [str componentsSeparatedByString:@"-"];
}

/**
 *  根据时间获取第一天周几
 *
 *  @param dateStr 时间
 *
 *  @return 周几
 */
- (NSString*)getMonthBeginAndEndWith:(NSDate *)dateStr{
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:dateStr];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    
    return   [self weekdayStringFromDate:beginDate];
}


#pragma mark ---
#pragma mark --- 视图初始化

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMessage];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBar];
    _occupyArray=[[NSMutableArray alloc]init];
    newDate =[NSDate date];
    
    //模糊效果
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0,74*_HIGHT ,_WIDTH*375,46*_HIGHT)];
    topView.backgroundColor=[ChangeColor getColor:@"000000"];
    topView.alpha=0.05;
    [self.view addSubview:topView];
    //红点
    UIImageView *redspotImage=[[UIImageView alloc]initWithFrame:CGRectMake(164*_WIDTH,99.6*_HIGHT,12*_WIDTH,12*_WIDTH)];
    redspotImage.backgroundColor=[ChangeColor getColor:@"FF6552"];
    redspotImage.layer.masksToBounds=YES;
    redspotImage.layer.cornerRadius=6;
    [self.view addSubview:redspotImage];
    UILabel *redspotLabel=[[UILabel alloc]initWithFrame:CGRectMake(179.2*_WIDTH,97*_HIGHT,33*_WIDTH,16*_HIGHT)];
    redspotLabel.text=@"已预订";
    redspotLabel.textColor=[ChangeColor getColor:@"FF6552"];
    redspotLabel.font=[UIFont fontWithName:@"ArialMT" size:11*_WIDTH];
    [self.view addSubview:redspotLabel];

    
}
-(void)setCollectionView
{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(kDeviceWidth/7, (kDeviceWidth/7)*4/3)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    [flowLayout setHeaderReferenceSize:CGSizeMake(kDeviceWidth, 50)];
    [flowLayout setMinimumInteritemSpacing:0]; //设置 y 间距
    [flowLayout setMinimumLineSpacing:0]; //设置 x 间距
    // flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置其边界
    //UIEdgeInsetsMake(设置上下cell的上间距,设置cell左距离,设置上下cell的下间距,设置cell右距离);
    
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    
    datecollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 120*_HIGHT, kDeviceWidth, kDeviceHeight-120*_HIGHT) collectionViewLayout:flowLayout];
    datecollectionView.dataSource = self;
    datecollectionView.delegate = self;
    datecollectionView.backgroundColor =[UIColor whiteColor];
    
    [datecollectionView registerNib:[UINib nibWithNibName:@"ZFChooseTimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [datecollectionView registerNib:[UINib nibWithNibName:@"ZFTimerCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.view addSubview:datecollectionView];


}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        ZFTimerCollectionReusableView * headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        [headerCell updateTimer:[self timeString:newDate many:indexPath.section]];
        
        return headerCell;
    }
    return nil;
}



#pragma mark ---
#pragma mark --- <UICollectionViewDataSource>



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSDate *dateList = [self getPriousorLaterDateFromDate:newDate withMonth:section];
    
    NSString *timerNsstring = [self getMonthBeginAndEndWith:dateList];
    
    NSInteger p_0 = [timerNsstring integerValue];
    
    NSInteger p_1 = [self getNumberOfDays:dateList] + p_0;
    
    return p_1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFChooseTimeCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDate *dateList = [self getPriousorLaterDateFromDate:newDate withMonth:indexPath.section];

    NSArray*array = [self timeString:newDate many:indexPath.section];
    
    NSInteger p = indexPath.row -[self getMonthBeginAndEndWith:dateList].intValue+1;
    
    NSString *str;

    if (p<10)
    {
        
        str = p > 0 ? [NSString stringWithFormat:@"0%ld",(long)p]:[NSString stringWithFormat:@"-0%ld",(long)-p];

    }
    else
    {
        
        str = [NSString stringWithFormat:@"%ld",(long)p];
    }
    
    NSArray *list = @[ array[0], array[1], str];

    [cell updateDay:list outDate:self.OutDateArray selected:[self.selectedData componentsJoinedByString:@""].integerValue currentDate:[self timeString:newDate many:0 ]andWithOccupyArray:_occupyArray];

    if ([cell.number.text integerValue]<0||[cell.number.text isEqualToString:@"-"]) {
        cell.topLineView.backgroundColor=[UIColor whiteColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
}




#pragma mark ---
#pragma mark --- block

- (void)backDate:(chooseDate)listDate;
{
    
    self.selectedDate = listDate;
    
}

#pragma mark ---
#pragma mark --- 提示框
/**
 *  返回时间
 */
- (void)goBack
{

    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_OutDateArray.count > 0 && _selectedData.count > 0) {
            
            if (self.selectedDate) {
                
                self.selectedDate(_OutDateArray,_selectedData);
            }
            
        }
    
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavigationBar
{
    NSArray *titleArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat width = ([UIScreen mainScreen].bounds.size.width-20)/7;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 74*_HIGHT)];
    view.backgroundColor=[UIColor colorWithRed:0.10f green:0.72f blue:1.00f alpha:1.00f];
    [self.view addSubview:view];
    
    UILabel *titlelabel=[[UILabel alloc]init];
    titlelabel.center=CGPointMake(_WIDTH*375/2, 64*_HIGHT/2+10);
    titlelabel.font = [UIFont systemFontOfSize:15.0*_WIDTH];
    titlelabel.text=@"我的排期";
    CGSize maximumLabelSize=CGSizeMake(100, 9999);
    CGSize expectSize=[titlelabel sizeThatFits:maximumLabelSize];
    titlelabel.frame=CGRectMake(0, 0, expectSize.width, expectSize.height);
    titlelabel.center=CGPointMake(_WIDTH*375/2, 41*_HIGHT);
    titlelabel.textColor=[UIColor whiteColor];
    [view addSubview:titlelabel];
    
    UIView *backview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 64*_HIGHT)];
    backview.backgroundColor=[UIColor clearColor];
    [view addSubview:backview];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BackClick1)];
    backview.userInteractionEnabled=YES;
    [backview addGestureRecognizer:tap];
    
    //返回按钮
    UIButton *BackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    BackButton.frame=CGRectMake(13, 30, 25, 25);
    [BackButton setImage:[UIImage imageNamed:@"Fill 1"] forState:UIControlStateNormal];
    [backview addSubview:BackButton];
    [BackButton addTarget:self
                   action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < titleArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width+10, 54*_HIGHT, width, 20*_HIGHT)];
        label.text = titleArray[i];
        label.textColor=[UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12.0*_WIDTH];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
}
-(void)getMessage
{
     [self setCollectionView];
}
-(void)BackClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)BackClick1{
    [self BackClick];
}

@end
