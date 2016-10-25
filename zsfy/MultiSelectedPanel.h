//
//  MultiSelectedPanel.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/11.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiSelectedPanel;
@class MultiSelectItem;
@protocol MultiSelectedPanelDelegate <NSObject>

- (void)willDeleteRowWithItem:(MultiSelectItem*)item withMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel;
- (void)didConfirmWithMultiSelectedPanel:(MultiSelectedPanel*)multiSelectedPanel;

@end


@interface MultiSelectedPanel : UIView

+ (instancetype)instanceFromNib;

@property (nonatomic, strong) NSMutableArray *selectedItems;
@property (nonatomic, weak) id<MultiSelectedPanelDelegate> delegate;

//数组有变化之后需要主动激活
- (void)didDeleteSelectedIndex:(NSUInteger)selectedIndex;
- (void)didAddSelectedIndex:(NSUInteger)selectedIndex;

@end
