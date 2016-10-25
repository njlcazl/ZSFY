//
//  VoiceSetting+CoreDataProperties.h
//  zsfy
//
//  Created by 曾祺植 on 12/23/15.
//  Copyright © 2015 wzy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VoiceSetting.h"

NS_ASSUME_NONNULL_BEGIN

@interface VoiceSetting (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userID;
@property (nullable, nonatomic, retain) NSNumber *voiceFlag;
@property (nullable, nonatomic, retain) NSNumber *isOn;

@end

NS_ASSUME_NONNULL_END
