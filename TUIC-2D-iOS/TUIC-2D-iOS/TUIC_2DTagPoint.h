//
//  TUIC_2DTagPoint.h
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    TUIC_2DTagTypeCorner  = 0,
    TUIC_2DTagTypePayload = 1,
    TUIC_2DTagTypeUnknown = 2,
} TUIC_2DTagType;


@interface TUIC_2DTagPoint : NSObject {
    UITouch    *touchObject;
    CGFloat    locationInView_X;
    CGFloat    locationInView_Y;
    TUIC_2DTagType  type;
    int        serialNumber;
}
@property (nonatomic, retain) UITouch *touchObject;
@property (assign) CGFloat locationInView_X;
@property (assign) CGFloat locationInView_Y;
@property (assign) TUIC_2DTagType type;
@property (assign) int serialNumber;

@end
