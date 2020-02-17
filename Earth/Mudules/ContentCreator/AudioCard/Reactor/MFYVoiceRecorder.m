//
//  MFYVoiceRecorder.m
//  Earth
//
//  Created by colr on 2020/2/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import "MFYVoiceRecorder.h"
#import "lame.h"

static NSString *AudioFileName = @"voice_tmp";
static CGFloat const MAXRecordTime = 60.0f;

@interface MFYVoiceRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *voiceRecorder;
@property (nonatomic, strong) AVAudioSession *voiceSession;

@end

@implementation MFYVoiceRecorder


#pragma mark - Publics

- (void)startRecord {
    if (self.voiceRecorder.recording) {
        [self.voiceRecorder stop];
    }
    [self.voiceRecorder record];
}

- (void)stopRecord {
    [self.voiceRecorder stop];
}

- (NSString *)audioCAFtoMP3 {
    NSString *cafFilePath = [self audiofilePath];
    NSString *mp3FilePath = [self mp3Path];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil]){
        NSLog(@"删除原MP3文件");
    }
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame,1);//设置1为单通道，默认为2双通道
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        
        lame_set_brate(lame,8);
        
        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);
        
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"convert Mp3 exception : %@",[exception description]);
    }
    @finally {
        NSLog(@"convert Mp3 file: %@", mp3FilePath);
        return mp3FilePath;
    }
}

#pragma mark - Accessors

- (AVAudioRecorder *)voiceRecorder {
    if (!_voiceRecorder) {
        NSError *recorderSetupError = nil;
        NSURL *url = [NSURL fileURLWithPath:self.audiofilePath];
        NSLog(@"file url : %@", url);
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        //录音格式 无法使用
        [settings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        //采样率
        [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];//44100.0
        //通道数
        [settings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //音频质量,采样质量
        [settings setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderBitRateKey];
        
        _voiceRecorder = [[AVAudioRecorder alloc] initWithURL:url
                                                     settings:settings
                                                        error:&recorderSetupError];
        if (recorderSetupError) {
            NSLog(@"recorderSetupError:%@", recorderSetupError);
        }
        
        _voiceRecorder.meteringEnabled = YES;
        _voiceRecorder.delegate = self;
        [_voiceRecorder prepareToRecord];
        
        //创建会话
        [self startVoiceSession];
    }
    return _voiceRecorder;
}

- (void)startVoiceSession {
    self.voiceSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [self.voiceSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&sessionError];
    if (!sessionError) {
        [self.voiceSession setActive:YES error:nil];
    } else {
        NSLog(@"Error creating voice session: %@", [sessionError description]);
    }
}

- (NSString *)audiofilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", AudioFileName, @"caf"]];
}

- (NSString *)mp3Path {
    NSString *mp3Path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", AudioFileName, @"mp3"]];
    return mp3Path;
}


@end
