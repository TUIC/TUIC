//
//  TUIC_Object.h
//  TUIC-2D-iOS
//
//  Created by Xman on 11/8/15.
//  Copyright 2011年 MHCI Lab. All rights reserved.
//

@protocol TUIC_ObjectDelegate <NSObject>

@optional
- (void) TUIC_ObjectdidUpdate;

@end

@interface TUIC_Object : NSObject{
    int tagID;
    float orientationAngle;
    CGPoint location;
    
    id<TUIC_ObjectDelegate> delegate;
    
    @private
    NSMutableArray* touchPoints;
}
@property (assign) CGPoint location;
@property (assign) int tagID;
@property (assign) float orientationAngle;
@property (nonatomic, retain) NSMutableArray* touchPoints;
- (void)updateObject;
@end


