//
//  IPDHelper.h
//  IPEYEDahuaTest
//
//  Created by Roman Solodyashkin on 21.10.2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPDHelper : NSObject

+ (void)showErrorString:(NSString*)error;
+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (void)showError:(NSError*)error withCancelAndRetry:(dispatch_block_t)block;
+ (void)showError:(NSError*)error withCancel:(dispatch_block_t)cancel andRetry:(dispatch_block_t)retry;
+ (void)showAlert:(NSString*)text title:(NSString*)title cancelAndRetry:(dispatch_block_t)retry;
+ (void)showAlert:(NSString*)text withCancelAndRetry:(dispatch_block_t)retryblock;
+ (void)showErrorWithRetry:(NSError*)error retry:(dispatch_block_t)retry;
+ (void)showRetryAlert:(NSString*)text withCancel:(dispatch_block_t)cancelblock andOK:(dispatch_block_t)okblock;

+ (void)handleReponseData:(NSData *_Nullable)data
                 response:(NSURLResponse *_Nullable)response
                    error:(NSError *_Nullable)error
                successcb:(void(^)(void))successcb
                  errorcb:(void(^)(NSError*e))errorcb;

+ (void)handleJSONReponseData:(NSData *_Nullable)data
                     response:(NSURLResponse *_Nullable)response
                        error:(NSError *_Nullable)error
                    successcb:(void(^)(id json))successcb
                      errorcb:(void(^)(NSError*e))errorcb;

@end

NS_ASSUME_NONNULL_END
