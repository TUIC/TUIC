//
//  CODirectionObject.h
//  ClipOnSDK
//
//  Created by sodas on 2011/1/25.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "COObject.h"
#import "COConstants.h"
@class CODirectionObject;

/**
 * CODirectionObjectDelegate will send button event message.
 */
@protocol CODirectionObjectDelegate <NSObject, COObjectDelegate>
@optional
/**
 * Dispatch Press event
 * @param coDirectionObject - The CODirectionObject to be pressed
 * @param type - The button pressed on CODirectionObject
 */
- (void)coDirectionObject:(CODirectionObject *)coDirectionObject didPressButton:(CODirectionButtonType)type;
@end


/**
 * CODirectionObject is an Object that should play with "+" 4 directions widget. 
 */
@interface CODirectionObject : COObject <COObjectDelegate> {
	/// Delegate of CODirectionObject
	id<CODirectionObjectDelegate> directionDelegate;
}

@property (nonatomic, retain) id<CODirectionObjectDelegate> directionDelegate;

/**
 * Initialize a static CODirectionObject
 *
 * You can reference COObject for detail about position/offset.
 * @param position - The position of screen edge this COObject want to attach.
 * @param offeset - The offeset from position origin
 * @returns a CODirectionObject intance
 */
- (id)initStaticObjectWithPosition:(COObjectPosition)position originOffeset:(CGFloat)offeset;

/**
 * Initialize a dynamic CODirectionObject
 *
 * @returns a CODirectionObject intance
 */
- (id)initDynamicObject;

@end
