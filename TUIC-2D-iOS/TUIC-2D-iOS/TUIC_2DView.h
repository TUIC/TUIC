//
//  TUIC_2DView.h
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "myMathFormulaUtil.h"
#import "TUIC_2DTagPoint.h"

@interface TUIC_2DView : UIView {
    int tagID;
    float orientationAngle;
    CGPoint location;
    CGSize  size;
    NSMutableArray *tagPoints;
    NSMutableArray *cornerPoints;
    NSMutableArray *payloadPoints;
    
    // UI element
    UILabel *tagInfolabel;
    

}

@property (nonatomic, retain) NSMutableArray *tagPoints;
@property (nonatomic, retain) NSArray *cornerPoints;
@property (nonatomic, retain) NSArray *payloadPoints;
@property (assign) CGPoint location;
@property (assign) CGSize  size;

-(void)decodeTag;
-(void)upDateLocation;
-(void)tagUnknownPoints;
@end
