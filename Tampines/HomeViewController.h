//
//  ViewController.h
//  Tampines
//
//  Created by Pradip on 10/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Webservice.h"

@class AppDelegate;
@class Webservice;

@interface HomeViewController : UIViewController<WebDataParserDelegate>
{
    AppDelegate *appDelegate;

    IBOutlet UIView *viewTabEvent,*viewTabAnnouncement,*viewTabFeedback,*viewTabUsefulInfo,*viewTabTermsAndConditions;
    
    IBOutlet UILabel *lblHeader;
    
    IBOutlet UIView *viewFilter;
    IBOutlet UIView *viewContent,*viewContainer;
    
    IBOutlet UIView *viewScrollBase,*viewPageFull;
    IBOutlet UIScrollView *scrollPaging;
    
    IBOutlet UIImageView *imgBg2;
    IBOutlet UIPageControl *pageControl;
    
    IBOutlet UIButton *btnNext,*btnPrevious;
    IBOutlet UIImageView *imgNext,*imgPrevious;
    
    IBOutlet UIView *viewSplash;
    
    IBOutlet UIImageView *imgview,*imgAd;
    
    IBOutlet UIView *viewMoreMenu;

}

-(void)showHomeScreen;
-(void)addViewOnHome:(UIView *)subview;

@end
