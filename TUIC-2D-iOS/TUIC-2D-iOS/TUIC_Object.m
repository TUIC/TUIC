//
//  TUIC_Object.m
//  TUIC-2D-iOS
//
//  Created by Xman on 11/8/15.
//  Copyright 2011年 MHCI Lab. All rights reserved.
//

#import "TUIC_Object.h"

#define kPayloadBit 9

@implementation TUIC_Object

@synthesize location;
@synthesize touchPoints;
@synthesize tagID;
@synthesize orientationAngle;

- (id)init
{
    self = [super init];
    if (self) {
        touchPoints = [[NSMutableArray alloc] initWithCapacity:3+kPayloadBit];
    }
    return self;
}

- (void)dealloc{
    [touchPoints release];
    [super dealloc];
}

@end
