//
//  MyTextView.m
//  Tampines
//
//  Created by Pradip on 03/04/14.
//  Copyright (c) 2014 Winjit Developer. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

@end
