//
//  AnnouncementsViewController.h
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ClsAnnouncemnets.h"
#import "Webservice.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@class AppDelegate;

@interface AnnouncementsViewController : UIViewController<WebDataParserDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *tblAnnouncements;
    NSMutableArray *arrAnnouncements;
    
     int intSelectedAnnouncementIndex;
    IBOutlet UIView *viewAnnouncementDetails,*viewListContent;
    
    IBOutlet UILabel *lblHeaderAnnouncemnet;
    IBOutlet UIScrollView *scrollAnnouncement;
    
    IBOutlet UIView *viewList,*viewAnnouncementDetailsCenter;
    
    IBOutlet UIButton *btnNext,*btnPrevious;
    IBOutlet UIImageView *imgNext,*imgPrevious;

}

-(void)getNewAnnouncementsFromServer;

@end
