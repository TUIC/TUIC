//
//  TUIC_2DTagPoint.m
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "TUIC_2DTagPoint.h"

@implementation TUIC_2DTagPoint
@synthesize locationInView_X, locationInView_Y;
@synthesize type, serialNumber;

- (id)init
{
    self = [super init];
    if (self) {
        locationInView_X = 0.0;
        locationInView_Y = 0.0;
        type = @"Payload";
        serialNumber = -1;
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end
