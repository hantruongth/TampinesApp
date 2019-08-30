//
//  Terms&ConditionsViewController.h
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
 #import <MessageUI/MessageUI.h>

@class AppDelegate;


@interface Terms_ConditionsViewController : UIViewController<MFMailComposeViewControllerDelegate,WebDataParserDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *lblNumber,*lblEmail;
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIWebView *webView;
    IBOutlet UIView *viewTCCenter,*viewTCCenter1,*viewTCCenter2,*viewTCCenter3;
    
    IBOutlet UIView *viewTAndC,*viewAboutUs,*viewWiFi;
    
    IBOutlet UITextView *txtPassword,*txtName;
}

-(IBAction)showTC;
-(IBAction)showWiFi;
-(IBAction)showAboutUs;
-(IBAction)removeAllview;

@end
