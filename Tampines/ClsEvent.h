//
//  ClsEvent.h
//  Tampines
//
//  Created by Pradip on 11/02/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsEvent : NSObject
{
    NSString *ID,*ccID,*rcID,*name,*description,*category,*date,*venue,*organized_by,*organizer,*contact,*fee,*strEventId,*startDate,*endDate,*cDays,*startTime,*endTime;
}

@property (strong, nonatomic) NSString *ID,*ccID,*rcID,*name,*description,*category,*date,*venue,*organized_by,*organizer,*contact,*fee,*strEventId,*startDate,*endDate,*cDays,*startTime,*endTime;

@end
