//
//  photoReadManager.m
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/27.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "photoReadManager.h"
#import "UIImageView+WebCache.h"

static photoReadManager * instance = nil;

@interface photoReadManager()

@property (nonatomic, strong) UIWindow * keyWindow;
@property (strong, nonatomic) NSMutableArray * photos;
@property (nonatomic, strong) UINavigationController * photoBrowserNavController;


@end

@implementation photoReadManager


+ (id)shareManager{
    
    @synchronized(self){
        static dispatch_once_t singel;
        dispatch_once(&singel, ^{
            instance = [[self alloc] init];
        });
    }
    
    return instance;
}


- (UIWindow *)keyWindow{
    if (_keyWindow == nil) {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    return _keyWindow;
}

- (MWPhotoBrowser *)photoBrowser{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        _photoBrowser.wantsFullScreenLayout = YES;
#endif
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

-(NSMutableArray *)photos{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (UINavigationController *)photoBrowserNavController{
    if (_photoBrowserNavController == nil) {
        _photoBrowserNavController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoBrowserNavController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    return _photoBrowserNavController;
}

- (void)showBrowserWithImages:(NSArray *)imgArray{
    
    if (imgArray && [imgArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imgArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [MWPhoto photoWithImage:object];
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                photo = [MWPhoto photoWithFilePath:object];
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    UIViewController *rootController = [self.keyWindow rootViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        [rootController presentViewController:self.photoBrowserNavController animated:YES completion:nil];
    });
    
}

#pragma mark 自己加的，为了显示多图片左右滑动
- (void)showBrowserWithImages:(NSArray *)imgArray index:(NSUInteger) index{
    
    if (imgArray && [imgArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imgArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                photo = [MWPhoto photoWithImage:object];
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                photo = [MWPhoto photoWithFilePath:object];
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    
    UIViewController *rootController = [self.keyWindow rootViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.photoBrowser setphotoCount:self.photos.count];
        [self.photoBrowser setCurrentPhotoIndex:index];
        [rootController presentViewController:self.photoBrowserNavController animated:YES completion:nil];
    });
    
}



#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}

@end
