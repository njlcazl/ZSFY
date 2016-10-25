//
//  CoreDataOperation.h
//  zsfy
//
//  Created by 曾祺植 on 12/24/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataOperation : NSObject

+ (NSArray *)getBlockList:(NSString *)userId;

+ (void)addBlockList:(NSString *)userID targetId:(NSString *)targetId;

+ (void)removeBlockList:(NSString *)userId targetId:(NSString *)targetId;

+ (NSArray *)getVoiceSetting:(NSString *)userId;

+ (void)changeVoiceSetting:(NSString *)userId VoiceFlag:(NSNumber *)voiceFlag isOn:(NSNumber *)isOn;

@end
