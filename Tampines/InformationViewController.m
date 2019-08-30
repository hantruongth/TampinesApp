//
//  InformationViewController.m
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "InformationViewController.h"

#import "MyCategory.h"

#import "SectionInfo.h"

@interface InformationViewController ()

@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, strong) NSMutableArray *sectionInfoArray;
@property (nonatomic, strong) NSArray *categoryList;

- (void) setCategoryArray;

@end

@implementation InformationViewController

@synthesize categoryList = _categoryList;
@synthesize openSectionIndex;
@synthesize sectionInfoArray;



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
    arrInfo=[[NSMutableArray alloc] init];
    
    arrNames=[[NSMutableArray alloc] initWithObjects:@"Tampines West CC",@"Residents' Committees",@"Banks & ATMs",@"Makan Places",@"Clinics",@"Schools",@"Groceries",@"Government Agencies",@"Petrol Kiosks",@"Sports Facilities",@"Community Facilities",@"Volunteer Welfare Organisations(VWOs)", nil];
    arrIcons=[[NSMutableArray alloc] initWithObjects:@"Tampines.png",@"committee.png",@"bank_atm.png",@"makanPlaces.png",@"clinics.png",@"school.png",@"groceries.png",@"government.png",@"petrol.png",@"sports.png",@"community.png",@"volunteer.png", nil];
    
    
    CGRect frame=viewList.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewList.frame=frame;
    
    viewInfotDetails.frame=CGRectMake(0, ORIGIN_FACTOR, 320, SCREEN_HEIGHT-20);
    
   frame=viewDetail.frame;
    if(IS_IPHONE_5)
        frame.size.height=383;
    else
        frame.size.height=340;
    viewDetail.frame=frame;
    
    
   // [self getUsefullInformation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(tableView==tblInfo)
    return 1;
    
    if(tableView==tblInfoDetails)
        return 1;
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
   
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if(tableView==tblInfo)
    {
        numberOfRows=4;
    }
    else if(tableView==tblInfoDetails)
    {
        numberOfRows = [arrDetails count];
    }
    
    return numberOfRows;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(tableView==tblInfoDetails)
    {

        
        CGRect frame=headerView.frame;
        frame.size.height=lblHeader.frame.origin.y+ lblHeader.frame.size.height+10;
        headerView.frame=frame;
        
        return headerView;
    }
    
    return nil;
    
}*/



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView==tblInfo)
    {
        if(IS_IPHONE_5)
            return 90;
    
        return 79;
    }
    if(tableView==tblInfoDetails)
    {
       
          ClsUsefulInformation *obj=[arrDetails objectAtIndex:indexPath.row];
        if(indexPath.row==isOpen)
        {
          
                       
            return [self getCellHeight:obj];
        }
        else
        {
            return [self getLabelHeightFor:obj.name];
        }
        
    }
    
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
    
    if(tableView==tblInfo)
    {
   
        for (int i=0; i<3; i++) {
            int newIndex=3*(int)indexPath.row+i;
            UIImage *image=[UIImage imageNamed:[arrIcons objectAtIndex:newIndex]];
            UIImageView *imgIcon=[[UIImageView alloc] initWithImage:image];
            imgIcon.frame=CGRectMake(10+82*i, 5, 50, 50);
            [cell.contentView addSubview:imgIcon];
            
            UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(5+82*i, 55,60, 30)];
            lblName.text= [arrNames objectAtIndex:newIndex];
            lblName.font=[UIFont fontWithName:FONT_BOLD size:10.0];
            lblName.backgroundColor=[UIColor clearColor];
            lblName.textColor=COLOR_DARK_RED;
            lblName.textAlignment=NSTextAlignmentCenter;
            lblName.numberOfLines=3;
            [cell.contentView addSubview:lblName];
            lblName=nil;
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=imgIcon.frame;
            button.tag=newIndex;
            [button addTarget:self action:@selector(imageUsefulInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            button=nil;
            imgIcon=nil;

        }

        
        
        }
    else if(tableView==tblInfoDetails)
    {
      ClsUsefulInformation *obj=[arrDetails objectAtIndex:indexPath.row];
        float myHeight=[self getLabelHeightFor:obj.name];
        //if(indexPath.row==isOpen)
        {
            UIView *viewBackground=[[UIView alloc ] initWithFrame:CGRectMake(0, 0, 238.5, myHeight)];
            viewBackground.backgroundColor=[UIColor colorWithRed:215.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
            [cell.contentView addSubview:viewBackground];
            
        }
       
        
        
        UIView *viewLine=[[UIView alloc ] initWithFrame:CGRectMake(0, myHeight-1, 238, 0.5)];
        viewLine.backgroundColor=COLOR_DARK_RED;
        [cell.contentView addSubview:viewLine];
        
        UIImageView *imgArrow=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        imgArrow.frame=CGRectMake(212, myHeight/2-7, 8, 13);
        imgArrow.contentMode=UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgArrow];
        
        UILabel *lblHeader=[[UILabel alloc] initWithFrame:CGRectMake(5,10, 200, myHeight)];
        //lblHeader.center=CGPointMake(105, 22);
        lblHeader.text=obj.name;
         [lblHeader setTextColor:COLOR_DARK_RED];
         lblHeader.backgroundColor=[UIColor clearColor];
         [lblHeader setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
         [cell.contentView addSubview:lblHeader];
        lblHeader.numberOfLines=0;
        [lblHeader sizeToFit];
        
        
        
        if(indexPath.row==isOpen)
        {
            imgArrow.frame=CGRectMake(208, myHeight/2-4, 13, 8);
            imgArrow.image=[UIImage imageNamed:@"arrowDown"];
            float factor=myHeight;
            CGRect rect=CGRectMake(0,0, 200, myHeight);
            // Description
            if([obj.description length]>0)
            {
                UILabel *lblDescription=[[UILabel alloc] initWithFrame:CGRectMake(10,factor, 200, 30)];
                lblDescription.text=@"Description:";
                [lblDescription setTextColor:COLOR_DARK_RED];
                lblDescription.backgroundColor=[UIColor clearColor];
                [lblDescription setFont:[UIFont fontWithName:FONT_BOLD size:14]];
                [cell.contentView addSubview:lblDescription];
                
                UITextView *txtDescription=[[UITextView alloc] initWithFrame:CGRectMake(5,factor+20, 220, 30)];
                    txtDescription.text=obj.description;
                
                [txtDescription setTextColor:COLOR_DARK_RED];
                txtDescription.backgroundColor=[UIColor clearColor];
                [txtDescription setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
                [cell.contentView addSubview:txtDescription];
                txtDescription.editable = NO;
                txtDescription.scrollEnabled=FALSE;
                txtDescription.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
               rect      = txtDescription.frame;
                rect.size.height = [self text:txtDescription.text sizeWithFont:txtDescription.font];
                txtDescription.frame   = rect;
            }
            
            
            if([obj.address length]>0)
            {
                UILabel *lblAddress=[[UILabel alloc] initWithFrame:CGRectMake(10,rect.origin.y+rect.size.height, 200, 30)];
                lblAddress.text=@"Address:";
                [lblAddress setTextColor:COLOR_DARK_RED];
                lblAddress.backgroundColor=[UIColor clearColor];
                [lblAddress setFont:[UIFont fontWithName:FONT_BOLD size:14]];
                [cell.contentView addSubview:lblAddress];
                
                UITextView *txtAddress=[[UITextView alloc] initWithFrame:CGRectMake(5,20+rect.origin.y+rect.size.height, 220, 30)];
                    txtAddress.text=obj.address;
                
                [txtAddress setTextColor:COLOR_DARK_RED];
                txtAddress.backgroundColor=[UIColor clearColor];
                [txtAddress setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
                [cell.contentView addSubview:txtAddress];
                txtAddress.editable = NO;
                txtAddress.scrollEnabled=FALSE;
                txtAddress.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
                rect      = txtAddress.frame;
                rect.size.height = [self text:txtAddress.text sizeWithFont:txtAddress.font];
                txtAddress.frame   = rect;
            }
            
            
            // Phone
            if([obj.phone length]>0)
            {
                UILabel *lblPhone=[[UILabel alloc] initWithFrame:CGRectMake(10,rect.origin.y+rect.size.height, 200, 30)];
                lblPhone.text=@"Telephone:";
                [lblPhone setTextColor:COLOR_DARK_RED];
                lblPhone.backgroundColor=[UIColor clearColor];
                [lblPhone setFont:[UIFont fontWithName:FONT_BOLD size:14]];
                [cell.contentView addSubview:lblPhone];
                
                UITextView *txtphone=[[UITextView alloc] initWithFrame:CGRectMake(5,rect.origin.y+20+rect.size.height, 220, 30)];
                    txtphone.text=obj.phone;
                [txtphone setTextColor:COLOR_DARK_RED];
                txtphone.backgroundColor=[UIColor clearColor];
                [txtphone setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
                [cell.contentView addSubview:txtphone];
                txtphone.editable = NO;
                txtphone.scrollEnabled=FALSE;
                txtphone.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
                rect      = txtphone.frame;
                rect.size.height = [self text:txtphone.text sizeWithFont:txtphone.font];
                txtphone.frame   = rect;
            }
            
            // Website
            if([obj.url length]>0)
            {
                UILabel *lblWebsite=[[UILabel alloc] initWithFrame:CGRectMake(10,rect.origin.y+rect.size.height, 200, 30)];
                lblWebsite.text=@"URL:";
                [lblWebsite setTextColor:COLOR_DARK_RED];
                lblWebsite.backgroundColor=[UIColor clearColor];
                [lblWebsite setFont:[UIFont fontWithName:FONT_BOLD size:14]];
                [cell.contentView addSubview:lblWebsite];
                
                UITextView *txtWebsite=[[UITextView alloc] initWithFrame:CGRectMake(5,20+rect.origin.y+rect.size.height, 220, 30)];
                    txtWebsite.text=obj.url;
                [txtWebsite setTextColor:COLOR_DARK_RED];
                txtWebsite.backgroundColor=[UIColor clearColor];
                [txtWebsite setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
                [cell.contentView addSubview:txtWebsite];
                txtWebsite.editable = NO;
                txtWebsite.scrollEnabled=FALSE;
                txtWebsite.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
                rect      = txtWebsite.frame;
                rect.size.height = [self text:txtWebsite.text sizeWithFont:txtWebsite.font];
                txtWebsite.frame   = rect;
            }
            
            UIView *viewLine2=[[UIView alloc ] initWithFrame:CGRectMake(0, rect.origin.y+rect.size.height, 238, 0.5)];
            viewLine2.backgroundColor=COLOR_DARK_RED;
            [cell.contentView addSubview:viewLine2];
            
                    }
        

        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView==tblInfoDetails)
    {
        if(isOpen!=indexPath.row)
        {
            isOpen=(int)indexPath.row;
            ClsUsefulInformation *obj=[arrDetails objectAtIndex:indexPath.row];
//            float myHeight=[self getLabelHeightFor:obj.name];
            int cellHeight=[self getCellHeight:obj];
            int offset=(cellHeight+[self getAllRowHeights:isOpen]-tblInfoDetails.contentOffset.y)-(tblInfoDetails.frame.size.height);
            
            NSLog(@"offset=%d",offset);
            if(offset>=0)
            {
                if(cellHeight>tblInfoDetails.frame.size.height)
                    [tblInfoDetails setContentOffset:CGPointMake(0, [self getAllRowHeights:isOpen]) animated:TRUE];
                else
                    [tblInfoDetails setContentOffset:CGPointMake(0, tblInfoDetails.contentOffset.y+offset) animated:TRUE];
            }
            
        }
        else
            isOpen=-1;

        
        [tblInfoDetails reloadData];
            
    }
    
}



-(void)showInfoDetails:(ClsUsefulInformation *)objInfo
{
    
    lblHeaderInfo.text=objInfo.name;
    
    if(intSelectedInfoIndex>0)
    {
        imgPrevious.hidden=FALSE;
        btnPrevious.hidden=FALSE;
    }
    else
    {
        imgPrevious.hidden=TRUE;
        btnPrevious.hidden=TRUE;
        
    }
    
    if(intSelectedInfoIndex<[arrInfo count]-1)
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
    for (UIView *subview in scrolInfo.subviews) {
        if(subview.tag==100)
            [subview removeFromSuperview];
    }
    
    UILabel *lblDescription=[[UILabel alloc] init];
    lblDescription.tag=100;
    lblDescription.text=@"Description";
    lblDescription.textColor=COLOR_DARK_RED;
    lblDescription.backgroundColor=[UIColor clearColor];
    lblDescription.frame=CGRectMake(10, 10, 200, 20);
    lblDescription.font=[UIFont fontWithName:FONT_BOLD size:14];
    [scrolInfo addSubview:lblDescription];
    
    UILabel *lblDescriptionText=[[UILabel alloc] init];
    lblDescriptionText.tag=100;
    lblDescriptionText.text=objInfo.description;
    lblDescriptionText.textColor=COLOR_DARK_RED;
    lblDescriptionText.font=[UIFont fontWithName:FONT_REGULAR size:14];
    lblDescriptionText.backgroundColor=[UIColor clearColor];
    lblDescriptionText.frame=CGRectMake(10, 40, 210, 10);
    lblDescriptionText.numberOfLines=0;
    [lblDescriptionText sizeToFit];
    [scrolInfo addSubview:lblDescriptionText];
    
    
    //Set Scrollview
    [scrolInfo setContentSize:CGSizeMake(scrolInfo.contentSize.width, lblDescriptionText.frame.origin.y+lblDescriptionText.frame.size.height)];
    [scrolInfo setContentOffset:CGPointZero];
    
}

-(IBAction)backInfoDetails:(id)sender
{
    [appDelegate animatePopViewController:viewListContent andViewToBeRemoved:viewInfotDetails];
}


-(IBAction)backToHomeClicked:(id)sender
{
    [appDelegate.homeVC showHomeScreen];
}

-(void)getAllInfoFromServer
{
    [tblInfo setContentOffset:CGPointZero];
    
   // if(arrInfo.count>0)
      //  return;
    
    
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
    [webObj GetDataInXMLFromStoredProcedure:@"_tspGetAllUsefulInfo" parameterName:nil parameterValue:nil];
    
   // [appDelegate showLoading:@"Loading"];
    
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
                              message:@"There is currently no information"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    //if([strMethodName isEqualToString:@"_tspGetAllUseFullInformation"])
    {
        [appDelegate removeLoading];
        arrWebData=arrList;
        //[tblInfo reloadData];
    }
}

-(void)parsingFailedFor:(NSString *)strMethodName With:(NSString *)strErrorMsg
{
    [appDelegate removeLoading];
    NSLog(@"Parsing Failed !!! %@",strErrorMsg);
}

-(IBAction)nextInfoClicked:(id)sender
{
    if(intSelectedInfoIndex<([arrInfo count]-1))
    {
        intSelectedInfoIndex++;
        [self showInfoDetails:[arrInfo objectAtIndex:intSelectedInfoIndex]];
        
    }
}

-(IBAction)previousInfoClicked:(id)sender
{
    if(intSelectedInfoIndex>0)
    {
        intSelectedInfoIndex--;
        [self showInfoDetails:[arrInfo objectAtIndex:intSelectedInfoIndex]];
        
    }
}


-(void)dummyData
{
    Webservice *webObj=[[Webservice alloc] init];
    NSString *strPath=[[NSBundle mainBundle] pathForResource:@"UsefulInfo" ofType:@"xml"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:strPath])
    {
        NSLog(@"FILE UsefulInfo didnot exist");
        return;
    }
    
    NSData *data=[[NSData alloc]initWithContentsOfFile:strPath];
    NSString* docString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *conversion=[webObj ConvertSpecialChar:docString];
           //---shows the XML---
        NSLog(@"%@",conversion);
    
    
    
    
    webObj.delegate=self;
    NSMutableData *webData = (NSMutableData *)[conversion dataUsingEncoding: NSASCIIStringEncoding];
    
    [webObj parsingUsefulInformation:webData];

}

-(CGRect)getHeaderSize:(NSString*)strName
{
    UILabel *lblHeader=[[UILabel alloc] initWithFrame:CGRectMake(10,5, 200, 30)];
    
    [lblHeader setTextColor:COLOR_DARK_RED];
    [lblHeader setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    lblHeader.text=strName;
     lblHeader.numberOfLines=0;
    [lblHeader sizeToFit];

   
    
    return lblHeader.frame;
}

- (float)text:(NSString *)text sizeWithFont:(UIFont *)font
{
    
    UITextView *txtView=[[UITextView alloc] init];
    
    
    txtView.text = text;
    txtView.font =font;
    
    if(IS_IOS7)
    {
        txtView.editable = YES;
        txtView.font = font;
        txtView.editable = NO;
    }
    
    //
    
    
    float fWidth = 220;
    CGSize newSize;
    newSize=[txtView sizeThatFits:CGSizeMake(fWidth, MAXFLOAT)];
    CGRect newFrame = txtView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fWidth), newSize.height);
    txtView.frame=newFrame;

    
    txtView=nil;
    
    return newSize.height;
}

-(void)imageUsefulInfoClicked:(UIButton *)btn
{
    isOpen=-1;
    intSelectedInfoIndex=(int)btn.tag;
    
    //intSelectedInfoIndex=12;
    NSString *strCat=[NSString stringWithFormat:@"%d",intSelectedInfoIndex+1];
    NSPredicate * predicate=[NSPredicate predicateWithFormat:@"category = %@",strCat];
    arrDetails=(NSMutableArray *)[arrWebData filteredArrayUsingPredicate:predicate];
    
    if([arrDetails count]>0)
    {
        [appDelegate.homeVC addViewOnHome:viewInfotDetails];
        [appDelegate animatePushViewController:viewInfotDetails andViewToBeRemoved:viewListContent state:0];
        [tblInfoDetails reloadData];
        [tblInfoDetails setContentOffset:CGPointZero];
        self.lastContentOffset=0;
        
       lblSubTitle.text=[arrNames objectAtIndex:intSelectedInfoIndex];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Tampines"
                              message:@"There is currently no information available"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getUsefullInformation
{
    
    [self setCategoryArray];
    tblInfoDetails.sectionHeaderHeight = 45;
    tblInfoDetails.sectionFooterHeight = 0;
    tblInfo.sectionHeaderHeight = 0;
    tblInfo.sectionFooterHeight = 0;
    self.openSectionIndex = NSNotFound;
    
    if ((self.sectionInfoArray == nil)|| ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:tblInfoDetails])) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (MyCategory *cat in self.categoryList) {
            SectionInfo *section = [[SectionInfo alloc] init];
            section.category = cat;
            section.open = NO;
            
            NSNumber *defaultHeight = [NSNumber numberWithInt:100];
            NSInteger count = [[section.category list] count];
            for (NSInteger i= 0; i<count; i++) {
                [section insertObject:defaultHeight inRowHeightsAtIndex:i];
            }
            
            [array addObject:section];
        }
        self.sectionInfoArray = array;
    }


    
}

- (void) sectionClosed : (NSInteger) section{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
	SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
	
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [tblInfoDetails numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [tblInfoDetails deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

- (void) sectionOpened : (NSInteger) section
{
    SectionInfo *array = [self.sectionInfoArray objectAtIndex:section];
    
    array.open = YES;
    NSInteger count = [array.category.list count];
    NSMutableArray *indexPathToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<count;i++)
    {
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenIndex = self.openSectionIndex;
    
    if (previousOpenIndex != NSNotFound)
    {
        SectionInfo *sectionArray = [self.sectionInfoArray objectAtIndex:previousOpenIndex];
        sectionArray.open = NO;
        NSInteger counts = [sectionArray.category.list count];
        [sectionArray.sectionView toggleButtonPressed:FALSE];
        for (NSInteger i = 0; i<counts; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenIndex]];
        }
    }
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenIndex == NSNotFound || section < previousOpenIndex)
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    [tblInfoDetails beginUpdates];
    [tblInfoDetails insertRowsAtIndexPaths:indexPathToInsert withRowAnimation:insertAnimation];
    [tblInfoDetails deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tblInfoDetails endUpdates];
    self.openSectionIndex = section;
    
}

- (void) setCategoryArray
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"CategoryList" withExtension:@"plist"];
    NSArray *mainArray = [[NSArray alloc] initWithContentsOfURL:url];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] initWithCapacity:[mainArray count]];
    for (NSDictionary *dictionary in mainArray) {
        MyCategory *category = [[MyCategory alloc] init];
        category.name = [dictionary objectForKey:@"name"];
        category.list = [dictionary objectForKey:@"list"];
        [categoryArray addObject:category];
    }
    self.categoryList = categoryArray;
}

-(float)getCellHeight:(ClsUsefulInformation *)obj
{
    float myHeight=[self getLabelHeightFor:obj.name];
    float factor=myHeight;
    
    UILabel *lblHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, myHeight)];
    CGRect rect=lblHeader.frame;
    // Description
    if([obj.description length]>0)
    {
        
        UITextView *txtDescription=[[UITextView alloc] initWithFrame:CGRectMake(5,factor+20, 220, 30)];
        txtDescription.text=obj.description;
        [txtDescription setTextColor:COLOR_DARK_RED];
        txtDescription.backgroundColor=[UIColor clearColor];
        [txtDescription setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
        txtDescription.editable = NO;
        txtDescription.scrollEnabled=FALSE;
        txtDescription.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
        rect      = txtDescription.frame;
        rect.size.height = [self text:txtDescription.text sizeWithFont:txtDescription.font];
        txtDescription.frame   = rect;
    }
    
    
    if([obj.address length]>0)
    {
        
        UITextView *txtAddress=[[UITextView alloc] initWithFrame:CGRectMake(5,20+rect.origin.y+rect.size.height, 220, 30)];
        
        txtAddress.text=obj.address;
        [txtAddress setTextColor:COLOR_DARK_RED];
        txtAddress.backgroundColor=[UIColor clearColor];
        [txtAddress setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
        txtAddress.editable = NO;
        txtAddress.scrollEnabled=FALSE;
        txtAddress.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
        rect      = txtAddress.frame;
        rect.size.height = [self text:txtAddress.text sizeWithFont:txtAddress.font];
        txtAddress.frame   = rect;
    }
    
    
    // Phone
    if([obj.phone length]>0)
    {
        
        UITextView *txtphone=[[UITextView alloc] initWithFrame:CGRectMake(5,rect.origin.y+20+rect.size.height, 220, 30)];
        txtphone.text=obj.phone;
        [txtphone setTextColor:COLOR_DARK_RED];
        txtphone.backgroundColor=[UIColor clearColor];
        [txtphone setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
        txtphone.editable = NO;
        txtphone.scrollEnabled=FALSE;
        txtphone.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
        rect      = txtphone.frame;
        rect.size.height = [self text:txtphone.text sizeWithFont:txtphone.font];
        txtphone.frame   = rect;
    }
    
    // Website
    if([obj.url length]>0)
    {
        
        UITextView *txtWebsite=[[UITextView alloc] initWithFrame:CGRectMake(5,20+rect.origin.y+rect.size.height, 220, 30)];
        if([obj.url length]>0)
            txtWebsite.text=obj.url;
        else
            txtWebsite.text=@"-";
        [txtWebsite setTextColor:COLOR_DARK_RED];
        txtWebsite.backgroundColor=[UIColor clearColor];
        [txtWebsite setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
        txtWebsite.editable = NO;
        txtWebsite.scrollEnabled=FALSE;
        txtWebsite.dataDetectorTypes = UIDataDetectorTypeLink|UIDataDetectorTypePhoneNumber;
        rect      = txtWebsite.frame;
        rect.size.height = [self text:txtWebsite.text sizeWithFont:txtWebsite.font];
        txtWebsite.frame   = rect;
    }
    
    
    return rect.origin.y+rect.size.height;

}

-(float)getLabelHeightFor:(NSString *)myString
{
    UILabel *lblHeader=[[UILabel alloc] initWithFrame:CGRectMake(0,15, 200, 44)];
    lblHeader.center=CGPointMake(105, 22);
    lblHeader.text=myString;
    [lblHeader setTextColor:COLOR_DARK_RED];
    lblHeader.backgroundColor=[UIColor clearColor];
    [lblHeader setFont:[UIFont fontWithName:FONT_REGULAR size:14]];
    lblHeader.numberOfLines=0;
    [lblHeader sizeToFit];
    
    if(lblHeader.frame.size.height<=22)
        return 44.0;
    return lblHeader.frame.size.height+20;
    lblHeader=nil;
}


-(int)getAllRowHeights:(int)intIndex
{
    int sum=0;
    for (int i=0; i<intIndex; i++) {
        ClsUsefulInformation *obj=[arrDetails objectAtIndex:i];
        sum=sum+[self getLabelHeightFor:obj.name];
    }
    
    return sum;
}
@end
