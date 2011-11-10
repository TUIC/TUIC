//
//  CODirectionObject.m
//  ClipOnSDK
//
//  Created by sodas on 2011/1/25.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "CODirectionObject.h"

#define kCODirectionPoint1 0.9f
#define kCODirectionPoint2 2.2f
#define kCODirectionPoint3 2.1f
#define kCODirectionPoint4 1.8f
#define kCODirectionPoint5 1.2f



@implementation CODirectionObject

@synthesize directionDelegate;

#pragma mark -
#pragma mark Lifecycle

- (id)initStaticObjectWithPosition:(COObjectPosition)position originOffeset:(CGFloat)offeset {
	NSArray *points = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:kCODirectionPoint1],
														[NSNumber numberWithFloat:kCODirectionPoint2],
														[NSNumber numberWithFloat:kCODirectionPoint3],
		 											    [NSNumber numberWithFloat:kCODirectionPoint4],
													    [NSNumber numberWithFloat:kCODirectionPoint5], nil];
	if (self = [super initStaticObjectWithPosition:position originOffeset:offeset andActivePoint:points]) {
		self.delegate = self;
	}
	[points release];
	return self;
}

- (id)initDynamicObject {
	NSArray *points = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:kCODirectionPoint1],
					   [NSNumber numberWithFloat:kCODirectionPoint2],
					   [NSNumber numberWithFloat:kCODirectionPoint3],
					   [NSNumber numberWithFloat:kCODirectionPoint4],
					   [NSNumber numberWithFloat:kCODirectionPoint5], nil];
	NSArray *hints = [[NSArray alloc] initWithObjects:@"Please press ↑ button", nil];
	if (self = [super initDynamicObjectWithActivePoint:points andCalibrationHints:hints]) {
		self.delegate = self;
	}
	[points release];
	[hints release];
	return self;
}

#pragma mark -
#pragma mark COObjectDelegate

- (void)coObject:(COObject *)aCOObject didPressButtonAtIndex:(NSUInteger)index {
	CODirectionButtonType type;
	if (index==0) type = CODirectionButtonUp;
	else if (index==1) type = CODirectionButtonRight;
	else if (index==2) type = CODirectionButtonLeft;
	else if (index==3) type = CODirectionButtonBottom;
	if ([directionDelegate respondsToSelector:@selector(coDirectionObject:didPressButton:)])
		[directionDelegate coDirectionObject:self didPressButton:type];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[super dealloc];
	self.directionDelegate = nil;
}

@end
