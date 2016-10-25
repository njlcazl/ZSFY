//
//  photoReadManager.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/4/27.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"

@interface photoReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;

+ (id)shareManager;

- (void)showBrowserWithImages:(NSArray *) imgArray;


/**
 *  这里要显示index
 *
 *  @param imgArray 所有的数组
 *  @param index    显示的index
 */
- (void)showBrowserWithImages:(NSArray *)imgArray index:(NSUInteger) index;

@end
