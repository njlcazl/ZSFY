//
//  SDAddItemViewController.m
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-7.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 *********************************************************************************
 */

#import "SDAddItemViewController.h"
#import "SDAddItemGridView.h"
#import "SDHomeGridItemModel.h"
#import "MianView.h"
#import "BNMainCell.h"
#import "ItemInfo.h"
#import "DBManager.h"

//设备屏幕的高度、宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//如果当前系统版本小于v返回YES，否则返回no
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//判断当前的系统是否小于IOS8  !SYSTEM_VERSION_LESS_THAN(@"8.0")意思是当前版本大于8.0
#define isIOS8 !SYSTEM_VERSION_LESS_THAN(@"8.0")

@interface SDAddItemViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
//    SDAddItemGridView *mainView;
    MianView *_mianView;
    NSInteger selectTag;
    
    //标题
    NSMutableArray *_muRemoveDataArray;
    //图片
    NSMutableArray *_muRemoveIconDataArray;
    DBManager *_dbManager;
}

@property (nonatomic, weak) SDAddItemGridView *mainView;
//刷数据用的数据源
@property (nonatomic, copy) NSMutableArray *dataArray;
//移除后存放的数据源
@property (nonatomic, copy) NSMutableArray *removeDataArray;
@end

@implementation SDAddItemViewController

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void)createData
{
    _dbManager = [DBManager sharedInstace];
    _dataArray = [[NSMutableArray alloc] init];
    _removeDataArray = [[NSMutableArray alloc] init];

    NSArray *dicArr1 = @[@{@"Title":@"网上立案",@"Icon":@"i00.png"},@{@"Title":@"网上阅卷",@"Icon":@"i01.png"}];
    
    NSArray *dicArr2 = @[@{@"Title":@"网上立案",@"Icon":@"i00.png"},@{@"Title":@"网上阅卷",@"Icon":@"i01.png"},@{@"Title":@"一卡通",@"Icon":@"i02.png"},@{@"Title":@"工作台历",@"Icon":@"i03.png"}];
    
    NSArray *dicArr3 = @[@{@"Title":@"网上立案",@"Icon":@"i00.png"},@{@"Title":@"网上阅卷",@"Icon":@"i01.png"},@{@"Title":@"工作台历",@"Icon":@"i03.png"},@{@"Title":@"院内通知",@"Icon":@"i04.png"},@{@"Title":@"通信录",@"Icon":@"i05.png"}];
    
    //角色1
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] intValue] == 0)
    {
        _removeDataArray = [NSMutableArray arrayWithArray:[_dbManager getAllModel:[[ItemInfo alloc] init]]];
        for(int i = 0;i < dicArr1.count;i ++)
        {
            ItemInfo *itemInfo = [[ItemInfo alloc] init];
            [itemInfo setValuesForKeysWithDictionary:dicArr1[i]];
            [_dataArray addObject:itemInfo];
            for(int  i = 0;i < _removeDataArray.count;i ++)
            {
                ItemInfo *info = [_removeDataArray objectAtIndex:i];
                if([itemInfo.Title isEqualToString:info.Title])
                {
                    [_dataArray removeObject:itemInfo];
                }
            }
        }
    }
    //角色2
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] intValue] == 1)
    {
        _removeDataArray = [NSMutableArray arrayWithArray:[_dbManager getAllModel:[[ItemInfo alloc] init]]];
        for(int i = 0;i < dicArr2.count;i ++)
        {
            ItemInfo *itemInfo = [[ItemInfo alloc] init];
            [itemInfo setValuesForKeysWithDictionary:dicArr2[i]];
            [_dataArray addObject:itemInfo];
            for(int  i = 0;i < _removeDataArray.count;i ++)
            {
                ItemInfo *info = [_removeDataArray objectAtIndex:i];
                if([itemInfo.Title isEqualToString:info.Title])
                {
                    [_dataArray removeObject:itemInfo];
                }
            }
        }
    }
    //角色3
    else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] intValue] == 2)
    {
        _removeDataArray = [NSMutableArray arrayWithArray:[_dbManager getAllModel:[[ItemInfo alloc] init]]];
        for(int i = 0;i < dicArr3.count;i ++)
        {
            ItemInfo *itemInfo = [[ItemInfo alloc] init];
            [itemInfo setValuesForKeysWithDictionary:dicArr3[i]];
            [_dataArray addObject:itemInfo];
            for(int  i = 0;i < _removeDataArray.count;i ++)
            {
                ItemInfo *info = [_removeDataArray objectAtIndex:i];
                if([itemInfo.Title isEqualToString:info.Title])
                {
                    [_dataArray removeObject:itemInfo];
                }
            }
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createData];
    
    [self createUI];
}


- (void)createUI
{
    _mianView = [[MianView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_mianView];
    
    _mianView.collectionView.dataSource = self;
    _mianView.collectionView.delegate = self;
    _mianView.collectionView.alwaysBounceVertical = YES;
    
    //单元格的注册
    [_mianView.collectionView registerNib:[UINib nibWithNibName:@"BNMainCell" bundle:nil] forCellWithReuseIdentifier:@"identifier"];
}

//单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
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

//创建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BNMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    ItemInfo *info;
    if(self.dataArray.count > indexPath.row)
    {
        info = self.dataArray[indexPath.row];
    }
    
    cell.iconImgView.frame = CGRectMake((Screen_Width/3 - (Screen_Width/3)/3)/2 , 6 + ((Screen_Width/3)/2 - (Screen_Width/3)/3)/2, (Screen_Width/3)/3, (Screen_Width/3)/3);

    cell.iconImgView.image = [UIImage imageNamed:info.Icon];
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth=0.1;
    cell.tag = indexPath.row;
    cell.titleLabel.text = info.Title;
    cell.selected = NO;
    
    return cell;
}

#pragma marm 单元格点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemInfo *item = [[ItemInfo alloc] init];
    item = _dataArray[indexPath.row];
    [_removeDataArray addObject:item];
    for(int  i = 0;i < _removeDataArray.count;i ++)
    {
        ItemInfo *info = [[ItemInfo alloc] init];
        info = _removeDataArray[i];
        if(![_dbManager insertOrUpdateModel:info])
        {
            [_dbManager insertOrUpdateModel:info];
        }
    }
    //移除数组里面的某个元素
    [_dataArray removeObjectAtIndex:indexPath.row];
    [collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(_IconBlock)
        {
            _IconBlock(@"Icon");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
