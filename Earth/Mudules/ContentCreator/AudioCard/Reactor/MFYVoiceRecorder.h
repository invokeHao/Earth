//
//  MFYVoiceRecorder.h
//  Earth
//
//  Created by colr on 2020/2/17.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYVoiceRecorder : NSObject

@property (nonatomic, copy, readonly) NSString *audiofilePath;
@property (nonatomic, copy, readonly) NSString *mp3Path;

- (void)startRecord;

- (void)stopRecord;

- (NSString *)audioCAFtoMP3;

@end

NS_ASSUME_NONNULL_END
