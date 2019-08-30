//
//  ViewController.m
//  Tampines
//
//  Created by Pradip on 10/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.homeVC=self;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    

    
    viewContainer.frame=CGRectMake(0, ORIGIN_FACTOR, 320, SCREEN_HEIGHT-20);
    viewSplash.frame=CGRectMake(0, 0, 320, SCREEN_HEIGHT);
    viewMoreMenu.frame=CGRectMake(0, ORIGIN_FACTOR, 320, SCREEN_HEIGHT-20);
    
    
    [self showHomeScreen];
    if(IS_IPHONE_5)
        imgview.image=[UIImage imageNamed:@"Splashiphone5.png"];
    else
        imgview.image=[UIImage imageNamed:@"Splash.png"];

    
    [self.view addSubview:viewSplash];
    [self performSelector:@selector(loadAd) withObject:nil afterDelay:1.0];
     [self performSelector:@selector(showAd) withObject:nil afterDelay:3.0];
    
    [appDelegate.eventsVC getAllCategoriesFromServer];
    

    imgPrevious.hidden=TRUE;
    btnPrevious.hidden=TRUE;
    

}


-(void)loadAd
{
    /*NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
     if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
     {
     NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
     strWebServiceName=[dict valueForKey:@"WebServiceURL"];
     
     }*/
    //if([appDelegate hasConnectivity])
    {
        NSURL *url = [NSURL URLWithString:
                      @"http://tmpcc.8streams.com/tampines/SplashScreenImage/splash.jpg"];
        imgAd.image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    }
    
}


-(void)showAd
{
    if(imgAd.image)
    {
        imgview.hidden=TRUE;
        [self performSelector:@selector(removeSplash) withObject:nil afterDelay:5.0];
    }
    else
    {
        [self removeSplash];
    }

}
-(void)removeSplash
{
    [viewSplash removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetBottomTabbar
{
    viewTabEvent.backgroundColor=[UIColor clearColor];
    viewTabAnnouncement.backgroundColor=[UIColor clearColor];
    viewTabFeedback.backgroundColor=[UIColor clearColor];
    viewTabUsefulInfo.backgroundColor=[UIColor clearColor];
    viewTabTermsAndConditions.backgroundColor=[UIColor clearColor];
    
    viewFilter.hidden=TRUE;
}

-(void)clearContentview
{
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    
    //[scrollPaging setContentOffset:CGPointZero];
    imgBg2.hidden=FALSE;
}


-(void)showHomeScreen
{
    
    [self resetBottomTabbar];
    [self clearContentview];
    imgBg2.hidden=TRUE;
    
    if(!IS_IPHONE_5)
    {
        CGRect frame=viewPageFull.frame;
        frame.origin.y=-40;
        viewPageFull.frame=frame;
        
        frame= imgPrevious.frame;
        frame.origin.y=260;
        imgPrevious.frame=frame;
        
        frame= imgNext.frame;
        frame.origin.y=260;
        imgNext.frame=frame;
        
        frame= btnPrevious.frame;
        frame.origin.y=260;
        btnPrevious.frame=frame;
        
        frame= btnNext.frame;
        frame.origin.y=260;
        btnNext.frame=frame;
        
        frame= pageControl.frame;
        frame.origin.y=360;
        pageControl.frame=frame;

        
        
    }
    
    [scrollPaging addSubview:viewPageFull];
    [scrollPaging setContentSize:CGSizeMake(viewPageFull.frame.size.width,0)];
    [viewContent addSubview:viewScrollBase];
    viewScrollBase.frame=CGRectMake(0, 0, 320, SCREEN_HEIGHT-45);
}

-(IBAction)eventsClicked:(id)sender
{
    [self resetBottomTabbar];
    [self clearContentview];
    
    viewTabEvent.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"Events and Courses";
    viewFilter.hidden=FALSE;
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    
    [viewContent addSubview:appDelegate.eventsVC.view];
    
    CGFloat pageWidth = scrollPaging.frame.size.width;
     [scrollPaging setContentOffset:CGPointMake(pageWidth*1,0) animated:TRUE];
    
     [appDelegate.eventsVC getNewEventsFromServer];
 }

-(IBAction)announcementClicked:(id)sender
{
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabAnnouncement.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"Announcements";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    
    [viewContent addSubview:appDelegate.announcementVC.view];
    
    CGFloat pageWidth = scrollPaging.frame.size.width;
    [scrollPaging setContentOffset:CGPointMake(pageWidth*0,0) animated:TRUE];

    [appDelegate.announcementVC getNewAnnouncementsFromServer];
}

-(IBAction)feedbackClicked:(id)sender
{
    
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabFeedback.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"Feedback";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat pageWidth = scrollPaging.frame.size.width;
    [scrollPaging setContentOffset:CGPointMake(pageWidth*2,0) animated:TRUE];
    
    [viewContent addSubview:appDelegate.feedbackVC.view];
    
}

-(IBAction)usefulInfoClicked:(id)sender
{
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabUsefulInfo.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"Useful Information";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    
    [viewContent addSubview:appDelegate.informationVC.view];

    CGFloat pageWidth = scrollPaging.frame.size.width;
    [scrollPaging setContentOffset:CGPointMake(pageWidth*3,0) animated:TRUE];
    [appDelegate.informationVC getAllInfoFromServer];
}

-(IBAction)newAboutClicked:(id)sender
{
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabTermsAndConditions.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"About Us";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    
    [viewContent addSubview:appDelegate.termsAndConditionsVC.view];
    
    CGFloat pageWidth = scrollPaging.frame.size.width;
    [scrollPaging setContentOffset:CGPointMake(pageWidth*4,0) animated:TRUE];
    [appDelegate.termsAndConditionsVC removeAllview];
}

-(IBAction)termsAndConditionClicked:(id)sender
{
    [viewContent addSubview:viewMoreMenu];
    
}

-(IBAction)backgroundMoreMenuClicked:(id)sender
{
    [viewMoreMenu removeFromSuperview];
}

-(IBAction)aboutUsClicked:(id)sender
{
    [viewMoreMenu removeFromSuperview];
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabTermsAndConditions.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"About Us";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    [viewContent addSubview:appDelegate.termsAndConditionsVC.view];
    [appDelegate.termsAndConditionsVC showAboutUs];
}

-(IBAction)wifiLoginClicked:(id)sender
{
    [viewMoreMenu removeFromSuperview];
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabTermsAndConditions.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"About Us";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    [viewContent addSubview:appDelegate.termsAndConditionsVC.view];
    [appDelegate.termsAndConditionsVC showWiFi];
}

-(IBAction)tAndcClicked:(id)sender
{
    [viewMoreMenu removeFromSuperview];
    [self resetBottomTabbar];
    [self clearContentview];
    viewTabTermsAndConditions.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5];
    
    lblHeader.text=@"About Us";
    
    for (UIView *subview in viewContent.subviews) {
        [subview removeFromSuperview];
    }
    [viewContent addSubview:appDelegate.termsAndConditionsVC.view];
    [appDelegate.termsAndConditionsVC showTC];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollPaging.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = scrollPaging.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page; // you need to have a **iVar** with getter for pageControl
    
    
    if(pageControl.currentPage>0)
    {
        imgPrevious.hidden=FALSE;
        btnPrevious.hidden=FALSE;
    }
    else
    {
        imgPrevious.hidden=TRUE;
        btnPrevious.hidden=TRUE;

    }
    
    if(pageControl.currentPage<4)
    {
        imgNext.hidden=FALSE;
        btnNext.hidden=FALSE;
    }
    else
    {
        imgNext.hidden=TRUE;
        btnNext.hidden=TRUE;
        
    }

}

-(IBAction)nextPageClicked:(id)sender
{
    CGFloat pageWidth = scrollPaging.frame.size.width;
    
    if((int)pageControl.currentPage<4)
    {
        int nextIndex=(int)pageControl.currentPage+1;
        [scrollPaging setContentOffset:CGPointMake(pageWidth*nextIndex,0) animated:TRUE];
    }
}

-(IBAction)previuosPageClicked:(id)sender
{
    CGFloat pageWidth = scrollPaging.frame.size.width;
    if((int)pageControl.currentPage>0)
    {
        int nextIndex=(int)pageControl.currentPage-1;
        [scrollPaging setContentOffset:CGPointMake(pageWidth*nextIndex,0) animated:TRUE];
    }
}
 
#pragma mark -Webservice delegate

-(void)parsingSucessfullFor:(NSString *)strMethodName With:(NSMutableArray *)arrList
{
    NSLog(@"Parsing Completed !!!");
    
}

-(void)parsingFailedFor:(NSString *)strMethodName With:(NSString *)strErrorMsg
{
    NSLog(@"Parsing Failed !!! %@",strErrorMsg);
}

-(void)addViewOnHome:(UIView *)subview
{
    subview.frame=CGRectMake(0, 0, viewContainer.bounds.size.width, viewContainer.bounds.size.height+20-ORIGIN_FACTOR);
    [viewContainer addSubview:subview];
}

@end
