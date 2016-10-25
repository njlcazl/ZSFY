//
//  ChatBackGroudImageViewController.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/23.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "ChatBackGroudImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "InfoManager.h"
#import "ChooseChatBgImageViewController.h"

@interface ChatBackGroudImageViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

{
    NSString * _chatter;
}

@property (nonatomic ,strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic ,strong) UITableView * tableView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation ChatBackGroudImageViewController

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
    
    self.title = @"聊天背景";
    
    [self initDataSource];
    [self.view addSubview:self.tableView];
    
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
    NSArray * array  = @[@"选中背景图", @"从相机中选中", @"拍一张"];
    [_dataSource addObjectsFromArray:array];
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
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)takePhoto{
    // 打开相机
#if TARGET_IPHONE_SIMULATOR
    [MBProgressHUD showText:@"模拟器不支持相机" toView:self.view];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}

- (void)choosePhoto{
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}


#pragma mark getter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
    }
    
    return _tableView;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}


- (UIView *)footerView{
    UIView * view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 90);
    
    return view;
}



#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(0x383838);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}



#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        ChooseChatBgImageViewController * chooseChatBgImageVC = [[ChooseChatBgImageViewController alloc] initWithChatter:_chatter];
        [self.navigationController pushViewController:chooseChatBgImageVC animated:YES];
        
    }else if (indexPath.row == 1){
        
        [self choosePhoto]; //选一张
        
    }else if (indexPath.row == 2){
        [self takePhoto]; //拍一张
    }else{
        
    }
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){  // 使用了图片
        
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];

        //图片存入沙盒
        [[InfoManager sharedInfoManager] saveChatviewBgImage:orgImage targetId:_chatter];
        
        //图片是自定义的图片，改变一下默认图片的序号，10是乱写的，现在有3个默认图片，比2大就行
        [[InfoManager sharedInfoManager] saveCurrentImageIndex:10 TargetId:_chatter];
        
        
        [MBProgressHUD showText:@"聊天背景更换了" toView:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


@end
