//
//  TDahuaAudioConfig.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 26.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDahuaCamBlank;
@class TDahuaAudioConfig;

NS_ASSUME_NONNULL_BEGIN

@protocol TDahuaAudioConfigDelegate <NSObject>
@required
- (void)TDahuaAudioConfigComplete:(TDahuaAudioConfig*)config error:(NSError*_Nullable)error;
@end

@interface TDahuaAudioConfig : NSObject
@property (nonatomic, strong, readonly) TDahuaCamBlank* blank;
@property (nonatomic, strong, readonly) NSString *file;
@property (nonatomic, weak) id <TDahuaAudioConfigDelegate> delegate;
+ (instancetype)configWithDahuaCamBlank:(TDahuaCamBlank*)blank delegate:(id <TDahuaAudioConfigDelegate>)delegate;
- (void)createAudioFileAsync;
@end

NS_ASSUME_NONNULL_END
