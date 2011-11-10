// Use For Doxygen
/** @file **/

/**
 * COObjectType
 *
 * COObject has 2 types: static and dynamic.
 * Static one means this object had an active rect while initializing.<br>
 * And a dynamic one meas that the active rect of one object is determined by CODetector.
 */
typedef enum {
	/**
	 * Static COObject.
	 * This type of COObject should be bind to CODetectorView with active rect.
	 */
	COObjectTypeStatic,
	/**
	 * Dynamic COObject.
	 * This type of COObject should be bind to CODetectorView without active rect.
	 */
	COObjectTypeDynamic,
} COObjectType;

/**
 * COObjectPosition
 *
 * Static COObject should attach to screen edge in different position
 * The following position is relative to the "Home Button" of iPad.
 */
typedef enum {
	COObjectPositionTop,
	COObjectPositionRight,
	COObjectPositionLeft,
	COObjectPositionBottom
} COObjectPosition;

/**
 * CODirectionButtonType
 *
 * Buttons on CODirectionObject
 */
typedef enum {
	CODirectionButtonUp,
	CODirectionButtonRight,
	CODirectionButtonLeft,
	CODirectionButtonBottom
} CODirectionButtonType;

/**
 * COABButtonType
 *
 * Buttons on COABObject
 */
typedef enum {
	COABButtonA,
	COABButtonB
} COABButtonType;