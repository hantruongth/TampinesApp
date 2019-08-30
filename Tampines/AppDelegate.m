//
//  AppDelegate.m
//  Tampines
//
//  Created by Pradip on 10/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize eventsVC,homeVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.eventsVC=[[EventsViewController alloc] initWithNibName:@"EventsViewController" bundle:nil];
    self.announcementVC=[[AnnouncementsViewController alloc] initWithNibName:@"AnnouncementsViewController" bundle:nil];
    self.feedbackVC=[[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
    self.informationVC=[[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    self.termsAndConditionsVC=[[Terms_ConditionsViewController alloc] initWithNibName:@"Terms_ConditionsViewController" bundle:nil];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
           return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    exit(0);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //[self.eventsVC setEventStatus];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Fade in Animation methods starts
//--- Method to animate new viewcontroller from left to right   ---//
-(void)animatePushViewController:(UIView*)vwToBeAdded andViewToBeRemoved:(UIView*)vwToBeRemoved state:(int)iState
{
    self.window.userInteractionEnabled = NO;
    vwToBeAdded.frame = CGRectMake(vwToBeAdded.frame.size.width,  vwToBeAdded.frame.origin.y,  vwToBeAdded.frame.size.width,  vwToBeAdded.frame.size.height);
    vwToBeRemoved.frame = CGRectMake(0,  vwToBeRemoved.frame.origin.y,  vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.size.height);
    
    UIView *vwHeader1 = [vwToBeAdded viewWithTag:2000];
    UIView *vwHeader2 = [vwToBeRemoved viewWithTag:2000];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         vwToBeRemoved.frame = CGRectMake(-vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.origin.y,  vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.size.height);
                         vwToBeAdded.frame = CGRectMake(0,  vwToBeAdded.frame.origin.y,  vwToBeAdded.frame.size.width,  vwToBeAdded.frame.size.height);
                         
                         
                         for (UIView *v in [vwHeader1 subviews])
                         {
                             if ([v isKindOfClass:[UIImageView class]])//([v isKindOfClass:[UIButton class]]||[v isKindOfClass:[UILabel class]])
                             {
                                 v.alpha = 0.9;
                             }
                             else
                             {
                                 v.alpha = 0.7;
                             }
                         }
                         
                         for (UIView *v in [vwHeader2 subviews])
                         {
                             if ([v isKindOfClass:[UIImageView class]])
                             {
                                 v.alpha = 0.9;
                             }
                             else
                             {
                                 v.alpha = 0.7;
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         vwToBeRemoved.frame = CGRectMake(0,  vwToBeRemoved.frame.origin.y,  vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.size.height);
                         vwToBeAdded.frame = CGRectMake(0,  vwToBeAdded.frame.origin.y,  vwToBeAdded.frame.size.width,  vwToBeAdded.frame.size.height);
                         self.window.userInteractionEnabled = YES;
                         
                         for (UIView *v in [vwHeader1 subviews])
                         {
                             v.alpha = 1;
                         }
                         
                         for (UIView *v in [vwHeader2 subviews])
                         {
                             v.alpha = 1;
                         }
                     }];
}

//--- Method to animate new viewcontroller from right to left   ---//
-(void)animatePopViewController:(UIView*)vwToBeAdded andViewToBeRemoved:(UIView*)vwToBeRemoved
{
    self.window.userInteractionEnabled = NO;
    
    vwToBeAdded.frame = CGRectMake(-vwToBeAdded.frame.size.width,  vwToBeAdded.frame.origin.y,  vwToBeAdded.frame.size.width,  vwToBeAdded.frame.size.height);
    vwToBeRemoved.frame = CGRectMake(0,  vwToBeRemoved.frame.origin.y,  vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.size.height);
    
    UIView *vwHeader1 = [vwToBeAdded viewWithTag:2000];
    UIView *vwHeader2 = [vwToBeRemoved viewWithTag:2000];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         vwToBeRemoved.frame = CGRectMake(vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.origin.y,  vwToBeRemoved.frame.size.width,  vwToBeRemoved.frame.size.height);
                         vwToBeAdded.frame = CGRectMake(0,  vwToBeAdded.frame.origin.y,  vwToBeAdded.frame.size.width,  vwToBeAdded.frame.size.height);
                         
                         
                         
                         for (UIView *v in [vwHeader1 subviews])
                         {
                             if ([v isKindOfClass:[UIImageView class]])
                             {
                                 v.alpha = 0.9;
                             }
                             else
                             {
                                 v.alpha = 0.7;
                             }
                         }
                         
                         for (UIView *v in [vwHeader2 subviews])
                         {
                             if ([v isKindOfClass:[UIImageView class]])
                             {
                                 v.alpha = 0.9;
                             }
                             else
                             {
                                 v.alpha = 0.7;
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         [vwToBeRemoved removeFromSuperview];
                         self.window.userInteractionEnabled = YES;
                         
                         for (UIView *v in [vwHeader1 subviews])
                         {
                             v.alpha = 1;
                         }
                         
                         for (UIView *v in [vwHeader2 subviews])
                         {
                             v.alpha = 1;
                         }
                     }];
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)showLoading:(NSString *)strMessage{
    
	self.hudMessage = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
	
	// Configure for text only and offset down
	self.hudMessage.mode = MBProgressHUDModeIndeterminate;
	//self.hudMessage.detailsLabelText = strMessage;
    self.hudMessage.detailsLabelFont=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
    self.hudMessage.labelFont=[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
	self.hudMessage.removeFromSuperViewOnHide = YES;
    [self.hudMessage hide:TRUE afterDelay:10.0];
    
 
}

- (void)showToast:(NSString *)strMessage{
    
	self.hudMessage = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
	
	// Configure for text only and offset down
	self.hudMessage.mode = MBProgressHUDModeText;
	self.hudMessage.detailsLabelText = strMessage;
    self.hudMessage.detailsLabelFont=[UIFont fontWithName:@"HelveticaNeue-Medium" size:12.0];
	self.hudMessage.removeFromSuperViewOnHide = YES;
    [self.hudMessage hide:TRUE afterDelay:4.0];
    
}

-(void)removeLoading
{
    [self.hudMessage setHidden:TRUE];
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
}

-(void)hideHUD
{
    [self.hudMessage removeFromSuperview];
    [self.hudMessage hide:TRUE];
}


-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken: (NSData *)deviceToken {

        NSString *token=[NSString string];
        token=[[[[NSString stringWithFormat:@"%@",deviceToken]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
           [self getPushNotificationRegistered:token];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)getPushNotificationRegistered:(NSString *)strToken
{
    
    if([self hasConnectivity])
    {
        Webservice *webObj=[[Webservice alloc] init];
        
        /* Commented by Yogesh as we need to use client's web service to push notification */
        //webObj.delegate=self;
        //[webObj GetDataInXMLFromStoredProcedure:@"_tspInsertDeviceToken" parameterName:[[NSMutableArray alloc] initWithObjects:@"devicetoken",@"cPlatform", nil] parameterValue:[[NSMutableArray alloc] initWithObjects:strToken,@"iOS", nil]];
        /***********************************************************************************/
        [webObj registerForPushNotificationWithDeviceToken:strToken andUserName:@"twcc"];
        webObj=nil;
    }
    

}

#pragma mark - Webservice delegate

-(void)parsingSucessfullFor:(NSString *)strMethodName With:(NSMutableArray *)arrList
{
    NSLog(@"Parsing Completed !!!");
    
    
    if([strMethodName isEqualToString:@"_tspInsertDeviceToken"])
    {
    }
 }

-(void)parsingFailedFor:(NSString *)strMethodName With:(NSString *)strErrorMsg
{
    NSLog(@"Parsing Failed !!! %@",strErrorMsg);
}

//Combine to get single date
- (NSDate *)bindTime:(NSDate *)dateTime WithDate:(NSDate *)startDate
{
    // NSLog(@"\n--------bindTime-----------");
    //NSLog(@"dateTime=%@",dateTime);
    //NSLog(@"startDate=%@",startDate);
    
    if(startDate==nil)
        return dateTime;
    
    if(dateTime==nil)
        return startDate;
    
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:startDate];
	NSDateComponents *timeComponents = [calendar components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:dateTime];
    
	[dateComponents setHour:[timeComponents hour]];
	[dateComponents setMinute:[timeComponents minute]];
	[dateComponents setSecond:[timeComponents second]];
    
	NSDate *newDate = [calendar dateFromComponents:dateComponents];
    // NSLog(@"newDate=%@",newDate);
    return newDate;
}
-(NSString *)dateToString:(NSDate*)dateInput withForamt:(NSString *)strDateFormat
{
    @try
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:strDateFormat];
        NSLocale * enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setLocale:enUSPOSIXLocale];
        NSString *strDate= [dateFormatter stringFromDate:dateInput];
        return strDate;
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Excption in AppDelegate : dateToString %@:%@ ",exception.name,exception.reason);
    }
}

-(NSDate *)stringToDateNew:(NSString*)strDate withForamt:(NSString *)strFormat
{
    
    
    @try
    {
        NSDate *myDate;
        if(strDate!=NULL)
        {
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:[NSString stringWithFormat:@"%@",strFormat]];
            NSLocale * enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ;
            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormat setLocale:enUSPOSIXLocale];
            
            myDate = [dateFormat dateFromString:strDate];
            
            
            return myDate;
            
        }
        return NULL;
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Excption in AppDelegate : stringToDate %@:%@ ",exception.name,exception.reason);
    }
    
}



-(void)resetHomeScreen
{
    CGRect rect;
    rect = [[UIScreen mainScreen] bounds]; // Get screen dimensions
   // NSLog(@"Bounds: %1.0f, %1.0f, %1.0f, %1.0f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    rect = [[UIScreen mainScreen] applicationFrame]; // Get application frame dimensions (basically screen - status bar)
    //NSLog(@"App Frame: %1.0f, %1.0f, %1.0f, %1.0f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    //rect = [[UIApplication sharedApplication] statusBarFrame]; // Get status bar frame dimensions
    
    
    [self.homeVC.view setFrame:CGRectMake(rect.origin.x, -50, 320,rect.size.height)];
    
    rect=self.homeVC.view.frame;
    NSLog(@"Statusbar frame: %1.0f, %1.0f, %1.0f, %1.0f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
