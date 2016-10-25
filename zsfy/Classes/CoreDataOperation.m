//
//  CoreDataOperation.m
//  zsfy
//
//  Created by 曾祺植 on 12/24/15.
//  Copyright © 2015 wzy. All rights reserved.
//

#import "CoreDataOperation.h"
#import "CoreDataManager.h"
#import "SettingModel+CoreDataProperties.h"
#import "VoiceSetting+CoreDataProperties.h"

@interface CoreDataOperation()

@end

@implementation CoreDataOperation

+ (void)initVoiceSetting:(NSString *)userId
{
    VoiceSetting *item1 = [NSEntityDescription insertNewObjectForEntityForName:@"VoiceSetting" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [item1 setUserID:userId];
    [item1 setVoiceFlag:@0];
    [item1 setIsOn:@1];
    
    VoiceSetting *item2 = [NSEntityDescription insertNewObjectForEntityForName:@"VoiceSetting" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [item2 setUserID:userId];
    [item2 setVoiceFlag:@1];
    [item2 setIsOn:@1];
    
    VoiceSetting *item3 = [NSEntityDescription insertNewObjectForEntityForName:@"VoiceSetting" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [item3 setUserID:userId];
    [item3 setVoiceFlag:@2];
    [item3 setIsOn:@0];
    NSError *err = [[NSError alloc] init];
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&err];
    if (isSaveSuccess) {
        NSLog(@"Save successFull");
    }
}

+ (NSArray *)getBlockList:(NSString *)userId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BlockList" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@", userId];
    NSError *err = [[NSError alloc] init];
    NSArray *FetchResults = [[CoreDataManager sharedCoreDataManager].managedObjContext executeFetchRequest:request error:&err];
    if (!FetchResults) {
        return nil;
    } else {
        NSMutableArray *retTmp = [[NSMutableArray alloc] init];
        for (int i = 0; i < FetchResults.count; i++) {
            SettingModel *item = FetchResults[i];
            [retTmp addObject:item.targetID];
        }
        return [retTmp copy];
    }
}

+ (void)addBlockList:(NSString *)userID targetId:(NSString *)targetId
{
    SettingModel *insertItem = [NSEntityDescription insertNewObjectForEntityForName:@"BlockList" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [insertItem setUserID:userID];
    [insertItem setTargetID:targetId];
    NSError *err = [[NSError alloc] init];
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&err];
    if (isSaveSuccess) {
        NSLog(@"Save successFull");
    }
}

+ (void)removeBlockList:(NSString *)userId targetId:(NSString *)targetId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BlockList" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [request setEntity:entity];
    
    request.predicate = [NSPredicate predicateWithFormat:@"userID = %@ AND targetID = %@", userId, targetId];
    NSError *err = [[NSError alloc] init];
    NSArray *FetchResults = [[CoreDataManager sharedCoreDataManager].managedObjContext executeFetchRequest:request error:&err];
    if (FetchResults.count == 1) {
        [[CoreDataManager sharedCoreDataManager].managedObjContext deleteObject:FetchResults[0]];
    }
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&err];          //保存数据
    if (!isSaveSuccess) {
    } else {
        NSLog(@"Del successful!");
    }

}

+ (NSArray *)getVoiceSetting:(NSString *)userId
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VoiceSetting" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID = %@", userId]];
    NSSortDescriptor *sortDescription = [[NSSortDescriptor alloc] initWithKey:@"voiceFlag" ascending:YES];
    NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescription, nil];
    [request setSortDescriptors:sortDescriptions];
    NSError *err = [[NSError alloc] init];
    NSArray *FetchResults = [[CoreDataManager sharedCoreDataManager].managedObjContext executeFetchRequest:request error:&err];
    if (FetchResults.count < 3) {
        [self initVoiceSetting:userId];
        return [NSArray arrayWithObjects:@1, @1, @0, nil];
    } else {
        NSMutableArray *ret = [[NSMutableArray alloc] init];
        for (int i = 0; i < FetchResults.count; i++) {
            VoiceSetting *item = FetchResults[i];
            [ret addObject:item.isOn];
        }
        return ret;
    }
}

+ (void)changeVoiceSetting:(NSString *)userId VoiceFlag:(NSNumber *)voiceFlag isOn:(NSNumber *)isOn
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"VoiceSetting" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [request setEntity:entity];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"userID = %@ AND voiceFlag = %@", userId, voiceFlag]];
    NSError *err = [[NSError alloc] init];
    NSArray *FetchResults = [[CoreDataManager sharedCoreDataManager].managedObjContext executeFetchRequest:request error:&err];
    if (FetchResults.count == 0) {
        [self initVoiceSetting:userId];
        FetchResults = [[CoreDataManager sharedCoreDataManager].managedObjContext executeFetchRequest:request error:&err];
    }
    VoiceSetting *item = FetchResults[0];
    [item setIsOn:isOn];
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&err];
    if (isSaveSuccess) {
        NSLog(@"Save successFull");
    }


    
}

@end
