//
//  ClsAmenity.h
//  Tampines
//
//  Created by Pradip on 07/03/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsAmenity : NSObject
{
    NSString *AmenityName;
    NSMutableArray *arrList;
}

@property (strong, nonatomic) NSString *AmenityName;
@property (strong, nonatomic) NSMutableArray *arrList;

@end
