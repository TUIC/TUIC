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
@synthesize TUIC2DtagArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize the view to track tags
        lastTouchtime = 0.0;
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
        self.exclusiveTouch = YES;
        TUIC2DtagArray = [[NSMutableArray alloc] initWithCapacity:0]; 
        
        tagMap = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    }
    return self;
}
-(void)dealloc {

    CFRelease(tagMap);
    [TUIC2DtagArray release];
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


#pragma mark Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n--\nTouch Began:");
    for (UITouch *touch in touches) {
        TUIC_2DTagPoint *tagPoint = [[TUIC_2DTagPoint alloc] init];
        tagPoint.touchObject = touch;
        tagPoint.locationInView_X = [touch locationInView:self].x;
        tagPoint.locationInView_Y = [touch locationInView:self].y;
        
        if ( ([touch timestamp] - lastTouchtime) <= TIME_THRESHOLD) {
            // Time difference from last touch is short enough,the same tag object
            if ([TUIC2DtagArray count]==0) 
                continue;
            TUIC_2DView *latestTUIC2DTag = [TUIC2DtagArray objectAtIndex:([TUIC2DtagArray count]-1)];
			[latestTUIC2DTag.tagPoints addObject:tagPoint];
            CFDictionarySetValue(tagMap, touch , latestTUIC2DTag);
            [latestTUIC2DTag decodeTag];
		}
		else {
            // Time difference from last touch is too long, create a tag object
			TUIC_2DView *newTUIC2DTag = [[TUIC_2DView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            [newTUIC2DTag.tagPoints addObject:tagPoint];
            CFDictionarySetValue(tagMap, touch , newTUIC2DTag);
            [TUIC2DtagArray addObject:newTUIC2DTag];
            [self addSubview:newTUIC2DTag];

            [newTUIC2DTag release];
		}
		
        [tagPoint release];
        
        // Refresh the latest timestamp
		lastTouchtime = [touch timestamp];
    }
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n--Touch moved:");
    for (UITouch *touch in touches) {
        TUIC_2DView *tag = (TUIC_2DView*)CFDictionaryGetValue(tagMap, touch);
        if([tag.tagPoints count] >= 3){
            [tag upDateLocation];
        }
    }
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n--Touch ended:");
    for (UITouch *touch in touches) {
        TUIC_2DView *tag = (TUIC_2DView*)CFDictionaryGetValue(tagMap, touch);
        if (tag == nil)
            continue;
        for(int i=0;i<[tag.tagPoints count];i++){
            TUIC_2DTagPoint *tagPoint = [tag.tagPoints objectAtIndex:i];
            if(tagPoint.touchObject==touch)
                [tag.tagPoints removeObject:tagPoint];
        }
        
        if([tag.tagPoints count]==0){
            [TUIC2DtagArray removeObject:tag];
        } else {
            [tag upDateLocation];
        }
        
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"\n--Touch cancelled:");
    [self touchesEnded:touches withEvent:event];
}

-(void)clearAll 
{
    [TUIC2DtagArray removeAllObjects];
}

@end
