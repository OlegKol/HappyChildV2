//
//  TAddCamBaseViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamBaseViewController.h"
#import "TAddCamCloudViewController.h"
#import "TAddCamScanQRViewController.h"
#import "TAddCamPreviewViewController.h"
//#import "ServerConnection.h"
//#import "MasterViewController.h"

@interface TAddCamBaseViewController ()

@end

@implementation TAddCamBaseViewController
@synthesize blank = _blank;

- (void)setBlank:(TDahuaCamBlank *)blank{
    @synchronized (self) {
        _blank = blank;
    }
}

- (TDahuaCamBlank*)blank{
    @synchronized (self) {
        return _blank;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LSTR(@"add-cam-title");
}

#pragma mark-
- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonNone;
}

- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuNone;
}

- (void)rightBarButtonTap:(id)sender{
    TAddCamRightMenuMask m = [self barRightButtonMenuMask];
    if (m != TAddCamRightMenuNone){
        __weak typeof(self) wself = self;
        
        UIAlertControllerStyle style = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert;
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil
                                                                    message:nil
                                                             preferredStyle:style];
        if ((m & TAddCamRightMenuToBegin) == TAddCamRightMenuToBegin){
            [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"add-cam-action-to-begin")
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(wself) sself = wself;if (!sself) return;
                [sself popToQRScan];
            }]];
        }
        if ((m & TAddCamRightMenuWiFiToEth) == TAddCamRightMenuWiFiToEth){
            [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"add-cam-action-switch-to-eth")
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(wself) sself = wself;if (!sself) return;
                [sself popToForkAndSelectEthernet];
            }]];
        }
        if ((m & TAddCamRightMenuEthToWiFi) == TAddCamRightMenuEthToWiFi){
            [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"add-cam-action-switch-to-wifi")
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(wself) sself = wself;if (!sself) return;
                [sself popToForkAndSelectWiFi];
            }]];
        }
        if (ac.actions.count){
            [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"cancel") style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
}

- (UINavigationItem*)navigationItem{
    UINavigationItem *item = [super navigationItem];
    switch ([self barRightButtonType]) {
        case TAddCamRightButtonNone:
            break;
        case TAddCamRightButtonTriDot:{
            if (item.rightBarButtonItem.tag != 1010 && [self barRightButtonMenuMask] != TAddCamRightMenuNone){
                UIBarButtonItem *btn =
                [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"more"]
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                              action:@selector(rightBarButtonTap:)];
                btn.tintColor = UIColor.whiteColor;
                btn.tag = 1010;
                item.rightBarButtonItem = btn;
            }
        }break;
        case TAddCamRightButtonLink:{
            if (item.rightBarButtonItem.tag != 1011 && [self barRightButtonMenuMask] != TAddCamRightMenuNone){
                UIBarButtonItem *btn =
                [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"link"]
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                              action:@selector(rightBarButtonTap:)];
                btn.tintColor = UIColor.whiteColor;
                btn.tag = 1011;
                item.rightBarButtonItem = btn;
            }
        }break;
    }
    return item;
}

- (void)popToQRScan{
    [self.navigationController popToRootViewControllerAnimated:NO];
    // TODO: перезапустить процесс добавления заново
//    [APP.masterViewController addCamAction:nil];
}

- (void)popToForkAndSelectEthernet{
    UINavigationController *nav = self.navigationController;
    [self popNavToClass:TAddCamPreviewViewController.class animated:NO];
    TAddCamPreviewViewController *vc = (id)nav.topViewController;
    if ([vc isKindOfClass:TAddCamPreviewViewController.class]){
        [vc ethButtonTap:nil];
    }
}

- (void)popToForkAndSelectWiFi{
    UINavigationController *nav = self.navigationController;
    [self popNavToClass:TAddCamPreviewViewController.class animated:NO];
    TAddCamPreviewViewController *vc = (id)nav.topViewController;
    if ([vc isKindOfClass:TAddCamPreviewViewController.class]){
        [vc wifiButtonTap:nil];
    }
}

- (void)popNavToClass:(Class)cls animated:(BOOL)animated{
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:cls]){
            [self.navigationController popToViewController:obj animated:animated];
            *stop = YES;
        }
    }];
}

#pragma mark-
- (void)pushCloudController{
    metrica_report_event(@"AddCam.Wi-Fi.Router.Connect.Complete");
    // cam with blank.serial found in local network, connect it to cloud...
    __block BOOL cloudInStack = NO;
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.navigationController.topViewController isKindOfClass:TAddCamCloudViewController.class]){
            cloudInStack = YES;
            *stop = YES;
        }
    }];
    if (!cloudInStack){
        WiFiLog(@"%s[%d]", __FUNCTION__, __LINE__);
        TAddCamCloudViewController *vc = (id)[TAddCamCloudViewController initWithMainBundle];
        vc.blank = self.blank;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)ignoreFinishScreenBlankAddedWithDevcode:(NSString*)devcode{
    __weak typeof(self) wself = self;
    UIAlertController *ac =
    [UIAlertController alertControllerWithTitle:LSTR(@"infomsg")
                                        message:LSTR(@"onvif-wifi-cam-added-ok")
                                 preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"goto-cam-details") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        __strong typeof(wself) sself = wself;if (!sself) return;
        [sself.blank cleanupSDKConnect];
        [sself.navigationController popToRootViewControllerAnimated:NO];
        // TODO: выбрать за юзера добавленную камеру в списке для проигрывания
        //[APP selectCam:ServerConnection.connection.camsByDevcode[devcode] withAttentionTime:0];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"add-more") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(wself) sself = wself;if (!sself) return;
        [sself.blank cleanupSDKConnect];
        [sself popToQRScan];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:LSTR(@"tocomplete") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(wself) sself = wself;if (!sself) return;
        [sself.blank cleanupSDKConnect];
        [sself.navigationController popToRootViewControllerAnimated:YES];
    }]];
    if (self.onScreen){
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)longSleepPringSec:(int32_t)sec text:(const char*)text{
    int32_t left_time = sec;
    const int32_t tick_time = 5;
    while (self.run && left_time > 0){
        int32_t sleep_time = left_time > tick_time ? tick_time : left_time;
        left_time -= sleep_time;
        WiFiLog(@"%s:%is", text, left_time);
        usleep(USEC_PER_SEC * sleep_time);
    }
}

@end
