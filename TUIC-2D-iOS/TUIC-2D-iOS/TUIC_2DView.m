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
@synthesize location;
@synthesize size;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        tagID = 0;
        orientationAngle = 0.0;
        tagPoints = [[NSMutableArray alloc] initWithCapacity:0];
        location = CGPointMake(0.0, 0.0);
        size = CGSizeMake(200, 200);
        tagInfolabel = [[UILabel alloc] initWithFrame:CGRectMake(location.x+size.width/2 , location.y + size.height/2 , 100, 30)];
        [tagInfolabel setText:[NSString stringWithFormat:@"Tag id is %d",tagID]];
        [self addSubview:tagInfolabel];
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
    tagID = 0;
    if([tagPoints count]<3){
        return;
    }
    else {
        for (int i=0; i<[tagPoints count]; i++) {
            TUIC_2DTagPoint *tagPt = [tagPoints objectAtIndex:i];
            switch (tagPt.type) {
                case TUIC_2DTagTypeCorner: {
                    break;
                }
                case TUIC_2DTagTypePayload: {
                    tagID += (int)pow(2, tagPt.serialNumber);
                    break;
                }
                case TUIC_2DTagTypeUnknown: {
                    //TODO: Identify its type
                    
                    break;
                }
                    
            }

        }
        
    }

}


-(void)upDateLocation
{
    float pt1_loc_X = 0.0;
    float pt1_loc_Y = 0.0;
    float pt2_loc_X = 0.0;
    float pt2_loc_Y = 0.0;
    for (int i=0; i<[tagPoints count]; i++) {
        TUIC_2DTagPoint *tmpTagPoint = [tagPoints objectAtIndex:i];
        if(tmpTagPoint.type==TUIC_2DTagTypeCorner){
            if(tmpTagPoint.serialNumber==1){
                pt1_loc_X = [tmpTagPoint.touchObject locationInView:self].x;
                pt1_loc_Y = [tmpTagPoint.touchObject locationInView:self].y;
            } else if (tmpTagPoint.serialNumber==2) {
                pt2_loc_X = [tmpTagPoint.touchObject locationInView:self].x;
                pt2_loc_Y = [tmpTagPoint.touchObject locationInView:self].y;
            }
        }
    }
    self.location = CGPointMake((pt1_loc_X+pt2_loc_X)/2, (pt1_loc_Y+pt2_loc_Y)/2);
    CGRect newFrame =  CGRectMake(location.x +size.width/2 , location.y + size.height/2 , 100, 30);
    tagInfolabel.frame  = newFrame;
    [tagInfolabel setText:[NSString stringWithFormat:@"Tag id is %d",tagID]];
}

@end
