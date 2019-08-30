//
//  Webservice.h
//  Webservice
//
//  Created by winjit on 20/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "TBXML.h"
#import "Webservice.h"

#import "ClsEvent.h"
#import "ClsCategory.h"
#import "ClsAnnouncemnets.h"
#import "ClsUsefulInformation.h"
#import "ClsAmenity.h"

@protocol WebDataParserDelegate;



@interface Webservice : NSObject<NSURLConnectionDelegate>
{
    
    NSURLConnection *conn;
    NSMutableData *webData;
    
    NSString *strDelimeter;
    
    
    NSString *calledProcedureName;
    
    NSString *strWebServiceName,*strServerName;
    BOOL showLog;
    
    BOOL isError;
    
    
    
}

@property (nonatomic, assign) id <WebDataParserDelegate> delegate;

@property (strong , retain) NSString *strDelimeter;


-(void)getDelimeter;

-(void)GetDataInXMLFromStoredProcedure:(NSString *)storedProcedureName parameterName:(NSMutableArray *)paramName parameterValue:(NSMutableArray *)paramValue;

-(void)GetDataInXMLByQuery:(NSString *)storedProcedureName Query:(NSString *)query TableName:(NSString *)tableName;

-(void)connectToWeb :(NSString *)genericWebMethod withMsg:(NSString *)soapMsg;

-(BOOL)checkInternet;

// parsing methods

-(void)parsingWebdata:(NSMutableData*)WebData;

-(void)GetDataInXMLFromStoredProcedureUsefulInfo:(NSString *)storedProcedureName parameterName:(NSMutableArray *)paramName parameterValue:(NSMutableArray *)paramValue;

-(void)parsingUsefulInformation:(NSMutableData*)WebData;

//For web service
-(void)GetDataInXMLFromWebService:(NSString *)webServiceName parameterName:(NSMutableArray *)paramName parameterValue:(NSMutableArray *)paramValue;

-(NSString*)ConvertSpecialChar:(NSString *)stringToConvert;

//client's push notification service call
-(void) registerForPushNotificationWithDeviceToken:(NSString*)strToken andUserName:(NSString*)strUserName;

@end

@protocol WebDataParserDelegate <NSObject>
@optional
-(void)parsingSucessfullFor:(NSString *)strMethodName With:(NSMutableArray *)arrList;
-(void)parsingFailedFor:(NSString *)strMethodName With:(NSString *)strErrorMsg;
@end




