//
//  myMathFormulaUtil.h
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

@interface myMathFormulaUtil:NSObject
+ (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint;


+(CGPoint)calculateCenterWithC1:(CGPoint)point1 andC2:(CGPoint)point2;
+(CGFloat)calculatePtDistance:(CGPoint)point1 andPoint2:(CGPoint)point2;
+(float)calculateDirecionAngle:(float)adjacent andOpposite:(float)opposite;

+ (CGFloat) isLeftwithP0:(CGPoint) P0 andP1:(CGPoint)P1 andP2:(CGPoint) P2;
+ (NSMutableArray*)simpleHull_2DwithV:(NSArray*)V andN:(NSInteger)n;

@end
