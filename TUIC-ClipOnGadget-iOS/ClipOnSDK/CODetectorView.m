//
//  CODetectorView.m
//  ClipOnSDK
//
//  Created by sodas on 2011/1/23.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "CODetectorView.h"
#import "COObject.h"
#import "COConstants.h"

//\cond
@interface CODetectorView (Private)
- (BOOL)point:(CGPoint)targetPoint isInCOObject:(COObject *)aCoObject;
- (int)indexOfPoint:(CGPoint)targetPoint inCOObject:(COObject *)aCOObject;
- (void)finishCalibration;
@end
//\noncond

@implementation CODetectorView

@synthesize coObjects;
@synthesize delegate;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	if (self = [super init]) {
		coObjects = [[NSMutableArray alloc] initWithObjects:nil];
		CGRect mainScreenRect = [[UIScreen mainScreen] applicationFrame];
		self.frame = CGRectMake(0, 0, mainScreenRect.size.width, mainScreenRect.size.height);
		isInCalibrationMode = NO;
		
		// Generate a overlay view in screen center
		calibrateDialog = [[UIView alloc] initWithFrame:
						   CGRectMake((self.frame.size.width-kCalibrationDialogWidth)/2, (self.frame.size.height-kCalibrationDialogHeight)/2, kCalibrationDialogWidth, kCalibrationDialogHeight)];
		calibrateDialog.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
		calibrateDialog.layer.cornerRadius = 10.0;
		calibrateDialog.layer.masksToBounds = YES;
		[self addSubview:calibrateDialog];
		calibrateDialog.hidden = YES;
	}
	return self;
}

#pragma mark -
#pragma mark Method

- (void)addCOObject:(COObject *)aCOObject {
	if (![coObjects containsObject:aCOObject]) {
		[coObjects addObject:aCOObject];
		[aCOObject attachToCODetectorView:self];
	}
}

- (void)removeCOObject:(COObject *)aCOObject {
	if ([coObjects containsObject:aCOObject]) {
		[coObjects removeObject:aCOObject];
		[aCOObject detachToCODetectorView:self];
	}
}

#pragma mark -
#pragma mark Util

- (BOOL)point:(CGPoint)targetPoint isInCOObject:(COObject *)aCoObject {
	CGFloat relativeX = targetPoint.x - aCoObject.activeRect.origin.x;
	CGFloat relativeY = targetPoint.y - aCoObject.activeRect.origin.y;
	return ((relativeX > 0 && relativeX < aCoObject.activeRect.size.width) &&
			(relativeY > 0 && relativeY < aCoObject.activeRect.size.height));
}

- (int)indexOfPoint:(CGPoint)targetPoint inCOObject:(COObject *)aCOObject {
	CGFloat relativePoint;
	if (aCOObject.activeRect.size.width > aCOObject.activeRect.size.height)
		relativePoint = targetPoint.x - aCOObject.activeRect.origin.x;
	else
		relativePoint = targetPoint.y - aCOObject.activeRect.origin.y;
	
	CGFloat pointDistance = 0;
	for (int i=0; i<[aCOObject.pointsArray count]-1; i++) {
		pointDistance += [(NSNumber *)[aCOObject.pointsArray objectAtIndex:i] floatValue];
		if (fabs((pointDistance - relativePoint)) < kObjectPointRange)
			return i;
	}
	return -1;
}

#pragma mark -
#pragma mark Calibration

- (void)startCalibrationModeForCOObject:(COObject *)aCOObject {
	if (!isInCalibrationMode) {
		if ((![coObjects containsObject:aCOObject])||(aCOObject.objectType!=COObjectTypeDynamic))
			return;
		
		calibratingObject = aCOObject;
		// Set Flag
		isInCalibrationMode = YES;
		// Hint UI
		calibrateDialog.hidden = NO;
		if (calibratingObject.calibrationHints!=nil) {
            UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, (calibrateDialog.frame.size.height-kCalibrationHintHeight)/2,
                                                                      calibrateDialog.frame.size.width, kCalibrationHintHeight)];
            hint.text = [calibratingObject.calibrationHints objectAtIndex:0];
            hint.backgroundColor = [UIColor clearColor];
            hint.textAlignment = UITextAlignmentCenter;
            hint.font = [hint.font fontWithSize:30];
			[calibrateDialog addSubview:hint];
			[hint release];
		}
		// Memory
		[calibratingObject retain];
	}
}

- (void)finishCalibrationMode {
	if (isInCalibrationMode) {
		// Set Flag
		isInCalibrationMode = NO;
		// Clean UI
		calibrateDialog.hidden = YES;
		for (UIView *item in calibrateDialog.subviews)
			[item removeFromSuperview];
		// Call Delegate
		if ([delegate respondsToSelector:@selector(coDetecorView:didFinishCalibratingCOObject:)])
			[delegate coDetecorView:self didFinishCalibratingCOObject:calibratingObject];
		// Release
		[calibratingObject release];
		calibratingObject = nil;
	}
}

#pragma mark -
#pragma mark Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// Useless, ignored.
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// We should ignore move event.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// Get the tocuh point
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	
	// Calc the position
	if ((fabs(touchPoint.y-self.frame.origin.y)<kDetectEdgeWidth || fabs(touchPoint.y-self.frame.size.height)<kDetectEdgeWidth) ||
		(fabs(touchPoint.x-self.frame.origin.x)<kDetectEdgeWidth || fabs(touchPoint.x-self.frame.size.width)<kDetectEdgeWidth)) {
		// Touch is in the active rect
		if (isInCalibrationMode) {
			// Find new COObject
			// Get Object size
			CGFloat coObjectSize = 0;
			for (NSNumber *item in calibratingObject.pointsArray)
				coObjectSize += [item floatValue];
			CGFloat coObjectOffset = 0;
			// This should be first button
			// Find Point Position
			if (fabs(touchPoint.y-self.frame.origin.y)<kDetectEdgeWidth) {
				// Upper
				coObjectOffset = touchPoint.x - [(NSNumber *)[calibratingObject.pointsArray objectAtIndex:0] floatValue];
				calibratingObject.activeRect = CGRectMake(coObjectOffset, 0, coObjectSize, kDetectEdgeWidth);
			} else if (fabs(touchPoint.y-self.frame.size.height)<kDetectEdgeWidth) {
				// Bottom
				coObjectOffset = touchPoint.x - [(NSNumber *)[calibratingObject.pointsArray objectAtIndex:0] floatValue];
				calibratingObject.activeRect = CGRectMake(coObjectOffset, self.frame.size.height-kDetectEdgeWidth, coObjectSize, kDetectEdgeWidth);
			} else if (fabs(touchPoint.x-self.frame.origin.x)<kDetectEdgeWidth) {
				// Left
				coObjectOffset = touchPoint.y - [(NSNumber *)[calibratingObject.pointsArray objectAtIndex:0] floatValue];
				calibratingObject.activeRect = CGRectMake(0, coObjectOffset, kDetectEdgeWidth, coObjectSize);
			} else if (fabs(touchPoint.x-self.frame.size.width)<kDetectEdgeWidth) {
				// Right
				coObjectOffset = touchPoint.y - [(NSNumber *)[calibratingObject.pointsArray objectAtIndex:0] floatValue];
				calibratingObject.activeRect = CGRectMake(self.frame.size.width-kDetectEdgeWidth, coObjectOffset, kDetectEdgeWidth, coObjectSize);
			}
			[self finishCalibrationMode];
		} else {
			// Whose touch point?
			for (COObject *item in coObjects) {
				if ([self point:touchPoint isInCOObject:item]) {
					int pointIndex = [self indexOfPoint:touchPoint inCOObject:item];
					if (pointIndex > -1 && pointIndex < [item.pointsArray count])
						if ([item.delegate respondsToSelector:@selector(coObject:didPressButtonAtIndex:)])
							[item.delegate coObject:item didPressButtonAtIndex:pointIndex];
					// Found COObject, bye.
					break;
				}
			}
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	// Touch is inperutted. Just ignore.
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[super dealloc];
	[coObjects release];
	[calibrateDialog release];
	self.delegate = nil;
}

@end
