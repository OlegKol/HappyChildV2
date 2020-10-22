//
//  TDahuaCamBlank.h
//  IPEYE
//
//  Created by Roman Solodyashkin on 18.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDahuaCamBlank;
@class TFirmwareInfo;

NS_ASSUME_NONNULL_BEGIN

/// A 0-length SSID indicates the wildcard SSID
/// http://standards.ieee.org/getieee802/download/802.11-2007.pdf
FOUNDATION_EXTERN NSInteger const TWIFI_SSID_MIN;
FOUNDATION_EXTERN NSInteger const TWIFI_SSID_MAX;
FOUNDATION_EXTERN NSInteger const TWIFI_SECURITY_KEY_MIN;
FOUNDATION_EXTERN NSInteger const TWIFI_SECURITY_KEY_MAX;
FOUNDATION_EXTERN NSString *const DahuaFirmwareVersionRegexPattern;

#if DEBUG
/// bug in some firmware wifi-name delimeter "_" instead of "-"
#define DAHUA_CAM_WIFI_NAME_DELIMETER_UNDERLINE 0
#define DAHUA_FIRMWARE_CLEAR_CACHED_BIN 0
#endif

// ----------------------------------------------------------------------------------------------------
//
#define TADD_CAM_FW_UPDATE_ON 1
//
// https://XXX/api/mobile.php?request=firmware
// ----------------------------------------------------------------------------------------------------

FOUNDATION_EXTERN int ipeye_dahua_last_error(void);

typedef enum : NSUInteger {
    TDahuBlankNoError = 0,
    TDahuBlankNotInitialized = (0x80000000|118),
} TDahuBlankECode;

#define DAHUA_CAM_CLOUD_BASE_TIME_SEC 90
#define DAHUA_CAM_REBOOT_TIME_SEC 60
#define DAHUA_CAM_FW_INSTALL_TIME_SEC 40
#define DAHUA_ERR_UNMASK(e) ((e) & 0x7fffffff)
#if TARGET_IPHONE_SIMULATOR
#define DAHUA_ERR_LAST 0
#else
#define DAHUA_ERR_LAST (DAHUA_ERR_UNMASK(ipeye_dahua_last_error()))
#endif

typedef NS_ENUM(NSUInteger, TDahuaCamBlankConnectionType) {
    TDahuaCamBlankConnectionTypeUnknown,
    TDahuaCamBlankConnectionTypeEthernet,
    TDahuaCamBlankConnectionTypeWiFi,
    TDahuaCamBlankConnectionTypeSound,
};

@protocol TDahuaCamBlankFirmwareDelegate <NSObject>
@required
- (void)blankFirmware:(TDahuaCamBlank*)blank uploadProgressChanged:(double)progress;
- (void)blankFirmware:(TDahuaCamBlank*)blank installProgressChanged:(double)progress;
- (void)blankFirmware:(TDahuaCamBlank*)blank updateError:(NSError*)error;
- (void)blankFirmwareUpdateCompleted:(TDahuaCamBlank*)blank;
@end

@protocol TDahuaCamBlankCloudDelegate <NSObject>
@required
- (void)blankWillStartAddingToCloud:(TDahuaCamBlank*)blank;
- (void)blankAddedToCloud:(TDahuaCamBlank*)blank;
- (void)blank:(TDahuaCamBlank*)blank addToCloudError:(NSError*)error;
@end

@protocol TDahuaCamBlankWiFiDelegate <NSObject>
@required
- (void)blankNeedWiFiReconnect:(TDahuaCamBlank*)blank;
- (void)blankWiFiConfigured:(TDahuaCamBlank*)blank;
@end

@interface TDahuaCamBlank : NSObject
/// force update to same version
@property (class, atomic, assign) BOOL forceFirmwareUpdate;
@property (class, atomic, assign) BOOL forceFirmwareDownload;
@property (class, atomic, assign) BOOL forceFirmwareDowngrade;
// from QR code or from api search by manually entered serial number
@property (atomic, strong) NSString *serial;
@property (atomic, strong) NSString *model;
@property (atomic, assign) BOOL modelHasEthernetPort;
@property (atomic, strong) NSString *login;
@property (atomic, strong) NSString *safetyCode; /// cam password by default from QR-Code or body label
@property (atomic, strong) NSString *nc;
// cam wifi auth
@property (atomic, strong) NSString *camWifiSSID;
@property (atomic, strong) NSString *camWifiSecurityKey;
// wifi router auth
@property (atomic, strong, nullable) NSString *wifiSSID;
@property (atomic, strong) NSString *wifiSecurityKey;
// local network
@property (atomic, strong) NSString *localIP;
@property (atomic, strong) NSString *localIPGateway;
@property (atomic, strong) NSString *localIPSubNetMask;
@property (atomic, strong) NSString *macAddress;
@property (atomic, assign) BOOL wifiConfigured;
//
@property (atomic, assign) BOOL initSupported;
@property (atomic, assign) BOOL initCompleted;
@property (atomic, assign) unsigned char byPwdResetWay;
@property (atomic, strong) NSTimeZone *timeZone;

@property (atomic, strong) NSString *deviceIPGatewayAsIPCam;

#pragma mark-
@property (nonatomic, assign) TDahuaCamBlankConnectionType connectiionType;
@property (atomic, assign) long loginID;
@property (nonatomic, weak) id <TDahuaCamBlankCloudDelegate> cloudDelegate;
@property (nonatomic, weak) id <TDahuaCamBlankWiFiDelegate> wifiDelegate;
@property (nonatomic, strong, readonly) NSURLSessionDataTask *addToCloudTask;
- (void)connectToCloudWithSerial:(NSURLRequest *)request retryCount:(NSInteger)retryCount;
- (void)cleanupSDKConnect;

- (BOOL)isBullet;

#pragma mark- service firmware
- (nullable TFirmwareInfo *)firmwareInfoForCurrentCam;
@property (atomic, strong, nullable) NSDictionary<NSNumber *,TFirmwareInfo *> *firmwareInfos;
- (NSURLSessionDataTask*)fetchServiceFirmwareInfos:(NSURLRequest *)request cb:(void(^)(NSDictionary<NSNumber*, TFirmwareInfo*> *infos, NSError *error))cb;
#pragma mark- cam firmware
@property (atomic, weak) id <TDahuaCamBlankFirmwareDelegate> firmwareDelegate;
@property (atomic, assign) NSInteger firmwareInstallRetryCount;
- (BOOL)camFirmwareVersion:(NSDate *_Nonnull*_Nullable)buildDate version:(NSString *_Nonnull*_Nullable)version;
/// result of call over firmwareDelegate
- (void)installFirmware;
@property (atomic, assign) BOOL firmwareUpdated;

#pragma mark-
- (BOOL)initializeCameraDevice;
- (BOOL)WlanConfig;
- (BOOL)configNTPToTimeZone:(NSTimeZone*)timeZone;
- (BOOL)configHumanDetect;
- (BOOL)configMotionDetect;
- (BOOL)configAudioDetect;
- (int)loginToCamera:(NSInteger)rc;
- (BOOL)askToConnectDeviceToCamWiFiIfNeed;

#pragma mark-
- (BOOL)fillParamsWithQRCode:(NSDictionary*)qr;
+ (BOOL)isDahuaIPCamSerialNumberValid:(NSString* _Nullable)serial;
+ (NSMutableDictionary*)parseQR:(NSString*)qr;

+ (BOOL)isWiFiSSIDValid:(NSString*)ssid;
+ (NSString*)fixWiFiSSID:(NSString*)ssid;
+ (BOOL)isWiFiSecurityKeyValid:(NSString*)key;
+ (NSString*)fixWiFiSecurityKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
