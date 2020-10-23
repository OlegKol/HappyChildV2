//
//  TAddCamWiFiBeginViewController.m
//  IPEYE
//
//  Created by Roman Solodyashkin on 19.11.2019.
//  Copyright © 2019 KONSTANTA, OOO Apps. All rights reserved.
//

#import "TAddCamGreenLampViewController.h"
#import "TAddCamWiFiEnterViewController.h"
#import "UIButton+OSExt.h"
#import "TAddCamResetViewController.h"
#import "TAddCamCloudViewController.h"

@interface TAddCamGreenLampViewController ()
@property (nonatomic, weak) IBOutlet UILabel *infoLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenLampInfoLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenLampConfirmLabel;
@property (nonatomic, weak) IBOutlet UIButton *greenLampConfirmButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@end

@implementation TAddCamGreenLampViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.blank.isBullet){
        self.infoLabel.text = LSTR(@"add-cam-wifi-begin-info");
        self.greenLampInfoLabel.text = LSTR(@"add-cam-green-lamp-blink");
        self.greenLampConfirmLabel.text = LSTR(@"add-cam-green-lamp-blink-confirm");
    }
    else{
        self.infoLabel.text = LSTR(@"add-cam-wifi-begin-info-homecam");
        self.greenLampInfoLabel.text = LSTR(@"add-cam-green-lamp-blink-homecam");
        self.greenLampConfirmLabel.text = LSTR(@"add-cam-green-lamp-blink-confirm-homecam");
    }
    [self.nextButton setTitle:LSTR(@"next") forState:UIControlStateNormal];
    [self.nextButton tricolorBlue];
    self.nextButton.enabled = NO;
}

- (IBAction)greenLampInfoTap:(id)sender{
    // https://video.tricolor.tv/documentation/?model=ipeye&action=reset
//    3.3 Если серийный номер соответствует одному из номеров,
//    который предоставил заказчик и при этом не привязан не к одному аккаунту,
//    то Клиент видит изображение, на котором показан соответствующий тип камеры.
//    Пример текста: «Световой индикатор мгает красным?»
//    2 кнопки:
//    «Да». Переход на экран 4.
//    «Нет, нужна подсказка». При клике на данную кнопку, клиент видит инструкцию, которая описывает «reset» камеры.
    TAddCamResetViewController *vc = (id)[TAddCamResetViewController initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)greenLampConfirmTap:(id)sender{
    self.greenLampConfirmButton.selected = !self.greenLampConfirmButton.selected;
    self.nextButton.enabled = self.greenLampConfirmButton.selected;
}

- (IBAction)nextTap:(id)sender{
    metrica_report_event(@"AddCam.GreenLampCheck.Complete");
    Class c;
    switch (self.blank.connectiionType) {
        case TDahuaCamBlankConnectionTypeEthernet:
            c = TAddCamCloudViewController.class;
            break;
        case TDahuaCamBlankConnectionTypeWiFi:
            c = TAddCamWiFiEnterViewController.class;
            break;
        default:
            c = TAddCamWiFiEnterViewController.class;
            break;
    }
    TAddCamBaseViewController *vc = (id)[c initWithMainBundle];
    vc.blank = self.blank;
    [self.navigationController pushViewController:vc animated:YES];
}

- (TAddCamRightButtonType)barRightButtonType{
    return TAddCamRightButtonTriDot;
}
- (TAddCamRightMenuMask)barRightButtonMenuMask{
    return TAddCamRightMenuToBegin;
}

@end
