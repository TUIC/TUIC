//
//  TUIC_2D_Window.h
//  TUIC-2D-iOS
//
//  Created by Xman on 11/8/15.
//  Copyright 2011年 MHCI Lab. All rights reserved.
//


@interface TUIC_2D_Window : UIWindow{
    NSMutableSet* unknownTouchSet;
    NSMutableSet* checkedTouchSet;
    NSMutableArray* TUICObjects;
}

@property (nonatomic, retain) NSMutableSet* unknownTouchSet;
@property (nonatomic, retain) NSMutableSet* checkedTouchSet;
@property (nonatomic, retain) NSMutableArray* TUICObjects;

- (void) recognizeTouch;

@end
