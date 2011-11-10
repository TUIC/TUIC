//
//  COObject.h
//  ClipOnSDK
//
//  Created by sodas on 2011/1/19.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CODetectorView.h"
#import "COConstants.h"

#define kiPadResolution 132

/**
 * COObjectDelegate will handle button press event on COObject
 */
@protocol COObjectDelegate <NSObject>
@optional
/**
 * While a button is pressed, the index of that button will send to this method.
 * @param aCOObject - COObject that user pressed.
 * @param index - Button index that user pressed.
 */
- (void)coObject:(COObject *)aCOObject didPressButtonAtIndex:(NSUInteger)index;
@end


/**
 * COObject - The Fundation of ClipOn Objects
 *
 * All ClipOn objects are derived from COObject.<br>
 * This is the fundamental of all ClipOn Objects.<br>
 * <br>
 * COObject defines how to response while receiving a touch event from
 * CODetector. It also contains where the active rect is.<br>
 * CODetector will dispatch touch event by checking active rect.
 *
 */

@interface COObject : NSObject {
	/**
	 * COObject could be Static or Dynamic type. This is a readonly property.
	 */
	COObjectType objectType;
	/**
	 * The active rect for COObject.<br>
	 * All touch points in this rect will be dipatch to this COObject.<br>
	 * If the type of this COObject is static, this should be a readonly property.
	 * It's ok to edit an active rect of a dynamic COObject.
	 */
	CGRect activeRect;
	/**
	 * An array which saves relative distance of COObject-Resposible touch points. This is a readonly property.
	 */
	NSArray *pointsArray;
	/**
	 * The CODetectorView this COObject bound to.
	 */
	CODetectorView *objectDetectView;
	/**
	 * A hint of active rect
	 */
	UIView *activeRectView;
	/**
	 * delegate of this COObject
	 */
	id<COObjectDelegate> delegate;
	/**
	 * An integer that you can use to identify COObjects in your application.<br>
	 * The value of tag will be 0 by default.
	 */
	NSInteger tag;
	/**
	 * A NSArray which saves UIImages for callibration hint.
	 */
	NSArray *calibrationHints;
}

@property (retain, nonatomic) NSArray *calibrationHints;
@property (assign, nonatomic) NSInteger tag;
@property (retain, nonatomic) id<COObjectDelegate> delegate;
@property (readonly, nonatomic) COObjectType objectType;
@property (readonly, nonatomic) NSArray *pointsArray;
@property (assign, nonatomic) CGRect activeRect;

/**
 * Init a Static COObject with predefined active rect and points
 *
 * <br><img src="coObjectPoints.png">
 * In above figure, the dark gray rectangle means the active rect, and the light gray circle is active points.<br>
 * So, if you have a ClipOn Widget like above, you also have an active points distance array :
 * <span style="font-style: italic; font-weight: bold;">{1, 1.5, 3, 2, 1.5}(cm)</span><br>
 * Then, just make that array become a NSArray with NSNumber, and pass in to this method as ActivePoints.<br>
 * Finally, the number above the circle is the index which will send to delegate while button is pressed.
 *
 * <br><img src="COObjectPositon.png">
 * The relationship of postion and offeset is shown above.
 *
 * @param position - The position of screen edge this COObject want to attach.
 * @param offeset - The offeset from position origin
 * @param points - Point Distances set of this COObject. This should be a NSArray contains CGFloat.<br>
 *                 The origin of points coordinate is related to the active rect and the length of this object.
 * @returns - A COObject with objectType is COObjectTypeStatic
 */
- (id)initStaticObjectWithPosition:(COObjectPosition)position originOffeset:(CGFloat)offeset andActivePoint:(NSArray *)points;


/**
 * Init a Dynamic COObject with predefined active rect and points. <br>
 * Note that the active rect of a dynamic COObject should not be predefined
 *
 * <br><img src="coObjectPoints.png">
 * In above figure, the dark gray rectangle means the active rect, and the light gray circle is active points.<br>
 * So, if you have a ClipOn Widget like above, you also have an active points distance array :
 * <span style="font-style: italic; font-weight: bold;">{1, 1.5, 3, 2, 1.5}(cm)</span><br>
 * Then, just make that array become a NSArray with NSNumber, and pass in to this method as ActivePoints.<br>
 * Finally, the number above the circle is the index which will send to delegate while button is pressed.
 *
 * @param points - Points set of this COObject. This should be a NSArray contains CGPoints via NSValue.<br>
 *                 The origin of points coordinate is related to the active rect.
 * @param imageSet - While user start to calibrate a COObject, you should ask user to press button in correct order,<br>
 *				   These images are used to be a hint for user.
 *				   <span style="font-weight: bold">In SDK 1.0,</span> CODetectorView will only show 1st image in this NSArray.<br>
 *				   Since you have to define dynamic COObject first, we can use only one button to check which COObject it is.<br>
 *				   <span style="color: #900; font-style: italic;">You should only ask user to press first button while calibrating</span> in SDK 1.0.
 * @returns - A COObject with objectType is COObjectTypeDynamic
 */
- (id)initDynamicObjectWithActivePoint:(NSArray *)points andCalibrationHints:(NSArray *)hints;

/**
 * Attach COObject to a CODetecorView
 * @param aDetector - The CODetector this COObject want to attach.
 */
- (void)attachToCODetectorView:(CODetectorView *)aDetector;

/**
 * Detach COObject from a CODetecorView
 * @param aDetector - The CODetector this COObject want to detach.
 */
- (void)detachToCODetectorView:(CODetectorView *)aDetector;

@end
