//
//  MultiSelectedPanel.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "MultiSelectedPanel.h"
#import "UIImageView+WebCache.h"
#import "MultiSelectItem.h"

@interface MultiSelectedPanel ()<UITabBarControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate>

@property (strong, nonatomic)  UIImageView *bkgImageView;
@property (strong, nonatomic)  UIButton *confirmBtn;


//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UICollectionView  *collectionView;

@end

@implementation MultiSelectedPanel



+ (instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MultiSelectedPanel" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self setUp];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}



- (UIImageView *)bkgImageView{
    if (!_bkgImageView) {
        _bkgImageView = [[UIImageView alloc] init];
        _bkgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bkgImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bkgImageView];
    }
    
    return _bkgImageView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, 242 + (self.frame.size.width - 320), 36) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13.5];
        [self.confirmBtn setBackgroundColor:UIColorFromRGB(0x0063ba)];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        _confirmBtn.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame) + 10, 8, 63, 28);
        [_confirmBtn addTarget:self action:@selector(confirmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
    }
    return _confirmBtn;
}

- (void)setUp
{
    self.bkgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MultiSelectedPanelTableViewCell"];
    self.collectionView.showsHorizontalScrollIndicator =  NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate =  self;
    
    
    
    [self.confirmBtn setTitle:@"确认(0)" forState:UIControlStateNormal];
    self.confirmBtn.enabled = NO;
    
}

- (void)updateConfirmButton
{
    int count = (int)_selectedItems.count;
    self.confirmBtn.enabled = count>0;
    
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确认(%d)",count] forState:UIControlStateNormal];
}

- (void)confirmBtnPressed:(UIButton *) btn {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didConfirmWithMultiSelectedPanel:)]) {
        [self.delegate didConfirmWithMultiSelectedPanel:self];
    }
}

#pragma mark - setter
- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
    _selectedItems = selectedItems;
    
    [self.collectionView reloadData];
    
    [self updateConfirmButton];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedItems.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MultiSelectedPanelTableViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    //添加一个imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(2.0f, 0.0f, 36.0f, 36.0f)];
    imageView.tag = 999;
    imageView.layer.cornerRadius = 4.0f;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:imageView];
    
    
    //    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:999];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
//    [imageView sd_setImageWithURL:item.imageURL placeholderImage:[UIImage imageNamed:@"1"]];
    imageView.image = item.placeHolderImage;
    return cell;
}



#pragma mark --     UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(36.0f, 36.0f);
}

#pragma mark  -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MultiSelectItem *item = self.selectedItems[indexPath.row];
    //删除某元素,实际上是告诉delegate去删除
    if (self.delegate&&[self.delegate respondsToSelector:@selector(willDeleteRowWithItem:withMultiSelectedPanel:)]) { //委托给控制器   删除列表中item
        [self.delegate willDeleteRowWithItem:item withMultiSelectedPanel:self];
    }
    
    
    //确定没了删掉
    if ([self.selectedItems indexOfObject:item]==NSNotFound) {
        [self updateConfirmButton];
        
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


#pragma mark - out call
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex
{
    [self updateConfirmButton];
    //执行删除操作
    //[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
}

- (void)didAddSelectedIndex:(NSUInteger)selectedIndex
{
    //找到index
    if (selectedIndex<self.selectedItems.count) {
        [self updateConfirmButton];
        //执行插入操作
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        
        //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

@end
