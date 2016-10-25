//
//  FYTrialBroadcast_ViewController.m
//  zsfy
//
//  Created by pyj on 15/11/16.
//  Copyright (c) 2015年 wzy. All rights reserved.
//
#define TitleViewH 30
#import "FYTrialBroadcast_ViewController.h"
#import "FYSearch_ViewController.h"
#import "FYSearchTitle_View.h"
#import "CycleScrollView.h"
#import "FYBroadColleciton_Cell.h"
#import "RootClass.h"
#import "MJExtension.h"
#import "FYBoradingView.h"
#import "FYZbhgViewController.h"
#import "SDCycleScrollView.h"
#import "FYWebViewController.h"

#define CollectionCellPadding 5
@interface FYTrialBroadcast_ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic , strong) SDCycleScrollView *mainScorllView;

@property (nonatomic,strong)UIPageControl *pageCtrl;
@property (nonatomic,strong)UIScrollView *bgView;
//CollectionView的布局
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
//CollectionView的布局
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout2;
/** 广告背景*/
@property (nonatomic,strong)UIView *adV;
/** 直播预告*/
@property (nonatomic,strong)UIView *BroadV;
@property (nonatomic,strong)UIScrollView *BroadVS;
/** 直播回顾*/
@property (nonatomic,strong)UIView *backBroadV;
@property (nonatomic,strong)UICollectionView *zbhgV;
/** 正在直播*/
@property (nonatomic,strong)UIView *BroadingV;
@property (nonatomic,strong)UICollectionView *zzzbV;
/** 顶部幻灯片数组*/
@property (nonatomic,strong)NSMutableArray *videoTopArr;
@property (nonatomic,strong)NSMutableArray *titleArr;
/** 直播预告列表数组*/
@property (nonatomic,strong)NSMutableArray *BordingArr;
/** 直播回顾列表数组*/
@property (nonatomic,strong)NSMutableArray *zbhgArr;
/** 正在直播列表数组*/
@property (nonatomic,strong)NSMutableArray *zzzbArr;



@end

@implementation FYTrialBroadcast_ViewController
-(NSMutableArray *)zzzbArr
{
    if (!_zzzbArr) {
        self.zzzbArr = [[NSMutableArray alloc]init];
    }
    return _zzzbArr;
}

-(NSMutableArray *)zbhgArr
{
    if (!_zbhgArr) {
        self.zbhgArr = [[NSMutableArray alloc]init];
    }
    return _zbhgArr;
}

static NSString *const reuseIdentifier1 = @"collectionCell1";
static NSString *const reuseIdentifier2 = @"collectionCell2";

- (NSMutableArray *)BordingArr
{
    if (!_BordingArr) {
        self.BordingArr = [[NSMutableArray alloc]init];
    }
    return _BordingArr;
}
- (NSMutableArray *)videoTopArr
{
    if (!_videoTopArr) {
        self.videoTopArr = [[NSMutableArray alloc]init];
    }
    return _videoTopArr;
}
- (NSMutableArray *)titleArr
{
    if (!_titleArr) {
        self.titleArr = [[NSMutableArray alloc]init];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"庭审直播";
    self.view.backgroundColor = FYColor(230, 230, 238);
    
    //创建右侧按钮
    [self createRightBtn];
    
    //初始化页面
    [self initWithView];
    
    
    
}


#pragma mark 创建右侧按钮
- (void)createRightBtn
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_botton_high"] style:UIBarButtonItemStyleDone target:self action:@selector(clickButtonItem)];
}

- (void)clickButtonItem
{
    FYSearch_ViewController *searchVC = [[FYSearch_ViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 初始化页面
- (void)initWithView
{
    //产品CollectionView
    self.flowLayout =
    [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UIScrollView *bgView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    bgView.backgroundColor = [UIColor clearColor];
    self.bgView = bgView;
    [self.view addSubview:self.bgView];
    
    
    
    
    
    //初始化frame
    //在这里是初始化
    self.adV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 180)];
    UIImageView *adVBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 180)];
    adVBg.image = [UIImage imageNamed:@"placeholder"];
    [self.adV addSubview:adVBg];
    [bgView addSubview:self.adV];
    
    
    
    
    //直播预告
    self.BroadV = [[UIView alloc]initWithFrame:CGRectMake(0, GetMaxY(self.adV.frame)+10, Screen_Width, 130)];
    UIView *titleView = [FYSearchTitle_View initWithTitle:@"直播预告" TipImage:@"arrow_right"];
    [self.BroadV addSubview:titleView];
    self.BroadV.userInteractionEnabled = YES;
    
    UIView *noview = [[UIView alloc]init];
    noview.backgroundColor = [UIColor whiteColor];
    [noview setFrame:CGRectMake(10, 30, Screen_Width - 20, 100)];
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Screen_Width - 20, 100/6)];
    lb.text= @"案件名称：暂无公告";
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont systemFontOfSize:12];
    [noview addSubview:lb];
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 100/6, Screen_Width - 20, 100/6)];
    lb1.text= @"案件号：";
    lb1.textColor = [UIColor grayColor];
    lb1.font = [UIFont systemFontOfSize:12];
    [noview addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 2*100/6, Screen_Width - 20, 100/6)];
    lb2.text= @"审理法院：";
    lb2.textColor = [UIColor grayColor];
    lb2.font = [UIFont systemFontOfSize:12];
    [noview addSubview:lb2];
    
    
    UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 3*100/6, Screen_Width - 20, 100/6)];
    lb3.text= @"主审法官：";
    lb3.textColor = [UIColor grayColor];
    lb3.font = [UIFont systemFontOfSize:12];
    [noview addSubview:lb3];
    
    UILabel *lb4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 4*100/6, Screen_Width - 20, 100/6)];
    lb4.text= @"开庭时间：";
    lb4.textColor = [UIColor grayColor];
    lb4.font = [UIFont systemFontOfSize:12];
    [noview addSubview:lb4];
    
    UILabel *lb5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 5*100/6, Screen_Width - 20, 100/6)];
    lb5.text= @"开庭地点：";
    lb5.textColor = [UIColor grayColor];
    lb5.font = [UIFont systemFontOfSize:12];
    [noview addSubview:lb5];
    [self.BroadV addSubview:noview];
    
    
    
    
    
    UIScrollView *boradSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 130)];
    self.BroadVS = boradSV;
    [self.BroadV addSubview:self.BroadVS];
    //    self.backBroadV.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.BroadV];
    
    
    
    //直播回顾
    self.backBroadV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.BroadV.frame), Screen_Width, 150 + TitleViewH)];
    UIView *backTitleView = [FYSearchTitle_View initWithTitle:@"直播回顾" TipImage:@"arrow_right"];
    [self.backBroadV addSubview:backTitleView];
    self.backBroadV.backgroundColor = [UIColor clearColor];
    self.zbhgV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, TitleViewH, Screen_Width, 150 ) collectionViewLayout:self.flowLayout];
    self.zbhgV.delegate = self;
    self.zbhgV.dataSource = self;
    //注册cell和ReusableView（相当于头部），务必注册，不然Crash
    [self.zbhgV registerClass:[FYBroadColleciton_Cell class]
   forCellWithReuseIdentifier:reuseIdentifier1];
    self.zbhgV.backgroundColor = FYColor(230, 230, 238);
    self.zbhgV.tag = 1;
    [self.backBroadV addSubview:self.zbhgV];
    [self.bgView addSubview:self.backBroadV];
    
    
    //正在直播
    self.BroadingV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backBroadV.frame), Screen_Width, 150 + TitleViewH)];
    UIView *broadingTitleView = [FYSearchTitle_View initWithTitle:@"正在直播" TipImage:@"arrow_right"];
    [self.BroadingV addSubview:broadingTitleView];
    self.BroadingV.backgroundColor = [UIColor clearColor];
    
    UIView *bView = [[UIView alloc]init];
    bView.backgroundColor = [UIColor whiteColor];
    [bView setFrame:CGRectMake(5, 30,  (Screen_Width - 3 * CollectionCellPadding) * 0.5, 140)];
    [self.BroadingV addSubview:bView];
    
    UIImageView *videoImg = [[UIImageView alloc]init];
    videoImg.image = [UIImage imageNamed:@"video_2"];
    [videoImg setFrame:CGRectMake(0, 0, (Screen_Width - 3 * CollectionCellPadding) * 0.5, 140 * 0.55)];
    [bView addSubview:videoImg];
    
    UIView *speView = [[UIView alloc]initWithFrame:CGRectMake(0, videoImg.height - 20, videoImg.width, 20)];
    speView.backgroundColor = [UIColor blackColor];
    speView.alpha = 0.3;
    [videoImg addSubview:speView];
    
    UILabel *ajlbLb  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, speView.width, speView.height)];
    ajlbLb.font = [UIFont systemFontOfSize:12];
    ajlbLb.textColor = [UIColor whiteColor];
    ajlbLb.text = @"";
    [speView addSubview:ajlbLb];
    
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(10, GetMaxY(videoImg.frame)+5, videoImg.width, 20)];
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.text = @"暂无回顾";
    titleLb.font = [UIFont systemFontOfSize:14];
    [bView addSubview:titleLb];
    
//    self.textLb = [[UILabel alloc]initWithFrame:CGRectMake(10, GetMaxY(self.titleLb.frame)+5, CellWidth*0.7, 30)];
//    self.textLb.numberOfLines = 0;
//    self.textLb.textAlignment = NSTextAlignmentLeft;
//    self.textLb.font = [UIFont systemFontOfSize:12];
//    self.textLb.text = @"";
//    [self addSubview:self.textLb];

//    self.BroadingV.backgroundColor = [UIColor clearColor];
//    self.zzzbV =[[UICollectionView alloc]initWithFrame:CGRectMake(0, TitleViewH, Screen_Width, 150 ) collectionViewLayout:self.flowLayout];
//    self.zzzbV.delegate = self;
//    self.zzzbV.dataSource = self;
//    [self.zzzbV registerClass:[FYBroadColleciton_Cell class]
//   forCellWithReuseIdentifier:reuseIdentifier2];
//    self.zzzbV.backgroundColor = FYColor(230, 230, 238);
    
    
    [self.BroadingV addSubview:self.zzzbV];
    [self.bgView addSubview:self.BroadingV];
    
    
    //    //设置尺寸
    self.bgView.contentSize = CGSizeMake(Screen_Width,CGRectGetMaxY(self.BroadingV.frame)+64);
    
    [self getRequest];
    
}


- (void)getRequest
{
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId = [defaults objectForKey:@"countId"];
    if ([NSString isBlankString:countId]) {
        countId = @"0";
    }
//    int needCountId = [countId intValue] + 1;
    
    int needCountId = [countId intValue];
    
    paras[@"courtId"] = @(needCountId);
    FYLog(@"参数:%@",paras);
    
    //获取“庭审直播”页面顶部幻灯片列表
    [self getTszbWithString:@"app/zb!getSlideListAjax.action" AndPara:paras];
    //获取直播预告列表
    [self getZbygWithString:@"app/zb!getTrailerListAjax.action" AndPara:paras];
    //直播回顾列表
    [self getZbhgWithString:@"app/zb!getVideoListAjax.action" AndPara:paras];
    //正在直播列表
    [self getZzzbWithString:@"app/zb!getLiveListAjax.action" AndPara:paras];
    
}

#pragma mark 庭审直播获取
- (void)getTszbWithString:(NSString *)url AndPara:(NSDictionary *)params
{
    [FSHttpTool post:url params:params success:^(id json) {
        NSDictionary *result = (NSDictionary *)json;
        NSLog(@"直播获取的结果是%@",result);
        if (![[NSNull null] isEqual:[result objectForKey:@"attach"]]) {
            NSArray *attachArr = [result objectForKey:@"attach"];
            for (int i = 0; i < attachArr.count; i ++) {
                Attach *attach = [Attach objectWithKeyValues:attachArr[i]];
                [self.videoTopArr addObject:attach];
                if (i == attachArr.count -1) {
                    [self reSetScrollView];
                }
            }
        }
    } failure:^(NSError *error) {
        FYLog(@"报错信息%@",error);
    }];
}
#pragma mark 直播回顾列表
- (void)getZbhgWithString:(NSString *)url AndPara:(NSDictionary *)params
{
    [FSHttpTool post:url params:params success:^(id json) {
        NSDictionary *result = (NSDictionary *)json;
        NSLog(@"回顾获取的结果是:%@",result);
        if (![[NSNull null] isEqual:[result objectForKey:@"attach"]]) {
            NSArray *attachArr = [result objectForKey:@"attach"];
            for (int i = 0; i < attachArr.count; i ++) {
                Attach *attach = [Attach objectWithKeyValues:attachArr[i]];
                
                [self.zbhgArr addObject:attach];
                if (i == attachArr.count -1) {
                    [self reSetZbhgV];
                }
            }
        }
    } failure:^(NSError *error) {
        FYLog(@"报错信息%@",error);
    }];
}
#pragma mark 直播预告列表
- (void)getZbygWithString:(NSString *)url AndPara:(NSDictionary *)params
{
    [FSHttpTool post:url params:params success:^(id json) {
        NSDictionary *result = (NSDictionary *)json;
        NSLog(@"直播预告结果:%@ -----",result);
        if (![[NSNull null] isEqual:[result objectForKey:@"attach"]]) {
            NSArray *attachArr = [result objectForKey:@"attach"];
            for (int i = 0; i < attachArr.count; i ++) {
                Attach *attach = [Attach objectWithKeyValues:attachArr[i]];
                [self.BordingArr addObject:attach];
                if (i == attachArr.count -1) {
                    [self reSetBoardingV];
                }
            }
        }
        
    } failure:^(NSError *error) {
        FYLog(@"报错信息%@",error);
    }];
}
#pragma mark 正在直播
- (void)getZzzbWithString:(NSString *)url AndPara:(NSDictionary *)params
{
    [FSHttpTool post:url params:params success:^(id json) {
        NSDictionary *result = (NSDictionary *)json;
        NSLog(@"正在直播列表的数据%@",json);
        
        if (![[NSNull null] isEqual:[result objectForKey:@"attach"]]) {
            NSArray *attachArr = [result objectForKey:@"attach"];
            for (int i = 0; i < attachArr.count; i ++) {
                Attach *attach = [Attach objectWithKeyValues:attachArr[i]];
                [self.zzzbArr addObject:attach];
                if (i == attachArr.count -1) {
                    [self resetZzzbV];
                }
            }
        }
        
        
        
    } failure:^(NSError *error) {
        FYLog(@"报错信息%@",error);
    }];
}

#pragma mark 重设广告页面
- (void)reSetScrollView
{
    
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *titleArr = [NSMutableArray array];
    //创建内容的View
    for (int i = 0; i <self.videoTopArr.count; ++i) {
        Attach *attach = self.videoTopArr[i];
        [imageArr addObject:attach.image];
        [titleArr addObject:attach.name];
    }
    
    
    //    //在这里是初始化
    //网络加载 --- 创建带标题的图片轮播器
    self.mainScorllView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, 180) imageURLStringsGroup:imageArr]; // 模拟网络延时情景
    self.mainScorllView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.mainScorllView.delegate = self;
    self.mainScorllView.titlesGroup = titleArr;
    self.mainScorllView.titleLabelTextFont = [UIFont systemFontOfSize:13];
    self.mainScorllView.titleLabelHeight = 20;
    self.mainScorllView.titleLabelBackgroundColor = [UIColor clearColor];
    self.mainScorllView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.mainScorllView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.mainScorllView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.adV addSubview:self.mainScorllView];
    
}



#pragma mark 重设直播预告页面
- (void)reSetBoardingV
{
    self.BroadVS.contentSize = CGSizeMake(Screen_Width *self.BordingArr.count, 100);
    self.BroadVS.scrollEnabled = YES;
    self.BroadVS.showsHorizontalScrollIndicator = YES;
    self.BroadVS.showsVerticalScrollIndicator = YES;
    
    for (int i = 0; i < self.BordingArr.count; i ++) {
        FYBoradingView *boardingV = [[FYBoradingView alloc]initWithFrame:CGRectMake(i * Screen_Width, TitleViewH, Screen_Width, 100)];
        boardingV.attach = self.BordingArr[i];
        [self.BroadVS addSubview:boardingV];
    }
    
}

#pragma mark重设正在直播页面
- (void)resetZzzbV
{
    
    
    
    
}

#pragma mark 重设直播回顾页面
- (void)reSetZbhgV
{
    int height = 0;
    
    //计算直播回顾背景的高度
    height =(int) ((self.zbhgArr.count % 2) ? self.zbhgArr.count*75 +150 : self.zbhgArr.count*75 );
    self.backBroadV.size = CGSizeMake(Screen_Width, height);
    self.zbhgV.size = CGSizeMake(Screen_Width, height);
    self.zbhgV.backgroundColor = [UIColor clearColor];
    [self.zbhgV reloadData];
    
    
    //重设正在直播的View
    [self.BroadingV setY:CGRectGetMaxY(self.backBroadV.frame)+TitleViewH];
    //设置尺寸
    self.bgView.contentSize = CGSizeMake(Screen_Width,CGRectGetMaxY(self.BroadingV.frame)+64);
    
    [self.zbhgV reloadData];
}



#pragma mark collectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    if (self.zbhgArr.count == 0) {
        return 1;
    }else
     
        return self.zbhgArr.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView == self.zbhgV) {
        FYBroadColleciton_Cell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1
                                                  forIndexPath:indexPath];
        if (self.zbhgArr.count > 0) {
            cell.attach = self.zbhgArr[indexPath.row];
        }
        return cell;
    }
    else{
        FYBroadColleciton_Cell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2
                                                  forIndexPath:indexPath];
        if (self.zzzbArr.count > 0) {
            cell.attach = self.zzzbArr[indexPath.row];
        }
        return cell;
    }
    
}

#pragma mark-------- UICollectionView Delegate -------------

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((Screen_Width - 3 * CollectionCellPadding) * 0.5,
                      150-10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)
collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)
collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    CGFloat padding = CollectionCellPadding;
    return UIEdgeInsetsMake(padding, padding, padding, padding);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.zbhgArr.count == 0) {
        return;
    }
    FYWebViewController *webView = [[FYWebViewController alloc]init];
    Attach *attach = self.zbhgArr[indexPath.row];

    webView.Title = attach.name;
    webView.url = attach.url;
        [self.navigationController pushViewController:webView animated:YES];
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    Attach *attach = [self.videoTopArr objectAtIndex:index];
    FYWebViewController *web = [[FYWebViewController alloc] init];
    web.Title = attach.name;
    web.url = attach.url;
    [self.navigationController pushViewController:web animated:YES];
    
}



@end
