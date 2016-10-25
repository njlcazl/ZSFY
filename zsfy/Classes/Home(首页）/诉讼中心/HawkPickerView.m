//
//  HawkPickerView.m
//  zsfy
//
//  Created by QYQ-Hawk on 15/12/8.
//  Copyright © 2015年 wzy. All rights reserved.
//

#import "HawkPickerView.h"

@interface HawkPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIPickerView * kPickerView;
    
    NSArray * dataArray;
}

@end

@implementation HawkPickerView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        dataArray = @[@"代理人", @"监护人",@"律师",@"当事人"];
        
        [self setupPickerView];
        
        return self;
    }
    return nil;
}

- (void)setupPickerView{
    
    kPickerView = [[UIPickerView alloc] init];
    
    kPickerView.frame = self.frame;

    [self addSubview:kPickerView];
    
    kPickerView.delegate = self;
    
    kPickerView.dataSource = self;
    
    [kPickerView selectRow:3 inComponent:0 animated:YES];

}

#pragma mark ==
#pragma mark Delegate 

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSLog(@"titile = %@",[dataArray objectAtIndex:row]);
    
    return [dataArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  
    self.SelectType(row);
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [kPickerView setFrame:frame];
    [kPickerView reloadAllComponents];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
