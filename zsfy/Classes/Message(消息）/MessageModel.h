//
//  MessageModel.h
//  IMDemo_UI
//
//  Created by Barry on 15/4/17.
//  Copyright (c) 2015年 Barry. All rights reserved.
//


/*!
 @enum
 @brief 聊天类型
 @constant MessageBodyType_Text 文本类型
 @constant MessageBodyType_Image 图片类型
 @constant MessageBodyType_Video 视频类型
 @constant MessageBodyType_Location 位置类型
 @constant MessageBodyType_Voice 语音类型
 @constant MessageBodyType_File 文件类型
 @constant MessageBodyType_Command 命令类型
 @constant MessageBodyType_notification 通知类型
 */
typedef enum {
    MessageBodyType_Text = 1,
    MessageBodyType_Image,
    MessageBodyType_Video,
    MessageBodyType_Location,
    MessageBodyType_Voice,
    MessageBodyType_File,
    MessageBodyType_Command,
    MessageBodyType_notification,
}MessageBodyType;


/*!
 @enum
 @brief 聊天消息发送状态
 @constant MessageDeliveryState_Pending 待发送
 @constant MessageDeliveryState_Delivering 正在发送
 @constant MessageDeliveryState_Delivered 已发送, 成功
 @constant MessageDeliveryState_Failure 已发送, 失败
 */
typedef enum {
    MessageDeliveryState_Pending = 0,
    MessageDeliveryState_Delivering,
    MessageDeliveryState_Delivered,
    MessageDeliveryState_Failure
}MessageDeliveryState;



#import <Foundation/Foundation.h>
#import "UCSMessage.h"

#define KFIRETIME 20

@interface MessageModel : NSObject
{
    BOOL _isPlaying;
}

@property (nonatomic) MessageBodyType type;
@property (nonatomic) MessageDeliveryState status;

@property (nonatomic) BOOL isSender;    //是否是发送者
@property (nonatomic) BOOL isRead;      //是否已读
@property (nonatomic) BOOL isChatGroup;  //是否是群聊

@property (nonatomic, assign) long long  messageId;
@property (nonatomic, copy) NSURL *headImageURL;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *username;


@property (nonatomic, copy) NSString * from; //消息发送者
@property (nonatomic, copy) NSString * to;  //消息接收者

@property (nonatomic) long long timestamp; // 消息的发送或者接收时间

//text
@property (nonatomic, strong) NSString *content;




//image
@property (nonatomic) CGSize size;
@property (nonatomic) CGSize thumbnailSize;
@property (nonatomic, strong) NSString *imageLocalPath; //图片本地地址
@property (nonatomic, strong) NSURL *imageRemoteURL; //大图远程url
@property (nonatomic, strong) NSString *thumbnailLocalPath; //小图本地地址
@property (nonatomic, strong) NSURL *thumbnailRemoteURL; //小图远程地址 不使用
@property (nonatomic, strong) UIImage *image; //大图
@property (nonatomic, strong) UIImage *thumbnailImage; //小图


//audio
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *remotePath;
@property (nonatomic) NSInteger time;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isPlayed;

//location
@property (nonatomic, strong) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, strong) NSString * videoPath; //视频目录



@property (nonatomic, strong) UCSMessage * message; //模型对应消息

@end

