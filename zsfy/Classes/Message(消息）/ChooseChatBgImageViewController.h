//
//  ChooseChatBgImageViewController.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/25.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BgImageModel : NSObject

- (instancetype)initWithImageName:(NSString *) imageName selected:(BOOL) selected;

@property (nonatomic, copy) NSString * imageName;
@property (nonatomic) BOOL selected;


@end

@interface ChooseChatBgImageViewController : UIViewController

- (instancetype)initWithChatter:(NSString *)chatter;

@end


