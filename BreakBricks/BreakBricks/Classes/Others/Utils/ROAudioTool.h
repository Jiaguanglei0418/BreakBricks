//
//  ROAudioTool.h
//  01-音效播放
//
//  Created by jiaguanglei on 15/9/24.
//  Copyright (c) 2015年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ROAudioTool : NSObject

/**
 *  播放音效
 *  传入需要播放的音效名称
 */
+ (void)playAudioWithFilename:(NSString *)filename;

/**
 *  销毁文件
 */
+ (void)disposeAudioWithFilename:(NSString *)filename;


// 根据音乐文件名称播放音乐
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称暂停音乐
+ (void)pauseMusicWithFilename:(NSString  *)filename;

// 根据音乐文件名称停止音乐
+ (void)stopMusicWithFilename:(NSString  *)filename;

@end
