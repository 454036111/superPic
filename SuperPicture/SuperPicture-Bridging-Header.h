//
//  SuperPicture-Bridging-Header.h
//  SuperPicture
//
//  Created by lcy on 2017/11/15.
//  Copyright © 2017年 lcy. All rights reserved.
//

#ifndef SuperPicture_Bridging_Header_h
#define SuperPicture_Bridging_Header_h

//@import HMSegmentedControl;
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "TGWebViewController.h"


#endif /* SuperPicture_Bridging_Header_h */

#import "JPUSHService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>



