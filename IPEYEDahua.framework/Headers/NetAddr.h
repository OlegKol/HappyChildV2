//
//  NetAddr.h
//  IPEye
//
//  Created by Roman Solodyashkin on 8/30/17.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NetAddrNetType) {
    NetAddrNetTypeUnknown,
    NetAddrNetTypeCelluar,
    NetAddrNetTypeWiFi,
    NetAddrNetTypeVPN,
};


@interface NetAddr : NSObject
@property (nonatomic, assign) struct sockaddr addr;
@property (nonatomic, readonly) NSString *ipString;
@property (nonatomic, readonly) NSString *macString;
@property (nonatomic, readonly) NetAddrNetType ntype;

- (id)initWithAddr:(struct sockaddr*)addr;

+ (instancetype)defaultGateway;
+ (instancetype)ipAddressWiFi;
+ (instancetype)ipAddressCelluar;
+ (instancetype)ipAddressVPN;

+ (NSString*)localWiFiSSID;
+ (BOOL)localWiFiSSIDIsEqualToSSID:(NSString*)ssid;
+ (BOOL)isWiFiEnabled;
+ (NSString*)randomMAC;
@end
