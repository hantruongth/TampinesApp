//
//  EventsViewController.h
//  Tampines
//
//  Created by Pradip on 11/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <EventKit/EventKit.h>
#import "Webservice.h"
#import <MapKit/MapKit.h>
#import "SFAnnotation.h"
#import "RegexKitLite.h"
#import "SVSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <EventKitUI/EventKitUI.h>

@class AppDelegate;
@class Webservice;

@interface EventsViewController : UIViewController<WebDataParserDelegate,MKMapViewDelegate,CLLocationManagerDelegate,EKEventEditViewDelegate>
{
    
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *tblEvents,*tblCategory;
    NSMutableArray *arrEvents,*arrCategory,*arrSelectedCategory,*arrTempEvents;
    
    IBOutlet UIImageView *imgTabBackground;
    IBOutlet UIScrollView *scrollRCTab;
    IBOutlet UIView *viewRCNames;
    
    IBOutlet UIView *viewCategory;
    
    SVSegmentedControl *redSC;
    BOOL isCCSelected;
    //Event Details
    
    IBOutlet UIView *viewEventDetails,*viewListContent;
    IBOutlet UILabel *lblDetailsEventName;
    IBOutlet UIScrollView *scrollEventDetails;
    
    int intSelectedEventIndex;
    
    //Event Location
    
    IBOutlet UIView *viewEventLocation;
    IBOutlet UILabel *lblAddToDeviceCalender;
    IBOutlet UILabel *lblEventLocation;
    
    IBOutlet MKMapView *mapView;
    UIImageView* routeView;
	NSArray* routes;
	UIColor* lineColor;
    MKPolylineView *routeLineView;
    MKCoordinateRegion region;
    
    IBOutlet UIView *viewList,*viewEventDetailsCenter,*viewEventLocationCenter;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UIActivityIndicatorView *activity;
    
    IBOutlet UIButton *btnNext,*btnPrevious;
    IBOutlet UIImageView *imgNext,*imgPrevious;
    
    int selectedRC,intSelectedCategory;
    
    IBOutlet UILabel *lblTitleEventAddress;
    
    BOOL isAllCategorySelected;
    
    
    IBOutlet UIImageView *img1,*img2,*img3;
    IBOutlet UIButton *btn1,*btn2;
    
    NSMutableArray *arrAllActiveEvents;
}

-(void)getNewEventsFromServer;
-(void)getAllCategoriesFromServer;
-(void)setEventStatus;



@end
