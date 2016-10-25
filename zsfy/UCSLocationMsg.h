//
//  UCSLocationMsg.h
//  ucsimlib
//
//  Created by bojan on 15/8/18.
//  Copyright (c) 2015年 ucpaas. All rights reserved.
//

#import "UCSMsgContent.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



/*!
 *  @brief  地理位置消息
 */
@interface UCSLocationMsg : UCSMsgContent


/*!
 *  @brief 纬度
 */
@property (assign, nonatomic) CLLocationDegrees latitude;

/*!
 *  @brief 经度
 */
@property (assign, nonatomic) CLLocationDegrees longitude;

/*!
 *  @brief  坐标类型。如果开发者不使用可以置空。
 */
@property (copy, nonatomic) NSString *coord_type;

/*!
 *  @brief 地址信息
 */
@property (copy, nonatomic) NSString *address;


/*!
 *  @brief  位置缩略图
 */
@property (strong, nonatomic) UIImage *thumbnailImage;



/*!
 *  @author barry, 15-12-02 15:12:38
 *
 *  @brief  构造位置信息对象
 *
 *  @param latitude  维度
 *  @param longitude 经度
 *  @param address   地址信息
 *  @param image     位置缩略图
 *  @param coord_type 坐标类型。可以为nil。
 *
 *  @return 位置信息对象
 */
- (instancetype)initWithLatitude:(CLLocationDegrees)latitude
                       longitude:(CLLocationDegrees)longitude
                         address:(NSString *)address
                   locationImage:(UIImage *)image
                      coord_type:(NSString *)coord_type;




@end
