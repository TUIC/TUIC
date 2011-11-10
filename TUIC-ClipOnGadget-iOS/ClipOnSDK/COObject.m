//
//  COObject.m
//  ClipOnSDK
//
//  Created by sodas on 2011/1/19.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "COObject.h"

//\cond
@interface COObject (Private)
- (id)initWithObjectType:(COObjectType)type andPointsArray:(NSArray *)aPointsArray;
@end
//\noncond

@implementation COObject

@synthesize tag;
@synthesize activeRect;
@synthesize objectType;
@synthesize pointsArray;
@synthesize delegate;
@synthesize calibrationHints;

#pragma mark -
#pragma mark Init

- (id)initWithObjectType:(COObjectType)type andPointsArray:(NSArray *)aPointsArray {
	if (self = [super init]) {
		objectType = type;
		NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:[aPointsArray count]];
		// Convert cm -> inch -> pixel
		for (NSNumber *item in aPointsArray) 
			[tmpArray addObject:[NSNumber numberWithFloat:[item floatValue]/2.54*kiPadResolution]];
		pointsArray = [[NSArray alloc] initWithArray:tmpArray];
		[tmpArray release];
		// Active Rect Hint
		activeRectView = [[UIView alloc] initWithFrame:CGRectMake(-10, -10, 1, 1)];
		activeRectView.backgroundColor = [UIColor lightGrayColor];
	}
	return self;
}

- (id)initStaticObjectWithPosition:(COObjectPosition)position originOffeset:(CGFloat)offeset andActivePoint:(NSArray *)points {
	if (self = [self initWithObjectType:COObjectTypeStatic andPointsArray:points]) {
		// Get Object size
		CGFloat coObjectSize = 0;
		for (NSNumber *item in pointsArray)
			coObjectSize += [item floatValue];
		
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		switch (position) {
			case COObjectPositionBottom:
				activeRect = CGRectMake(offeset, screenRect.size.height-kDetectEdgeWidth, coObjectSize, kDetectEdgeWidth);
				break;
			case COObjectPositionTop:
				activeRect = CGRectMake(offeset, 0, coObjectSize, kDetectEdgeWidth);
				break;
			case COObjectPositionLeft:
				activeRect = CGRectMake(0, offeset, kDetectEdgeWidth, coObjectSize);
				break;
			case COObjectPositionRight:
				activeRect = CGRectMake(screenRect.size.width-kDetectEdgeWidth, offeset, kDetectEdgeWidth, coObjectSize);
				break;
			default:
				activeRect = CGRectZero;
				break;
		}
		
		activeRectView = [[UIView alloc] initWithFrame:activeRect];
		activeRectView.backgroundColor = [UIColor lightGrayColor];
		self.calibrationHints = nil;
	}
	return self;
}

- (id)initDynamicObjectWithActivePoint:(NSArray *)points andCalibrationHints:(NSArray *)hints {
	if (self = [self initWithObjectType:COObjectTypeDynamic andPointsArray:points]) {
		activeRect = CGRectZero;
		self.calibrationHints = hints;
	}
	return self;
}

#pragma mark -
#pragma mark Information

- (NSString *)description {
	NSString *coType = nil;
	if (objectType==COObjectTypeStatic) coType=@"Static";
	else if (objectType==COObjectTypeDynamic) coType=@"Dynamic";
	return [NSString stringWithFormat:@"%@, COObjectType=%@, activeRect=(x=%f,y=%f)(w=%f,h=%f), points=%@",
			[super description], coType, activeRect.origin.x, activeRect.origin.y, activeRect.size.width, activeRect.size.height, pointsArray];
}

#pragma mark -
#pragma mark Method

- (void)attachToCODetectorView:(CODetectorView *)aDetector {
	if (![objectDetectView isEqual:aDetector]) {
		[activeRectView removeFromSuperview];
		[objectDetectView release];
		objectDetectView = aDetector;
		[objectDetectView retain];
		[aDetector addSubview:activeRectView];
		[objectDetectView addCOObject:self];
	}
}

- (void)detachToCODetectorView:(CODetectorView *)aDetector {
	if (![objectDetectView isEqual:aDetector]) {
		[activeRectView removeFromSuperview];
		[objectDetectView release];
		objectDetectView = nil;
		[objectDetectView removeCOObject:self];
	}
}

#pragma mark -
#pragma mark Setter/Getter

- (void)setActiveRect:(CGRect)newRect {
	// The active rect of static COObject should be readonly.
	if (objectType==COObjectTypeDynamic) {
		activeRect = newRect;
		activeRectView.frame = activeRect;
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[super dealloc];
	[pointsArray release];
	[objectDetectView release];
	[activeRectView release];
	self.delegate = nil;
	self.calibrationHints = nil;
}

@end
