//
//  OSServerDataRateController.h
//  IPEYEDahua
//
//  Created by Roman Solodyashkin on 21.10.2020.
//

#import <Foundation/Foundation.h>
#import <IPEYEDahua/OSServerDataRateProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSServerDataRateController : NSObject
@property (nonatomic, strong, readonly) NSURLSession* session;

/// EX: https://DOMAIN/api/speed_test.php
- (NSURLSessionUploadTask*)calcUploadDataRateWithDelegate:(id<OSServerDataRateDelegate>)delegate request:(NSURLRequest*)request;

/// EX: https://DOMAIN/api/speed_test.php?download=1048576
- (NSURLSessionDownloadTask*)calcDownloadDataRateWithDelegate:(id<OSServerDataRateDelegate>)delegate request:(NSURLRequest*)request;

@end

NS_ASSUME_NONNULL_END
