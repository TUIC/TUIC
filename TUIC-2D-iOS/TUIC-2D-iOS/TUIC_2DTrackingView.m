//
//  TUIC_2DTrackingView.m
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//
#define TIME_THRESHOLD 1.0

#import "TUIC_2DTrackingView.h"

@implementation TUIC_2DTrackingView
@synthesize ActiveTouches, TUIC2DtagArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize the view to track tags
        lastTouchtime = 0.0;
        
        self.multipleTouchEnabled = YES;
        self.exclusiveTouch = YES;
        ActiveTouches = [[NSMutableArray alloc] initWithCapacity:0];
        TUIC2DtagArray = [[NSMutableArray alloc] initWithCapacity:0]; 
    }
    return self;
}
-(void)dealloc {

    [TUIC2DtagArray release];
    [ActiveTouches release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //TODO    

}




#pragma mark Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        
        if (![ActiveTouches containsObject:touch]) {
            [ActiveTouches addObject:touch];
        
        }
        
        TUIC_2DTagPoint *tagPoint = [[TUIC_2DTagPoint alloc] init];
        tagPoint.locationInView_X = [touch locationInView:self].x;
        tagPoint.locationInView_Y = [touch locationInView:self].y;
        
        if ( ([touch timestamp] - lastTouchtime) > TIME_THRESHOLD) {
			//time difference from last touch is too long,so new a tag object
			TUIC_2DView *newTUIC2DTag = [[TUIC_2DView alloc] init];
            [newTUIC2DTag.tagPoints addObject:tagPoint];
            [TUIC2DtagArray addObject:newTUIC2DTag];
            [newTUIC2DTag release];

		}
		else {
			// Time difference from last touch is short enough,the same tag object
            TUIC_2DView *latestTUIC2DView = [TUIC2DtagArray objectAtIndex:([TUIC2DtagArray count]-1)];
			[latestTUIC2DView.tagPoints addObject:tagPoint];
            [latestTUIC2DView decodeTag];
		}
		
        [tagPoint release];
        
        // Renew the latest timestamp
		lastTouchtime = [touch timestamp];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //TODO
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //TODO
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //TODO
}

-(void)clearAll 
{
    //TODO
    
}

@end
