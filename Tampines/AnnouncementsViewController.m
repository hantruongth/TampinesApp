//
//  AnnouncementsViewController.m
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "AnnouncementsViewController.h"

@interface AnnouncementsViewController ()

@end

@implementation AnnouncementsViewController

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
    arrAnnouncements=[[NSMutableArray alloc] init];
      viewAnnouncementDetails.frame=CGRectMake(0, ORIGIN_FACTOR, 320, SCREEN_HEIGHT-20);
    
    CGRect frame=viewList.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewList.frame=frame;
    
    frame=viewAnnouncementDetailsCenter.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewAnnouncementDetailsCenter.frame=frame;
    
    //[self addDummyAnnouncements];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if(tableView==tblAnnouncements)
        numberOfRows=[arrAnnouncements count];
     
    return numberOfRows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==tblAnnouncements)
        return 80;
    
    return 0;
    
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
    
    if(tableView==tblAnnouncements)
    {
        
        UIView *viewLine=[[UIView alloc ] initWithFrame:CGRectMake(0, 79, 238, 0.5)];
        viewLine.backgroundColor=COLOR_DARK_RED;
        [cell.contentView addSubview:viewLine];
        viewLine=nil;
        
        UIImageView *imgArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_arrow@2x.png"]];
        imgArrow.frame=CGRectMake(200, 30, 16, 19);
        [cell.contentView addSubview:imgArrow];
        imgArrow=nil;
        
        
        ClsAnnouncemnets *objAnnouncement = [arrAnnouncements objectAtIndex:[indexPath row]];
        
        UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        lblName.text=objAnnouncement.name;
        lblName.font=[UIFont fontWithName:FONT_BOLD size:16.0];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.textColor=COLOR_DARK_RED;
        [cell.contentView addSubview:lblName];
        lblName=nil;
        
        
        UILabel *lblStartDate=[[UILabel alloc] initWithFrame:CGRectMake(15, 30, 200, 20)];
        lblStartDate.text=[NSString stringWithFormat:@"Start Date: %@",objAnnouncement.startDate];
        lblStartDate.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
        lblStartDate.backgroundColor=[UIColor clearColor];
        lblStartDate.textColor=COLOR_DARK_RED;
        [cell.contentView addSubview:lblStartDate];
        lblStartDate=nil;

        UILabel *lblEndtDate=[[UILabel alloc] initWithFrame:CGRectMake(15, 46, 200, 20)];
        lblEndtDate.text=[NSString stringWithFormat:@"End Date:   %@",objAnnouncement.endDate];
        lblEndtDate.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
        lblEndtDate.backgroundColor=[UIColor clearColor];
        lblEndtDate.textColor=COLOR_DARK_RED;
        [cell.contentView addSubview:lblEndtDate];
        lblEndtDate=nil;
        
        /*UILabel *lblDescription=[[UILabel alloc] initWithFrame:CGRectMake(15, 45, 180, 50)];
        lblDescription.text=[NSString stringWithFormat:@"%@", objAnnouncement.description];
        lblDescription.backgroundColor=[UIColor clearColor];
        lblDescription.font=[UIFont fontWithName:FONT_REGULAR size:12.0];
        lblDescription.textColor=COLOR_DARK_RED;
        lblDescription.numberOfLines=2;
        [lblDescription sizeToFit];
        [cell.contentView addSubview:lblDescription];
        lblDescription=nil;*/
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView==tblAnnouncements)
    {
        intSelectedAnnouncementIndex=(int)indexPath.row;
        ClsAnnouncemnets *objAnnouncement=[arrAnnouncements objectAtIndex:indexPath.row];
        [self showAnnouncementDetails:objAnnouncement];
        [appDelegate.homeVC addViewOnHome:viewAnnouncementDetails];
        [appDelegate animatePushViewController:viewAnnouncementDetails andViewToBeRemoved:viewListContent state:0];
        
    }
    
}

-(void)showAnnouncementDetails:(ClsAnnouncemnets *)objAnnouncemnet
{
    
    lblHeaderAnnouncemnet.text=objAnnouncemnet.name;
    
    if(intSelectedAnnouncementIndex>0)
    {
        imgPrevious.hidden=FALSE;
        btnPrevious.hidden=FALSE;
    }
    else
    {
        imgPrevious.hidden=TRUE;
        btnPrevious.hidden=TRUE;
        
    }
    
    if(intSelectedAnnouncementIndex<[arrAnnouncements count]-1)
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
    for (UIView *subview in scrollAnnouncement.subviews) {
        if(subview.tag==100)
            [subview removeFromSuperview];
    }
    
    UILabel *lblStartDate=[[UILabel alloc] init];
    lblStartDate.tag=100;
    lblStartDate.text=@"Start Date:";
    lblStartDate.textColor=COLOR_DARK_RED;
    lblStartDate.backgroundColor=[UIColor clearColor];
    lblStartDate.frame=CGRectMake(10, 10, 200, 20);
    lblStartDate.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollAnnouncement addSubview:lblStartDate];
    
    UILabel *lblStartDateText=[[UILabel alloc] init];
    lblStartDateText.tag=100;
    lblStartDateText.text=objAnnouncemnet.startDate;
    lblStartDateText.textColor=COLOR_DARK_RED;
    lblStartDateText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblStartDateText.backgroundColor=[UIColor clearColor];
    lblStartDateText.frame=CGRectMake(10, 30, 210, 10);
    lblStartDateText.numberOfLines=0;
    [lblStartDateText sizeToFit];
    [scrollAnnouncement addSubview:lblStartDateText];
    
    UILabel *lblEndDate=[[UILabel alloc] init];
    lblEndDate.tag=100;
    lblEndDate.text=@"End Date:";
    lblEndDate.textColor=COLOR_DARK_RED;
    lblEndDate.backgroundColor=[UIColor clearColor];
    lblEndDate.frame=CGRectMake(10, 60, 200, 20);
    lblEndDate.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollAnnouncement addSubview:lblEndDate];
    
    UILabel *lblEndDateText=[[UILabel alloc] init];
    lblEndDateText.tag=100;
    lblEndDateText.text=objAnnouncemnet.endDate;
    lblEndDateText.textColor=COLOR_DARK_RED;
    lblEndDateText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblEndDateText.backgroundColor=[UIColor clearColor];
    lblEndDateText.frame=CGRectMake(10, 80, 210, 10);
    lblEndDateText.numberOfLines=0;
    [lblEndDateText sizeToFit];
    [scrollAnnouncement addSubview:lblEndDateText];
    
    UILabel *lblDescription=[[UILabel alloc] init];
    lblDescription.tag=100;
    lblDescription.text=@"Description:";
    lblDescription.textColor=COLOR_DARK_RED;
    lblDescription.backgroundColor=[UIColor clearColor];
    lblDescription.frame=CGRectMake(10, 110, 200, 20);
    lblDescription.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrollAnnouncement addSubview:lblDescription];
    
    UILabel *lblDescriptionText=[[UILabel alloc] init];
    lblDescriptionText.tag=100;
    lblDescriptionText.text=objAnnouncemnet.description;
    lblDescriptionText.textColor=COLOR_DARK_RED;
    lblDescriptionText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblDescriptionText.backgroundColor=[UIColor clearColor];
    lblDescriptionText.frame=CGRectMake(10, 130, 210, 10);
    lblDescriptionText.numberOfLines=0;
    [lblDescriptionText sizeToFit];
    [scrollAnnouncement addSubview:lblDescriptionText];
    
    
    //Set Scrollview
    [scrollAnnouncement setContentSize:CGSizeMake(scrollAnnouncement.contentSize.width, lblDescriptionText.frame.origin.y+lblDescriptionText.frame.size.height)];
    [scrollAnnouncement setContentOffset:CGPointZero];
   
}

-(IBAction)backAnnouncementDetails:(id)sender
{
    [appDelegate animatePopViewController:viewListContent andViewToBeRemoved:viewAnnouncementDetails];
}

-(IBAction)backToHomeClicked:(id)sender
{
    [appDelegate.homeVC showHomeScreen];
}

-(void)getNewAnnouncementsFromServer
{
    [tblAnnouncements setContentOffset:CGPointZero];
    
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
    [webObj GetDataInXMLFromStoredProcedure:@"_tspGetAllAnnouncement" parameterName:nil parameterValue:nil];
    
    [appDelegate showLoading:@"Loading"];
    
}
#pragma mark - Webservice delegate

-(void)parsingSucessfullFor:(NSString *)strMethodName With:(NSMutableArray *)arrList
{
    NSLog(@"Parsing Completed !!!");
    [appDelegate removeLoading];
    if([arrList count]==0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Tampines"
                              message:@"There are currently no announcements"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if([strMethodName isEqualToString:@"_tspGetAllAnnouncement"])
    {
         [appDelegate removeLoading];
        arrAnnouncements=arrList;
        [tblAnnouncements reloadData];
    }
}
-(void)parsingFailedFor:(NSString *)strMethodName With:(NSString *)strErrorMsg
{
    NSLog(@"Parsing Failed !!! %@",strErrorMsg);
    
}

-(void)addDummyAnnouncements
{
    arrAnnouncements=nil;
    arrAnnouncements=[[NSMutableArray alloc] init];
    
    
    ClsAnnouncemnets *objAnnouncement1=[[ClsAnnouncemnets alloc] init];
    objAnnouncement1.name=@"New Movie";
    objAnnouncement1.ID=@"1";
    objAnnouncement1.description=@"Watch the new released movie at Tampines, book your movie tickets and select your seats online. Features reviews, movie schedules contests and special promotions.Watch the new released movie at Tampines, book your movie tickets and select your seats online. Features reviews, movie schedules contests and special promotions.Watch the new released movie at Tampines, book your movie tickets and select your seats online. Features reviews, movie schedules contests and special promotions.Watch the new released movie at Tampines, book your movie tickets and select your seats online. Features reviews, movie schedules contests and special promotions.Watch the new released movie at Tampines, book your movie tickets and select your seats online. Features reviews, movie schedules contests and special promotions.";
    
    [arrAnnouncements addObject:objAnnouncement1];
    objAnnouncement1=nil;
    
    ClsAnnouncemnets *objAnnouncement2=[[ClsAnnouncemnets alloc] init];
    objAnnouncement2.name=@"Happy New Year";
    objAnnouncement2.ID=@"2";
    objAnnouncement2.description=@"Yes! We are down to 7 days to Chinese New Year (CNY)! Have you decorated your house and ready to welcome your visitors?";
    [arrAnnouncements addObject:objAnnouncement2];
    objAnnouncement2=nil;

    [tblAnnouncements reloadData];
}

-(IBAction)nextAnnouncementClicked:(id)sender
{
    if(intSelectedAnnouncementIndex<([arrAnnouncements count]-1))
    {
        intSelectedAnnouncementIndex++;
        [self showAnnouncementDetails:[arrAnnouncements objectAtIndex:intSelectedAnnouncementIndex]];
        
    }
}

-(IBAction)previousAnnouncementClicked:(id)sender
{
    if(intSelectedAnnouncementIndex>0)
    {
        intSelectedAnnouncementIndex--;
        [self showAnnouncementDetails:[arrAnnouncements objectAtIndex:intSelectedAnnouncementIndex]];
        
    }
}

@end
