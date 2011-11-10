//
//  COABObject.h
//  ClipOnSDK
//
//  Created by sodas on 2011/1/26.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COConstants.h"
#import "COObject.h"
@class COABObject;

/**
 * COABObjectDelegate will send button event message.
 */
@protocol COABObjectDelegate <NSObject, COObjectDelegate>
@optional
/**
 * Dispatch Press event
 * @param coABObject - The COABObject to be pressed
 * @param type - The button pressed on COABObject
 */
- (void)coABObject:(COABObject *)coABObject didPressButton:(COABButtonType)type;
@end

/**
 * COABObject is an Object that should play with "AB" buttons widget. 
 */
@interface COABObject : COObject <COABObjectDelegate> {
	/// Delegate of COABObject
	id<COABObjectDelegate> abDelegate;
}

@property (nonatomic, retain) id<COABObjectDelegate> abDelegate;

/**
 * Initialize a static COABObject
 *
 * You can reference COObject for detail about position/offset.
 * @param position - The position of screen edge this COObject want to attach.
 * @param offeset - The offeset from position origin
 * @returns a COABObject intance
 */
- (id)initStaticObjectWithPosition:(COObjectPosition)position originOffeset:(CGFloat)offeset;

/**
 * Initialize a dynamic COABObject
 *
 * @returns a COABObject intance
 */
- (id)initDynamicObject;

@end
