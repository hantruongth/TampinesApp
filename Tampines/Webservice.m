//
//  Webservice.m
//  Webservice
//
//  Created by winjit on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Webservice.h"

#define DBToken @""
#define Username @""
#define Password @""
#define DeviceId @""


@implementation Webservice

@synthesize delegate,strDelimeter;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.strDelimeter=@"~~";
        showLog=FALSE;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
            strWebServiceName=[dict valueForKey:@"WebServiceURL"];
            showLog=[[dict valueForKey:@"LogXMLOutput"] intValue];
        }
           
    }
            

    return self;
}


//To get the delimeter used in the soap message
-(void)getDelimeter
{
    calledProcedureName=@"GetDelimiter";
    
    NSString *soapMsg =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                        <soap:Envelope\
                        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
                        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
                        xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                        <soap:Body>\
                        <GetDelimiter\
                        xmlns=\"http://tempuri.org/\">\
                        </GetDelimiter>\
                        </soap:Body>\
                        </soap:Envelope>"];
    
    [self connectToWeb:@"GetDelimiter" withMsg:soapMsg];
    
}




//Things to know while using this class
//In this class, strDBToken,strUsername,strPassword & strDeviceId are declared as properties.
//You will need to set the value to this properties by creating object of this class.
//You only need to pass Stored Procedure Name as a string, parameter name & parameter value as mutable arrays. 
//You only need to add parameter names & values in it.
//Also If you want data using Query, then pass Query & TableName as a string values. 



//To get the xml data from stored procedure
-(void)GetDataInXMLFromStoredProcedure:(NSString *)storedProcedureName parameterName:(NSMutableArray *)paramName parameterValue:(NSMutableArray *)paramValue
{

    calledProcedureName=storedProcedureName;

    NSString *soapMsg =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                        <soap:Envelope\
                        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
                        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
                        xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                        <soap:Body>\
                        <GetDataInXMLFromStoredProcedure\
                        xmlns=\"http://tempuri.org/\">\
                        <DBToken>%@</DBToken>\
                        <UserName>%@</UserName>\
                        <Password>%@</Password>\
                        <DeviceID>%@</DeviceID>\
                        <ProcedureName>%@</ProcedureName>\
                        <Parameters>",DBToken,Username,Password,DeviceId,storedProcedureName];
    
    //To add runtime parameters to the web service.
    for (int parameters = 0; parameters<[paramName count]; parameters++)
    {
        NSString *strParameter = [NSString stringWithFormat:@"<string>"];
        strParameter = [NSString stringWithFormat:@"%@%@%@%@",strParameter,[paramName objectAtIndex:parameters],self.strDelimeter,[paramValue objectAtIndex:parameters]];
        strParameter = [NSString stringWithFormat:@"%@</string>",strParameter];
        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,strParameter];
    }
    
    soapMsg = [NSString stringWithFormat:@"%@</Parameters>\
               </GetDataInXMLFromStoredProcedure>\
               </soap:Body>\
               </soap:Envelope>",soapMsg];
    
    
    [self connectToWeb:@"GetDataInXMLFromStoredProcedure" withMsg:soapMsg];
    
    if(showLog)
     NSLog(@"\n\nSoap Message = %@",soapMsg); 
    
    // return soapMsg;
}

//To get the xml data from stored procedure
-(void)GetDataInXMLFromStoredProcedureUsefulInfo:(NSString *)storedProcedureName parameterName:(NSMutableArray *)paramName parameterValue:(NSMutableArray *)paramValue
{
    
    calledProcedureName=storedProcedureName;
    
    NSString *soapMsg =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                        <soap:Envelope\
                        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
                        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
                        xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                        <soap:Body>\
                        <GetXMLFromStoredProcedure\
                        xmlns=\"http://tempuri.org/\">\
                        <DBToken>%@</DBToken>\
                        <UserName>%@</UserName>\
                        <Password>%@</Password>\
                        <DeviceID>%@</DeviceID>\
                        <ProcedureName>%@</ProcedureName>\
                        <Parameters>",DBToken,Username,Password,DeviceId,storedProcedureName];
    
    //To add runtime parameters to the web service.
    for (int parameters = 0; parameters<[paramName count]; parameters++)
    {
        NSString *strParameter = [NSString stringWithFormat:@"<string>"];
        strParameter = [NSString stringWithFormat:@"%@%@%@%@",strParameter,[paramName objectAtIndex:parameters],self.strDelimeter,[paramValue objectAtIndex:parameters]];
        strParameter = [NSString stringWithFormat:@"%@</string>",strParameter];
        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,strParameter];
    }
    
    soapMsg = [NSString stringWithFormat:@"%@</Parameters>\
               </GetXMLFromStoredProcedure>\
               </soap:Body>\
               </soap:Envelope>",soapMsg];
    
    
    [self connectToWeb:@"GetXMLFromStoredProcedure" withMsg:soapMsg];
    
    if(showLog)
        NSLog(@"\n\nSoap Message = %@",soapMsg);
    
    // return soapMsg;
}


//For web service
-(void)GetDataInXMLFromWebService:(NSString *)webServiceName parameterName:(NSMutableArray *)paramName parameterValue:(NSMutableArray *)paramValue
{
    
    calledProcedureName=webServiceName;
    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                         <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                         <soap:Body>\
                         <%@ xmlns=\"http://tempuri.org/\">",webServiceName];
    
    for (int i = 0; i< [paramName count]; i++) 
    {
        //create xml as param name     //<%@>%@</%@>
        NSString *strParameter = [NSString stringWithFormat:@"<%@><![CDATA[%@]]></%@>",[paramName objectAtIndex:i],[paramValue objectAtIndex:i],[paramName objectAtIndex:i]];
        soapMsg = [NSString stringWithFormat:@"%@%@",soapMsg,strParameter];
    }
    
    soapMsg = [NSString stringWithFormat:@"%@</%@>\
               </soap:Body>\
               </soap:Envelope>",soapMsg,webServiceName];
    
    //NSLog(@"\n\nSoap Message = %@",soapMsg); 
    [self connectToWeb:[NSString stringWithFormat:@"%@",webServiceName] withMsg:soapMsg];
}

//To get the xml data from Query
-(void)GetDataInXMLByQuery:(NSString *)storedProcedureName Query:(NSString *)query TableName:(NSString *)tableName
{
    NSString *soapMsg =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                        <soap:Envelope\
                        xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
                        xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\
                        xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                        <soap:Body>\
                        <GetDataByQuery\
                        xmlns=\"http://tempuri.org/\">\
                        <DBToken>%@</DBToken>\
                        <UserName>%@</UserName>\
                        <Password>%@</Password>\
                        <DeviceID>%@</DeviceID>\
                        <Query>%@</Query>\
                        <TableName>%@</TableName>\
                        </GetDataByQuery>\
                        </soap:Body>\
                        </soap:Envelope>",
                        DBToken,Username,Password,DeviceId,
                        query,tableName];
    
   // NSLog(@"Soap Message = %@",soapMsg);
    [self connectToWeb:@"GetDataByQuery" withMsg:soapMsg];
    //return soapMsg;
}



#pragma mark Connect to generic web service 
-(void)connectToWeb :(NSString *)genericWebMethod withMsg:(NSString *)soapMsg
{
    isError=NO;
    
    //Pass path of Generic Web Service url
    NSURL *url = [NSURL URLWithString:strWebServiceName];
    
    NSMutableURLRequest *req =[NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
	
    [req addValue:@"text/xml; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
	
	[req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	
    [req addValue:[ NSString stringWithFormat:@"http://tempuri.org/%@", genericWebMethod] forHTTPHeaderField:@"SOAPAction"];
	
    //Address of web service(180.235.131.176)
	[req addValue:strServerName forHTTPHeaderField:@"Host"];
	
    [req setHTTPMethod:@"POST"];
    
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Test for Internet, calling the self method
    if([self checkInternet])
    {
        conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	}
    
	else
	{		
		/*UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"" 
							  message:@"Unable to Connect"
							  delegate:self  
							  cancelButtonTitle:@"OK" 
							  otherButtonTitles:nil];
		[alert show];*/
    }    
}

#pragma mark Reachability method
-(BOOL)checkInternet
{
	//Test for Internet Connection
	Reachability *r = [Reachability reachabilityWithHostName:@"google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
    
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) 
    {
		internet = NO;
	} 
    
    else 
    {
		internet = YES;
	}
	return internet;
    
    return YES;
}

#pragma mark Connection Delegate methods
-(void) connection:(NSURLConnection *) connection 
didReceiveResponse:(NSURLResponse *) response 
{
    //Test for Internet, calling the self method
	if ([self checkInternet])
	{
		webData = [[NSMutableData alloc]init];
		[webData setLength: 0];
	}
    
	else
	{
		
		/*UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"" 
							  message:@"Unable to Connect"
							  delegate:self  
							  cancelButtonTitle:@"Ok" 
							  otherButtonTitles:nil];
		[alert show];*/
    }	
}

-(void) connection:(NSURLConnection *) connection 
	didReceiveData:(NSData *) data 
{
    //Test for Internet, calling the self method
	if ( [self checkInternet])
		[webData appendData:data];
    
	else
	{
		
		/*UIAlertView *alert = [[UIAlertView alloc] 
							  initWithTitle:@"" 
							  message:@"Unable to Connect"
							  delegate:self  
							  cancelButtonTitle:@"Ok" 
							  otherButtonTitles:nil];
		[alert show];*/		
	}
}

-(void) connection:(NSURLConnection *) connection 
  didFailWithError:(NSError *) error 
{
    
    
    NSLog(@"error=%@",error.description);
    

    if(!isError)
    [[self delegate] parsingFailedFor:calledProcedureName With:error.localizedDescription];
    
    isError=TRUE;
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection 
{
    	

    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [webData mutableBytes] 
                        length:[webData length] 
                        encoding:NSUTF8StringEncoding];
    
      NSString *conversion=[self ConvertSpecialChar:theXML];
    if(showLog)
    {
    //---shows the XML---
    NSLog(@"%@",conversion);
    }
    
    
  
    
    webData = (NSMutableData *)[conversion dataUsingEncoding: NSUTF8StringEncoding];
    
    
    if ([calledProcedureName caseInsensitiveCompare:calledProcedureName]==NSOrderedSame) {
        [self parsingWebdata:webData];
    }
    
}


-(void)parsingWebdata:(NSMutableData*)WebData
{
  //---------------------------------------------------------------------//
       
     
    if([calledProcedureName isEqualToString:@"GetWiFiDetails"])
    {
        [self parsingWiFiDetails:WebData];
        return;
    }
    
    
    
    NSMutableArray *arrList=[[NSMutableArray alloc] init];
    
    TBXML * tbxml = [[TBXML alloc] initWithXMLData:WebData];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root) 
    {            
        TBXMLElement * SoapBody = [TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        if (SoapBody!=nil)
        {
            TBXMLElement * SoapResponse = [TBXML childElementNamed:@"GetDataInXMLFromStoredProcedureResponse" parentElement:SoapBody];
            
            if (SoapResponse!=nil)
            {
                TBXMLElement * SoapResult = [TBXML childElementNamed:@"GetDataInXMLFromStoredProcedureResult" parentElement:SoapResponse];
                
                if (SoapResult!=nil)
                {
                    TBXMLElement * NewDataSet = [TBXML childElementNamed:@"NewDataSet" parentElement:SoapResult];
                    
                    if (NewDataSet!=nil)
                    {
                        
                        TBXMLElement * RecordSet = [TBXML childElementNamed:calledProcedureName parentElement:NewDataSet];
                //---------------------------------------------------------------------//
                        
                        if([calledProcedureName isEqualToString:@"_tspGetAllEvent"])
                        {
                            
                            while (RecordSet != nil)
                            {
                                
                                ClsEvent *objEvent=[[ClsEvent alloc] init];
                                
                                // iEventID
                                TBXMLElement *TBiEventID = [TBXML childElementNamed:@"iEventID" parentElement:RecordSet];
                                if (TBiEventID != nil)
                                    objEvent.ID = [TBXML textForElement:TBiEventID];
                                
                                // cEventName
                                TBXMLElement *TBcEventName = [TBXML childElementNamed:@"cEventName" parentElement:RecordSet];
                                if (TBcEventName != nil)
                                    objEvent.name = [TBXML textForElement:TBcEventName];
                                
                                // cDescription
                                TBXMLElement *TBcDescription = [TBXML childElementNamed:@"cDescription" parentElement:RecordSet];
                                if (TBcDescription != nil)
                                    objEvent.description = [TBXML textForElement:TBcDescription];
                                
                                // cCategoryID
                                TBXMLElement *TBcCategoryID = [TBXML childElementNamed:@"cCategoryID" parentElement:RecordSet];
                                if (TBcCategoryID != nil)
                                    objEvent.category = [TBXML textForElement:TBcCategoryID];
                                
                                
                                // dStartDate
                                TBXMLElement *TBdStartDate = [TBXML childElementNamed:@"StartDate" parentElement:RecordSet];
                                if (TBdStartDate != nil)
                                    objEvent.startDate = [TBXML textForElement:TBdStartDate];
                                
                                // dEndDate
                                TBXMLElement *TBdEndDate = [TBXML childElementNamed:@"EndDate" parentElement:RecordSet];
                                if (TBdEndDate != nil)
                                    objEvent.endDate = [TBXML textForElement:TBdEndDate];
                                
                                // cDays
                                TBXMLElement *TBcDays = [TBXML childElementNamed:@"cDays" parentElement:RecordSet];
                                if (TBcDays != nil)
                                    objEvent.cDays = [TBXML textForElement:TBcDays];
                                
                                // cInFullAddress
                                TBXMLElement *TBcInFullAddress = [TBXML childElementNamed:@"cInFullAddress" parentElement:RecordSet];
                                if (TBcInFullAddress != nil)
                                    objEvent.venue = [TBXML textForElement:TBcInFullAddress];
                                
                                // cOrganizer
                                TBXMLElement *TBcOrganizer = [TBXML childElementNamed:@"cOrganizer" parentElement:RecordSet];
                                if (TBcOrganizer != nil)
                                    objEvent.organizer = [TBXML textForElement:TBcOrganizer];
                                
                                  // iOrganizedByCC
                                TBXMLElement *TBiOrganizedByCC = [TBXML childElementNamed:@"iOrganizedByCC" parentElement:RecordSet];
                                if (TBiOrganizedByCC != nil)
                                    objEvent.ccID = [TBXML textForElement:TBiOrganizedByCC];
                                
                                // iOrganizedByRC
                                TBXMLElement *TBiOrganizedByRC = [TBXML childElementNamed:@"iOrganizedByRC" parentElement:RecordSet];
                                if (TBiOrganizedByRC != nil)
                                    objEvent.rcID = [TBXML textForElement:TBiOrganizedByRC];
                                
                                // cContact
                                TBXMLElement *TBcContact = [TBXML childElementNamed:@"cContact" parentElement:RecordSet];
                                if (TBcContact != nil)
                                    objEvent.contact = [TBXML textForElement:TBcContact];
                                
                                // cFee
                                TBXMLElement *TBcFee = [TBXML childElementNamed:@"cFee" parentElement:RecordSet];
                                if (TBcFee != nil)
                                    objEvent.fee = [TBXML textForElement:TBcFee];


                                // dStart Time
                                TBXMLElement *TBdStartTime = [TBXML childElementNamed:@"dStartTime" parentElement:RecordSet];
                                if (TBdStartTime != nil)
                                    objEvent.startTime = [TBXML textForElement:TBdStartTime];
                                
                                // dEnd Timw
                                TBXMLElement *TBdEndTime = [TBXML childElementNamed:@"dEndTime" parentElement:RecordSet];
                                if (TBdEndTime != nil)
                                    objEvent.endTime = [TBXML textForElement:TBdEndTime];
                                
                                //------ Add Object Into Array ----------
                                [arrList addObject:objEvent];
                                
                                
                                //move to next record
                                RecordSet = [TBXML nextSiblingNamed:calledProcedureName searchFromElement:RecordSet];
                            }
                        }
                    //---------------------------------------------------------------------//

                            else if([calledProcedureName isEqualToString:@"_tspGetAllCategory"])
                                {
                                    
                                    while (RecordSet != nil)
                                    {
                                        
                                        ClsCategory *objCategory=[[ClsCategory alloc] init];
                                        
                                        // iEventID
                                        TBXMLElement *TBiCategoryId = [TBXML childElementNamed:@"iCategoryId" parentElement:RecordSet];
                                        if (TBiCategoryId != nil)
                                            objCategory.ID = [TBXML textForElement:TBiCategoryId];
                                        
                                        // cEventName
                                        TBXMLElement *TBcCategoryName = [TBXML childElementNamed:@"cCategoryName" parentElement:RecordSet];
                                        if (TBcCategoryName != nil)
                                            objCategory.name = [TBXML textForElement:TBcCategoryName];
                                        
                                        
                                        //------ Add Object Into Array ----------
                                        [arrList addObject:objCategory];
                                        
                                        
                                        //move to next record
                                        RecordSet = [TBXML nextSiblingNamed:calledProcedureName searchFromElement:RecordSet];
                                    }
                                }
                        //---------------------------------------------------------------------//

             
                        
                            else if([calledProcedureName isEqualToString:@"_tspGetAllAnnouncement"])
                            {
                                
                                while (RecordSet != nil)
                                {
                                    
                                    ClsAnnouncemnets *objAnnouncemnet=[[ClsAnnouncemnets alloc] init];
                                    
                                    // Name
                                    TBXMLElement *TBcMessageTitle = [TBXML childElementNamed:@"cMessageTitle" parentElement:RecordSet];
                                    if (TBcMessageTitle != nil)
                                        objAnnouncemnet.name = [TBXML textForElement:TBcMessageTitle];
                                    
                                    // Start Date
                                    TBXMLElement *TBStartDate = [TBXML childElementNamed:@"StartDate" parentElement:RecordSet];
                                    if (TBStartDate != nil)
                                        objAnnouncemnet.startDate = [TBXML textForElement:TBStartDate];
                                    
                                    // End Date
                                    TBXMLElement *TBEndDate = [TBXML childElementNamed:@"EndDate" parentElement:RecordSet];
                                    if (TBEndDate != nil)
                                        objAnnouncemnet.endDate = [TBXML textForElement:TBEndDate];
                                    
                                    // Description
                                    TBXMLElement *TBcMessageDetail = [TBXML childElementNamed:@"cMessageDetail" parentElement:RecordSet];
                                    if (TBcMessageDetail != nil)
                                        objAnnouncemnet.description = [TBXML textForElement:TBcMessageDetail];
                                    
                                    
                                    //------ Add Object Into Array ----------
                                    [arrList addObject:objAnnouncemnet];
                                    
                                    
                                    //move to next record
                                    RecordSet = [TBXML nextSiblingNamed:calledProcedureName searchFromElement:RecordSet];
                                }
                            }
                        //---------------------------------------------------------------------//
                        
                        
                        
                            else if([calledProcedureName isEqualToString:@"_tspGetAllUsefulInfo"])
                            {
                                
                                while (RecordSet != nil)
                                {
                                    
                                    ClsUsefulInformation *objUsefulInformation=[[ClsUsefulInformation alloc] init];
                                    
                                    // iUsefulInfoID
                                    TBXMLElement *TBiUsefulInfoID = [TBXML childElementNamed:@"iUsefulInfoID" parentElement:RecordSet];
                                    if (TBiUsefulInfoID != nil)
                                        objUsefulInformation.ID = [TBXML textForElement:TBiUsefulInfoID];
                                    
                                    // iFkCategoryID
                                    TBXMLElement *TBiFkCategoryID = [TBXML childElementNamed:@"iFkCategoryID" parentElement:RecordSet];
                                    if (TBiFkCategoryID != nil)
                                        objUsefulInformation.category = [TBXML textForElement:TBiFkCategoryID];
                                    
                                    // cTitle
                                    TBXMLElement *TBcTitle = [TBXML childElementNamed:@"cTitle" parentElement:RecordSet];
                                    if (TBcTitle != nil)
                                        objUsefulInformation.name = [TBXML textForElement:TBcTitle];
                                    
                                    // cDescription
                                    TBXMLElement *TBcDescription = [TBXML childElementNamed:@"cDescription" parentElement:RecordSet];
                                    if (TBcDescription != nil)
                                        objUsefulInformation.description = [TBXML textForElement:TBcDescription];
                                    
                                    // cAddress
                                    TBXMLElement *TBcAddress = [TBXML childElementNamed:@"cAddress" parentElement:RecordSet];
                                    if (TBcAddress != nil)
                                        objUsefulInformation.address = [TBXML textForElement:TBcAddress];
                                    
                                    // cTelephone
                                    TBXMLElement *TBcTelephone = [TBXML childElementNamed:@"cTelephone" parentElement:RecordSet];
                                    if (TBcTelephone != nil)
                                        objUsefulInformation.phone = [TBXML textForElement:TBcTelephone];
                                    
                                    // cURL
                                    TBXMLElement *TBcURL = [TBXML childElementNamed:@"cURL" parentElement:RecordSet];
                                    if (TBcURL != nil)
                                        objUsefulInformation.url = [TBXML textForElement:TBcURL];
                                    
                                    
                                    
                                    //------ Add Object Into Array ----------
                                    [arrList addObject:objUsefulInformation];
                                    
                                    
                                    //move to next record
                                    RecordSet = [TBXML nextSiblingNamed:calledProcedureName searchFromElement:RecordSet];
                                }
                            }
                        

                    }
                }
            }
        }
    }
    
    [[self delegate] parsingSucessfullFor:calledProcedureName With:arrList];
}




-(NSString*)ConvertSpecialChar:(NSString *)stringToConvert

{
    
    NSInteger i;
    
    NSArray *clefs = [NSArray arrayWithObjects:@"&amp;",@"&lt;",@"&gt;",@"&#xD;&#xA;",@"&#xA;", nil];
    
    NSArray *values = [NSArray arrayWithObjects:@"&",@"<",@">",@"\n",@"\n", nil];
    
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjects:values forKeys:clefs];
    
    
    NSArray *keys = [dict allKeys];
    
    for (i=0; i<[keys count]; i++) {
        
        NSString *searchForMe = [keys objectAtIndex:i];
        
        NSRange range = [stringToConvert rangeOfString : searchForMe];
        
        if (range.location != NSNotFound) {
            
            stringToConvert= [stringToConvert      stringByReplacingOccurrencesOfString:searchForMe  withString:[dict objectForKey:searchForMe]];
            
        }
        
    }
    
    return stringToConvert;
    
}

-(void)parsingUsefulInformation:(NSMutableData*)WebData
{
    
    NSMutableArray *arrList=[[NSMutableArray alloc] init];
    
    TBXML * tbxml = [[TBXML alloc] initWithXMLData:WebData];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root)
    {
        TBXMLElement * SoapBody = [TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        if (SoapBody!=nil)
        {
            TBXMLElement * SoapResponse = [TBXML childElementNamed:@"GetXMLFromStoredProcedureResponse" parentElement:SoapBody];
            
            if (SoapResponse!=nil)
            {
                TBXMLElement * SoapResult = [TBXML childElementNamed:@"GetXMLFromStoredProcedureResult" parentElement:SoapResponse];
                
                if (SoapResult!=nil)
                {
                    TBXMLElement * RecordSet = [TBXML childElementNamed:@"Root" parentElement:SoapResult];
                    
                    if (RecordSet!=nil)
                    {
                        TBXMLElement *TBAmenity = [TBXML childElementNamed:@"Amenity" parentElement:RecordSet];
                        
                        while (TBAmenity!=nil)
                        {
                            
                            ClsAmenity *objParent=[[ClsAmenity alloc] init];
                            objParent.AmenityName= [TBXML valueOfAttributeNamed:@"Amenity" forElement:TBAmenity];
                            
                            NSLog(@"objParent.AmenityName=%@",objParent.AmenityName);
                            objParent.arrList=[[NSMutableArray alloc] init];
                            [arrList addObject:objParent];
                            
                             TBXMLElement *TBName = [TBXML childElementNamed:@"Name" parentElement:TBAmenity];
                            while(TBName)
                            {
                                ClsAmenity *obj=[[ClsAmenity alloc] init];
                                obj.AmenityName= [TBXML valueOfAttributeNamed:@"name" forElement:TBName];
                                obj.arrList=[[NSMutableArray alloc] init];
                                [objParent.arrList addObject:obj];
                                
                                TBXMLElement *TBAddress = [TBXML childElementNamed:@"Address" parentElement:TBName];
                                
                                while (TBAddress) {
                                    NSString *strAddress=[TBXML valueOfAttributeNamed:@"Address" forElement:TBAddress];
                                    [obj.arrList addObject:strAddress];

                                    
                                    TBAddress = [TBXML nextSiblingNamed:@"Address"  searchFromElement:TBAddress];
                                }
                                
                                TBName = [TBXML nextSiblingNamed:@"Name"  searchFromElement:TBName];
                            }
                            //move to next record
                            TBAmenity = [TBXML nextSiblingNamed:@"Amenity"  searchFromElement:TBAmenity];
                            
                        }
                    }
                }
            }
        }
    }
    
    [[self delegate] parsingSucessfullFor:calledProcedureName With:arrList];
}


-(void)parsingWiFiDetails:(NSMutableData*)WebData
{
    
    NSMutableArray *arrList=[[NSMutableArray alloc] init];
    
    TBXML * tbxml = [[TBXML alloc] initWithXMLData:WebData];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root)
    {
        TBXMLElement * SoapBody = [TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        if (SoapBody!=nil)
        {
            TBXMLElement * SoapResponse = [TBXML childElementNamed:@"GetWiFiDetailsResponse" parentElement:SoapBody];
            if (SoapResponse!=nil)
            {
                TBXMLElement * SoapResult = [TBXML childElementNamed:@"GetWiFiDetailsResult" parentElement:SoapResponse];
                
                if (SoapResult!=nil)
                {
                    TBXMLElement * RecordSet = [TBXML childElementNamed:@"WiFiDetails" parentElement:SoapResult];
                    
                    if (RecordSet!=nil)
                    {
                        // WiFiName
                        TBXMLElement *TBWiFiName = [TBXML childElementNamed:@"WiFiName" parentElement:RecordSet];
                        if (TBWiFiName != nil)
                            [arrList addObject:[TBXML textForElement:TBWiFiName]];
                        
                        // WiFiPassword
                        TBXMLElement *TBWiFiPassword = [TBXML childElementNamed:@"WiFiPassword" parentElement:RecordSet];
                        if (TBWiFiPassword != nil)
                             [arrList addObject:[TBXML textForElement:TBWiFiPassword]];
                    }
                }
            }

            
        }
    }
    
     [[self delegate] parsingSucessfullFor:calledProcedureName With:arrList];
}

#pragma mark Webservice call for client's push notifier
-(void) registerForPushNotificationWithDeviceToken:(NSString*)strToken andUserName:(NSString*)strUserName
{
    
    
    NSString *strBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *soapMsg =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                        <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                        <soap:Body>\
                        <RegisterPushNotificationDevice xmlns=\"http://nanopushnotification/\">\
                        <appKey>%@</appKey>\
                        <deviceType>1</deviceType>\
                        <deviceToken>%@</deviceToken>\
                        <appUserName>%@</appUserName>\
                        </RegisterPushNotificationDevice>\
                        </soap:Body>\
                        </soap:Envelope>",strBundleIdentifier,strToken,strUserName];
    strBundleIdentifier=nil;
    
    
    NSURL *url = [NSURL URLWithString:@"http://54.251.245.52/NanoPUSH/NanoPushService.asmx"];
    
    NSMutableURLRequest *req =[NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)soapMsg.length];
	
    [req addValue:@"text/xml; charset=utf-8"  forHTTPHeaderField:@"Content-Type"];
	
	[req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	
    [req addValue:@"http://nanopushnotification/RegisterPushNotificationDevice" forHTTPHeaderField:@"SOAPAction"];
	
    //Address of web service(180.235.131.176)
	[req addValue:@"54.251.245.52" forHTTPHeaderField:@"Host"];
	
    [req setHTTPMethod:@"POST"];
    
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Test for Internet, calling the self method
    
    if([self checkInternet])
    {
        conn = [[NSURLConnection alloc] initWithRequest:req delegate:nil];
	}
	else
	{
		/*UIAlertView *alert = [[UIAlertView alloc]
         initWithTitle:@""
         message:@"Unable to Connect"
         delegate:self
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [alert show];*/
    }
    conn=nil;
    
    // return soapMsg;
}

@end
