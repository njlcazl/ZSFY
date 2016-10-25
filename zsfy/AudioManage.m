

#import "AudioManage.h"
#import "VoiceConverter.h"

#define AudioDuration 60           // 设置录音时间 (默认为1分钟 1*60=60)
#define AudioDurationLimit 1.00f    // 限制录音最短时间 (少于此时间不进行编码)
#define ALPHA 0.02f                 // 音频振幅调解相对值 (越小振幅就越高)
#define AudioVolume 0.9f            // 播放音量调解 (0.0f~1.0f)

@interface AudioManage ()


@property(nonatomic, retain) NSTimer *timer;
@end

@implementation AudioManage


- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    self.audioPlayer = nil;
    self.audioRecorder = nil;
    self.recordSettings = nil;
    self.amrFileName = nil;
    self.fileName = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // 采用pcm音频格式
        NSMutableDictionary *recDic = [[NSMutableDictionary alloc] initWithCapacity:8];
        [recDic setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recDic setObject:[NSNumber numberWithFloat:8000.00] forKey: AVSampleRateKey];
        [recDic setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [recDic setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recDic setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];
        [recDic setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recDic setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [recDic setObject:[NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
        self.recordSettings = recDic;
        [recDic release];
      }
    return self;
}


#pragma mark - Custom Methods
/**
 @功能:获得音频文件数据
 @参数:空
 @返回值:空
 */
- (NSData*) getData
{
    NSData *data = [NSData dataWithContentsOfFile:self.amrFileName];
    return data;
}

/**
 @功能:获取音频文件名
 @参数:空
 @返回值:音频文件名 (NSString类型)
 */
- (NSString*)getAudioName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"]; // 精确到毫秒级
    NSString *times = [dateFormatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"record_%@.wav", times];
    [dateFormatter release];
    //制定文件名
    NSString *wavFilePath = [NSString stringWithFormat:@"%@/%@",[self getCachePath], fileName];
    return wavFilePath;
}

/**
 @功能:开始录制音频
 @参数:空
 @返回值:空
 */
- (void) startRecord
{
    _overTimeOnce = FALSE;
    [self stopPlaying];
    [self stopRecording];
    // 缓冲音频录音
    _bgRecordTime = [[NSDate date] timeIntervalSince1970];
    [self startRecordProgress];
    // 开启音频振幅计量器
    [self beginTimeMeters]; // 此函数暂停使用,因为不需要查看音频振幅
    
}

// 取消录制音频
/**
 @功能:取消录制音频(包括停止录音, 删除不可用的录音文件)
 @参数:空
 @返回值:空
 */
-(void) cancelRecord
{
    // 停止录音
    [self stopRecording];
    // 删除不可用的录音文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileName])
    {
        if (![self.audioRecorder deleteRecording])
        {
            DDLogVerbose(@"AudioPlayerViewController:删除时间短的录音文件 -> 失败!");
        }
    }
    
}

/**
 @功能:音频处理(包括停止录音, wav格式转成amr格式, 发送amr格式的音频到网络, amr格式转成wav格式, 获取当前录音时间)
 @参数:空
 @返回值:空
 */
- (void)stopRecord
{
    // 停止录音
    [self stopRecording];

    // 防止频繁点击录音接钮事件
    _endRecordTime = [[NSDate date] timeIntervalSince1970];
    double durationTime = [self getDurationTime];

    if (durationTime <= 0.2)
    {

        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(startRecordProgress)
                                                   object:nil];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordFinished:)])
        {
            [self.delegate audioRecordFinished:FALSE];
        }
        
        return;
    }
    
    // 录音超时 或 录音时间少于最短限制时间 都当作录音失败
    if ([self isOverTime] || (durationTime < AudioDurationLimit))
    {
        // 删除不可用的录音文件
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileName])
        {
            if (![self.audioRecorder deleteRecording])
            {
                DDLogVerbose(@"AudioPlayerViewController:删除时间短的录音文件 -> 失败!");
            }
        }
        
        //
        if (durationTime < AudioDurationLimit)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordFinished:)])
            {
                [self.delegate audioRecordFinished:FALSE];
            }
        }
        
        return;
    }
    
    // 处理音频
    [self resolveRecord];
}

/**
 @功能:处理音频录音
 @参数:空
 @返回值:空
 */
- (void)resolveRecord//录音超时
{
    // wav格式转成amr格式
    if ([self voiceWavToAmr:self.fileName])//这时两种格式并存
    {
        // 录音成功 -> 回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordFinished:)])
        {
            [self.delegate audioRecordFinished:TRUE];
        }
    }
    else
    {
        // 录音失败 -> 回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordFinished:)])
        {
            [self.delegate audioRecordFinished:FALSE];
        }
    }
    
    // 删除已生成的录音文件
//    if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileName])
//    {
//        if (![self.audioRecorder deleteRecording])
//        {
//            DDLogVerbose(@"AudioPlayerViewController:删除录音文件 -> 失败!");
//        }
//    }
}


/**
 @功能:缓冲音频录音
 @参数:空
 @返回值:空
 */
- (void)startRecordProgress
{
    //
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    

    // 设置音频文件路径（录制的wav文件）
    self.fileName = [self getAudioName];
    //录制的url
    NSURL * url = [NSURL fileURLWithPath:self.fileName];
    AVAudioRecorder *aAudioRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                                  settings:self.recordSettings
                                                                     error:nil];
    [aAudioRecorder setDelegate:self];
    aAudioRecorder.meteringEnabled = YES;
    self.audioRecorder = aAudioRecorder;
    [aAudioRecorder release];
    // 检测录音设备

    if (![AVAudioSession sharedInstance].inputAvailable)
    {
        DDLogVerbose(@"AudioPlayerViewController:录音设备硬件不支持!");
        return;
    }
    
    // 准备录音
    if (self.audioRecorder && [self.audioRecorder prepareToRecord])
    {
        [self.audioRecorder recordForDuration:(NSTimeInterval)AudioDuration];
    }
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recordDurationchange) userInfo:nil repeats:YES];
    self.timer = time;
    [time  fire];

}

-(void)recordDurationchange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordingTime:)])
    {
        [self.delegate audioRecordingTime:self.audioRecorder.currentTime];
    }
}


/**
 @功能:停止录音
 @参数:空
 @返回值:空
 */
-(void) stopRecording
{
    if (self.audioRecorder)
    {
        [self.audioRecorder stop];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
    
    // 关闭音频振幅计量器
    [self.timer invalidate];
    [self stopTimeMeters];
}

/**
 @功能:暂停录音
 @参数:空
 @返回值:空
 */
- (void)pauseRecording
{
    if (self.audioRecorder)
    {
        if ([self.audioRecorder isRecording])
        {
            [self.audioRecorder pause];
        }
    }
}
/**
 @功能:播放指定的AMR音频文件
 @参数:音频文件的全路径
 @返回值:空
 */
- (void) playAmrFile:(NSString*)amrFilePath
{
    if ([self voiceAmrToWav:amrFilePath])
    {
        [self beginPlaying]; // 播放音频
    }
}


- (void)playWavWith:(NSString *)urlString;
{
    self.fileName = urlString;
    [self beginPlaying];
}

/**
 @功能:播放录音
 @参数:空
 @返回值:空
 */
-(void) beginPlaying   //********************************wav 文件
{
    if (self.fileName)
    {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        
        [self pausePlaying];
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        NSURL *url = [NSURL fileURLWithPath:self.fileName];
        AVAudioPlayer *aAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        aAudioPlayer.volume = AudioVolume; // 音量(0.0~1.0)
        aAudioPlayer.numberOfLoops =0;    // 只播放一次
        aAudioPlayer.currentTime = 0.0;    // 可以指定从任意位置开始播放
        aAudioPlayer.delegate = self;
        self.audioPlayer = aAudioPlayer;
        [self.audioPlayer play];
        [aAudioPlayer release];
    }
}




/**
 @功能:停止播放
 @参数:空
 @返回值:空
 */
-(void) stopPlaying
{
    if (self.audioPlayer)
    {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
        [self.audioPlayer stop];
    }
}

/**
 @功能:暂停播放
 @参数:空
 @返回值:空
 */
-(void) pausePlaying
{
    if (self.audioPlayer)
    {
        [self.audioPlayer pause];
    }
}

/**
 @功能:获取录音时长
 @参数:空
 @返回值:时间 double类型
 */
- (NSTimeInterval)getDurationTime
{
#if 0
    NSData *data = [NSData dataWithContentsOfFile:self.fileName];
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:nil];
    double durationTime = [play duration];
    [play release];
    
    double time = durationTime;
#else
    NSTimeInterval time = _endRecordTime-_bgRecordTime;
    if (time < 0.0)
    {
        time = 0.0;
    }
    if (time >= AudioDuration)
    {
        time = AudioDuration;
    }
#endif
    
    return time;
}

/**
 @功能:查测录音是否超时
 @参数:空
 @返回值:超时返回TRUE, 不超时返回FALSE
 */
- (BOOL)isOverTime
{
    // 获取当前录音时间
    double durationTime = [self getDurationTime];
    BOOL overTime = FALSE;
    if (durationTime >= AudioDuration)
    {
        overTime = TRUE;
    }
    
    return overTime;
}

/**
 @功能:获取解码后的wav文件缓存路径
 @参数:空
 @返回值:当前解码后的wav文件缓存路径
 */
- (NSString*)getWavFilePath
{
    return self.fileName;
}

/**
 @功能:获取编码后的amr文件缓存路径
 @参数:空
 @返回值:当前编码后的amr文件缓存路径
 */
- (NSString*)getAmrFilePath
{
    return self.amrFileName;
}

/**
 @功能:获取音频缓存路径
 @参数:空
 @返回值:当前音频缓存路径
 */
- (NSString*)getCachePath
{
     NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return cacheDir;
}

/**
 @功能:音频wav格式转成amr格式
 @参数:音频文件名
 @返回值:返回类型int 成功时返回1, 失败时返回0
 */
- (int)voiceWavToAmr:(NSString*)wavFilePath
{
    if (wavFilePath && wavFilePath.length)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
        {
            int success = [VoiceConverter wavToAmr:wavFilePath];
            if (success)
            {
                self.fileName = wavFilePath;
                if ([wavFilePath hasSuffix:@"wav"])
                {
                    self.amrFileName = [self.fileName stringByReplacingOccurrencesOfString:@"wav" withString:@"amr"];
                }
                else
                {
                    self.amrFileName = [self.fileName stringByReplacingOccurrencesOfString:@"WAV" withString:@"amr"];
                }
            }
            else
            {
                self.amrFileName = nil;
            }
        
            return success;
        }
        else
        {
            DDLogVerbose(@"AudioPlayerViewController:Wav音频文件不存在!");
        }
    }
    
    return 0;
}

/**
 @功能:音频amr格式转成wav格式
 @参数:音频文件名
 @返回值:返回类型int 成功时返回1, 失败时返回0
 */
//播放前转码  苹果只能播放wav
- (int)voiceAmrToWav:(NSString*)amrFilePath
{
    if (amrFilePath && amrFilePath.length)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:amrFilePath])
        {
            int success = [VoiceConverter amrToWav:amrFilePath];
            if (success)
            {
                self.amrFileName = amrFilePath;
                if ([amrFilePath hasSuffix:@"amr"])
                {
                    //wav
                    self.fileName = [amrFilePath stringByReplacingOccurrencesOfString:@"amr" withString:@"wav"];
                }
                else
                {
                    self.fileName = [amrFilePath stringByReplacingOccurrencesOfString:@"AMR" withString:@"wav"];
                }
            }
            else
            {
                self.fileName = nil;
            }
            
             return success;
        }
        else
        {
            DDLogVerbose(@"AudioPlayerViewController:Amr音频文件不存在!");
        }
    }
    
    return 0;
}

/**
 @功能:计时器,用于刷新音频振幅
 @参数:空
 @返回值:空
 */
- (void)beginTimeMeters
{
    [self stopTimeMeters];
    
    _levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                   target:self
                                                 selector:@selector(refrushMeters)
                                                 userInfo:nil
                                                  repeats:YES];
}

/**
 @功能:停止音频振幅计时器
 @参数:空
 @返回值:空
 */
- (void)stopTimeMeters
{
    if (_levelTimer)
    {
        [_levelTimer invalidate];
        _levelTimer = nil;
    }
}

/**
 @功能:刷新音频振幅值
 @参数:空
 @返回值:空
 */
- (void)refrushMeters
{
    if (self.audioRecorder)
    {
        [self.audioRecorder updateMeters];
        double aveChannel = pow(10, (ALPHA * [self.audioRecorder averagePowerForChannel:0]));
        if (aveChannel <= 0.0f)
        {
            aveChannel = 0.0f;
        }
        
        if (aveChannel >= 1.0f)
        {
            aveChannel = 1.0f;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordChannel:)])
        {
            [self.delegate audioRecordChannel:aveChannel];
        }
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (recorder == self.audioRecorder)
    {
        _endRecordTime = [[NSDate date] timeIntervalSince1970];
        if ([self isOverTime] && !_overTimeOnce)
        {
            _overTimeOnce = TRUE;
            [self resolveRecord];//会转码 生产amr文件wav文件还在
            [self stopRecording];
            if (self.delegate && [self.delegate respondsToSelector:@selector(audioRecordOverTime)])
            {
                [self.delegate audioRecordOverTime];
            }
        }
    }
}

- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder
{
    // 正在录音时来电话时，暂停录音
    if (recorder == self.audioRecorder)
    {
        [self pauseRecording];
    }
}

- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder
{
    // 电话打完后，接着录音
    if (recorder == self.audioRecorder)
    {
        [self.audioRecorder record];
    }
}

//删除文件
- (BOOL) deleteWithContentPath:(NSString *)thePath
{
    NSError *error=nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:thePath])
    {
        [fileManager removeItemAtPath:thePath error:&error];
    }
    if (error)
    {
        DDLogVerbose(@"删除文件时出现问题:%@",[error localizedDescription]);
        return NO;
    }
    return YES;
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    if (recorder == self.audioRecorder)
    {
        if(error)
        {
            DDLogVerbose(@"AudioPlayerViewController:audioEncode[%@]",
                  [error localizedDescription]);
        }
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    if (player == self.audioPlayer)
    {
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
        [[AVAudioSession sharedInstance] setCategory:
         AVAudioSessionCategoryAmbient error:nil];
        if (self.delegate && [self.delegate respondsToSelector:
                              @selector(audioPlayFinished)])
        {
            [self.delegate audioPlayFinished];
        }
    }
}

@end
