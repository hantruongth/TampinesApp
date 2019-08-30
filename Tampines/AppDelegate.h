//
//  AppDelegate.h
//  Tampines
//
//  Created by Pradip on 10/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventsViewController.h"
#import "ClsEvent.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"
#import "AnnouncementsViewController.h"
#import "FeedbackViewController.h"
#import "InformationViewController.h"
#import "Terms_ConditionsViewController.h"
#import "Webservice.h"
#import "ClsCategory.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
//comment

@class EventsViewController;
@class HomeViewController;
@class AnnouncementsViewController;
@class FeedbackViewController;
@class InformationViewController;
@class Terms_ConditionsViewController;
@class Webservice;
@class ClsCategory;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IS_IOS7 [[UIDevice currentDevice] systemVersion].doubleValue>=7.0
#define ORIGIN_FACTOR (IS_IOS7 ? 20 : 0)

#define COLOR_DARK_RED [UIColor colorWithRed:164.0/255.0 green:0.0/255.0 blue:07.0/255.0 alpha:1.0]

#define FONT_BOLD @"AppleSDGothicNeo-Bold" 
#define FONT_REGULAR @"AppleSDGothicNeo-Medium"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WebDataParserDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EventsViewController *eventsVC;
@property (strong, nonatomic) HomeViewController *homeVC;
@property (strong, nonatomic) AnnouncementsViewController *announcementVC;
@property (strong, nonatomic) FeedbackViewController *feedbackVC;
@property (strong, nonatomic) InformationViewController *informationVC;
@property (strong, nonatomic) Terms_ConditionsViewController *termsAndConditionsVC;


@property (strong, nonatomic) MBProgressHUD *hudMessage;

-(void)animatePushViewController:(UIView*)vwToBeAdded andViewToBeRemoved:(UIView*)vwToBeRemoved state:(int)iState;
-(void)animatePopViewController:(UIView*)vwToBeAdded andViewToBeRemoved:(UIView*)vwToBeRemoved;

- (void)showLoading:(NSString *)strMessage;
-(void)removeLoading;
- (void)showToast:(NSString *)strMessage;

-(BOOL)hasConnectivity;
- (NSDate *)bindTime:(NSDate *)dateTime WithDate:(NSDate *)startDate;
-(NSString *)dateToString:(NSDate*)dateInput withForamt:(NSString *)strDateFormat;
-(NSDate *)stringToDateNew:(NSString*)strDate withForamt:(NSString *)strFormat;

-(void)resetHomeScreen;

@end
