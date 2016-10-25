//
//  MessageModelManager.h
//  UC_Demo_1.0.0
//
//  Created by Barry on 15/5/19.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "UCSMessage.h"

@interface MessageModelManager : NSObject

+ (id)modelWithMessage:(UCSMessage *) message;


@end
