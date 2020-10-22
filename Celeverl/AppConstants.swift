//
//  AppConstants.swift
//  HappyChild
//
//  Created by Евгений on 11/12/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppConstants {
    
    public static let APP_AVENIR_BOLD = "Avenir-Black"
    public static let APP_AVENIR = "Avenir"
    
    public static let APP_ROBOTO_MEDIUM = "Roboto-Medium"
    public static let APP_ROBOTO_REGULAR = "Roboto-Regular"
    public static let APP_ROBOTO_BOLD = "Roboto-Bold"
    
    public static let APP_OPENSANS_REGULAR = "OpenSans-Regular"
    
    //MARK: - APP COLORS
    public static let APP_DEFAULT_DARK_BLUE_COLOR = UIColor.init(hex: "#32417F", alpha: 1)
    public static let APP_DEFAULT_PINK_COLOR = UIColor.init(hex: "#FFE2F2", alpha: 1)
    public static let APP_DEFAULT_GRAY_COLOR = UIColor(red: 0.512, green: 0.512, blue: 0.512, alpha: 1)
    public static let APP_DEFAULT_TEXT_COLOR = UIColor.init(hex: "#32417F", alpha: 1)
    
    //MARK: - URL CONSTANTS
       public static let APP_NOTIFICATION_URL = "https://happychild.tech/api/MobileAppPushNotification/GetPushNotificationsForUser/"
       public static let APP_REGISTER_PHONE_URL = "https://happychild.tech/api/MobileAppAccount/RegisterByPhone/"
       public static let APP_CONFIRM_OCDE_URL = "https://happychild.tech/api/MobileAppAccount/RegisterByPhone/"
       public static let APP_USER_SETTING_URL = "https://happychild.tech/api/MobileAppProfile/GetUserProfileData/"
       public static let APP_REMINDER_SETTING_URL = "https://happychild.tech/api/MobileAppOnlineSettings/GetUserOnlineSettings"
       public static let APP_GETTING_USER_BALANCE_URL = "https://happychild.tech/api/MobileAppBalance"
       public static let APP_GET_DAYLY_DOCUMENTS_URL = "https://happychild.tech/api/MobileAppDailyReport/"
       public static let APP_GET_LAST_TEN_DOCUMENTS_URL = "https://happychild.tech//api/MobileAppDailyReportListInfo"
       public static let APP_GET_LAST_DOCUMENT_URL = "https://happychild.tech/api/MobileAppDailyReport/GetLastDailyReport"
       public static let APP_GET_HELP_INFO_URL = "https://happychild.tech/api/MobileAppHelp"
       public static let APP_GET_CHECK_PROMO_CODE_URL = "https://happychild.tech/api/MobileAppPromocode"
       public static let APP_GET_CAMERAS_LIST_URL = "https://happychild.tech/api/MobileAppCameraSettings"
       
       public static let PHONE_NUMBER_PREFIX = "+3"
       public static let PHONE_NUMBER_LENGHT = 11
       
       //MARK: - ID_INTERACTOR_PARAMETERS
       public static let USER_PARAMETER = "USER_PARAMETER"
       public static let CAMERA_MODEL_PARAMETER = "CAMERA_MODEL_PARAMETER"
       
       
       
       //MARK: - APPLICATION COLOR
       
    
}
