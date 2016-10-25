//
//  FileListTableView.m
//  WAVtoAMRtoWAV
//
//  Created by Jeans Huang on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VoiceConverter.h"
#import "wav.h"
#import "interf_dec.h"
#import "dec_if.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation VoiceConverter

//+ (int)amrToWav:(NSString *)amrFilePath;
//+ (int)wavToAmr:(NSString *)wavFilePath;

+ (int)amrToWav:(NSString *)amrFilePath
{
    if (amrFilePath)
    {
        if ([amrFilePath hasSuffix:@"amr"] || [amrFilePath hasSuffix:@"AMR"])
        {
            NSString *path = amrFilePath;
            NSString *savePath = nil;
            if ([path hasSuffix:@"amr"])
            {
                savePath = [amrFilePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
            }
            else
            {
                savePath = [amrFilePath stringByReplacingOccurrencesOfString:@"AMR" withString:@"wav"];
            }
//
            ///Users/nanchanghupeng/Library/Application Support/iPhone Simulator/7.1/Applications/1AA50120-E25C-474C-8742-BE7A8CBE773F/Library/Caches/1483682352.amr
            ///Users/nanchanghupeng/Library/Application Support/iPhone Simulator/7.1/Applications/1AA50120-E25C-474C-8742-BE7A8CBE773F/Library/Caches/1989081282.amr
            if (DecodeAMRFileToWAVEFile([amrFilePath cStringUsingEncoding:NSASCIIStringEncoding],
                                        [savePath cStringUsingEncoding:NSASCIIStringEncoding]))
            {
                return 1; // 成功返回1
            }
        }
    }
    
    NSLog(@"VoiceConvertVC:amr-->wav格式转换失败!");
    return 0; // 失败返回0
}

//+ (int)amrToWav:(NSString *)amrFilePath
//{
//    if (amrFilePath)
//    {
//        if ([amrFilePath hasSuffix:@"amr"] || [amrFilePath hasSuffix:@"AMR"])
//        {
//            NSString *path = amrFilePath;
//            NSString *savePath = nil;
//            if ([path hasSuffix:@"amr"])
//            {
//                savePath = [path stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
//            }
//            else
//            {
//                savePath = [path stringByReplacingOccurrencesOfString:@"AMR" withString:@"wav"];
//            }
//            
//            if (DecodeAMRFileToWAVEFile([path cStringUsingEncoding:NSASCIIStringEncoding],
//                                         [savePath cStringUsingEncoding:NSASCIIStringEncoding]))
//            {
//                return 1; // 成功返回1
//            }
//        }
//    }
//    
//    NSLog(@"VoiceConvertVC:amr-->wav格式转换失败!");
//    return 0; // 失败返回0
//}


// WAVE音频采样频率是8khz
// 音频样本单元数 = 8000*0.02 = 160 (由采样频率决定)
// 声道数 1 : 160
//        2 : 160*2 = 320
// bps决定样本(sample)大小
// bps = 8 --> 8位 unsigned char
//       16 --> 16位 unsigned short
+ (int)wavToAmr:(NSString *)wavFilePath
{
    if (wavFilePath)
    {
        if ([wavFilePath hasSuffix:@"wav"] || [wavFilePath hasSuffix:@"WAV"])
        {
            NSString *path = wavFilePath;
            NSString *savePath = nil;
            if ([path hasSuffix:@"wav"])
            {
                savePath = [path stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
            }
            else
            {
                savePath = [path stringByReplacingOccurrencesOfString:@"WAV" withString:@"amr"];
            }
            
            if (EncodeWAVEFileToAMRFile([path cStringUsingEncoding:NSASCIIStringEncoding],
                                        [savePath cStringUsingEncoding:NSASCIIStringEncoding], 1, 16))
            {
                return 1; // 成功返回1
            }
        }
    }
    
    NSLog(@"VoiceConvertVC:wav-->amr格式转换失败!");
    
    return 0; // 失败返回0
}

@end
