//
//  FYSearch_ViewController.m
//  zsfy
//
//  Created by pyj on 15/11/16.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import "FYSearch_ViewController.h"
#import "FYBroadColleciton_Cell.h"
#import "FYZbhgViewController.h"
#import "MJExtension.h"
#define CollectionCellPadding 5

@interface FYSearch_ViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>


//CollectionView的布局
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
/** 列表数组*/
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong)UICollectionView *myCollectionView;
@property (nonatomic,assign)int pageNo;
@property (nonatomic,assign)int SumPage;

@property (nonatomic,strong)UIActivityIndicatorView *juhuaView;
@property (nonatomic,strong)UISearchBar *mySearchBar;
@end

@implementation FYSearch_ViewController

-(NSMutableArray *)listArr
{
    if (!_listArr) {
        self.listArr = [[NSMutableArray alloc]init];
    }
    return _listArr;
}
static NSString *const reuseIdentifier = @"collectionCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"视频搜索";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initWithView];
}

- (void)initWithView
{
    //产品CollectionView
    self.flowLayout =
    [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.mySearchBar = [[UISearchBar alloc]init];
    self.mySearchBar.placeholder = @"案件号/案由/当事人/法官";
    self.mySearchBar.frame = CGRectMake(0, 0, Screen_Width, 44);
    self.mySearchBar.delegate = self;
    [self.view addSubview:self.mySearchBar];
    
    self.myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, Screen_Width, Screen_Height-64-44) collectionViewLayout:self.flowLayout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = FYColor(230, 230, 238);
    [self.myCollectionView registerClass:[FYBroadColleciton_Cell class]
              forCellWithReuseIdentifier:reuseIdentifier];
    self.myCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMore)];
    //    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myCollectionView];
    self.pageNo = 1;
    [self getRequestWithPage:self.pageNo andText:@""];
    
}


- (void)getRequestWithPage:(NSInteger)pageNo andText:(NSString *)text
{
    //    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //    testActivityIndicator.center = CGPointMake(100.0f, 100.0f);//只能设置中心，不能设置大小
    //    [testActivityIndicator setFrame:CGRectMake((Screen_Width-100)*0.5, (Screen_Height-100)*0.5, 100, 100)];//不建议这样设置，因为UIActivityIndicatorView是不能改变大小只能改变位置，这样设置得到的结果是控件的中心在（100，100）上，而不是和其他控件的frame一样左上角在（100， 100）长为100，宽为100.
    //    [self.myCollectionView addSubview:testActivityIndicator];
    //    testActivityIndicator.color = [UIColor whiteColor]; // 改变圈圈的颜色为红色； iOS5引入
    //    self.juhuaView = testActivityIndicator;
    //    [self.juhuaView startAnimating]; // 开始旋转
    NSMutableDictionary *paras = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *countId = [defaults objectForKey:@"countId"];
    if ([NSString isBlankString:countId]) {
        countId = @"0";
    }
    int needCountId = [countId intValue];
    paras[@"courtId"] = @(needCountId);
    paras[@"pageNo"] = @(pageNo);
    paras[@"rowSize"] = @10;
    paras[@"ah"] = text;
    paras[@"ay"] = text;
    paras[@"dsrmc"] = text;
    paras[@"fgmc"] = text;
    NSLog(@"参数:%@",paras);
    [self urlString:@"app/zb!searchAjax.action" AndPara:paras];
}

- (void)addMore
{
    self.pageNo ++;
    if (self.pageNo > self.SumPage) {
        [MBProgressHUD showError:@"没有更多数据了" toView:self.myCollectionView];
        [self.myCollectionView.footer endRefreshing];
    }else
    {
        [self getRequestWithPage:self.pageNo andText:self.mySearchBar.text];
    }
    
    
}

#pragma mark 视频搜索
- (void)urlString:(NSString *)url AndPara:(NSDictionary *)params
{
    [MBProgressHUD showMessage:@""];
    [FSHttpTool post:url params:params success:^(id json) {
        [self.myCollectionView.footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSDictionary *result = (NSDictionary *)json;
        NSLog(@"视频搜索的dict is %@",result);
        NSDictionary *attachDict = [result objectForKey:@"attach"];
        if ([attachDict isEqual:[NSNull null]]) {
            return ;
        }
        NSArray *listArr = [attachDict objectForKey:@"list"];
        self.SumPage = [[attachDict objectForKey:@"pageCount"] intValue];
        NSLog(@"视频数组:%@",listArr);
        
        for (int i = 0; i < listArr.count; i ++) {
            Attach *attach = [Attach objectWithKeyValues:listArr[i]];
            
            [self.listArr addObject:attach];
//            if(i == listArr.count - 1)
//            {
//               
//                [self.juhuaView stopAnimating]; // 结束旋转
//                [self.juhuaView setHidesWhenStopped:YES]; //当旋转结束时隐藏
//            }
        }
         [self.myCollectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.myCollectionView.footer endRefreshing];
        [MBProgressHUD hideHUD];
        NSLog(@"报错信息%@",error);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FYBroadColleciton_Cell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                              forIndexPath:indexPath];
    if (self.listArr.count > 0) {
        cell.attach = self.listArr[indexPath.row];
    }
    
    
    return cell;
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
    FYZbhgViewController *zbhgVC = [[FYZbhgViewController alloc]init];
    zbhgVC.attach = self.listArr[indexPath.row];
    [self.navigationController pushViewController:zbhgVC animated:YES];
}

#pragma mark 视频搜索方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mySearchBar resignFirstResponder];
    //    self.pageNo = 1;
    //    [self.list removeAllObjects];
    //    self.save = searchBar;
    //    [self getCourtBookWithPage:self.pageNo AndText:searchBar.text];
    //搜索功能
    NSLog(@"搜索");
    self.pageNo = 1;
    [self.listArr removeAllObjects];
    [self getRequestWithPage:self.pageNo andText:self.mySearchBar.text];

    
    
}






@end
