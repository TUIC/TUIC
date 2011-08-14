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
    NSMutableArray *tagPoints;
    
    // UI element
    UILabel *tagInfolabel;
    

}

@property (nonatomic, retain) NSMutableArray *tagPoints;

-(void)decodeTag;

@end
