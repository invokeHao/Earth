//
//  MFYAudioDisplayView.h
//  Earth
//
//  Created by colr on 2020/2/16.
//  Copyright © 2020 fuYin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFYAudioDisplayView : UIView

-(void)reloadDataWithArray:(NSArray*)arr;

- (void)playTheAudio;

- (void)stopTheAudio;

@end

NS_ASSUME_NONNULL_END
