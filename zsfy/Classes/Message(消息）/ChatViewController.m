//
//  ChatViewController.m
//  IMDemo_UI
//
//  Created by Barry on 15/4/17.
//  Copyright (c) 2015年 Barry. All rights reserved.
//

#import "ChatViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "photoReadManager.h"
#import "MessageModelManager.h"
#import "AudioPlayManager.h"


#import "UCMessageToolBar.h"
#import "UCChatBarMoreView.h"
#import "EmojiKeyboardView.h"

#import "UCChatViewCell.h"
#import "UCChatTimeCell.h"
#import "UCChatNotificationCell.h"

#import "UCChatImageBubbleView.h"

#import "NSDate+Category.h"

#import "AudioManage.h"


#import "ChatDiscussionDetailViewController.h"
#import "SingelChatDeltailViewController.h"
#import "UIScrollView+UCkeyboardControl.h"


#import <objc/runtime.h>
#import "BaseTabBarController.h"


#import "UIImageView+WebCache.h"

#import "ChatSendHelper.h"
#import "BBBadgeBarButtonItem.h"
#import "UINavigationItem+Barry.h"


#define KUseSRRefresh  0

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UCChatBarMoreViewDelegate, UCMessageToolBarDelegate,AudioPlayerViewControllerDelegate , ChatSendHelperDelegate, UIAlertViewDelegate, UCSIMClientDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;  //复制
    UIMenuItem *_deleteMenuItem; //删除
    UIMenuItem * _forwardMenuItem; //转发
    UIMenuItem * _moreMenuItem; //更多
    NSIndexPath *_longPressIndexPath;

    NSMutableArray *_messages; //消息数组
    
    NSTimeInterval _recordDuration; //录音时长

    UIImageView * _backView; //聊天背景
    
    
    int _otherUnreadCount; //其他人的未读消息总数
    
    long long _resendNewMessageId ; //记录重发消息后,新的messageid
    
    NSDictionary * _resendEventInfo; //重发事件中传递的info
    
    dispatch_queue_t _DataQueue;  //数据操作线程
    BOOL  _firstInput;
}

@property (nonatomic        ) UCS_IM_ConversationType   chatType;
@property (strong, nonatomic) NSString                  *chatter;

@property (strong, nonatomic) NSMutableArray            *dataSource;//tableView数据源

@property (strong, nonatomic) UITableView               *tableView;
@property (strong, nonatomic) UCMessageToolBar          *chatToolBar;

@property (strong, nonatomic) UIImagePickerController   *imagePicker;

@property (strong, nonatomic) NSDate                    *chatTagDate;//标记时间

@property (strong, nonatomic) NSMutableArray            *messages;
@property (nonatomic        ) BOOL                      isPlayingAudio;

@property (nonatomic,strong ) AudioManage               * audioManager;//录音、播放类
@property (strong, nonatomic) photoReadManager          *photoReadManager;//相册观察类
@property (strong, nonatomic) AudioPlayManager          * audioPlayManager;//播放录音类

@property (strong, nonatomic) UCChatBarMoreView         * moreView;//更多键盘
@property (strong, nonatomic) EmojiKeyboardView         * emojiKeyboardView;//表情键盘

@property (nonatomic, strong) ChatSendHelper            * sendHelper;

/**
 *  记录旧的textView contentSize Heigth
 */
@property (nonatomic, assign) CGFloat                   previousTextViewContentHeight;

/**
 *  记录键盘的高度
 */
@property (nonatomic, assign) CGFloat                   keyboardViewHeight;
@property (nonatomic, assign) TextViewInputViewType     textViewInputViewType;

@property (nonatomic, strong) UIAlertView * resendAlertView;

@property (nonatomic, strong) UIRefreshControl * refreshControl;


@end

@implementation ChatViewController

#pragma mark - 处理耗时操作的线程
- (void)exDataQueue:(void (^)())queue {
    dispatch_async(_DataQueue, queue);
}
- (void)exMainQueue:(void (^)())queue {
    dispatch_async(dispatch_get_main_queue(), queue);
}



- (instancetype)initWithChatter:(NSString *)chatter type:(UCS_IM_ConversationType)type{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _chatType = type;
        _messages = [NSMutableArray array];
        _DataQueue = dispatch_queue_create("UCSIM", NULL);
        _firstInput = YES;
    }
    
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *ScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = ScrollView;
    [[UCSIMClient sharedIM] setDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    // 监听是否被移除讨论组
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removedADiscussion:) name:RemovedADiscussionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotice:) name:DidReciveNewMessageNotifacation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageDidCleanNotification:) name:ChatMessageDidCleanNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discussionNameChanged:) name:DiscussionNameChanged object:nil];

    [self.view addSubview:self.tableView];
    [self.view sendSubviewToBack:self.tableView];
    

    //从数据库中加载聊天消息
    [self loadMessages];
    
    
    //清空当前会话的所有未读消息
     WEAKSELF
    [self exDataQueue:^{
         BOOL ret = NO;
         ret = [[UCSIMClient sharedIM] clearConversationsUnreadCount:_chatType targetId:_chatter];
         if (ret) {
             [weakSelf exMainQueue:^{
                 //通知application的未读数 和 tabbarItem的未读数 改变
                  [[NSNotificationCenter defaultCenter] postNotificationName:UnReadMessageCountChangedNotification object:nil];
             }];
         }
     }];
    
    //设置聊天键盘的ui
    [self setup];
    
    [self setupBarButtonItem];
    
    
}


- (void)setup{
    
    //表情键盘和更多键盘的高度
    self.keyboardViewHeight = 216;
    // 设置Message TableView 的bottom edg
    CGFloat inputViewHeight = 46;
    [self setTableViewInsetsWithBottomValue:inputViewHeight];
    
    //初始化输入框高度
    if (!self.previousTextViewContentHeight){
        self.previousTextViewContentHeight = [self getTextViewContentH:self.chatToolBar.inputTextView];
    }
    
        WEAKSELF
 
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            CGRect inputViewFrame = weakSelf.chatToolBar.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            weakSelf.chatToolBar.frame = inputViewFrame;
        };
        
        self.tableView.keyboardDidScrollToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == TextViewTextInputType)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.tableView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            if (weakSelf.textViewInputViewType == TextViewTextInputType)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        self.tableView.keyboardWillBeDismissed = ^() {
            CGRect inputViewFrame = weakSelf.chatToolBar.frame;
            inputViewFrame.origin.y = weakSelf.view.bounds.size.height - inputViewFrame.size.height;
            weakSelf.chatToolBar.frame = inputViewFrame;
        };
    
    
    // block回调键盘通知
    self.tableView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        if (weakSelf.textViewInputViewType == TextViewTextInputType) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = weakSelf.chatToolBar.frame;
                                 CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = weakSelf.view.frame.size.height - inputViewFrame.size.height;
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 weakSelf.chatToolBar.frame = CGRectMake(inputViewFrame.origin.x,
                                                                              inputViewFrameY,
                                                                              inputViewFrame.size.width,
                                                                              inputViewFrame.size.height);
                                 
                                 [weakSelf setTableViewInsetsWithBottomValue:weakSelf.view.frame.size.height
                                  - weakSelf.chatToolBar.frame.origin.y];
                                 if (showKeyborad)
                                     [weakSelf scrollToBottomAnimated:NO];
                             }
                             completion:nil];
        }
    };
    
    self.tableView.keyboardDidChange = ^(BOOL didShowed) {
        if ([weakSelf.chatToolBar.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (weakSelf.textViewInputViewType == TextViewTextInputType) {
                    weakSelf.moreView.alpha = 0.0;
                    weakSelf.emojiKeyboardView.alpha = 0.0;
                }
            }
        }
    };
    
    self.tableView.keyboardDidHide = ^() {
        [weakSelf.chatToolBar.inputTextView resignFirstResponder];
    };
    

    
    
    // 设置手势滑动，默认添加一个bar的高度值
    self.tableView.messageInputBarHeight = CGRectGetHeight(self.chatToolBar.bounds);

    //因为使用了懒加载，但是在使用的时候进行加载会出现页面跳动，所以这里先加载
    self.moreView;
    self.emojiKeyboardView;
    
    //判断有没有草稿，有就加到输入框中
    [self exDataQueue:^{
        NSString * draft = [[UCSIMClient sharedIM] getTextMessageDraft:_chatType targetId:_chatter];
        [self exMainQueue:^{
            self.chatToolBar.inputTextView.text = draft;
            if (self.chatToolBar.inputTextView.text.length > 1000) {
                self.chatToolBar.inputTextView.textColor = [UIColor redColor];
            }else{
                self.chatToolBar.inputTextView.textColor = [UIColor blackColor];
            }
        }];
    }];
}




#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}




#pragma mark 私有方法

/**
 *  设置左上角的未读数
 */
- (void)setLeftItemUnreadCount:(int)unreadCount{
    
    BBBadgeBarButtonItem * item = (BBBadgeBarButtonItem *)self.navigationItem.leftBarButtonItems[1];
    item.badgeValue = [self unreadCountString:_otherUnreadCount];
}

/**
 *  根据未读数，得到显示的string
 */
- (NSString *) unreadCountString:(int) unreadCount{
    return [NSString stringWithFormat:@"%@", @"消息"];
}

/**
 *  判断是不是空 或者 空格
 */
-(BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

//设置导航栏
- (void)setupBarButtonItem
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 17)];
    [leftButton addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    BBBadgeBarButtonItem *leftBarItem = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:leftButton];
    leftBarItem.badgeValue = @"消息";
    leftBarItem.badgeBGColor = [UIColor clearColor];
    leftBarItem.badgeFont = [UIFont systemFontOfSize:16];
    leftBarItem.badgeOriginX = 13;
    leftBarItem.badgeOriginY = -5;
    leftBarItem.shouldAnimateBadge = NO;
    [self.navigationItem setCustomLeftBarButtonItem:leftBarItem];
    
    UIButton *rightButtom = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    rightButtom.imageView.contentMode = UIViewContentModeRight;
    switch (_chatType) {
        case UCS_IM_DISCUSSIONCHAT:
        {
            [rightButtom addTarget:self action:@selector(enterGroupDetail:) forControlEvents:UIControlEventTouchUpInside];
            [rightButtom setImage:[UIImage imageNamed:@"nav_discussion"] forState:UIControlStateNormal];
            UCSDiscussion * discussion;
            discussion = [[UCSIMClient sharedIM] getDiscussionInfoWithDiscussionId:_chatter];
            if (discussion.memberList.count <= 0) {
                UIBarButtonItem * rBtn = nil;
                [self.navigationItem setCustomRightBarButtonItem:rBtn];
            }else{
                UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtom];
                [self.navigationItem setCustomRightBarButtonItem:rightBarItem];
            }
            break;
        }
        case UCS_IM_GROUPCHAT:
            break;
        case UCS_IM_SOLOCHAT:
        {
            [rightButtom addTarget:self action:@selector(enterSingleDetail:) forControlEvents:UIControlEventTouchUpInside];
            [rightButtom setImage:[UIImage imageNamed:@"nav_singel"] forState:UIControlStateNormal];
            UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtom];
            [self.navigationItem setCustomRightBarButtonItem:rightBarItem];
            break;
        }
        default:
            break;
    }

    
    //初始化显示导航栏左上角的未读消息
    [self exDataQueue:^{
        _otherUnreadCount = [[UCSIMClient sharedIM] getTotalUnreadCount];
        [self exMainQueue:^{
            [self setLeftItemUnreadCount:_otherUnreadCount];
        }];
    }];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 初始化聊天背景
    [self setChatViewBackGroud];
    
    // 设置键盘通知或者手势控制键盘消失
    [self.tableView setupPanGestureControlKeyboardHide:YES];
    
    // KVO 检查contentSize
    [self.chatToolBar.inputTextView addObserver:self
                                          forKeyPath:@"contentSize"
                                             options:NSKeyValueObservingOptionNew
                                             context:nil];
    
    [self.chatToolBar.inputTextView setEditable:YES];
    

    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_backView removeFromSuperview];
    
    [self stopAudioPlaying];
    
    //使第三方view消失
    if (self.textViewInputViewType != TextViewNormalInputType) {
        [self layoutOtherMenuViewHiden:YES];
    }
    
    // remove键盘通知或者手势
    [self.tableView disSetupPanGestureControlKeyboardHide:NO];
    // remove KVO
    [self.chatToolBar.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [self.chatToolBar.inputTextView setEditable:NO];
    
    //保存草稿
    NSString * draft = self.chatToolBar.inputTextView.text;
    if (![self isEmpty:draft] ) { //保存草稿
        [[UCSIMClient sharedIM] saveTextMessageDraft:_chatType targetId:_chatter content:draft];
    }else{  //清除草稿
        [[UCSIMClient sharedIM] clearTextMessageDraft:_chatType targetId:_chatter];
    }

}

- (void)dealloc
{
    _backView = nil;
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    
    _audioManager.delegate = nil;
    _audioManager = nil;
    _photoReadManager = nil;
    _audioPlayManager = nil;
    _refreshControl = nil;
    
     [[NSNotificationCenter defaultCenter ] removeObserver:self];
}




- (void)enterSingleDetail:(UIButton *) sender{
    
    if (_chatType == UCS_IM_SOLOCHAT) {
        SingelChatDeltailViewController * singleDetailVC = [[SingelChatDeltailViewController alloc] initWithChatter:_chatter type:_chatType Flag:NO];
        [self.navigationController pushViewController:singleDetailVC animated:YES];
    }
}

- (void)enterGroupDetail:(UIButton *) sender{
    
    if (_chatType == UCS_IM_DISCUSSIONCHAT) {
        ChatDiscussionDetailViewController * discussionVC = [[ChatDiscussionDetailViewController alloc] initWithDiscussionId:_chatter type:_chatType];
        [self.navigationController pushViewController:discussionVC animated:YES];
    }else if (_chatType == UCS_IM_GROUPCHAT){
        
    }
}


#pragma mark 监控手机靠近、远离
-(void)sensorStateChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}



#pragma mark  懒加载

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (UIRefreshControl *)refreshControl{
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [UIColor lightGrayColor];
        [_refreshControl addTarget:self action:@selector(refreshLoadMore) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView addSubview:self.refreshControl];
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
        [_tableView addGestureRecognizer:tap];
        
    }
    
    return _tableView;
}

- (UCMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        
        // 设置Message TableView 的bottom edg
        CGFloat inputViewHeight = 46;
        // 输入工具条的frame
        CGRect inputFrame = CGRectMake(0.0f,
                                       self.view.frame.size.height - inputViewHeight,
                                       self.view.frame.size.width,
                                       inputViewHeight);
        
        
        _chatToolBar = [[UCMessageToolBar alloc] initWithFrame:inputFrame];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        [self.view addSubview:_chatToolBar];
    }
    
    [self.view bringSubviewToFront:_chatToolBar];
    
    return _chatToolBar;
}

- (EmojiKeyboardView *)emojiKeyboardView{
    if (_emojiKeyboardView == nil) {
        _emojiKeyboardView = (EmojiKeyboardView *)self.chatToolBar.faceView;
        _emojiKeyboardView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight);
        [self.view addSubview:_emojiKeyboardView];
    }
    [self.view bringSubviewToFront:_emojiKeyboardView];
    return _emojiKeyboardView;
}

- (UCChatBarMoreView *)moreView{
    if (_moreView == nil) {
        _moreView = [[UCChatBarMoreView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), self.keyboardViewHeight)];
        _moreView.backgroundColor = UIColorFromRGB(0xffffff);
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _moreView.delegate = self;
        [self.view addSubview:_moreView];
    }
    [self.view bringSubviewToFront:_moreView];
    return _moreView;
}


- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    return _chatTagDate;
}

- (AudioManage *)audioManager{
    if (_audioManager == nil) {
        _audioManager = [[AudioManage alloc] init];
        _audioManager.delegate = self;
    }
    
    return _audioManager;
}


- (photoReadManager *)photoReadManager{
    if (_photoReadManager == nil) {
        _photoReadManager = [photoReadManager shareManager];
    }
    
    return _photoReadManager;
}


- (AudioPlayManager *)audioPlayManager{
    if (_audioPlayManager == nil) {
        _audioPlayManager = [AudioPlayManager defaultManager];
        _audioPlayManager.audioManage = self.audioManager;
    }
    
    return _audioPlayManager;
}


- (ChatSendHelper *)sendHelper{
    if (_sendHelper == nil) {
        _sendHelper = [ChatSendHelper sharedChatSendHelper];
        _sendHelper.ChatViewDelegate = self;
    }
    return _sendHelper;
}





#pragma mark - GestureRecognizer

/*!
 *  @brief  隐藏键盘
 */
-(void)keyBoardHidden
{
    if (self.textViewInputViewType != TextViewNormalInputType) {
        [self layoutOtherMenuViewHiden:YES];
    }else{
//        [self.chatToolBar endEditing:YES];
    }
}
// 长按手势 删除操作
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[MessageModel class]]) {
            MessageModel* obj = (MessageModel*)object;
            if ((obj.type == MessageBodyType_Text)
                ||(obj.type == MessageBodyType_Image)
                ||(obj.type == MessageBodyType_Voice)
                ||(obj.type == MessageBodyType_Video)
                ||(obj.type == MessageBodyType_Location)
                ||(obj.type == MessageBodyType_File))
            {
                UCChatViewCell *cell = (UCChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell becomeFirstResponder];
                _longPressIndexPath = indexPath;
                [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
            }
            
        }
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (_forwardMenuItem == nil) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMenuAction:)];
    }
    
    if (_moreMenuItem == nil) {
        _moreMenuItem = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(moreMenuAction:)];
    }

    //暂时只开放删除和复制
    if (messageType == MessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}


#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    // todo by du. 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    _longPressIndexPath = nil;
    [_menuController setMenuItems:nil];
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:_longPressIndexPath.row];
        
        //获取这个model的message，并且移除
        [[UCSIMClient sharedIM] deleteMessages:_chatType targetId:_chatter messageId:model.messageId];
        UCSMessage * message = [self getMessageWithId:model.messageId];
        [_messages removeObject:message];
        
        
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:_longPressIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    _longPressIndexPath = nil;
    [_menuController setMenuItems:nil];
}

- (void)forwardMenuAction:(id)sender
{
    _longPressIndexPath = nil;
    [_menuController setMenuItems:nil];
}

- (void)moreMenuAction:(id) sender
{
    [_menuController setMenuItems:nil];
}



#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[NSString class]]) {   //显示时间
            NSString * timeIdentifier = @"timeIdentifierCell";
            UCChatTimeCell * timeCell = (UCChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:timeIdentifier];
            if (timeCell == nil) {
                timeCell = [[UCChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:timeIdentifier];
            }
            
            timeCell.time = (NSString *)obj;
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
            
            if (model.type == MessageBodyType_notification) { //系统通知
                NSString * notificationIdentifier = @"MessageCellNotificationCell";
                UCChatNotificationCell * cell = (UCChatNotificationCell*)[tableView dequeueReusableCellWithIdentifier:notificationIdentifier];
                if (cell == nil) {
                    cell = [[UCChatNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notificationIdentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.model = model;
                return cell;
                
                
            }else{   //会话消息
                NSString * messageIdentifier = [UCChatViewCell cellIdentifierForMessageModel:model];
                UCChatViewCell *cell = (UCChatViewCell *)[tableView dequeueReusableCellWithIdentifier:messageIdentifier];
                if (cell == nil) {
                    cell = [[UCChatViewCell alloc] initWithMessageModel:model reuseIdentifier:messageIdentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.messageModel = model;
                return cell;
            }
        }
    }
    
    return nil;
}


#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        MessageModel * model = (MessageModel*) obj;
        if (model.type == MessageBodyType_notification) {
            return [UCChatNotificationCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)model];
        }else{
          return [UCChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
        }
    }
}



#pragma mark UIResponder 获取对气泡的操作
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        UCChatImageBubbleView * bubbleView = [userInfo objectForKey:KPressedBubbleView];
        [self chatImageCellBubblePressed:model withBubble:bubbleView];
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        
        _chatTagDate = nil;
        _resendEventInfo = [userInfo copy];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重发这一条消息？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
        self.resendAlertView = alert;
        [alert show];
        
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    } else if([eventName isEqualToString:kRouterEventChatHeadImageTapEventName]) {
        if (!model.isSender) {
            BOOL tmp = !(model.message.conversationType == UCS_IM_SOLOCHAT);
            SingelChatDeltailViewController * singleDetailVC = [[SingelChatDeltailViewController alloc] initWithChatter:model.message.senderUserId
                                                                                                                   type:model.message.conversationType Flag:tmp];
            [self.navigationController pushViewController:singleDetailVC animated:YES];
        }
        
    }

}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    if (!model || !model.localPath) {
        return;
    }
    
    if (model.type == MessageBodyType_Voice) {
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [self.audioPlayManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            [self.audioManager playAmrFile:model.localPath];
            
        }else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    
}

- (void)chatVideoCellPressed:(MessageModel *)model{
 
    
    [self playVideoWithVideoPath:model.videoPath];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model withBubble:(UCChatImageBubbleView *) imageBubbleView
{
   
    if (model.type == MessageBodyType_Image) {

        if (model.imageRemoteURL && !model.isSender) {
            NSURL * url = model.imageRemoteURL;
            [self showBrowserWithImages:url];
        }else{
            NSString  * urlString = model.imageLocalPath;
            NSURL * url = [[NSURL alloc] initFileURLWithPath:urlString];
            [self showBrowserWithImages:url];
        }


    }else if (model.type == MessageBodyType_Video){
        
    }
}



#pragma mark UINavigationControllerDelegate


#pragma mark UCChatBarMoreViewDelegate
- (void)moreViewTakePicAction:(UCChatBarMoreView *)moreView{
    DDLogVerbose(@"moreViewTakePicAction");
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 打开相机
#if TARGET_IPHONE_SIMULATOR
    [MBProgressHUD showText:@"模拟器不支持相机" toView:self.view];
#elif TARGET_OS_IPHONE
    if (![self isCameraPermissions]) {
        return;
    }
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
    
}
// 检测是否打开相机权限
- (BOOL)isCameraPermissions
{
    BOOL ret = YES;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusAuthorized && authStatus != AVAuthorizationStatusNotDetermined)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机权限未打开，请到 设置->隐私->相机 中设置你的权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            ret = NO;
        }
    }
    return ret;
}

- (void)moreViewPhotoAction:(UCChatBarMoreView *)moreView{
    DDLogVerbose(@"moreViewPhotoAction");
    
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}
- (void)moreViewLocationAction:(UCChatBarMoreView *)moreView{
    DDLogVerbose(@"moreViewLocationAction");
    
    // 隐藏键盘
    [self keyBoardHidden];
}
- (void)moreViewVideoAction:(UCChatBarMoreView *)moreView{
    DDLogVerbose(@"moreViewVideoAction");
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [MBProgressHUD showText:@"模拟器不支持视频拍摄" toView:self.view];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
    
}
- (void)moreViewAudioCallAction:(UCChatBarMoreView *)moreView{
    DDLogVerbose(@"moreViewAudioCallAction");
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"实时语音功能还未开放" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [view show];
}

- (void)moreviewFileAction:(UCChatBarMoreView *)moreView{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件传输功能还未开放" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [view show];
}

- (void)moreviewCardAction:(UCChatBarMoreView *)moreView{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送名片功能还未开放" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [view show];
}

- (void)moreviewtakeShortVideoAction:(UCChatBarMoreView *)moreView{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短视频功能还未开放" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [view show];
}

- (void)moreviewvideoChatAction:(UCChatBarMoreView *)moreView{
    UIAlertView * view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"实时视频功能还未开放" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
    [view show];
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {   //使用了视频
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                DDLogVerbose(@"failed to remove file, error:%@.", error);
            }
        }
        
        // 发送视频
        [self sendVideo:mp4];
        
        
    }else{  // 使用了图片
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        //发送图片
        [self sendImage:orgImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - helper

// 转MP4
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    DDLogVerbose(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    DDLogVerbose(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    DDLogVerbose(@"completed.");
                } break;
                default: {
                    DDLogVerbose(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            DDLogVerbose(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

// 获取第一帧图片
-(UIImage *)getVideoImage:(NSString *)videoURL
{
    NSString* fileNoExtStr = [videoURL stringByDeletingPathExtension];
    NSString* imagePath = [NSString stringWithFormat:@"%@.jpg", fileNoExtStr];
    UIImage * returnImage = [[UIImage alloc] initWithContentsOfFile:imagePath] ;
    if (returnImage)
    {
        return returnImage;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil] ;
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    returnImage = [[UIImage alloc] initWithCGImage:image] ;
    CGImageRelease(image);
    [UIImageJPEGRepresentation(returnImage, 0.6) writeToFile:imagePath atomically:YES];
    return returnImage;
}





#pragma mark LocationViewDelegate

#pragma mark UCMessageToolBarDelegate

- (void)didStyleChangeToRecord:(BOOL)changedToRecord{
    
    if (changedToRecord) {
        if (self.textViewInputViewType == TextViewTextInputType)
            return;
        // 在这之前，textViewInputViewType已经不是XHTextViewTextInputType
        [self layoutOtherMenuViewHiden:YES];
    }
}

- (void)didSelectedFaceButton:(BOOL)isSelected{
    
    if (isSelected) {
        self.textViewInputViewType = TextViewFaceInputType;
        [self layoutOtherMenuViewHiden:NO];
    } else {
        [self.chatToolBar.inputTextView becomeFirstResponder];
    }
}

- (void)didSelectedMoreButton:(BOOL)isSelected{
    
    if (isSelected) {
        self.textViewInputViewType = TextViewMoreInputType;
        [self layoutOtherMenuViewHiden:NO];
    }else{
        [self.chatToolBar.inputTextView becomeFirstResponder];
    }
}


- (void)inputTextViewDidBeginEditing:(MessageTextView *)messageInputTextView{
    DDLogVerbose(@"inputTextViewDidBeginEditing %@", messageInputTextView.text);
    
    if (!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}


- (void)inputTextViewWillBeginEditing:(MessageTextView *)messageInputTextView{
    DDLogVerbose(@"inputTextViewWillBeginEditing %@", messageInputTextView.text);
    
    self.textViewInputViewType = TextViewTextInputType;
}


- (void)didSendText:(NSString *)text{

    if (text && text.length  > 0) {
        
        [self sendText:text];
    }
}


- (void)didSendFace:(NSString *)faceLocalPath{
    
}


#pragma mark 录音手指动作

/**
 *  按下手指开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView{
    
    //如果正在播放，就停止
    if (_isPlayingAudio) {
        [self stopAudioPlaying];
    }
    
    if ([self canRecord]) {
        UCRecordView *tmpView = (UCRecordView *)self.chatToolBar.recordView;
        CGPoint point = CGPointMake(self.view.center.x, self.view.center.y - 80);
        tmpView.center = point;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        
         [self.audioManager startRecord];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"麦克风权限未打开，请到 设置->隐私->麦克风 中设置你的权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

/**
 *  手指上滑取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView{
    
    [self.audioManager cancelRecord];
}

/**
 *  手指松开，完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView{
    
    [self.audioManager stopRecord];
}

- (void)didDragOutsideAction:(UIView *)recordView{

}

- (void)didDragInsideAction:(UIView *)recordView{
    
}


#pragma mark private
- (void)sendText:(NSString *) text{

    [self checkNetWork];
    UCSMessage * message = [self.sendHelper sendText:text conversationType:_chatType targetId:_chatter];
    [self addmessage:message];
}


- (void)sendVoice{
    [self checkNetWork];
    if (_recordDuration == 0) {
        return;
    }
    UCSMessage * message = [self.sendHelper sendVoice:self.audioManager.amrFileName duration:_recordDuration conversationType:_chatType targetId:_chatter];
    [self addmessage:message];
    _recordDuration = 0;
}


-(void)sendImage:(UIImage *) img{
    [self checkNetWork];
    UCSMessage * message = [self.sendHelper sendImage:img conversationType:_chatType targetId:_chatter];
    [self addmessage:message];
}


- (void)sendVideo:(NSURL *) videoPath{
}


- (void)sendChatLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address{
    
}


/*!
 *  @brief  重发消息
 *
 *  @param info 点击事件中传递的info
 */
- (void)resendMessageWithEventInfo:(NSDictionary *) info{
    
    WEAKSELF
    [self exDataQueue:^{
        
        UCChatViewCell *resendCell = [info objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        
        UCSMessage * message = [self getMessageWithId:messageModel.messageId];
        [_messages removeObject:message];
        
        message.sentStatus = SendStatus_sending;
        message.time = [NSDate date].timeIntervalSince1970;
        [_messages addObject:message];
        NSArray * newDataSource = [self formatMessages:_messages];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:newDataSource];
        
        [weakSelf exMainQueue:^{
            [weakSelf.tableView reloadData];
            [weakSelf scrollToBottomAnimated:YES];
        }];
        
        //重发消息
        [weakSelf resendMessage:messageModel];
        
    }];
}

/**
 *   重发一条消息
 */
- (void)resendMessage:(MessageModel*) model{
    
    [self checkNetWork];
    //数据库中删除旧消息
    BOOL success = [[UCSIMClient sharedIM] deleteMessages:_chatType targetId:_chatter messageId:model.messageId];
    
    if (!success) {
        DDLogVerbose(@"删除失败");
    }
    
    UCSMessage * message = model.message;
    long long oldMessageId = message.messageId;
    [self.sendHelper resendMessage:message oldMessageId:oldMessageId];
}





/*!
 *  @brief  检查消息之间的间隔，超过一定时间，填充时间,用于加载消息的时候使用
 */
- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (UCSMessage *message in messagesArray) {
            NSTimeInterval time = message.time;
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)time];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 * 4 || tempDate < -60 * 4 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}


/*!
 *  @brief  检查消息之间的时间间隔，填充时间，发送的时候使用
 */
-(NSMutableArray *)formatMessage:(UCSMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSTimeInterval time = message.time;
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)time];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 * 4 || tempDate < -60 *  4 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}


#pragma mark 展示大图

- (void)showBrowserWithImages:(NSURL *) seletedUrl
{
    NSUInteger i = 0;
    NSUInteger index = 0;
    
    //先取到所有大图url,加入一个数组
    NSMutableArray * urlArray = [NSMutableArray array];
    for (id  obj  in self.dataSource) {
        if (![obj isKindOfClass:[MessageModel class]]) {
            continue;
        }
        
        MessageModel * model = (MessageModel *) obj;
        if (model.type == MessageBodyType_Image) {
           
            NSURL *url ;
            
            if (model.isSender && model.imageLocalPath) {
                url = [[NSURL alloc] initFileURLWithPath:model.imageLocalPath];
                
            }else {
                
                if (model.imageRemoteURL) {
                    url = model.imageRemoteURL;
                }
            }
            
            if ([url isEqual:seletedUrl]) {
                index = i;
            }
            
            i++;
            [urlArray addObject:url];
        }

    }
    
    NSArray * array = [urlArray copy];

    [self.photoReadManager showBrowserWithImages:array index:index];
}



// 消息加入数组
- (void)addmessage:(UCSMessage *) message{
    if (message == nil) {
        return;
    }
    WEAKSELF
    [self exDataQueue:^{
        [_messages addObject:message];
        NSArray *messages = [weakSelf formatMessage:message];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        [weakSelf exMainQueue:^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
            [weakSelf.tableView endUpdates];
            [weakSelf scrollToBottomAnimated:YES];
        }];
    }];

}


- (void)popViewController:(UIButton *) sender;
{
    //清除当前会话的所有消息的未读状态
    WEAKSELF
    [self exDataQueue:^{
        BOOL ret = NO;
        ret = [[UCSIMClient sharedIM] clearConversationsUnreadCount:_chatType targetId:_chatter];
        
        if (ret) {
            [weakSelf exMainQueue:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UnReadMessageCountChangedNotification object:nil];
            }];
        }
    }];
    
    // 返回到消息会话页面
    [self.navigationController popViewControllerAnimated:YES];
    
}




/*!
 *  @brief  加载更多
 */
- (void)refreshLoadMore{
    
    _chatTagDate = nil;
    
    WEAKSELF
    [self exDataQueue:^{
       
        UCSMessage * firstModel = [_messages firstObject];
        long long oldestMessageId = firstModel.messageId;
        NSArray * oldMessages = [[UCSIMClient sharedIM] getHistoryMessages:_chatType targetId:_chatter oldestMessageId:oldestMessageId count:10];

        if (oldMessages.count>0) {
            //插入消息队列中
            NSMutableArray * tempMessages = [oldMessages mutableCopy];
            [tempMessages addObjectsFromArray:[_messages copy]];
            
            _messages = [tempMessages mutableCopy];
            
            NSInteger currentCount = [weakSelf.dataSource count];
            weakSelf.dataSource = [[weakSelf formatMessages:tempMessages] mutableCopy];
            
            [weakSelf exMainQueue:^{
                
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                 [weakSelf.refreshControl endRefreshing];
                
            }];
            
        }else{
            [weakSelf exMainQueue:^{
                [weakSelf.refreshControl endRefreshing];
            }];
        }
        
    }];
    
}


/*!
 *  @brief  第一次加载
 */
- (void)loadMessages{
    
    WEAKSELF
    [self exDataQueue:^{
        
        NSArray * messages = [[UCSIMClient sharedIM] getLatestMessages:_chatType targetId:_chatter count:10];
        
        if (messages.count > 0) {
            weakSelf.messages = [messages mutableCopy];
            weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            
            [weakSelf exMainQueue:^{
                
                [weakSelf.tableView reloadData];
                [self scrollToBottomAnimated:NO];
            }];
        }
    }];
    
}

#pragma mark 发送前检测网络情况
- (void)checkNetWork{
    if ([WatchDog sharedWatchDog].haveNetWork) {
        [MBProgressHUD showNoNetWork:@"网络连接不可用,消息可能发送失败，请检查网络" toView:self.view];
    }
}




#pragma mark 停止音频播放
- (void)stopAudioPlaying
{
    //停止音频播放及播放动画
    [self.audioManager stopPlaying];
    _isPlayingAudio = NO;
    MessageModel *playingModel = [self.audioPlayManager stopMessageAudioModel];
    
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

#pragma mark 停止录制音频
-(void)stopAudioRecoding{
    [self.audioManager stopRecord];
    
    UCRecordView *tmpView = (UCRecordView *)self.chatToolBar.recordView;
    if (tmpView.superview == self.view) {
        [tmpView removeFromSuperview];
    }
    
}

#pragma mark 判断能不能录音
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}




/*!
 *  @brief  根据messageid 在 _messages中获取对应的message
 */
- (UCSMessage *)getMessageWithId:(long long)messageId{
    UCSMessage * message = nil;
    for (id obj in _messages) {
        if ([obj isKindOfClass:[UCSMessage class]]) {
            message = (UCSMessage *)obj;
            if (message.messageId == messageId) {
                return message;
            }
        }
    }
    
    return nil;
}


/*!
 *  @brief  发送消息成功，刷新视图
 */
- (void)didSendMessage:(UCSMessage *)message{
    
    WEAKSELF
    [self exDataQueue:^{
        
        if ([weakSelf.chatter isEqualToString:message.receiveId])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel *currentModel = [weakSelf.dataSource objectAtIndex:i];
                    if (message.messageId == currentModel.messageId) {
                        
                        [self updateMessages:message dataSource:currentModel success:YES];
                        
                        [weakSelf exMainQueue:^{
                            [weakSelf.tableView reloadData];
                        }];
                        
                        break;
                    }
                }
            }
        }
        
    }];
}


/*!
 *  @brief  发送消息失败，刷新视图
 */
- (void)didFalureToSendMessage:(UCSMessage *) message error:(UCSErrorCode ) error{
    
    WEAKSELF
    [self exDataQueue:^{
        
        if (error && [message.receiveId isEqualToString: weakSelf.chatter]) {
            
            for (int i = 0; i < weakSelf.dataSource.count; i++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel * currentModel = [weakSelf.dataSource objectAtIndex:i];
                    if (message.messageId == currentModel.messageId) {
                        
                        [self updateMessages:message dataSource:currentModel success:NO];
                        
                        [weakSelf exMainQueue:^{
                            [weakSelf.tableView reloadData];
                        }];
                        break;
                    }
                }
            }
        }
    }];
    
}



/*!
 *  @brief  返回消息发送结果后，更新messages 和 DataSource中对应的数据源
 */
- (void)updateMessages:(UCSMessage *) message dataSource:(MessageModel *) model  success:(BOOL) success{
    
    if (_resendNewMessageId && _resendNewMessageId > 0) {
        message.messageId = _resendNewMessageId;
        message.time = [NSDate date].timeIntervalSince1970;
        model.messageId = _resendNewMessageId;
        model.timestamp = [NSDate date].timeIntervalSince1970;
    }
    
    model.status = (success)? MessageDeliveryState_Delivered : MessageDeliveryState_Failure;
}



#pragma mark AudioPlayerViewControllerDelegate
/*!
 *  @brief  录音结束后回调, 参数isFinished, 成功时为TRUE, 失败时为FALSE
 */
- (void)audioRecordFinished:(BOOL)isFinished{
    if (isFinished == false) {
        [MBProgressHUD showText:@"录音时间太短，请稍做增长" toView:self.view];
        return;
    }
     [self sendVoice];
}


/*!
 *  @brief  录音超时后回调, 没有超时时不回调
 */
- (void)audioRecordOverTime{
    
    //超时后还是取消振幅图片
    UCRecordView *tmpView = (UCRecordView *)self.chatToolBar.recordView;
    if (tmpView.superview == self.view) {
        [tmpView removeFromSuperview];
    }
}


/*!
 *  @brief  录音过程中的音频振幅(注意:振幅是时刻变化的)
 */
- (void)audioRecordChannel:(double)channel{
    
    // 振幅调整，主线程
    WEAKSELF
    [self exMainQueue:^{
        if ([self.chatToolBar.recordView  isKindOfClass:[UCRecordView class]]) {
            [(UCRecordView *)weakSelf.chatToolBar.recordView  setVoiceImage:channel];
        }
    }];
    
}



/*!
 *  @brief  录音时间 时时更新 秒计数     每0.5s得到一次currenttim，最后一次也就是总时间
 */
- (void)audioRecordingTime:(double)time{
    _recordDuration = time;
    if (time >=50) {
        WEAKSELF
        [self exMainQueue:^{
            if ([weakSelf.chatToolBar.recordView  isKindOfClass:[UCRecordView class]]) {
                [(UCRecordView *)weakSelf.chatToolBar.recordView  setlableText:time];
            }
        }];
    }
    
}


/*!
 *  @brief  录音播放结束后回调.
 */
- (void)audioPlayFinished{

    [self stopAudioPlaying];
}




#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    [self sendChatLocationLatitude:latitude longitude:longitude andAddress:address];
}




#pragma mark 通知

/*!
 *  @brief  程序激活，刷新数据，
 */
- (void)applicationDidBecomeActive
{
    _chatTagDate = nil;
//    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
}

/*!
 *  @brief  程序失活，被打断，防止bug
 */
- (void)applicationWillResignActive
{
    //打断录音
    [self stopAudioRecoding];
    
    //打断播放
    if (_isPlayingAudio) {
        [self stopAudioPlaying];
    }
}

/*!
 *  @brief  清空了消息，收到通知，刷新
 */
- (void)chatMessageDidCleanNotification:(NSNotification *) note{
    
    if ([(NSString *)note.object isEqualToString:_chatter]) {
        _chatTagDate = nil;
        
        [_messages removeAllObjects];
        [_dataSource removeAllObjects];
        [_tableView reloadData];
    }
}

/*!
 *  @brief  讨论组名称被修改了
 */
- (void)discussionNameChanged:(NSNotification *) note{
    self.title = (NSString * )note.object;
}

/*!
 *  @brief  被踢出讨论组了 隐藏查看讨论组详情按钮
 */
- (void)removedADiscussion:(NSNotification *) note
{
    NSString * discussionId = (NSString *)note.object;
    if ([_chatter isEqualToString:discussionId]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBarButtonItem * rBtn = nil;
            [self.navigationItem setCustomRightBarButtonItem:rBtn];
        });
    }
}

/*!
 *  @brief  收到消息的通知
 */
- (void)didReceiveMessageNotice:(NSNotification *) note{

        UCSMessage * msgEntity = (UCSMessage *)note.object;
        if ((msgEntity.conversationType == UCS_IM_SOLOCHAT  && [msgEntity.senderUserId isEqualToString:_chatter])
            || (msgEntity.conversationType == UCS_IM_DISCUSSIONCHAT && [msgEntity.receiveId isEqualToString:_chatter])
            || (msgEntity.conversationType == UCS_IM_GROUPCHAT && [msgEntity.receiveId isEqualToString:_chatter]))
        {
            [self addmessage:msgEntity];
            
        }else{
            
            [self exMainQueue:^{
                _otherUnreadCount++;
                [self setLeftItemUnreadCount:_otherUnreadCount];
            }];
        }

}


/*!
 *  @brief  设置聊天背景
 */
- (void)setChatViewBackGroud{
    WEAKSELF
    [self exDataQueue:^{
        UIImage * img = nil;
        img = [[InfoManager sharedInfoManager] chatViewBgImageWithTargetId:_chatter];
        [weakSelf exMainQueue:^{
            if (_backView.superview == nil) {
                _backView = [[UIImageView alloc] initWithFrame:self.view.bounds];
                _backView.userInteractionEnabled = YES;
                _backView.contentMode = UIViewContentModeScaleAspectFill;
                [self.view insertSubview:_backView belowSubview:self.tableView];
            }
            _backView.image = img;
            
        }];
    }];
}




#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self keyBoardHidden];
}




#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView == self.resendAlertView) {
        if (buttonIndex == 1) {
            [self resendMessageWithEventInfo:_resendEventInfo];
        }
    }
}


#pragma mark - tableview scroll
- (void)scrollToBottomAnimated:(BOOL)animated {
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                     atScrollPosition:UITableViewScrollPositionBottom
                                             animated:animated];
    }
}

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
              atScrollPosition:(UITableViewScrollPosition)position
                      animated:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:indexPath
                                 atScrollPosition:position
                                         animated:animated];
}


#pragma mark 获取textView的高度
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}




#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    //输入框允许的最大高度
    CGFloat maxHeight = [UCMessageToolBar maxHeight];
    //当前输入框需要的高度
    CGFloat contentH = [self getTextViewContentH:textView];
    
    // 是否是删除收缩
    BOOL isShrinking = contentH < self.previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             // 设置tableview的inset，联动性更好
                             [self setTableViewInsetsWithBottomValue:self.tableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.chatToolBar adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.chatToolBar.frame;
                             self.chatToolBar.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.chatToolBar adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    

    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height );
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}



#pragma mark - Other Menu View Frame Helper Mehtod

- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    //取消第一响应者
    [self.chatToolBar.inputTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = self.chatToolBar.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            self.chatToolBar.frame = inputViewFrame;
        };
        
        void (^FaceViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.emojiKeyboardView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.chatToolBar.faceButton.selected = !hide;
            self.emojiKeyboardView.alpha = !hide;
            self.emojiKeyboardView.frame = otherMenuViewFrame;
        };
        
        void (^MoreViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.moreView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.chatToolBar.moreButton.selected = !hide;
            self.moreView.alpha = !hide;
            self.moreView.frame = otherMenuViewFrame;
        };
        
        if (hide) {
            switch (self.textViewInputViewType) {
                case TextViewFaceInputType: {
                    FaceViewAnimation(hide);
                    break;
                }
                case TextViewMoreInputType: {
                    MoreViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        } else {
            
            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
            switch (self.textViewInputViewType) {
                case TextViewFaceInputType: {
                    // 1、先隐藏和自己无关的View
                    MoreViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    FaceViewAnimation(hide);
                    break;
                }
                case TextViewMoreInputType: {
                    // 1、先隐藏和自己无关的View
                    FaceViewAnimation(!hide);
                    // 2、再显示和自己相关的View
                    MoreViewAnimation(hide);
                    break;
                }
                default:
                    break;
            }
        }
        
        InputViewAnimation(hide);

        if (_firstInput)
        {
            [self.tableView  reloadData];
            if (_dataSource.count >10)
            {
                _firstInput = NO;
                
            }
        }
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.chatToolBar.frame.origin.y];
        
        [self scrollToBottomAnimated:NO];
    } completion:^(BOOL finished) {
        if (hide) {
            self.textViewInputViewType = TextViewNormalInputType;
        }
    }];
}



#pragma mark ChatSendHelperDelegate

/*!
 *  @brief  发送消息状态回调
 */
- (void)chatSendHelper:(ChatSendHelper *)sendHelper sendStatusDidChanged:(BOOL)success MessageId:(long long)messageId error:(UCSErrorCode)error
{
    
    UCSMessage * sendMsg = [self getMessageWithId:messageId];
    if (sendMsg== nil) {
        return ;
    }
    
    _resendNewMessageId = 0;
    
    if (success) {
        sendMsg.sentStatus = SendStatus_success;
        [self didSendMessage:sendMsg];
        
    }else{
        sendMsg.sentStatus = SendStatus_fail;
        [self didFalureToSendMessage:sendMsg error:error];
    }
}

/*!
 *  @brief  重发消息状态回调
 */
- (void)chatSendHelper:(ChatSendHelper *)sendHelper reSendStatusDidChanged:(BOOL)success oldMessageId:(long long)oldMessageId newMessageId:(long long)newMessageId error:(UCSErrorCode)error
{
    UCSMessage * sendMsg = [self getMessageWithId:oldMessageId];
    if (sendMsg== nil) {
        return ;
    }
    
    _resendNewMessageId = newMessageId;
    
    if (success) {

        sendMsg.sentStatus = SendStatus_success;
        [self didSendMessage:sendMsg];
        
    }else{
        
        sendMsg.sentStatus = SendStatus_fail;
        [self didFalureToSendMessage:sendMsg error:error];
    }
}



#pragma mark - Key-value Observing
//kvo检测textview的高度改变
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.chatToolBar.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

- (void)didReceiveMessages:(NSArray *)messgeArray
{
    NSNotification *item = [NSNotification notificationWithName:DidReciveNewMessageNotifacation object:messgeArray[0]];
    [[NSNotificationCenter defaultCenter] postNotification:item];
}

- (void)didRemoveFromDiscussionWithDiscussionId:(NSString *)discussionID
{
    NSNotification *item = [NSNotification notificationWithName:RemovedADiscussionNotification object:discussionID];
    [[NSNotificationCenter defaultCenter] postNotification:item];
}

@end
