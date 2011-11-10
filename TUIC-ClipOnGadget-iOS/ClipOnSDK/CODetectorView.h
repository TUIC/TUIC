//
//  CODetectorView.h
//  ClipOnSDK
//
//  Created by sodas on 2011/1/23.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

// iPad resolution = 132dpi.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class COObject;
@class CODetectorView;

/// The detection band width (size) of CODetectorView
#define kDetectEdgeWidth (2.1/2.54) * 132
/// If 2 points is closed enough (distance < this range), we'll say they are the same point.
#define kObjectPointRange (0.68/2.54)*132
/// The width of calibration dialog
#define kCalibrationDialogWidth 500
/// The height of calibration dialog
#define kCalibrationDialogHeight 340
/// The height of calibration hint
#define kCalibrationHintHeight 80

/**
 * CODetectorViewDelegate will send message when finishing a calibrating
 */
@protocol CODetectorViewDelegate <NSObject>
@optional
/**
 * CODetecorView finished a calibration of a COObject.
 * @param coDetectorView - This CODetecorView. Or the message sender.
 * @param aCOObject - The COObject which is just finished its calibration.
 */
- (void)coDetecorView:(CODetectorView *)coDetectorView didFinishCalibratingCOObject:(COObject *)aCOObject;

@end

/**
 * CODetectorView is used to detect COObject.
 *
 * CODetectorView could bind lots of COObject.<br>
 * And after received touch event, it will dispatch touch event
 * to corresponding COObject.
 *
 * CODetecorView will fit to the size of main screen.
 */
@interface CODetectorView : UIView {
	/**
	 * This NSMutableArray contains all COObjects which are bound to this CODetectorView.<br>
	 * If this NSMutableArray is empty, it means there's no COObject bound to this CODetectorView
	 */
	NSMutableArray *coObjects;
	/**
	 * A Flag used to check is CODetetorView in calibration mode or not.
	 */
	BOOL isInCalibrationMode;
	/**
	 * A dialog which will show while calibrating
	 */
	UIView *calibrateDialog;
	/**
	 * The COObject which is in calibrate mode
	 */
	COObject *calibratingObject;
	/**
	 * delegate
	 */
	id<CODetectorViewDelegate> delegate;
}

@property (readonly, nonatomic, retain) NSMutableArray *coObjects;
@property (retain, nonatomic) id<CODetectorViewDelegate> delegate;

/**
 * Add a COObject into this CODetectorView, and start to listen to it.
 * @param aCOObject - The COObject you want to add in.
 */
- (void)addCOObject:(COObject *)aCOObject;

/**
 * Remove a COObject from this CODetectorView, and stop to listen to it.
 * @param aCOObject - The COObject you want to remove.
 */
- (void)removeCOObject:(COObject *)aCOObject;

/**
 * Calibration a COObject
 * Note that this COObject must be a Dynamic one and has already been added to this CODetectorView.<br>
 *
 * @param aCOObject - the COObject you want to calibration
 */
- (void)startCalibrationModeForCOObject:(COObject *)aCOObject;

@end
