//
//  TFirmwareInfo.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 30.06.2020.
//  Copyright © 2020 KONSTANTA, OOO Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int32_t, TFirmwareInfoType) {
    TFirmwareInfoTypeUnknown,
    TFirmwareInfoTypeBullet,
    TFirmwareInfoTypeBulletOld, /// old versions for tests downgrade->upgrade
    TFirmwareInfoTypeHome = 100,
    TFirmwareInfoTypeHomeOld,
};

typedef NS_ENUM(NSUInteger, TFirmwareState) {
    TFirmwareStateUnknown,
    TFirmwareStateDeprecated,
    TFirmwareStateUpToDate,
};

NS_ASSUME_NONNULL_BEGIN

@interface TFirmwareInfo : NSObject <NSCoding>
@property (nonatomic, assign) TFirmwareInfoType type;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSDate *buildDate;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSURL *localCacheFile;
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *fetchTask;

+ (instancetype)infoWithJSON:(NSDictionary*)json typeKey:(NSString*)typeKey;
+ (NSDictionary<NSNumber *,TFirmwareInfo *> *)cachedInfos;
- (NSURLSessionDownloadTask*)fetch:(void(^)(TFirmwareInfo *info,NSError *error))cb;
- (void)save;
- (void)remove;
- (BOOL)cached;
@end

NS_ASSUME_NONNULL_END
