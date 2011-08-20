//
//  myMathFormulaUtil.m
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#define RAD_DEG         (180/3.1415926)

#import "myMathFormulaUtil.h"

@implementation myMathFormulaUtil
+(CGPoint)calculateCenterWithC1:(CGPoint)point1 andC2:(CGPoint)point2
{
    CGFloat x = (point2.x + point1.x)/2;
    CGFloat y = (point2.y + point1.y)/2;
    return CGPointMake(x, y);
}


+(CGFloat)calculatePtDistance:(CGPoint)point1 andPoint2:(CGPoint)point2
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrtf(dx*dx + dy*dy);
}

+(float)calculateDirecionAngle:(float)adjacent andOpposite:(float)opposite
{
	
	if(adjacent == 0) {
		return opposite < 0 ? 270 : 90 ;
	}
    
	if(opposite == 0) {
		return adjacent < 0 ? 180 : 0 ;
	}
    
	if(opposite > 0){
		if (adjacent > 0) 
			return ( atanf(opposite/adjacent)*RAD_DEG );
	    else 
			return (180 - atanf(opposite / (-adjacent))*RAD_DEG);
	} else {
		if (adjacent > 0)
			return (360 - atanf( (-opposite)/adjacent)*RAD_DEG); 
		else 
			return (180 + atanf((-opposite)/(-adjacent))*RAD_DEG);
	}
	
	return -1.0;
}
@end
