//
//  pdws.h
//  zsfy
//
//  Created by pyj on 15/11/21.
//  Copyright (c) 2015年 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pdws : NSObject

@property (nonatomic, assign) NSInteger firstResult;
@property (nonatomic, strong) NSArray * list;
@property (nonatomic, assign) NSInteger offsetSize;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, assign) NSInteger rowSize;

@end
