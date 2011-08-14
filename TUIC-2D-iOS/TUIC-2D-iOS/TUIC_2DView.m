//
//  TUIC_2DView.m
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "TUIC_2DView.h"

#define DIAGNO_LENGTH 200.0

@implementation TUIC_2DView
@synthesize tagPoints;


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        tagID = 0;
        orientationAngle = 0.0;
        tagPoints = [[NSMutableArray alloc] initWithCapacity:0];
        CGRect selfBound = [self bounds];
        tagInfolabel = [[UILabel alloc] initWithFrame:CGRectMake(selfBound.origin.x+selfBound.size.width, selfBound.origin.y+selfBound.size.height, 100, 30)];        
    }
    
    return self;
}


- (void)dealloc
{
    [tagPoints release];
    [tagInfolabel release];
	[super dealloc];
}


-(void)decodeTag
{
    if([tagPoints count]<3){
        return;
    }
    else {
        for (int i=0; i<[tagPoints count]; i++) {
            //TODO
            CGPoint pointLocation = CGPointMake([touch locationInView:self].x, [touch locationInView:self].y);
        }
        
    }

}


@end
