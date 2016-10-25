//
//  FYHomeViewController.m
//  zsfy
//
//  Created by pyj on 15/11/9.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYHomeViewController.h"

#import "CTB.h"
#import "CourtBook_ViewController.h"
#import "TrialOpen_ViewController.h"
#import "NewsCenter_ViewController.h"
#import "Questionnaire_ViewController.h"
#import "Filing_ViewController.h"
#import "Litigation_ViewController.h"
#import "Notice_ViewController.h"
#import "FYTrialBroadcast_ViewController.h"
#import "Execute_ViewController.h"
#import "FYWebViewController.h"
#import "SDAddItemViewController.h"

#import "CCAdsPlayView.h"
#import "SDCycleScrollView.h"
#import "ZYGbLitigationViewController.h"

#import "MianView.h"
#import "BNMainCell.h"
#import "DBManager.h"
#import "ItemInfo.h"



//设备屏幕的高度、宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//如果当前系统版本小于v返回YES，否则返回no
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//判断当前的系统是否小于IOS8  !SYSTEM_VERSION_LESS_THAN(@"8.0")意思是当前版本大于8.0
#define isIOS8 !SYSTEM_VERSION_LESS_THAN(@"8.0")


@interface FYHomeViewController ()<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    UIPageControl *pageCtrl;
    
    MianView *_mainView;
    
    NSInteger selectTag;
    
    //要显示的数据源
    NSMutableArray *_muShowDataArray;
    //数据库操作
    DBManager *_dbManager;
}

@property (nonatomic , strong) SDCycleScrollView *mainScorllView;
/** 广告背景*/
@property (nonatomic,strong)UIView *adV;
/** 存放图片的数组*/
@property (nonatomic,strong)NSMutableArray *ImageArr;
/** 存放文字的数组*/
@property (nonatomic,strong)NSMutableArray *TitleArr;


/** 轮播所有的数组*/
@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)NSString *isInit;
@property (nonatomic,strong)NSString *saveCountId;

@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation FYHomeViewController


- (NSMutableArray *)ImageArr
{
    if (!_ImageArr) {
        self.ImageArr = [NSMutableArray array];
    }
    return _ImageArr;
}
- (NSMutableArray *)listArr
{
    if (!_listArr) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}
- (NSMutableArray *)TitleArr
{
    if (!_TitleArr) {
        self.TitleArr = [NSMutableArray array];
    }
    return _TitleArr;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        [self createData];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(![NSString isBlankString:self.isInit])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *countId = [defaults objectForKey:@"countId"];
        if (![self.saveCountId isEqualToString:countId]) {
            [self.listArr removeAllObjects];
            [self.ImageArr removeAllObjects];
            [self.mainScorllView removeFromSuperview];
            self.mainScorllView = nil;
            [self getDataRequest];
        }
    }
}

//各种数据类型初始化
- (void)createData
{
    _dataArray = [[NSMutableArray alloc] init];
    _dbManager = [DBManager sharedInstace];
    _muShowDataArray =[NSMutableArray array];
    
    NSArray *muShowDataArray = @[@{@"Title":@"审务公开",@"Icon":@"01"},@{@"Title":@"裁判文书",@"Icon":@"02"},@{@"Title":@"执行在线",@"Icon":@"03"},@{@"Title":@"诉讼中心",@"Icon":@"04"},@{@"Title":@"审务导航",@"Icon":@"05"},@{@"Title":@"新闻中心",@"Icon":@"06"},@{@"Title":@"法院公告",@"Icon":@"07"},@{@"Title":@"庭审直播",@"Icon":@"08"},@{@"Title":@"更多",@"Icon":@"09"}];
    
    for(int i = 0;i < muShowDataArray.count;i ++)
    {
        ItemInfo *itemInfo = [[ItemInfo alloc] init];
        [itemInfo setValuesForKeysWithDictionary:muShowDataArray[i]];
        [_muShowDataArray addObject:itemInfo];
    }
    
//    NSLog(@"======>%ld",[_dbManager getAllModel:[[ItemInfoss alloc]init]].count);
   if([_dbManager getAllModel:[[ItemInfo alloc]init]].count)
   {
       _dataArray = [NSMutableArray arrayWithArray:[_dbManager getAllModel:[[ItemInfo alloc] init]]];
       for(int i= 0 ; i < _dataArray.count; i++)
       {
           ItemInfo *info = _dataArray[i];
           [_muShowDataArray insertObject:info atIndex:_muShowDataArray.count-1];
           [_mainView.collectionView reloadData];
       }
   }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"掌上法院";
    self.isInit = @"1";
    
    [self createUI];
}

- (void)createUI
{
    _mainView = [[MianView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    [self.view addSubview:_mainView];
    
    _mainView.collectionView.dataSource = self;
    _mainView.collectionView.delegate = self;
    _mainView.collectionView.alwaysBounceVertical = YES;
    
    //单元格的注册
    [_mainView.collectionView registerNib:[UINib nibWithNibName:@"BNMainCell" bundle:nil] forCellWithReuseIdentifier:@"identifier"];
    
    //组头注册
    [_mainView.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier"];
}


#pragma mark ======================== 各种代理方法 =========================
#pragma mark - UICollectionDataSource
//单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _muShowDataArray.count;
}

//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//单元格的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/3, 100);
}

//组头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 180);
}

#pragma mark - UICollectionViewDelegate
//创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BNMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    ItemInfo *info = [_muShowDataArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    //icon 图标
    cell.iconImgView.image = [UIImage imageNamed:info.Icon];
    
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.1;
    cell.tag = indexPath.row;
    //标题
    cell.titleLabel.text = info.Title;
    cell.selected = NO;
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGR.minimumPressDuration = 1.0;
    
    if([cell.titleLabel.text isEqualToString:@"更多"] || [cell.titleLabel.text isEqualToString:@"审务公开"] || [cell.titleLabel.text isEqualToString:@"裁判文书"] || [cell.titleLabel.text isEqualToString:@"执行在线"] || [cell.titleLabel.text isEqualToString:@"诉讼中心"] || [cell.titleLabel.text isEqualToString:@"审务导航"] || [cell.titleLabel.text isEqualToString:@"新闻中心"] || [cell.titleLabel.text isEqualToString:@"法院公告"] || [cell.titleLabel.text isEqualToString:@"庭审直播"])
    {
        cell.iconImgView.frame = CGRectMake((Screen_Width/3 - (Screen_Width/3)/2)/2 , 6, (Screen_Width/3)/2, (Screen_Width/3)/2);
        [cell removeGestureRecognizer:longPressGR];
    }
    else
    {
        cell.iconImgView.frame = CGRectMake((Screen_Width/3 - (Screen_Width/3)/3)/2 , 6 + ((Screen_Width/3)/2 - (Screen_Width/3)/3)/2, (Screen_Width/3)/3, (Screen_Width/3)/3);
        [cell addGestureRecognizer:longPressGR];
    }
    
    return cell;
}

#pragma mark 组头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerIdentifier" forIndexPath:indexPath];
    self.adV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 180)];
    UIImageView *adVBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 180)];
    adVBg.image = [UIImage imageNamed:@"placeholder"];
    [self.adV addSubview:adVBg];
    [reusableView addSubview:self.adV];
    return reusableView;
}

#pragma mark 网络请求数据
- (void)getDataRequest
{
    //if (self.ImageArr.count > 0 ) return;
    NSDictionary *paras = [NSDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId = [defaults objectForKey:@"countId"];
    self.saveCountId = countId;
    int needCountId;
    if ([NSString isBlankString:countId]) {
        countId = @"0";
        
        needCountId = [countId intValue] + 1;
    }
    else
    {
        needCountId = [countId intValue];
    }
    
    paras = @{@"courtId":@(needCountId),@"categoryId":@2,@"rowSize":@10};
    [self.TitleArr removeAllObjects];
    [self.ImageArr removeAllObjects];
    [self.listArr removeAllObjects];
    
    FYLog(@"参数:%@",paras);
    [FSHttpTool post:@"app/article!listAjax.action" params:paras success:^(id json) {
        NSLog(@"%@",json);
        NSDictionary *result = (NSDictionary *)json;
        
        NSArray *attachArr = [result objectForKey:@"attach"];
        if (attachArr.count >= 1) {
            for (int i = 0; i < attachArr.count; i ++) {
                [self.listArr addObject:attachArr[i]];
            }
            for (int i = 0; i < attachArr.count; i ++) {
                NSDictionary *detail = attachArr[i];
                NSString *imgUrl = [detail objectForKey:@"titleImg"];
                NSString *title = [detail objectForKey:@"title"];
                [self.TitleArr addObject:title];
                [self.ImageArr addObject:imgUrl];
            }
        }
        if (attachArr.count) {
            [self reSetAdV];
        }
    } failure:^(NSError *error) {
        FYLog(@"报错信息%@",error);
    }];
}


#pragma mark 重设广告页面
- (void)reSetAdV
{
    //    //在这里是初始化
    NSLog(@"图片数组的内容是:%@ --- %@",self.ImageArr,self.TitleArr);
    //网络加载 --- 创建带标题的图片轮播器
    self.mainScorllView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, 180) imageURLStringsGroup:self.ImageArr]; // 模拟网络延时情景
    self.mainScorllView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.mainScorllView.delegate = self;
    self.mainScorllView.titlesGroup = self.TitleArr;
    self.mainScorllView.titleLabelTextFont = [UIFont systemFontOfSize:13];
    self.mainScorllView.titleLabelHeight = 20;
    self.mainScorllView.titleLabelBackgroundColor = [UIColor clearColor];
    self.mainScorllView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
   self.mainScorllView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.mainScorllView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.adV addSubview:self.mainScorllView];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dic = [_listArr objectAtIndex:index];
    FYWebViewController *web = [[FYWebViewController alloc] init];
    web.Title = @"新闻详情";
//    [dic objectForKey:@"title"];
    web.url = [dic objectForKey:@"url"];
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
    NSLog(@"%f",offset.x / bounds.size.width);
}

#pragma marm 单元格点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        //审务公开
        TrialOpen_ViewController *trial = [[TrialOpen_ViewController alloc] init];
        [self.navigationController pushViewController:trial animated:YES];
    }
    else if (indexPath.row == 1)
    {
        //裁判文书
        CourtBook_ViewController *court = [[CourtBook_ViewController alloc] init];
        [self.navigationController pushViewController:court animated:YES];
    }
    else if (indexPath.row == 2)
    {
        //执行在线
        Execute_ViewController *exe = [[Execute_ViewController alloc] init];
        [self.navigationController pushViewController:exe animated:YES];
    }
    else if (indexPath.row == 3)
    {
        //诉讼中心
        ZYGbLitigationViewController *litigation = [[ZYGbLitigationViewController alloc] init];
        [self.navigationController pushViewController:litigation animated:YES];
    }
    else if (indexPath.row == 4)
    {
        //审务导航
        FYWebViewController *webView = [[FYWebViewController alloc]init];
        
        webView.Title = @"审务导航";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *countId = [defaults objectForKey:@"countId"];
        int needCountId;
        if ([NSString isBlankString:countId]) {
            countId = @"0";
            needCountId = [countId intValue] + 1;

        } else {
            needCountId = [countId intValue];
        }
        
        if(needCountId == 1)
        {
            //广州铁路运输中级法院
            NSString *url = @"http://183.63.189.107/PalmCourt/3D/index.html";
            webView.url = url;
            [self.navigationController pushViewController:webView animated:YES];
            
        }else if (needCountId == 2)
        {
            //广州铁路运输法院
//            NSString *url = @"http://map.baidu.com/mobile/webapp/walk/list/qt=walk&sn=1$$b60d691683bbc5cef02d83e3$$12614156.64,2631111.90$$%E6%9D%A8%E7%AE%95%E5%9C%B0%E9%93%81%E7%AB%99-F%E5%8F%A3$$&en=1$$8e0bea5c8dfce1f26c47604b$$12613980.00,2631013.00$$%E5%B9%BF%E5%B7%9E%E5%B8%82%E9%93%81%E8%B7%AF%E8%BF%90%E8%BE%93%E6%B3%95%E9%99%A2$$&sc=257&ec=257&c=257&pn=0&rn=5&searchFlag=transit&version=3&wm=1/foo=bar&vt=map";
            NSString *url = @"http://183.63.189.107/PalmCourt/3D/index3.html";
            webView.url = url;
            [self.navigationController pushViewController:webView animated:YES];
        }else
        {
            //肇庆
//            NSString *url = @"http://map.baidu.com/mobile/webapp/walk/list/qt=walk&sn=1%24%24ceb25e5793cf53aa7adbd280%24%2412518514.70%2C2625655.00%24%24%E8%82%87%E5%BA%86%E7%81%AB%E8%BD%A6%E7%AB%99%24%24&en=1%24%240f14629c672f71720d0e6bd1%24%2412518351.40%2C2625892.00%24%24%E8%82%87%E5%BA%86%E9%93%81%E8%B7%AF%E8%BF%90%E8%BE%93%E6%B3%95%E9%99%A2%24%24&sc=338&ec=338&c=338&pn=0&rn=5&searchFlag=transit&version=3&wm=1/foo=bar&vt=map";
            NSString *url = @"http://183.63.189.107/PalmCourt/3D/index2.html";
            webView.url = url;
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
    else if (indexPath.row == 5)
    {
        //新闻中心
        NewsCenter_ViewController *new = [[NewsCenter_ViewController alloc] init];
        [self.navigationController pushViewController:new animated:YES];
    }
    else if (indexPath.row == 6)
    {
        //法院公告
        Notice_ViewController *notice = [[Notice_ViewController alloc] init];
        [self.navigationController pushViewController:notice animated:YES];
    }
    else if(indexPath.row == 7)
    {
        //庭审直播
        FYTrialBroadcast_ViewController *broadcast = [[FYTrialBroadcast_ViewController alloc]init];
        [self.navigationController pushViewController:broadcast animated:YES];
    }
    else if(indexPath.row == _muShowDataArray.count - 1)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId  =  [userDefault objectForKey:@"user_id"];
        NSLog(@"userId  is %@",userId);
        if(![NSString isBlankString:userId] )
        {
            SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
            addVc.title = @"更多";
            addVc.IconBlock = ^(NSString *sender)
            {
                if([_dbManager getAllModel:[[ItemInfo alloc]init]].count)
                {
                    [_dataArray removeAllObjects];
                    _dataArray = [NSMutableArray arrayWithArray:[_dbManager getAllModel:[[ItemInfo alloc] init]]];
                    
                    NSRange range = {8,_muShowDataArray.count-8};
                    [_muShowDataArray removeObjectsInRange:range];
                    for(int i= 0 ; i < self.dataArray.count; i++)
                    {
                        ItemInfo *info = _dataArray[i];
                        [_muShowDataArray addObject:info];
                    }
                    ItemInfo *infof = [[ItemInfo alloc] init];
                    infof.Title = @"更多";
                    infof.Icon = @"09";
                    [_muShowDataArray addObject:infof];
                    [_mainView.collectionView reloadData];
                }
            };
            
            [self.navigationController pushViewController:addVc animated:YES];
        }else
        {
            [MBProgressHUD showSuccess:@"用户未登录"];
        }
    }
    else
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userId  =  [userDefault objectForKey:@"user_id"];
        if(![NSString isBlankString:userId] )
        {
            [MBProgressHUD showSuccess:@"正在开发，敬请期待"];
        }
        else
        {
            [MBProgressHUD showSuccess:@"用户未登录"];
        }
    }
}

- (void)longPressToDo:(UILongPressGestureRecognizer *)tap
{
    selectTag = tap.view.tag;
    __weak typeof(self) weakSelf = self;
    //手势开始
    if (tap.state == UIGestureRecognizerStateBegan)
    {
        if(isIOS8)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定需要移除此项 ？" preferredStyle:UIAlertControllerStyleAlert];
            //显示弹出窗
            [weakSelf presentViewController:alertController animated:YES completion:nil];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                           {
          //长按手势点击事件====================================
                                              
                                               ItemInfo *info = [_muShowDataArray objectAtIndex:selectTag];
                                               for(int i = 0;i < _dataArray.count;i ++)
                                               {
                                                   ItemInfo *itemInfo = [[ItemInfo alloc] init];
                                                   itemInfo = [_dataArray objectAtIndex:i];
                                                   if([itemInfo.Title isEqualToString:info.Title])
                                                   {
                                                       if([_dbManager deleteModel:itemInfo andIsWhereId:YES])
                                                       {
                                                           [_muShowDataArray removeObjectAtIndex:selectTag];
                                                           [_mainView.collectionView reloadData];
                                                       }
                                                   }
                                               }
                                               
                                           }];
            [alertController addAction:sureAction];
            [alertController addAction:cancelAction];
        }
        else
        {
            UIAlertView *alertVc = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定需要移除此项 ？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertVc.delegate = self;
            [alertVc show];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        ItemInfo *info = [_muShowDataArray objectAtIndex:selectTag];
        
        for(int i = 0;i < _dataArray.count;i ++)
        {
            ItemInfo *itemInfo = [[ItemInfo alloc] init];
            itemInfo = [_dataArray objectAtIndex:i];
            if([itemInfo.Title isEqualToString:info.Title])
            {
                //                    [_dataArray removeObjectAtIndex:i];
//                NSLog(@"%d",[_dbManager insertOrUpdateModel:itemInfo]);
                if([_dbManager deleteModel:itemInfo andIsWhereId:YES])
                {
                    [_muShowDataArray removeObjectAtIndex:selectTag];
                    [_mainView.collectionView reloadData];
                }
            }
        }
    }
}





@end
