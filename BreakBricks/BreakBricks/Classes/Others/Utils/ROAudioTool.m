//
//  ROAudioTool.m
//  01-音效播放
//
//  Created by jiaguanglei on 15/9/24.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import "ROAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation ROAudioTool

 /**  声明私有的成员变量 ***/
static NSMutableDictionary *_soundIDs;

static NSMutableDictionary *_players;

/**
 *  保证soundIDs, 只创建1次
 */
+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    
    // 为了保证后台播放, 设置会话类型
    // 1. 创建音频会话
    AVAudioSession *session = [[AVAudioSession alloc] init];
    
    // 2. 设置会话类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 3. 激活会话
    [session setActive:YES error:nil];
}

//#warning /**  与initialize, 异曲同工, 但是调用 soundID的时候不能直接用 _soundID, 必须采用[self soundID], 否则直接调用静态变量 _soundID, 每次都创建一个 _soundID, 不会调用此方法***/
//+ (NSMutableDictionary *)soundIDs
//{
//    if (!_soundIDs) {
//        _soundIDs = [NSMutableDictionary dictionary];
//    }
//    return _soundIDs;
//}


+ (void)playAudioWithFilename:(NSString *)filename
{
    /*
    // 0. 创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    // 1. 创建音效ID
    SystemSoundID outSystemSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &outSystemSoundID);
    
    // 2. 播放本地音效
    // AudioServicesPlayAlertSound(nil)  ---- 既播放又振动
    // [注意] iOS8 模拟器不支持播放音效
    AudioServicesPlaySystemSound(outSystemSoundID);
     */
    
    // 1. 从字典中取soundID
    // 1.1 判断文件名是否为空
    if (filename == nil) return;
    SystemSoundID outSystemSoundID = [_soundIDs[filename] unsignedIntValue];
    
    // 1.2 判断soundID是否为空
    if (!outSystemSoundID) {
//        LogRed(@"创建新的soundID");
        
        // 如果ID为空, 根据文件名创建url
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 1.3 判断URL是否为nil
        if(url == nil) return;
        
        // 1.4 根据url创建soundID 并添加到字典中
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &outSystemSoundID);
        
        _soundIDs[filename] = @(outSystemSoundID);
    }
    
    // 2. 播放soundID
    AudioServicesPlaySystemSound(outSystemSoundID);
    
}

/**
 *  根据filename 销毁soundID
 */
+ (void)disposeAudioWithFilename:(NSString *)filename{
    if(filename == nil)return;
    
    // 1. 取出soundID
    SystemSoundID outSystemSoundID = [_soundIDs[filename] unsignedIntValue];
    
    if (outSystemSoundID) {
        // 2. 销毁soundID
        AudioServicesDisposeSystemSoundID(outSystemSoundID);
        
        // 3. 从字典中移除已经销毁的SoundID
        [_soundIDs removeObjectForKey:filename];
    }
}


//--------------------------------------------------------
+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}

// 根据音乐名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return nil;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (!player) {
//        NSLog(@"创建新的播放器");
        
        // 2.1根据文件名称加载音效URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        
        // 2.2判断url是否为nil
        if (!url) {
            return player;
        }
        
        // 2.3创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        // 2.4准备播放
        if(![player prepareToPlay])
        {
            return nil;
        }
        // 允许快进
        player.enableRate = NO;
        player.rate = 3;
        
        // 2.5将播放器添加到字典中
        [self players][filename] = player;
        
    }
    // 3.播放音乐
    if (!player.playing)
    {
        [player play];
    }
    
    return player;
}


// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否存在
    if(player)
    {
        // 2.1判断是否正在播放
        if (player.playing)
        {
            // 暂停
            [player pause];
        }
    }
    
}

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename
{
    // 0.判断文件名是否为nil
    if (filename == nil) {
        return;
    }
    
    // 1.从字典中取出播放器
    AVAudioPlayer *player = [self players][filename];
    
    // 2.判断播放器是否为nil
    if (player) {
        // 2.1停止播放
        [player stop];
        // 2.2清空播放器
        //        player = nil;
        // 2.3从字典中移除播放器
        [[self players] removeObjectForKey:filename];
    }
}
@end
