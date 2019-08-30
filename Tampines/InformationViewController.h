//
//  InformationViewController.h
//  Tampines
//
//  Created by Pradip on 14/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyTextView.h"
#import "SectionView.h"

@class AppDelegate;

@interface InformationViewController : UIViewController<WebDataParserDelegate,SectionView>
{
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *tblInfo,*tblInfoDetails;
    NSMutableArray *arrInfo,*arrDetails,*arrWebData;
    
    int intSelectedInfoIndex;
    IBOutlet UIView *viewInfotDetails,*viewListContent;
    
    IBOutlet UILabel *lblHeaderInfo;
    IBOutlet UIScrollView *scrolInfo;
    
    IBOutlet UIView *viewList,*viewDetail;
    
    IBOutlet UIButton *btnNext,*btnPrevious;
    IBOutlet UIImageView *imgNext,*imgPrevious;
    
    BOOL flagTableType;
    
    IBOutlet UILabel *lblSubTitle;
    
    NSMutableArray *arrIcons,*arrNames,*arrSubTitles,*arrInfo2;
    
    int isOpen;
}

@property (nonatomic, assign) CGFloat lastContentOffset;

-(void)getAllInfoFromServer;

@end
