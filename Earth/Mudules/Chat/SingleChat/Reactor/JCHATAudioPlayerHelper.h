//
//  JCHATAudioPlayerHelper.h
//  Earth
//
//  Created by colr on 2020/2/29.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XHAudioPlayerHelperDelegate <NSObject>

@optional
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer;
- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer;

@end

@interface JCHATAudioPlayerHelper : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *playingFileName;

@property (nonatomic, assign) id <XHAudioPlayerHelperDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *playingIndexPathInFeedList;//给动态列表用

+ (id)shareInstance;

- (AVAudioPlayer*)player;
- (BOOL)isPlaying;

- (void)managerAudioWithFileName:(NSString*)amrName toPlay:(BOOL)toPlay;
- (void)managerAudioWithData:(NSData *)data toplay:(BOOL)toPlay;
- (void)pausePlayingAudio;//暂停
- (void)stopAudio;//停止


@end

NS_ASSUME_NONNULL_END
