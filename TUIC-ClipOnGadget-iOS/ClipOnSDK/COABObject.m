//
//  COABObject.m
//  ClipOnSDK
//
//  Created by sodas on 2011/1/26.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "COABObject.h"

#define kCOABPoint1 1.0f
#define kCOABPoint2 3.0f
#define kCOABPoint3 0.9f

@implementation COABObject

@synthesize abDelegate;

#pragma mark -
#pragma mark Lifecycle

- (id)initStaticObjectWithPosition:(COObjectPosition)position originOffeset:(CGFloat)offeset {
	NSArray *points = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:kCOABPoint1],
					   [NSNumber numberWithFloat:kCOABPoint2], [NSNumber numberWithFloat:kCOABPoint3], nil];
	if (self = [super initStaticObjectWithPosition:position originOffeset:offeset andActivePoint:points]) {
		self.delegate = self;
	}
	[points release];
	return self;
}

- (id)initDynamicObject {
	NSArray *points = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:kCOABPoint1],
					   [NSNumber numberWithFloat:kCOABPoint2], [NSNumber numberWithFloat:kCOABPoint3], nil];
	NSArray *hints = [[NSArray alloc] initWithObjects:@"Please press A button", nil];
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
	COABButtonType type;
	if (index==0) type = COABButtonA;
	else if (index==1) type = COABButtonB;
	
	if ([abDelegate respondsToSelector:@selector(coABObject:didPressButton:)])
		[abDelegate coABObject:self didPressButton:type];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
	[super dealloc];
	self.abDelegate = nil;
}

@end
