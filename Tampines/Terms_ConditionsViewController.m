//  Terms&ConditionsViewController.m
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "Terms_ConditionsViewController.h"

@interface Terms_ConditionsViewController ()
{
    IBOutlet UITextView *txtviwAboutUsFBText;
}

@end

//@interface UIApplication (Private)
//
//- (BOOL)openURL:(NSURL*)url;
//
//@end

@implementation Terms_ConditionsViewController

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
        [scrollview setContentSize:CGSizeMake(320, SCREEN_HEIGHT-50)];
    else
        [scrollview setContentSize:CGSizeMake(320, SCREEN_HEIGHT-100)];
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TC" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL:nil];
    
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
    
    webView.scrollView.bounces=false;
    webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    CGRect frame=viewTCCenter.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewTCCenter.frame=frame;
    
        
    viewTCCenter1.frame=frame;
    viewTCCenter2.frame=frame;
    viewTCCenter3.frame=frame;
    if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"fb://profile/1498367654"]])
    {
         txtviwAboutUsFBText.text=@"Visit us on Facebook today: fb://profile/1498367654\nThank you.\nTampines West Community Club (TWCC) © 2014\nVersion 2014.1.1";
    }

}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark OpenURL Category method


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(IBAction)showTC:(id)sender
{
    webView.scrollView.contentOffset=CGPointZero;
    [self removeAllview];
    [self.view addSubview:viewTAndC];
    
   
}

-(IBAction)showAboutUs:(id)sender
{
    [self removeAllview];
    [self.view addSubview:viewAboutUs];
}


-(IBAction)showWiFi:(id)sender
{
    [self removeAllview];
    [self.view addSubview:viewWiFi];
    
    NSLog(@"WIFI=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"WiFiName"]);
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"WiFiName"])
    {
        txtName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"WiFiName"];
        txtPassword.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"WiFiPassword"];
    
    }
    else
    {
        txtName.text=@"twcc";
        txtPassword.text=@"tampwest95Home";
        
    }

    Webservice *webObj=[[Webservice alloc] init];
    webObj.delegate=self;
   [webObj GetDataInXMLFromWebService:@"GetWiFiDetails" parameterName:nil parameterValue:nil];
}

-(void)removeAllview
{
    [viewAboutUs removeFromSuperview];
     [viewWiFi removeFromSuperview];
    [viewTAndC removeFromSuperview];
}

-(IBAction)backToHomeClicked:(id)sender
{
    [appDelegate.homeVC showHomeScreen];
}

-(IBAction)backClicked:(id)sender
{
    [self removeAllview];
}

-(IBAction)callClicked:(id)sender
{
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:67837910"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Tampines" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
    

}

-(IBAction)faxClicked:(id)sender
{
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:67832208"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Tampines" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
    
    
}

-(IBAction)emailClicked:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer =
        [[MFMailComposeViewController alloc] init];
        [mailComposer setSubject:[NSString stringWithFormat:@"Feedback"]];
        
        NSString *strHTMLBody=[NSString stringWithFormat:@"To Tampines"];
        [mailComposer setMessageBody:strHTMLBody
                              isHTML:NO];
        

        
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

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Webservice delegate

-(void)parsingSucessfullFor:(NSString *)strMethodName With:(NSMutableArray *)arrList
{
    NSLog(@"Parsing Completed !!!");
    [appDelegate removeLoading];
    
    
    if([strMethodName isEqualToString:@"GetWiFiDetails"])
    {
        if([arrList count]==0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Tampines"
                                  message:@"There are currently no WiFi Details"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        txtName.text=[arrList objectAtIndex:0];
        txtPassword.text=[arrList objectAtIndex:1];
        
        [[NSUserDefaults standardUserDefaults] setValue:txtName.text forKey:@"WiFiName"];
        [[NSUserDefaults standardUserDefaults] setValue:txtPassword.text forKey:@"WiFiPassword"];
        
        [[NSUserDefaults standardUserDefaults]  synchronize];
    }
}

-(void)parsingFailedFor:(NSString *)strMethodName With:(NSString *)strErrorMsg
{
    NSLog(@"Parsing Failed !!! %@",strErrorMsg);
    [appDelegate removeLoading];
    
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Tampines"
                          message:strErrorMsg
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

@end
