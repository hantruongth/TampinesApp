//
//  FeedbackViewController.m
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize reverseGeocoder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [scrollview setFrame:CGRectMake(0, 48, 320, SCREEN_HEIGHT-100)];
    
    if(!IS_IPHONE_5)
        [scrollview setContentSize:CGSizeMake(320, SCREEN_HEIGHT)];
    else
        [scrollview setContentSize:CGSizeMake(320, SCREEN_HEIGHT-100)];
    
    arrFeedbackType=[[NSMutableArray alloc] initWithObjects:@"Estate/Cleanliness",@"Events",@"General Feedback", nil];
    
    
    viewAttachMap.frame=CGRectMake(0, ORIGIN_FACTOR, 320, SCREEN_HEIGHT-20);
    
    CGRect frame=viewAttachMapCenter.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewAttachMapCenter.frame=frame;
    
    frame=lblTitleEventAddress.frame;
    if(!IS_IPHONE_5)
        frame.origin.y =270;
    lblTitleEventAddress.frame=frame;
    
    frame=lblCurrentAddress.frame;
    if(!IS_IPHONE_5)
        frame.origin.y =290;
    lblCurrentAddress.frame=frame;
    
     [self HideKeyboardAndDoneButtonBar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //scrollview.scrollEnabled=FALSE;
    [self ShowKeyboardAndDoneButtonBar];

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self HideKeyboardAndDoneBarClicked:Nil];
    [textField resignFirstResponder];
    return TRUE;
}

//-----------------------------------------------------------------
#pragma mark - Text view
//-----------------------------------------------------------------
- (void) textViewDidChange: (UITextView *) textView {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        CGRect line = [textView caretRectForPosition:
                       textView.selectedTextRange.start];
        CGFloat overflow = line.origin.y + line.size.height
        - ( textView.contentOffset.y + textView.bounds.size.height
           - textView.contentInset.bottom - textView.contentInset.top );
        if ( overflow > 0 ) {
            // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
            // Scroll caret to visible area
            CGPoint offset = textView.contentOffset;
            offset.y += overflow + 7; // leave 7 pixels margin
            // Cannot animate with setContentOffset:animated: or caret will not appear
            [UIView animateWithDuration:.2 animations:^{
                [textView setContentOffset:offset];
            }];
        }
        }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [self ShowKeyboardAndDoneButtonBar];
    
    if(textView==txtDescription)
    {
        if(IS_IPHONE_5)
            [scrollview setContentOffset:CGPointMake(0, 60) animated:TRUE];
        else
            [scrollview setContentOffset:CGPointMake(0, 100) animated:TRUE];
    }
    else
    {
        if(IS_IPHONE_5)
            [scrollview setContentOffset:CGPointMake(0, 130) animated:TRUE];
        else
            [scrollview setContentOffset:CGPointMake(0, 200) animated:TRUE];

    }
}

-(IBAction)HideKeyboardAndDoneBarClicked:(id)sender
{
    [scrollview  setContentOffset:CGPointMake(0, 0)];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtLocation resignFirstResponder];
    
    
    [viewDone removeFromSuperview];
    [self HideKeyboardAndDoneButtonBar];
}



-(void)HideKeyboardAndDoneButtonBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [viewDone setFrame:CGRectMake(0.0,1000.0,320.0,50.0)];
    [UIView commitAnimations];
    
    [scrollview setContentOffset:CGPointMake(0, 0) animated:TRUE];
    if(!IS_IPHONE_5)
        [scrollview setContentSize:CGSizeMake(320, SCREEN_HEIGHT)];
    else
        [scrollview setContentSize:CGSizeMake(320, SCREEN_HEIGHT-100)];
}

-(void)ShowKeyboardAndDoneButtonBar
{
    [scrollview setContentSize:CGSizeMake(320, 700)];
    [appDelegate.homeVC addViewOnHome:viewDone];
    [viewDone setFrame:CGRectMake(0.0,1000.0,320.0,50.0)];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    if([[UIDevice currentDevice] systemVersion].doubleValue>=7.0)
        [viewDone setFrame:CGRectMake(0.0,(SCREEN_HEIGHT-260-20),320.0,50.0)];
    else
        [viewDone setFrame:CGRectMake(0.0,(SCREEN_HEIGHT-260-20),320.0,50.0)];
    [UIView commitAnimations];
}



-(IBAction)getLocationClicked:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter =10;
    [locationManager startUpdatingLocation];
    
    [appDelegate showLoading:@"Loading"];
     [self HideKeyboardAndDoneBarClicked:nil];
    [appDelegate.homeVC addViewOnHome:viewAttachMap];
    [appDelegate animatePushViewController:viewAttachMap andViewToBeRemoved:viewContent state:0];
}

-(IBAction)backLocationClicked:(id)sender
{
    [appDelegate animatePopViewController:viewContent andViewToBeRemoved:viewAttachMap];
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    
     [locationManager stopUpdatingLocation];
    [appDelegate removeLoading];
    //Show Annotattios
    [mapView removeAnnotations:mapView.annotations];
    //CLLocationCoordinate2D from=CLLocationCoordinate2DMake(1.343517, 103.846259);
    
   CLLocationCoordinate2D from=currentLocation.coordinate;
    // remove any annotations that exist
    SFAnnotation *annotation = [[SFAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(from.latitude, from.longitude)];
    annotation.imgPin=[UIImage imageNamed:@"ic_pin.png"];
    [mapView addAnnotation:annotation];
    
    //mapView.centerCoordinate=currentLocation.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.4;
    span.longitudeDelta = 0.4;
    
    MKCoordinateRegion region;
    region.center = from;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
    
    //reverse-geocode location
	reverseGeocoder = [[MJReverseGeocoder alloc] initWithCoordinate:from];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;
{
    [appDelegate removeLoading];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tampines"
                                                        message:@"Unable to get current location." delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
#pragma mark -
#pragma mark MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if(annotationView)
        return annotationView;
    else
    {
        SFAnnotation *lpoint=(SFAnnotation *)annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        annotationView.image=lpoint.imgPin;
        return annotationView;
    }
    return nil;
}

#pragma mark -
#pragma mark MJReverseGeocoderDelegate

- (void)reverseGeocoder:(MJReverseGeocoder *)geocoder didFindAddress:(Address *)addressComponents{
	//hide network indicator
	[appDelegate  removeLoading];
    txtLocation.text=addressComponents.fullAddress;
    lblCurrentAddress.text=txtLocation.text;
	/*txtLocation.text = [NSString stringWithFormat:@"%@ %@, %@, %@",
                        addressComponents.streetNumber,
                        addressComponents.route,
                        addressComponents.city,
                        addressComponents.stateCode];*/
}


- (void)reverseGeocoder:(MJReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
	//show network indicator
	
    [appDelegate  removeLoading];
    NSLog(@"REVERSE GEOCODE ERROR CODE: %ld", (long)[error code]);
    
    if([error code] == 1){
        NSLog(@"NO REVERSE GEOCODE RESULTS");
    }
}




-(IBAction)getPhotoClicked:(id)sender
{
    [self HideKeyboardAndDoneBarClicked:nil];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo to Attach"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Select from Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:appDelegate.homeVC.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int i = (int)buttonIndex;
    switch(i)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.editing=TRUE;
            [appDelegate.homeVC presentViewController:picker animated:YES completion:^{}];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.editing=TRUE;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [appDelegate.homeVC presentViewController:picker animated:YES completion:^{}];
        }
        default:
            // Do Nothing.........
            break;
    }
}

#pragma mark -
#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:^{}];
    self.selectedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!self.selectedImage)
    {
        return;
    }
    
    // Adjusting Image Orientation
    NSData *data = UIImagePNGRepresentation(self.selectedImage);
    UIImage *tmp = [UIImage imageWithData:data];
    UIImage *fixed = [UIImage imageWithCGImage:tmp.CGImage
                                         scale:self.selectedImage.scale
                                   orientation:self.selectedImage.imageOrientation];
    imgSelected.image = fixed;
    
}

-(IBAction)backToHomeClicked:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self HideKeyboardAndDoneBarClicked:nil];
    [appDelegate.homeVC showHomeScreen];
}

-(IBAction)clearClicked:(id)sender
{
     [self HideKeyboardAndDoneBarClicked:nil];
    
    txtFirstName.text=@"";
    txtLastName.text=@"";
    txtEmail.text=@"";
    
    txtDescription.text=@"";
    txtLocation.text=@"";
    
    lblFeedbackType.text=@"Select type";
    
    imgSelected.image=[UIImage imageNamed:@"symbol_white.png"];
    self.selectedMap=nil;

}

-(IBAction)feedbackClicked:(id)sender
{
    
    
}

-(IBAction)feedbackEmailClicked:(id)sender
{
    [self HideKeyboardAndDoneBarClicked:nil];

    if(txtFirstName.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tampines"
                                                       message:@"Please enter first name."
                                                      delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if([lblFeedbackType.text isEqualToString:@"Select type"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tampines"
                                                       message:@"Please select feedback type."
                                                      delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if([txtDescription.text length]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tampines"
                                                       message:@"Please enter description."
                                                      delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    

    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer =
        [[MFMailComposeViewController alloc] init];
        [mailComposer setSubject:[NSString stringWithFormat:@"Feedback: %@",lblFeedbackType.text]];
        
        NSString *strHTMLBody=[NSString stringWithFormat:@"To Tampines CC Officer,\n\nName: %@ %@\nDescription: %@\nLocation: %@\n\nThanks,\n Tampines Resident",txtFirstName.text,txtLastName.text,txtDescription.text,txtLocation.text];
        [mailComposer setMessageBody:strHTMLBody
                              isHTML:NO];
        
        if(imgSelected.image!=[UIImage imageNamed:@"symbol_white.png"])
        {
            NSData *imageData = UIImageJPEGRepresentation(imgSelected.image, 0.5);
            [mailComposer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"Tampines.jpg"]];
        }
        
        if(self.selectedMap)
        {
            NSData *imageData2 = UIImageJPEGRepresentation(self.selectedMap, 0.5);
            [mailComposer addAttachmentData:imageData2 mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"Location.jpg"]];
        }
        
        [mailComposer setToRecipients:[NSArray arrayWithObjects:@"PA_TampinesWestCC@pa.gov.sg", nil]];
        mailComposer.mailComposeDelegate = self;
        [appDelegate.homeVC presentViewController:mailComposer animated:YES completion:nil];
        
        //mobileapp.qa@gmail.com
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tampines"
                                                       message:@"Please configure your email account first."
                                                      delegate:self
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self clearClicked:nil];
    
    if(result==MFMailComposeResultSent)
    {
        [appDelegate showToast:@"Feedback sent"];
    }
}

-(IBAction)feedbackTypeClicked:(id)sender
{
    [self HideKeyboardAndDoneBarClicked:nil];
    CGRect frame=CGRectMake(140, 318, 140, 80);
    frame.origin.y-=scrollview.contentOffset.y;
    viewPopup.frame=frame;
    
    [appDelegate.homeVC addViewOnHome:viewShowFeedbackType];
}

-(IBAction)removeFeedbackTypeClicked:(id)sender
{
    [viewShowFeedbackType removeFromSuperview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrFeedbackType count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 25;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier=@"MyIndentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    //Disable cell selection
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //------------------------------Clear All-----------------
    for (UIView *view in cell.contentView.subviews) {
        
        {
            [view removeFromSuperview];
        }
        
    }
    
    
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 25)];
        lblName.text=[arrFeedbackType objectAtIndex:indexPath.row];
        lblName.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=COLOR_DARK_RED;
        [cell.contentView addSubview:lblName];
        lblName=nil;
        
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    lblFeedbackType.text=[arrFeedbackType objectAtIndex:indexPath.row];
       [viewShowFeedbackType removeFromSuperview];
}


-(IBAction)attachPhotoClicked:(id)sender
{
    UIGraphicsBeginImageContext(mapView.frame.size);
	[mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    self.selectedMap=viewImage;
    
    [appDelegate animatePopViewController:viewContent andViewToBeRemoved:viewAttachMap];
    
    [appDelegate showToast:@"Current location map tile attached with your feedback email."];
}

@end
