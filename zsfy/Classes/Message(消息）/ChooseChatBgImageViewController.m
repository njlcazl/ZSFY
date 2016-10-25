//
//  ChooseChatBgImageViewController.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/25.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "ChooseChatBgImageViewController.h"
#import "InfoManager.h"



@implementation BgImageModel

-(instancetype)initWithImageName:(NSString *)imageName selected:(BOOL)selected{
    self = [super init];
    if (self) {
        _imageName = imageName;
        _selected = selected;
    }
    
    return  self;
}


@end

@interface ChooseChatBgImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSString * _chatter;
    BgImageModel * _currentModel;
    
}

@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation ChooseChatBgImageViewController

- (instancetype)initWithChatter:(NSString *)chatter{
    
    self = [super init];
    if (self) {
        // Custom initialization
        _chatter = chatter;
        _dataSource = [NSMutableArray array];
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   [self.view setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    self.title = @"选择背景图";
    [self initDataSource];
    [self.view addSubview:self.collectionView];
}


- (void)viewWillAppear:(BOOL)animated{
    [self setupBarButtonItem];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


#pragma mark private
- (void)initDataSource{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [_dataSource addObject:[[BgImageModel alloc] initWithImageName:@"chat_backgroud_patternThumb" selected:NO]];
        [_dataSource addObject:[[BgImageModel alloc] initWithImageName:@"chat_backgroud_grayThumb" selected:NO]];
        [_dataSource addObject:[[BgImageModel alloc] initWithImageName:@"chat_backgroud_skyThumb" selected:NO]];
        
        NSInteger index = [[InfoManager sharedInfoManager] CurrentImageIndexWithTargetId:_chatter];
        if (index < _dataSource.count) {
            BgImageModel * model = _dataSource[index];
            model.selected = YES;
            
            [_dataSource replaceObjectAtIndex:index withObject:model];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
    });
    
}

- (void)setupBarButtonItem{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 17)];
    button.imageView.contentMode = UIViewContentModeLeft;
    [button addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setCustomLeftBarButtonItem:leftBarItem];
}

- (void)pop{
    
    // 设置背景图
    if (_currentModel) {
        UIImage * image = [UIImage imageNamed: _currentModel.imageName];
        [[InfoManager sharedInfoManager] saveChatviewBgImage:image targetId:_chatter];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark getter函数
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
    }
    
    return _collectionView;
}




#pragma mark  UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    BgImageModel * model = (BgImageModel *)[_dataSource objectAtIndex:indexPath.row];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.layer.cornerRadius = imageView.bounds.size.width * 0.1;
    imageView.layer.masksToBounds = YES;
    UIImage * image = [UIImage imageNamed:model.imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width - 20, 2, 18, 18)];
    if (model.selected) {
       icon.image = [UIImage imageNamed:@"chat_backgroud_choose"];
    }
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [cell addSubview:imageView];
    [cell addSubview:icon];
    
    return cell;
}

#pragma mark  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  w = (self.view.frame.size.width - 50 )/3;
    return CGSizeMake(w, 135);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 25);
}

#pragma mark  UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (BgImageModel * model in _dataSource) {
        model.selected = NO;
    }
    
    BgImageModel * model = [_dataSource objectAtIndex:indexPath.row];
    model.selected = YES;
    _currentModel = model;
    
    [self.collectionView reloadData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //保存背景图片
        UIImage * image = nil;
        NSString * imageName = [_currentModel.imageName substringToIndex:(_currentModel.imageName.length - @"Thumb".length)];
        image = [UIImage imageNamed:imageName];
        [[InfoManager sharedInfoManager] saveChatviewBgImage:image targetId:_chatter];
        
        //保存默认的序号
        [[InfoManager sharedInfoManager] saveCurrentImageIndex:indexPath.row TargetId:_chatter];
    });
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end



