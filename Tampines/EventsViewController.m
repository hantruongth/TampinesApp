
//
//  EventsViewController.m
//  Tampines
//
//  Created by Pradip on 11/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "EventsViewController.h"

@interface EventsViewController ()

@end

@implementation EventsViewController

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
    
    
    arrAllActiveEvents=[[NSMutableArray alloc] init];
    /*
     Palmspring RC
     Palmsville RC
     Polyview RC
     Green RC
     Grove RC
     Park RC
     Terrace RC
     Summerville RC
     
     i) Sports
     ￼ii) Youth
     ￼iii) Festivals
     ￼iv) Active Ageing
     ￼v) Racial Harmony
     ￼vi) Arts and Culture
     ￼vii) Woman’s
     ￼viii) Community Emergency & Engagement
     */
    
    arrEvents =[[NSMutableArray alloc] init];
    arrCategory=[[NSMutableArray alloc] init];
    
    [scrollRCTab addSubview:viewRCNames];
    [scrollRCTab setContentSize:viewRCNames.frame.size];
    scrollRCTab.hidden=TRUE;
    
    NSLog(@"Home View =%@",appDelegate.homeVC.view);
    viewEventDetails.frame=CGRectMake(0, 0, 320, SCREEN_HEIGHT-20);
     viewEventLocation.frame=CGRectMake(0, ORIGIN_FACTOR, 320, SCREEN_HEIGHT-20);
    
    // 2nd CONTROL
	redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"All",@"Green", @"Park", @"Palmsville",@"Summerville", @"Palmspring", @"Polyview", @"Terrace", @"Grove", nil]];
    [redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
	redSC.crossFadeLabelsOnDrag = YES;
	redSC.thumb.tintColor = COLOR_DARK_RED;
    
    redSC.font = [UIFont fontWithName:FONT_REGULAR size:12];
    redSC.height=27;
    [redSC setSelectedSegmentIndex:0 animated:NO];
	
	[viewRCNames addSubview:redSC];
	
    redSC.center =viewRCNames.center;
    
    
    CGRect frame=viewList.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewList.frame=frame;
    
    frame=viewEventDetailsCenter.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewEventDetailsCenter.frame=frame;
    
    frame=viewEventLocationCenter.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=350;
    viewEventLocationCenter.frame=frame;
    
    frame=lblTitleEventAddress.frame;
    if(!IS_IPHONE_5)
        frame.origin.y =275;
    lblTitleEventAddress.frame=frame;

    frame=scrollEventDetails.frame;
    if(!IS_IPHONE_5)
        frame.size.height =238;
    scrollEventDetails.frame=frame;
    
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = 10.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    isCCSelected=TRUE;
    
    //[self addDummyCategories];

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToHomeClicked:(id)sender
{
    [appDelegate.homeVC showHomeScreen];
}

-(void)getNewEventsFromServer
{
   // return;
    
    [tblEvents setContentOffset:CGPointZero];
    
    if(![appDelegate hasConnectivity])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tampines"
                                                            message:@"No internet connection available" delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    Webservice *webObj=[[Webservice alloc] init];
    webObj.delegate=self;
    [webObj GetDataInXMLFromStoredProcedure:@"_tspGetAllEvent" parameterName:nil parameterValue:nil];
    
    [appDelegate showLoading:@"Loading"];

}

-(void)getAllCategoriesFromServer
{
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![appDelegate hasConnectivity])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Tampines"
                                                            message:@"No internet connection available" delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    Webservice *webObj=[[Webservice alloc] init];
    webObj.delegate=self;
    [webObj GetDataInXMLFromStoredProcedure:@"_tspGetAllCategory" parameterName:nil parameterValue:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if(tableView==tblEvents)
        numberOfRows=[arrEvents count];
    else
        numberOfRows=[arrCategory count]+1;
    
    return numberOfRows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==tblEvents)
        return 80;
    
     UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(28, 5, 140, 40)];
    
    
   
    if([indexPath row]==0)
       lblName.text=@"All";
    else
    {
         ClsCategory *objCategory = [arrCategory objectAtIndex:[indexPath row]-1];
        lblName.text=objCategory.name;
    }
    lblName.font=[UIFont fontWithName:FONT_BOLD size:13.0];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.textColor=[UIColor whiteColor];
    lblName.numberOfLines=0;
    
    [lblName sizeToFit];
    
    return lblName.frame.size.height+12;
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
    //----------------Clear All-------------------------------
    for (UIView *view in cell.contentView.subviews) {
        
        {
            [view removeFromSuperview];
        }
        
    }
    
    

    
    if(tableView==tblEvents)
    {
        UIView *viewLine=[[UIView alloc ] initWithFrame:CGRectMake(0, 79, 238, 0.5)];
        viewLine.backgroundColor=COLOR_DARK_RED;
        [cell.contentView addSubview:viewLine];
        viewLine=nil;
        
        ClsEvent *objEvent = [arrEvents objectAtIndex:[indexPath row]];
        /*UIImageView *imgIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgthumbWestCC.jpg"]];
        imgIcon.frame=CGRectMake(5, 15, 53, 44);
        [cell.contentView addSubview:imgIcon];
        
       if(isCCSelected==FALSE)
        {
            int intRC=selectedRC;
            
            if(selectedRC==0)
                intRC=[self getFirstRcId:objEvent];
            
            UIImage *imgRC=[UIImage imageNamed:[NSString stringWithFormat:@"thumb%d.png",intRC]];
        if(imgRC)
            imgIcon.image=imgRC;
        }
        
        imgIcon=nil;*/
        
        UIImageView *imgArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_arrow@2x.png"]];
        imgArrow.frame=CGRectMake(215, 30, 16, 19);
        [cell.contentView addSubview:imgArrow];
        imgArrow=nil;
        
        
        
        
        
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        lblName.text=objEvent.name;
         lblName.font=[UIFont fontWithName:FONT_BOLD size:16.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=COLOR_DARK_RED;
        lblName.numberOfLines=2;
        [cell.contentView addSubview:lblName];
        lblName=nil;
        
        UILabel *lblDescription=[[UILabel alloc] initWithFrame:CGRectMake(15, 40, 180, 60)];
        lblDescription.text=objEvent.description;
        lblDescription.backgroundColor=[UIColor clearColor];
        lblDescription.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
        lblDescription.textColor=COLOR_DARK_RED;
        [cell.contentView addSubview:lblDescription];
        lblDescription.numberOfLines=2;
        [lblDescription sizeToFit];
        lblDescription=nil;
    }
    else if(tableView==tblCategory)
    {
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(28, 5, 140, 40)];
        
        
        
        if([indexPath row]==0)
            lblName.text=@"All";
        else
        {
            ClsCategory *objCategory = [arrCategory objectAtIndex:[indexPath row]-1];
            lblName.text=objCategory.name;
        }
        lblName.font=[UIFont fontWithName:FONT_BOLD size:13.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=[UIColor whiteColor];
        lblName.numberOfLines=0;
        
        [lblName sizeToFit];
        [cell.contentView addSubview:lblName];
        lblName=nil;
        
        UIImageView *imgSwitch=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio_btn.png"]];
        if([indexPath row]==0)
        {
            if(isAllCategorySelected)
                imgSwitch.image=[UIImage imageNamed:@"radio_btn_sel.png"];
        }
        else{
        if([[arrSelectedCategory objectAtIndex:indexPath.row-1] boolValue])
            imgSwitch.image=[UIImage imageNamed:@"radio_btn_sel.png"];
        }
        
        imgSwitch.frame=CGRectMake(5, 5, 14, 14);
        [cell.contentView addSubview:imgSwitch];
        imgSwitch=nil;
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView==tblEvents)
    {
        intSelectedEventIndex=(int)indexPath.row;
        ClsEvent *objEvent=[arrEvents objectAtIndex:indexPath.row];
        [self showEventDetails:objEvent];
        
        
        NSLog(@"Home View Frame=%@",appDelegate.homeVC.view);
        NSLog(@"Event Deatail View Frame=%@",viewEventDetails);
        //[appDelegate.homeVC addViewOnHome:viewEventDetails];
        [appDelegate.homeVC addViewOnHome:viewEventDetails];
        [appDelegate animatePushViewController:viewEventDetails andViewToBeRemoved:viewListContent state:0];


    }
    else if(tableView==tblCategory)
    {
        if([indexPath row]==0)
        {
            isAllCategorySelected=!isAllCategorySelected;
            arrSelectedCategory=nil;
            arrSelectedCategory=[[NSMutableArray alloc] init];
            for (int i=0; i<arrCategory.count; i++) {
                [arrSelectedCategory addObject:@"0"];
            }
        }
        else
        {
            isAllCategorySelected=FALSE;
        intSelectedCategory=(int)indexPath.row-1;
        NSString *strChangedState=[NSString stringWithFormat:@"%d",![[arrSelectedCategory objectAtIndex:intSelectedCategory] boolValue]];
        [arrSelectedCategory replaceObjectAtIndex:intSelectedCategory withObject:strChangedState];
        }
        
        [tblCategory reloadData];
        [arrEvents removeAllObjects];
        
        
        if(isCCSelected)
        {
            [self showEvents_CC];
        }
        else
        {
            [self showEvents_RC:(selectedRC)];
        }
    
    
}

}
-(IBAction)RCClicked:(id)sender
{
    
    isCCSelected=FALSE;
    intSelectedEventIndex=0;
    selectedRC=0;
    imgTabBackground.image=[UIImage imageNamed:@"tab4.png"];
    scrollRCTab.hidden=FALSE;
    [scrollRCTab setContentOffset:CGPointZero];
     [redSC setSelectedSegmentIndex:0 animated:NO];
    
    
    //Set Default Category All
    isAllCategorySelected=TRUE;
    arrSelectedCategory=nil;
    arrSelectedCategory=[[NSMutableArray alloc] init];
    for (int i=0; i<arrCategory.count; i++) {
        [arrSelectedCategory addObject:@"0"];
    }
    
    [self showEvents_RC:0];

}

-(IBAction)CCClicked:(id)sender
{
    isCCSelected=TRUE;
    
    imgTabBackground.image=[UIImage imageNamed:@"tab3.png"];
    scrollRCTab.hidden=TRUE;
    
    //Set Default Category All
    isAllCategorySelected=TRUE;
    arrSelectedCategory=nil;
    arrSelectedCategory=[[NSMutableArray alloc] init];
    for (int i=0; i<arrCategory.count; i++) {
        [arrSelectedCategory addObject:@"0"];
    }
    [self showEvents_CC];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset {
    /*if (scrollView == scrollRCTab) {
        CGFloat x = targetContentOffset->x;
        
        NSLog(@"targetContentOffset->x=%f",targetContentOffset->x);
        x = roundf(x / 120.0f) * 120.0f;
        targetContentOffset->x = x;
        
        [self resetCategories];
    } */
}

-(IBAction)removeCategoryViewClicked:(id)sender
{
    [viewCategory removeFromSuperview];
}

-(IBAction)filterClicked:(id)sender
{
    [appDelegate.homeVC addViewOnHome:viewCategory];
    
    if(arrCategory.count==0)
    {
        [self getAllCategoriesFromServer];
    }
}

/*
    The filter option should work only for either RC or events category. If the user select a particular RC, all the events conducting from the RC should be listed. If the user select a particular event, all RC conducting the particular event should be listed.
 */

-(void)resetCategories
{

    for (int i=0; i<[arrSelectedCategory count]; i++) {
        [arrSelectedCategory replaceObjectAtIndex:i withObject:@"0"];
    }
    [tblCategory reloadData];
}

-(void)showEventDetails:(ClsEvent *)objEvent
{
    activity.hidden=TRUE;
    [activity stopAnimating];
    
    lblDetailsEventName.text=objEvent.name;
    lblEventLocation.text=objEvent.venue;
    
    if(intSelectedEventIndex>0)
    {
        imgPrevious.hidden=FALSE;
        btnPrevious.hidden=FALSE;
    }
    else
    {
        imgPrevious.hidden=TRUE;
        btnPrevious.hidden=TRUE;
        
    }
    
    if(intSelectedEventIndex<[arrEvents count]-1)
    {
        imgNext.hidden=FALSE;
        btnNext.hidden=FALSE;
    }
    else
    {
        imgNext.hidden=TRUE;
        btnNext.hidden=TRUE;
        
    }
    
    
    //Make Subview Clear
    for (UIView *subview in scrollEventDetails.subviews) {
        if(subview.tag==100)
            [subview removeFromSuperview];
    }
    
    NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
    [dateFormatterWS setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:@"dd/MM/yyyy"];
    
    
    //-----  Description --------------
    UILabel *lblDescription=[[UILabel alloc] init];
    lblDescription.tag=100;
    lblDescription.text=@"Description:";
    lblDescription.textColor=COLOR_DARK_RED;
    lblDescription.backgroundColor=[UIColor clearColor];
    lblDescription.frame=CGRectMake(10, 10, 200, 20);
    lblDescription.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblDescription];
    
    UILabel *lblDescriptionText=[[UILabel alloc] init];
    lblDescriptionText.tag=100;
    lblDescriptionText.text=objEvent.description;
    lblDescriptionText.textColor=COLOR_DARK_RED;
    lblDescriptionText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblDescriptionText.backgroundColor=[UIColor clearColor];
    lblDescriptionText.frame=CGRectMake(10, 30, 210, 10);
    lblDescriptionText.numberOfLines=0;
    [lblDescriptionText sizeToFit];
    [scrollEventDetails addSubview:lblDescriptionText];
    
    
     //-----  Start Date --------------
    UILabel *lblStartDate=[[UILabel alloc] init];
    lblStartDate.tag=100;
    lblStartDate.text=@"Start Date:";
    lblStartDate.textColor=COLOR_DARK_RED;
    lblStartDate.backgroundColor=[UIColor clearColor];
    lblStartDate.frame=CGRectMake(10, 10+lblDescriptionText.frame.origin.y+lblDescriptionText.frame.size.height, 200, 20);
    lblStartDate.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblStartDate];
    
    UILabel *lblStartDateText=[[UILabel alloc] init];
    lblStartDateText.tag=100;
    
    if(objEvent.startDate)
        lblStartDateText.text=objEvent.startDate;
    else
        lblStartDateText.text=@"-";
    lblStartDateText.textColor=COLOR_DARK_RED;
    lblStartDateText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblStartDateText.backgroundColor=[UIColor clearColor];
    lblStartDateText.frame=CGRectMake(10, 30+lblDescriptionText.frame.origin.y+lblDescriptionText.frame.size.height, 200, 20);
    lblStartDateText.numberOfLines=0;
    [lblStartDateText sizeToFit];
    [scrollEventDetails addSubview:lblStartDateText];
    
     //-----  End Date --------------
    UILabel *lblEndDate=[[UILabel alloc] init];
    lblEndDate.tag=100;
    lblEndDate.text=@"End Date:";
    lblEndDate.textColor=COLOR_DARK_RED;
    lblEndDate.backgroundColor=[UIColor clearColor];
    lblEndDate.frame=CGRectMake(10, 10+lblStartDateText.frame.origin.y+lblStartDateText.frame.size.height, 200, 20);
    lblEndDate.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblEndDate];

    UILabel *lblEndDateText=[[UILabel alloc] init];
    lblEndDateText.tag=100;
    
    if(objEvent.endDate)
        lblEndDateText.text=objEvent.endDate;
    else
        lblEndDateText.text=@"-";
    
    lblEndDateText.textColor=COLOR_DARK_RED;
    lblEndDateText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblEndDateText.backgroundColor=[UIColor clearColor];
    lblEndDateText.frame=CGRectMake(10, 30+lblStartDateText.frame.origin.y+lblStartDateText.frame.size.height, 200, 20);
    lblEndDateText.numberOfLines=0;
    [lblEndDateText sizeToFit];
    [scrollEventDetails addSubview:lblEndDateText];
    
    
    //-----  Start Time --------------
    
    UILabel *lblStartTime=[[UILabel alloc] init];
    lblStartTime.tag=100;
    lblStartTime.text=@"Start Time:";
    lblStartTime.textColor=COLOR_DARK_RED;
    lblStartTime.backgroundColor=[UIColor clearColor];
    lblStartTime.frame=CGRectMake(10, 10+lblEndDateText.frame.origin.y+lblEndDateText.frame.size.height, 200, 20);
    lblStartTime.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblStartTime];
    
    UILabel *lblStartTimeText=[[UILabel alloc] init];
    lblStartTimeText.tag=100;
    
    if(objEvent.startTime)
        lblStartTimeText.text=objEvent.startTime;
    else
        lblStartTimeText.text=@"-";
    lblStartTimeText.textColor=COLOR_DARK_RED;
    lblStartTimeText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblStartTimeText.backgroundColor=[UIColor clearColor];
    lblStartTimeText.frame=CGRectMake(10, 30+lblEndDateText.frame.origin.y+lblEndDateText.frame.size.height, 200, 20);
    lblStartTimeText.numberOfLines=0;
    [lblStartTimeText sizeToFit];
    [scrollEventDetails addSubview:lblStartTimeText];
    
    //-----  End Time --------------
    
    UILabel *lblEndTime=[[UILabel alloc] init];
    lblEndTime.tag=100;
    lblEndTime.text=@"End Time:";
    lblEndTime.textColor=COLOR_DARK_RED;
    lblEndTime.backgroundColor=[UIColor clearColor];
    lblEndTime.frame=CGRectMake(10, 10+lblStartTimeText.frame.origin.y+lblStartTimeText.frame.size.height, 200, 20);
    lblEndTime.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblEndTime];
    
    UILabel *lblEndTimeText=[[UILabel alloc] init];
    lblEndTimeText.tag=100;
    
    if(objEvent.endTime)
        lblEndTimeText.text=objEvent.endTime;
    else
        lblEndTimeText.text=@"-";
    
    lblEndTimeText.textColor=COLOR_DARK_RED;
    lblEndTimeText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblEndTimeText.backgroundColor=[UIColor clearColor];
    lblEndTimeText.frame=CGRectMake(10, 30+lblStartTimeText.frame.origin.y+lblStartTimeText.frame.size.height, 200, 20);
    lblEndTimeText.numberOfLines=0;
    [lblEndTimeText sizeToFit];
    [scrollEventDetails addSubview:lblEndTimeText];
    //-----  Days --------------
    UILabel *lblDays=[[UILabel alloc] init];
    lblDays.tag=100;
    lblDays.text=@"Days:";
    lblDays.textColor=COLOR_DARK_RED;
    lblDays.backgroundColor=[UIColor clearColor];
    lblDays.frame=CGRectMake(10, 10+lblEndTimeText.frame.origin.y+lblEndTimeText.frame.size.height, 200, 20);
    lblDays.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblDays];
    
    UILabel *lblDaysText=[[UILabel alloc] init];
    lblDaysText.tag=100;
    
    if(objEvent.cDays)
        lblDaysText.text=objEvent.cDays;
    else
        lblDaysText.text=@"-";
    
    lblDaysText.textColor=COLOR_DARK_RED;
    lblDaysText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblDaysText.backgroundColor=[UIColor clearColor];
    lblDaysText.frame=CGRectMake(10, 30+lblEndTimeText.frame.origin.y+lblEndTimeText.frame.size.height, 200, 20);
    lblDaysText.numberOfLines=0;
    [lblDaysText sizeToFit];
    [scrollEventDetails addSubview:lblDaysText];
    
    //-----  Address --------------
    UILabel *lblVenue=[[UILabel alloc] init];
    lblVenue.tag=100;
    lblVenue.text=@"Venue:";
    lblVenue.textColor=COLOR_DARK_RED;
    lblVenue.backgroundColor=[UIColor clearColor];
    lblVenue.frame=CGRectMake(10, 10+lblDaysText.frame.origin.y+lblDaysText.frame.size.height, 200, 20);
    lblVenue.font=[UIFont fontWithName:FONT_BOLD size:15];
    [scrollEventDetails addSubview:lblVenue];
    
    UILabel *lblVenueText=[[UILabel alloc] init];
    lblVenueText.tag=100;
    lblVenueText.text=objEvent.venue;
    lblVenueText.textColor=COLOR_DARK_RED;
    lblVenueText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblVenueText.backgroundColor=[UIColor clearColor];
    lblVenueText.frame=CGRectMake(10, 30+lblDaysText.frame.origin.y+lblDaysText.frame.size.height, 210, 10);
    lblVenueText.numberOfLines=0;
    [lblVenueText sizeToFit];
    [scrollEventDetails addSubview:lblVenueText];
    
    //-----  Organizer --------------
    
    UILabel *lblOrganizer=[[UILabel alloc] init];
    lblOrganizer.tag=100;
    lblOrganizer.text=@"Organizer:";
    lblOrganizer.textColor=COLOR_DARK_RED;
    lblOrganizer.backgroundColor=[UIColor clearColor];
    lblOrganizer.frame=CGRectMake(10, 10+lblVenueText.frame.origin.y+lblVenueText.frame.size.height, 200, 20);
    lblOrganizer.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblOrganizer];
    
    UILabel *lblOrganizerText=[[UILabel alloc] init];
    lblOrganizerText.tag=100;
    
    if(objEvent.organizer)
        lblOrganizerText.text=objEvent.organizer;
    else
        lblOrganizerText.text=@"-";
    lblOrganizerText.textColor=COLOR_DARK_RED;
    lblOrganizerText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblOrganizerText.backgroundColor=[UIColor clearColor];
    lblOrganizerText.frame=CGRectMake(10, 30+lblVenueText.frame.origin.y+lblVenueText.frame.size.height, 200, 10);
    lblOrganizerText.numberOfLines=0;
    [lblOrganizerText sizeToFit];
    [scrollEventDetails addSubview:lblOrganizerText];
    
     //-----  Contact --------------
    
    UILabel *lblContact=[[UILabel alloc] init];
    lblContact.tag=100;
    lblContact.text=@"Contact:";
    lblContact.textColor=COLOR_DARK_RED;
    lblContact.backgroundColor=[UIColor clearColor];
    lblContact.frame=CGRectMake(10, 10+lblOrganizerText.frame.origin.y+lblOrganizerText.frame.size.height, 200, 20);
    lblContact.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblContact];
    
    UILabel *lblContactText=[[UILabel alloc] init];
    lblContactText.tag=100;
    
    if(objEvent.contact)
    lblContactText.text=objEvent.contact;
    else
        lblContactText.text=@"-";
    lblContactText.textColor=COLOR_DARK_RED;
    lblContactText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblContactText.backgroundColor=[UIColor clearColor];
    lblContactText.frame=CGRectMake(10, 30+lblOrganizerText.frame.origin.y+lblOrganizerText.frame.size.height, 200, 10);
    lblContactText.numberOfLines=0;
    [lblContactText sizeToFit];
    [scrollEventDetails addSubview:lblContactText];
    
    //-----  Fees --------------
    UILabel *lblFee=[[UILabel alloc] init];
    lblFee.tag=100;
    lblFee.text=@"Fee:";
    lblFee.textColor=COLOR_DARK_RED;
    lblFee.backgroundColor=[UIColor clearColor];
    lblFee.frame=CGRectMake(10, 10+lblContactText.frame.origin.y+lblContactText.frame.size.height, 200, 20);
    lblFee.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollEventDetails addSubview:lblFee];
    
    UILabel *lblFeeText=[[UILabel alloc] init];
    lblFeeText.tag=100;
    
    if(objEvent.fee)
        lblFeeText.text=objEvent.fee;
    else
        lblFeeText.text=@"-";
    
    lblFeeText.textColor=COLOR_DARK_RED;
    lblFeeText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblFeeText.backgroundColor=[UIColor clearColor];
    lblFeeText.frame=CGRectMake(10, 30+lblContactText.frame.origin.y+lblContactText.frame.size.height, 200, 20);
    lblFeeText.numberOfLines=0;
    [lblFeeText sizeToFit];
    [scrollEventDetails addSubview:lblFeeText];
    
    
     //-----  Image  --------------
    /*UIImageView *imgIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imgWestCC.jpg"]];
    imgIcon.tag=100;
    imgIcon.frame=CGRectMake(10, 5+lblFeeText.frame.origin.y+lblFeeText.frame.size.height, 205, 100);
    [scrollEventDetails addSubview:imgIcon];
    
    if(isCCSelected==FALSE)
    {
        int intRC=selectedRC;
        if(selectedRC==0)
            intRC=[self getFirstRcId:objEvent];
        
        UIImage *imgRC=[UIImage imageNamed:[NSString stringWithFormat:@"img%d.png",intRC]];
        if(imgRC)
            imgIcon.image=imgRC;
    }
    */
    
    //Set Scrollview
    [scrollEventDetails setContentSize:CGSizeMake(scrollEventDetails.contentSize.width, lblFeeText.frame.origin.y+lblFeeText.frame.size.height+20)];
    [scrollEventDetails setContentOffset:CGPointZero];
    
    
    
    NSString *strKey=[[NSUserDefaults standardUserDefaults] valueForKey:objEvent.ID];
    if(strKey==nil)
    {
        lblAddToDeviceCalender.text=@"Add to Device Calendar";
    }
    else
    {
       if([arrAllActiveEvents containsObject:objEvent.ID])
        lblAddToDeviceCalender.text=@"Remove from Device Calendar";
        else
        {
            lblAddToDeviceCalender.text=@"Add to Device Calendar";
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:objEvent.ID];
        }
        
    }
}

-(IBAction)backEventDetails:(id)sender
{
    [appDelegate animatePopViewController:viewListContent andViewToBeRemoved:viewEventDetails];
}

-(IBAction)nextEventClicked:(id)sender
{
    if(intSelectedEventIndex<([arrEvents count]-1))
    {
        intSelectedEventIndex++;
        [self showEventDetails:[arrEvents objectAtIndex:intSelectedEventIndex]];
    
    }
}

-(IBAction)previousEventClicked:(id)sender
{
    if(intSelectedEventIndex>0)
    {
        intSelectedEventIndex--;
        [self showEventDetails:[arrEvents objectAtIndex:intSelectedEventIndex]];
        
    }
}



-(IBAction)backEventLocationClicked:(id)sender
{
    [appDelegate animatePopViewController:viewEventDetails andViewToBeRemoved:viewEventLocation];
}



#pragma mark - Webservice delegate

-(void)parsingSucessfullFor:(NSString *)strMethodName With:(NSMutableArray *)arrList
{
    NSLog(@"Parsing Completed !!!");
    [appDelegate removeLoading];

    
    if([strMethodName isEqualToString:@"_tspGetAllEvent"])
    {
        if([arrList count]==0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Tampines"
                                  message:@"There are currently no events"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        arrTempEvents=arrList;
        
        [self reloadEventIds:arrTempEvents];
        
        [self CCClicked:nil];
    }
    else if([strMethodName isEqualToString:@"_tspGetAllCategory"])
    {
        if([arrList count]==0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Tampines"
                                  message:@"There are currently no categories"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        arrCategory=arrList;
        arrSelectedCategory=nil;
        arrSelectedCategory=[[NSMutableArray alloc] init];
        for (int i=0; i<arrCategory.count; i++) {
            [arrSelectedCategory addObject:@"0"];
        }
        
        NSLog(@"arrCategory=%@",arrCategory);
        
        [tblCategory reloadData];
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


-(IBAction)locationClicked:(id)sender
{
    
    @try {
        //Show Annotattios
        [mapView removeAnnotations:mapView.annotations];
        [mapView removeOverlays:mapView.overlays];
        
        //1.348796 103.935719  Event
        //1.367496 103.828869  My Location
        CLLocationCoordinate2D to;
        ClsEvent *objEvent=[arrEvents objectAtIndex:intSelectedEventIndex];
        
        {
            double latitude = 0, longitude = 0;
            NSString *esc_addr =  [objEvent.venue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
            NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
            //NSLog(@"result=%@",result);
            if (result) {
                NSScanner *scanner = [NSScanner scannerWithString:result];
                if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
                    [scanner scanDouble:&latitude];
                    if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                        [scanner scanDouble:&longitude];
                    }
                }
            }
            
            to.latitude = latitude;
            to.longitude = longitude;
            
            
            if(latitude==0.0 && longitude==0.0)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tampines"
                                                               message:@"Unable to plot route as invalid event address."
                                                              delegate:self
                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            NSLog(@"latitude=%f longitude=%f",latitude,longitude);
        }
        
        
        //set default values
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        
        CLLocationCoordinate2D from=currentLocation.coordinate;
        
        routes = [self calculateRoutesFrom:from to:to];
        lineColor=[UIColor blueColor];
        int pointCount = (int)[routes count];
        
        [appDelegate.homeVC addViewOnHome:viewEventLocation];
        [appDelegate animatePushViewController:viewEventLocation andViewToBeRemoved:viewEventDetails state:0];
        
        // remove any annotations that exist
        SFAnnotation *annotation = [[SFAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(from.latitude, from.longitude)];
        annotation.imgPin=[UIImage imageNamed:@"ic_pin.png"];
        [mapView addAnnotation:annotation];
        
        if(pointCount<2)
        {
            return;
        }
        
        CLLocationCoordinate2D polypoints[pointCount];
        
        //To draw on actual roads from google api
        for (int j=0; j<pointCount; j++) {
            CLLocation *loc = [routes objectAtIndex:j];
            polypoints[j].latitude = loc.coordinate.latitude;
            polypoints[j].longitude = loc.coordinate.longitude;
        }
        
        NSLog(@"routes=%lu",(unsigned long)routes.count);
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:polypoints count:pointCount];
        [mapView addOverlay:polyline];
        
        
        //start point of route
        minLat =from.latitude;
        minLon  =from.longitude;
        
        //End point of route
        maxLat =to.latitude;
        maxLon  =to.longitude;
        
        
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        
        
        if(maxLat>minLat)
            region.span.latitudeDelta  = maxLat - minLat;
        else
            region.span.latitudeDelta  =  minLat-maxLat;
        
        if(maxLon>minLon)
            region.span.longitudeDelta = (maxLon - minLon)*2;
        else
            region.span.longitudeDelta = (minLon-maxLon)*2;
        
        [mapView setRegion:region animated:YES];
        
        
        
        
        SFAnnotation *annotation1 = [[SFAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(to.latitude, to.longitude)];
        annotation1.imgPin=[UIImage imageNamed:@"ic_mark.png"];
        [mapView addAnnotation:annotation1];
        
        
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
    
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
    {
        SFAnnotation *lpoint=(SFAnnotation *)annotation;
         annotationView.image=lpoint.imgPin;
        return annotationView;
    }
    else
    {
        SFAnnotation *lpoint=(SFAnnotation *)annotation;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        annotationView.image=lpoint.imgPin;
        return annotationView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay {
	MKPolylineView *plv = [[MKPolylineView alloc] initWithOverlay:overlay];
    plv.strokeColor = lineColor;
	plv.lineWidth =5.0;
	return plv;
}

#pragma mark function for route google api

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5] ;
		//printf("[%f,", [latitude doubleValue]);
		//printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSUTF8StringEncoding error:nil];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}


#pragma mark - UIControlEventValueChanged

- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
    
    [arrEvents removeAllObjects];
    selectedRC=(int)segmentedControl.selectedSegmentIndex;
    
    NSLog(@"(int)segmentedControl.selectedSegmentIndex+1)=%d",(int)segmentedControl.selectedSegmentIndex+1);
    
    [self showEvents_RC:((int)segmentedControl.selectedSegmentIndex)];
    
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
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

-(void)addDummyCategories
{
    
    arrCategory=nil;
    arrSelectedCategory=nil;
    arrCategory =[[NSMutableArray alloc] init];
    
    ClsCategory *Obj1=[[ClsCategory alloc] init];
    Obj1.ID=@"1";
    Obj1.name=@"Sports";
    [arrCategory addObject:Obj1];
    Obj1=nil;
    
    ClsCategory *Obj2=[[ClsCategory alloc] init];
    Obj2.ID=@"2";
    Obj2.name=@"Youth";
    [arrCategory addObject:Obj2];
    Obj2=nil;
    
    ClsCategory *Obj3=[[ClsCategory alloc] init];
    Obj3.ID=@"3";
    Obj3.name=@"Festivals";
    [arrCategory addObject:Obj3];
    Obj3=nil;
    
    ClsCategory *Obj4=[[ClsCategory alloc] init];
    Obj4.ID=@"4";
    Obj4.name=@"Active Ageing";
    [arrCategory addObject:Obj4];
    Obj4=nil;
    
    ClsCategory *Obj5=[[ClsCategory alloc] init];
    Obj5.ID=@"5";
    Obj5.name=@"Racial Harmony";
    [arrCategory addObject:Obj5];
    Obj5=nil;
    
    ClsCategory *Obj6=[[ClsCategory alloc] init];
    Obj6.ID=@"6";
    Obj6.name=@"Arts and Culture";
    [arrCategory addObject:Obj6];
    Obj6=nil;
    
    ClsCategory *Obj7=[[ClsCategory alloc] init];
    Obj7.ID=@"7";
    Obj7.name=@"Woman’s";
    [arrCategory addObject:Obj7];
    Obj7=nil;
    
    ClsCategory *Obj8=[[ClsCategory alloc] init];
    Obj8.ID=@"8";
    Obj8.name=@"Community Emergency & Engagement";
    [arrCategory addObject:Obj8];
    Obj8=nil;
    
    arrSelectedCategory=[[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",nil];

    [tblCategory reloadData];

    
}

/*
 i) Sports
 ￼ii) Youth
 ￼iii) Festivals
 ￼iv) Active Ageing
 ￼v) Racial Harmony
 ￼vi) Arts and Culture
 ￼vii) Woman’s
 vii) Community Emergency & Engagement
 */

-(void)addDummyEvents
{
    
    arrEvents=[[NSMutableArray alloc] init];
    
    ClsEvent *obj1=[[ClsEvent alloc] init];
    obj1.ID=@"1";
    obj1.name=@"Sports Competition";
    obj1.description=@" A new sports festival that bridges community participation and sports excellence will offer residents from all ages, races and estates the opportunity to be part of Singapore's exciting sporting landscape. From the Sunday sports enthusiast, the arm-chair commentator, to the serious athlete, all can now play, compete and volunteer. ";
    obj1.ccID=@"0";
    obj1.rcID=@"1,5";
    
    obj1.venue=@"5, Tampines Ave3, Singapore 529705";
    obj1.startDate=@"2014-03-1T11:21:45";
    obj1.endDate=  @"2014-03-2T11:21:45";
    obj1.category=@"1";
    [arrEvents addObject:obj1];
    obj1.organizer=@"Steven Awyong";
    obj1=nil;
    
    
    ClsEvent *obj2=[[ClsEvent alloc] init];
    obj2.ID=@"2";
    obj2.name=@"Community Games";
    obj2.description=@"Are you a sports lover? Do you want to know more friends? Are you looking for competitions where you and your family and friends can participate together as a team? If you answered ‘YES’ to any of the above questions, come join us in the Community Games!";
    obj2.ccID=@"0";
    obj2.rcID=@"2";
    
    obj2.venue=@"Blk 903 Tampines Avenue 4 #01-292 Singapore 520903";
    obj2.startDate=@"2014-03-7T11:21:45";
    obj2.endDate=  @"2014-03-8T11:21:45";
    obj2.category=@"2,3";
    [arrEvents addObject:obj2];
    obj2.organizer=@"Steven Awyong";
    obj2=nil;
    
    ClsEvent *obj3=[[ClsEvent alloc] init];
    obj3.ID=@"3";
    obj3.name=@"Dance Competition";
    obj3.description=@"Are you a dance lover? Do you want to know more friends? Are you looking for competitions where you and your family and friends can participate together as a team? If you answered ‘YES’ to any of the above questions, come join us in the Community!";
    obj3.ccID=@"0";
    obj3.rcID=@"3,4,5,6";
    
    obj3.venue=@"Blk 889A, Tampines Street 81, #01-1028, Singapore 521889";
    obj3.startDate=@"2014-03-10T11:21:45";
    obj3.endDate=  @"2014-03-11T11:21:45";
    obj3.category=@"1,3,5";
    obj3.organizer=@"Steven Awyong";
    [arrEvents addObject:obj3];
    obj3=nil;
   
    ClsEvent *obj4=[[ClsEvent alloc] init];
    obj4.ID=@"4";
    obj4.name=@"Food Festival";
    obj4.description=@"The Singapore Food Festival is a grand interactive learning experience, a Singapore food guide that gives you a closer look at the rich cultures that make our little island pulsate with energy. Talented local and international chefs hold regular cooking workshops and demonstrations during this period and if you’re lucky, you might just go home with a secret tip or two to spice up your culinary adventures in your kitchen. It’s an immensely popular food festival that appeals to both locals and tourists (with a record attendance of over 354,000 foodies last year) alike with its smorgasbord of tantalizing treats and events happening across town.";
    obj4.ccID=@"1";
    obj4.rcID=@"0";
    
    obj4.venue=@"Blk 889A, Tampines Street 81, #01-1028, Singapore 521889";
    obj4.startDate=@"2014-03-06T12:15:00";
    obj4.endDate=  @"2014-03-06T12:20:00";
    obj4.category=@"4";
    obj4.organizer=@"Steven Awyong";
    [arrEvents addObject:obj4];
    obj4=nil;
    

    NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
    [dateFormatterWS setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSLog(@"Date=%@",[dateFormatterWS stringFromDate:[NSDate date]]);
    
    arrTempEvents=[arrEvents mutableCopy];
    
    [tblEvents reloadData];
    
    
   
    isAllCategorySelected=TRUE;
    [tblCategory reloadData];
 [self showEvents_CC];
}


-(void)showEvents_RC:(int)intRCType
{
    // No category is selected
    if([self isCategoryAllSelected]==TRUE)
    {
        isAllCategorySelected=TRUE;
        [tblCategory reloadData];
        //No RC type is selected
        if(intRCType==0)
        {
            [arrEvents removeAllObjects];
            for (ClsEvent *objEvent in arrTempEvents) {
                if([self isEventHasAnyRC:objEvent])
                [arrEvents addObject:objEvent];
            }
            
        }
        else
        {
            [arrEvents removeAllObjects];
            for (ClsEvent *objEvent in arrTempEvents) {
                    if([self isEventHasRC:objEvent And:intRCType])
                    [arrEvents addObject:objEvent];
            }
        }
    }
    else
    {
        if(intRCType==0)
        {
            [arrEvents removeAllObjects];
            for (ClsEvent *objEvent in arrTempEvents) {
                for (int i=0; i<[arrSelectedCategory count]; i++) {
                    if([[arrSelectedCategory objectAtIndex:i] isEqualToString:@"1"])
                    {
                        ClsCategory *objCategory = [arrCategory  objectAtIndex:i];
                        if([self isEventHasCategory:objEvent And:objCategory] && (![self isEventHasRC:objEvent And:0]) && [arrEvents containsObject:objEvent]==FALSE&& [self isEventHasAnyRC:objEvent])
                            [arrEvents addObject:objEvent];
                    }
                }
            }
            
        }
        else
        {
            [arrEvents removeAllObjects];
            for (ClsEvent *objEvent in arrTempEvents) {
                for (int i=0; i<[arrSelectedCategory count]; i++) {
                    if([[arrSelectedCategory objectAtIndex:i] isEqualToString:@"1"])
                    {
                        ClsCategory *objCategory = [arrCategory  objectAtIndex:i];
                        
                         if([self isEventHasRC:objEvent And:intRCType] && [self isEventHasCategory:objEvent And:objCategory]&& [arrEvents containsObject:objEvent]==FALSE)
                                [arrEvents addObject:objEvent];
                    }
                }
            }
        }
    }

    
    
    [tblEvents reloadData];
}

-(void)showEvents_CC
{
    [arrEvents removeAllObjects];
    
    if([self isCategoryAllSelected]==TRUE)
    {
        isAllCategorySelected=TRUE;
        [tblCategory reloadData];
        
        for (ClsEvent *objEvent in arrTempEvents) {
        if([objEvent.ccID intValue]>0)
            [arrEvents addObject:objEvent];
        }
    }
    else
    {
        for (ClsEvent *objEvent in arrTempEvents) {
            for (int i=0; i<[arrSelectedCategory count]; i++) {
                if([[arrSelectedCategory objectAtIndex:i] isEqualToString:@"1"])
                {
                    ClsCategory *objCategory = [arrCategory  objectAtIndex:i];
                    //if([objEvent.ccID intValue]>0 && [objCategory.ID isEqualToString:objEvent.category])
                    if([objEvent.ccID intValue]>0 && [self isEventHasCategory:objEvent And:objCategory]&& [arrEvents containsObject:objEvent]==FALSE)
                [arrEvents addObject:objEvent];
                }
        }
        }
    }
    
    
    [tblEvents reloadData];
}



-(BOOL)isCategoryAllSelected
{
    
    NSLog(@"isCategoryAllSelected=%d",[arrSelectedCategory containsObject:@"1"]);
    return (![arrSelectedCategory containsObject:@"1"])||(isAllCategorySelected);
}

-(IBAction)addEventToSystemCalender:(id)sender
{
      @try {
    
    ClsEvent *objEvent=[arrEvents objectAtIndex:intSelectedEventIndex];
    
    NSString *strKey=objEvent.ID;
    
    NSDateFormatter *dateFormatterTime = [[NSDateFormatter alloc] init];
    [dateFormatterTime setDateFormat:@"hh:mm a"];
    
    NSDate *starttime=[dateFormatterTime dateFromString:objEvent.startTime];
    NSDate *endtime=[dateFormatterTime dateFromString:objEvent.endTime];
    if(starttime==nil){
        [dateFormatterTime setDateFormat:@"HH:mm"];
        starttime=[dateFormatterTime dateFromString:objEvent.startTime];
        endtime=[dateFormatterTime dateFromString:objEvent.endTime];
    }
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:strKey]==nil)
    {
        
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) {  return;}
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = objEvent.name;
            //date formatter for the above string
            NSDateFormatter *dateFormatterWS = [[NSDateFormatter alloc] init];
            [dateFormatterWS setDateFormat:@"dd/MM/yyyy"];
            event.startDate =[dateFormatterWS dateFromString:objEvent.startDate];
           
            if(starttime)
            event.startDate = [appDelegate bindTime:starttime WithDate:event.startDate];
            
            event.endDate = [dateFormatterWS dateFromString:objEvent.endDate];
            
            if(endtime)
            event.endDate = [appDelegate bindTime:endtime WithDate:event.endDate];

            event.location=objEvent.venue;
            event.notes=objEvent.description;
            
            EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:0];
            event.alarms = [NSArray arrayWithObject:alarm];
            
           
            EKEventEditViewController *eventEditViewController = [[EKEventEditViewController alloc] init] ;
            eventEditViewController.editViewDelegate = self;
            eventEditViewController.event = event;
            eventEditViewController.eventStore = store;
            
            [appDelegate.homeVC presentViewController:eventEditViewController animated:YES completion:nil];
            eventEditViewController=nil;
            
        }];
    }
    else
    {
        //activity.hidden=FALSE;
        //[activity startAnimating];
        lblAddToDeviceCalender.text=@"Add to Device Calendar";
         [appDelegate showToast:@"Removed from device Calendar"];
        
        EKEventStore* store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted)  {  [appDelegate removeLoading];return;}
            EKEvent* eventToRemove = [store eventWithIdentifier:[[NSUserDefaults standardUserDefaults] valueForKey:strKey]];
            if (eventToRemove) {
                NSError* error = nil;
                [store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:strKey];
             
                [arrAllActiveEvents removeObject:strKey];

            }
        }];
    }
          
      }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }

}


- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
	
	NSError *error = nil;
    ClsEvent *objEvent=[arrEvents objectAtIndex:intSelectedEventIndex];
    NSString *strKey=objEvent.ID;
    
    activity.hidden=TRUE;
    [activity stopAnimating];
    
	switch (action) {
		case EKEventEditViewActionCanceled:
        {
            
        }
			break;
		case EKEventEditViewActionSaved:
        {
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
            NSString *savedEventId = controller.event.eventIdentifier;  //this is so you can access this event later
            
            NSLog(@"savedEventId=%@",savedEventId);
            [[NSUserDefaults standardUserDefaults] setValue:savedEventId forKey:strKey];
             lblAddToDeviceCalender.text=@"Remove from Device Calendar";
            
            [appDelegate showToast:@"Added to Device Calendar"];
            
            [arrAllActiveEvents addObject:strKey];
        }
			break;
			
		case EKEventEditViewActionDeleted:
        {
			[controller.eventStore removeEvent:controller.event span:EKSpanThisEvent error:&error];
            
        }
			break;
			
		default:
			break;
	}
    
	[controller dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)reloadEventIds:(NSMutableArray *)arrTemp
{
    [arrAllActiveEvents removeAllObjects];
    EKEventStore* store = [[EKEventStore alloc] init];
    
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted)  {  return;}
        
        for (ClsEvent *objEvent in arrTemp) {
            NSString *strKey=[[NSUserDefaults standardUserDefaults] valueForKey:objEvent.ID];
            
            if(strKey)
            {
                EKEvent* eventToRemove = [store eventWithIdentifier:strKey];
                if (eventToRemove) {
                    [arrAllActiveEvents addObject:objEvent.ID];
                }
            }
        }
    }];
}

-(void)setEventStatus
{
    ClsEvent *objEvent=[arrEvents objectAtIndex:intSelectedEventIndex];
    NSString *strKey=[[NSUserDefaults standardUserDefaults] valueForKey:objEvent.ID];
    if(strKey==nil)
    {
        lblAddToDeviceCalender.text=@"Add to Device Calendar";
    }
    else
    {
        if([arrAllActiveEvents containsObject:objEvent.ID])
            lblAddToDeviceCalender.text=@"Remove from Device Calendar";
        else
        {
            lblAddToDeviceCalender.text=@"Add to Device Calendar";
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:objEvent.ID];
        }
        
    }

}

-(BOOL)isEventHasCategory:(ClsEvent *)objEvent And:(ClsCategory *)objCategory
{
    
    NSArray *strings = [objEvent.category componentsSeparatedByString:@","];
    
    if(strings.count==0)
        return FALSE;
    
    for (NSString *cat in strings) {
        if([objCategory.ID isEqualToString:cat])
            return TRUE;
    }

    return FALSE;
}

-(BOOL)isEventHasRC:(ClsEvent *)objEvent And:(int )intRC
{
    
    
    NSString *strRC=[NSString stringWithFormat:@"%d",intRC];
    NSArray *strings = [objEvent.rcID componentsSeparatedByString:@","];
    
    if(strings.count==0)
        return FALSE;
    
    for (NSString *cat in strings) {
        if([strRC isEqualToString:cat])
            return TRUE;
    }
    
    return FALSE;
}

-(BOOL)isEventHasAnyRC:(ClsEvent *)objEvent
{
    
    
    NSString *strRC=[NSString stringWithFormat:@"%d",0];
    NSArray *strings = [objEvent.rcID componentsSeparatedByString:@","];
    
    if(objEvent.rcID.length==0)
        return FALSE;
    
    if(strings.count==0)
        return FALSE;
    
    for (NSString *cat in strings) {
        if([strRC isEqualToString:cat])
            return FALSE;
    }
    
    return TRUE;
}

-(int)getFirstRcId:(ClsEvent *)objEvent
{
    NSArray *strings = [objEvent.rcID componentsSeparatedByString:@","];
    
    if(strings.count==0)
        return FALSE;
    
    return [[strings objectAtIndex:0] intValue];

}

@end
