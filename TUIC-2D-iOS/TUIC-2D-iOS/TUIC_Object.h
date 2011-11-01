//
//  TUIC_Object.h
//  TUIC-2D-iOS
//
//  Created by Xman on 11/8/15.
//  Copyright 2011年 MHCI Lab. All rights reserved.
//


@interface TUIC_Object : NSObject{
    int tagID;
    float orientationAngle;
    CGPoint location;
    NSMutableArray* touchPoints;
    
}
@property (assign) CGPoint location;
@property (assign) int tagID;
@property (assign) float orientationAngle;
@property (nonatomic, retain) NSMutableArray* touchPoints;

@end
