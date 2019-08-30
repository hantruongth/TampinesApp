//
//  FeedbackViewController.h
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
 #import <MessageUI/MessageUI.h>
#import "MJReverseGeocoder.h"
#import "Address.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@class AppDelegate;
@interface FeedbackViewController : UIViewController<UITextFieldDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MJReverseGeocoderDelegate,MKMapViewDelegate,CLLocationManagerDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UITextField *txtFirstName,*txtLastName,*txtEmail;
    IBOutlet UITextView *txtDescription,*txtLocation;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    IBOutlet UIImageView *imgSelected;
    
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIView *viewContent;
    
    IBOutlet UIView *viewDone;
    
    
    IBOutlet UIView *viewShowFeedbackType;
    IBOutlet UITableView *tblFeedbackType;
    NSMutableArray *arrFeedbackType;
    
    IBOutlet UILabel *lblFeedbackType;
    IBOutlet UIView *viewPopup;
    MJReverseGeocoder *reverseGeocoder;
    
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *lblCurrentAddress;
    
    UIView *viewAttachMap,*viewAttachMapCenter;
    
    IBOutlet UILabel *lblTitleEventAddress;
    
}

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *selectedMap;
@property(nonatomic, retain) MJReverseGeocoder *reverseGeocoder;

@end
