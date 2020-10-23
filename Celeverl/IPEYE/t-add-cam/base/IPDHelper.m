//
//  IPDHelper.m
//  IPEYEDahuaTest
//
//  Created by Roman Solodyashkin on 21.10.2020.
//

#import "IPDHelper.h"
#import "TAddCamBaseViewController.h"

NSString *const ServiceURLString = @"ru.heymom";

@implementation IPDHelper

+ (void)showError:(NSError*)error withCancel:(dispatch_block_t)cancel andRetry:(dispatch_block_t)retry
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:LSTR(@"error") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"retry") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (retry)
                retry();
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancel)
                cancel();
        }]];
        [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
    });
}

+ (void)showError:(NSError*)error withCancelAndRetry:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:LSTR(@"error") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"retry") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block)
                block();
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
    });
}

+ (void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"okmsg") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        UIViewController *topViewController = [UIViewController topMostController];
        [topViewController presentViewController:ac animated:YES completion:nil];
    });
}

+ (void)showErrorString:(NSString*)error
{
    if ( nil == error )
        return;
    
    error = [self stringByReplacingTags:error];
    [self showAlertWithTitle:LSTR(@"error") message:error];
}

+ (NSString*)stringByReplacingTags:(NSString*)string
{
    @try
    {
        NSRange r;
        NSString *s = string;
        while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
            s = [s stringByReplacingCharactersInRange:r withString:@""];
        return s;
    }
    @catch (NSException *exception)
    {
        return string;
    }
}

+ (NSError*)errorWithException:(NSException*)e
{
    if (!e)
        return [self unknownError];
    NSString *str = [e.userInfo objectForKey:NSLocalizedDescriptionKey];
    if (nil == str)
        str = LSTR(@"error");
    return [NSError errorWithDomain:ServiceURLString
                               code:1000
                           userInfo:@{NSLocalizedDescriptionKey:str}];
}

+ (NSError*)unknownError
{
    return [NSError errorWithDomain:ServiceURLString
                               code:1
                           userInfo:@{NSLocalizedDescriptionKey:LSTR(@"error")}];
}

+ (NSError*)errorWithData:(NSData*)data
{
    if (!data.length)
        return nil;
    
    NSError *apierr = nil;
    NSString *danger = nil;
    @try
    {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL];
        if (jsonDic)
        {
            danger = [jsonDic objectForKey:@"danger"];
            if ([danger isKindOfClass:[NSArray class]])
                danger = ((NSArray*)danger).firstObject;
            if (!danger.length){
                danger = [jsonDic objectForKey:@"error"];
                if (!danger.length){
                    danger = [jsonDic objectForKey:@"message"];
                }
            }
        }
    }
    @catch(NSException *e)
    {
        LOG_EX(e);
    }
    if (!danger)
        danger = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (danger.length)
        apierr = [NSError errorWithDomain:ServiceURLString code:2 userInfo:@{NSLocalizedDescriptionKey:danger}];
    else
        apierr = [self unknownError];
    
    return apierr;
}

+ (void)handleReponseData:(NSData *_Nullable)data
                 response:(NSURLResponse *_Nullable)response
                    error:(NSError *_Nullable)error
                successcb:(void(^)(void))successcb
                  errorcb:(void(^)(NSError*e))errorcb
{
    NSError *e = nil;
    BOOL ok = NO;
    if (error){
        if (error.code != NSURLErrorCancelled)
            e = error;
    }
    else if ([response isKindOfClass:[NSHTTPURLResponse class]] &&
             ((NSHTTPURLResponse*)response).statusCode != 200){
        e = [self errorWithData:data];
    }
    else{
        ok = YES;
    }
    @try{
        if (e)        {if (errorcb)     errorcb(e);}
        else if (ok)  {if (successcb)   successcb();}
        else          {if (errorcb)     errorcb(nil);}
    }@catch(NSException *ex){
        if (errorcb) errorcb([self errorWithException:ex]);
    }
}

+ (void)showAlert:(NSString*)text title:(NSString*)title cancelAndRetry:(dispatch_block_t)retry
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"retry") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (retry)
                retry();
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
    });
}

+ (void)showAlert:(NSString*)text withCancelAndRetry:(dispatch_block_t)retryblock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"retry") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (retryblock)
                retryblock();
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
    });
}

+ (void)showErrorWithRetry:(NSError*)error retry:(dispatch_block_t)retry
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:LSTR(@"error") message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"retry") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (retry)
                retry();
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
    });
}

+ (void)showRetryAlert:(NSString*)text withCancel:(dispatch_block_t)cancelblock andOK:(dispatch_block_t)okblock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:text preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"retry") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okblock)
                okblock();
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelblock)
                cancelblock();
        }]];
        [[UIViewController topMostController] presentViewController:vc animated:YES completion:nil];
    });
}

+ (NSError*)errorFromHTTPResponse:(NSHTTPURLResponse*)response{
    if ([response isKindOfClass:NSHTTPURLResponse.class]){
        return [self errorFromHTTPResponseCode:((NSHTTPURLResponse*)response).statusCode];
    }
    else{
        return self.unknownError;
    }
}

+ (NSError*)errorFromHTTPResponseCode:(NSInteger)statusCode{
    NSString *localized = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
    NSError *e = [NSError errorWithDomain:ServiceURLString
                                     code:statusCode
                                 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ (%ld)", localized, statusCode]}];
    return e;
}

+ (NSError*)errorFromHTTPResponseCode:(NSInteger)statusCode message:(nonnull NSString*)message{
    NSError *e = [NSError errorWithDomain:ServiceURLString
                                     code:statusCode
                                 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@ (%ld)", message, statusCode]}];
    return e;
}

+ (void)handleJSONReponseData:(NSData *_Nullable)data
                     response:(NSURLResponse *_Nullable)response
                        error:(NSError *_Nullable)error
                    successcb:(void(^)(id json))successcb
                      errorcb:(void(^)(NSError*e))errorcb
{
    NSError *e = nil;
    NSDictionary *json = nil;
    if (error){
        //if (error.code != NSURLErrorCancelled)
            e = error;
    }
    else if ([response isKindOfClass:[NSHTTPURLResponse class]] &&
             ((NSHTTPURLResponse*)response).statusCode != 200 &&
             ((NSHTTPURLResponse*)response).statusCode != 201)
    {
        switch (((NSHTTPURLResponse*)response).statusCode) {
            case 304:
                e = [NSError errorWithDomain:@"IPEYE" code:304 userInfo:nil];
                break;
            case 504:{
                e = [self errorFromHTTPResponse:(id)response];
            }break;
            default:{
                e = [self errorWithData:data];
                if (!e){
                    e = [self errorFromHTTPResponse:(id)response];
                }
            }break;
        }
    }
    else{
        @try{
            NSError *jsonErr = nil;
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonErr];
            if (!json){
//#if DEBUG
//                NSLog(@"\nDERR: %@\nJSON-ERR:%@", response, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//#endif
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (NSOrderedSame == [str compare:@"null" options:NSCaseInsensitiveSearch]){
                    json = @{};
                }
                else if (jsonErr)
                    e = jsonErr;
                else if (data.length > 0) // server returns error string
                    e = [NSError errorWithDomain:ServiceURLString
                                            code:2
                                        userInfo:@{NSLocalizedDescriptionKey:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]}];
                else
                    e = [self unknownError];
            }
            else{
                if ([json isKindOfClass:NSDictionary.class]){
                    NSString *danger = [json objectForKey:@"danger"];
                    if ([danger isKindOfClass:[NSArray class]])
                        danger = ((NSArray*)danger).firstObject;
                    if ([danger isKindOfClass:[NSString class]] && danger.length > 0)
                        e = [NSError errorWithDomain:ServiceURLString code:2 userInfo:@{NSLocalizedDescriptionKey:danger}];
                    else if ([json objectForKey:@"success"])
                        json = [json objectForKey:@"success"];
                    // tricolor proxy errors
                    if ([json isKindOfClass:NSDictionary.class]){
                        NSNumber *triNumcode = json[@"response_code"];
                        if (triNumcode){
                            NSInteger trcode = triNumcode.integerValue;
                            switch (trcode) {
                                case 200:
                                case 204:{
                                    
                                }break;
                                default:{
                                    id trespo = json[@"response"];
                                    NSString *tmsg = nil;
                                    if ([trespo isKindOfClass:NSString.class]){
                                        tmsg = trespo;
                                    }
                                    else if ([trespo isKindOfClass:NSDictionary.class]){
                                        tmsg = [trespo objectForKey:@"message"];
                                    }
                                    if (tmsg.length > 0){
                                        e = [self errorFromHTTPResponseCode:trcode message:tmsg];
                                    }
                                    else{
                                        e = [self errorFromHTTPResponseCode:trcode];
                                    }
                                }break;
                            }
                        }
                    }
                }
            }
        }
        @catch(NSException *ex){
            e = [self errorWithException:ex];
        }
    }
    @try{
        if (e)        {if (errorcb)     errorcb(e);}
        else if (json){if (successcb)   successcb(json);}
        else          {if (errorcb)     errorcb([self unknownError]);}
    }@catch(NSException *ex){
        if (errorcb) errorcb([self errorWithException:ex]);
    }
}

@end
