//
//  TUIC_2DTagPoint.h
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TUIC_2DTagPoint : NSObject {
    CGFloat    locationInView_X;
    CGFloat    locationInView_Y;
    NSString   *type;
    int        serialNumber;
}

@property (assign) CGFloat locationInView_X;
@property (assign) CGFloat locationInView_Y;
@property (nonatomic, retain) NSString *type;
@property (assign) int serialNumber;

@end
