//
//  TUIC_2D_Window.h
//  TUIC-2D-iOS
//
//  Created by  on 11/8/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
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

- (NSMutableArray*)simpleHull_2DwithV:(NSArray*)V andN:(NSInteger)n;
- (CGFloat) isLeftwithP0:(CGPoint) P0 andP1:(CGPoint)P1 andP2:(CGPoint) P2;
@end
