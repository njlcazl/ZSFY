

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayerViewControllerDelegate <NSObject>

@optional
- (void)audioRecordFinished:(BOOL)isFinished; // 录音结束后回调, 参数isFinished, 成功时为TRUE, 失败时为FALSE
- (void)audioRecordOverTime; // 录音超时后回调, 没有超时时不回调
- (void)audioRecordChannel:(double)channel;  // 录音过程中的音频振幅(注意:振幅是时刻变化的)
- (void)audioPlayFinished; // 录音播放结束后回调
- (void)audioRecordingTime:(double)time;//录音时间 时时更新 秒计数     没0.5s得到一次currenttim，最后一次也就是总时间

@end

@interface AudioManage : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    id <AudioPlayerViewControllerDelegate> _delegate;

    NSTimer                         *_levelTimer;   // 音频振幅刷新计时器
    int                             _recordEncoding; // 录音格式编码
    BOOL                            _overTimeOnce; // 当超时时只提醒一次, 避免超时时函数audioRecorderDidFinishRecording里的方法重复执行
    // 录音按钮按下到弹起的时间间隔
    NSTimeInterval                  _bgRecordTime;
    NSTimeInterval                  _endRecordTime;
}   

@property (assign) id <AudioPlayerViewControllerDelegate> delegate;
@property (nonatomic, retain) AVAudioPlayer         *audioPlayer;
@property (nonatomic, retain) AVAudioRecorder       *audioRecorder;
@property (nonatomic, retain) NSMutableDictionary   *recordSettings;
@property (nonatomic, retain) NSString              *amrFileName;// 录音编码后的amr文件
@property (nonatomic, retain) NSString              *fileName;// 录音解码后的wav文件

// 开始录制音频
-(void) startRecord;

// 停止录制音频
-(void) stopRecord;

// 取消录制音频
-(void) cancelRecord;

// 播放指定的AMR音频文件
- (void) playAmrFile:(NSString*)amrFilePath;


- (BOOL) deleteWithContentPath:(NSString *)thePath;


- (void) playWavWith:(NSString *)urlString;

// 获得音频数据
- (NSData*) getData;

// 获得录音时长
- (NSTimeInterval)getDurationTime;//利用按钮按下和时间差来进行减

// 获取解码后的wav文件缓存路径
- (NSString*)getWavFilePath;

// 获取编码后的amr文件缓存路径
- (NSString*)getAmrFilePath;

// 停止播放
-(void) stopPlaying;

@end
