//
//  TUIC_Object.m
//  TUIC-2D-iOS
//
//  Created by Xman on 11/8/15.
//  Copyright 2011年 MHCI Lab. All rights reserved.
//

#import "TUIC_Object.h"
#import "TUIC_2D_Constant.h"
#import "myMathFormulaUtil.h"

#define kPayloadBit 9

@implementation TUIC_Object

@synthesize location;
@synthesize touchPoints;
@synthesize tagID;
@synthesize orientationAngle;
@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self) {
        touchPoints = [[NSMutableArray alloc] initWithCapacity:3+kPayloadBit];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [touchPoints release];
    [delegate release];
    [super dealloc];
}


- (void)updateObject{
    location = [myMathFormulaUtil calculateCenterWithC1:[[touchPoints objectAtIndex:1] locationInView:nil] andC2:[[touchPoints objectAtIndex:2] locationInView:nil]];
    orientationAngle = [myMathFormulaUtil pointPairToBearingDegrees:[[touchPoints objectAtIndex:0] locationInView:nil] secondPoint:self.location];
    [delegate TUIC_ObjectdidUpdate:self];
}

@end
