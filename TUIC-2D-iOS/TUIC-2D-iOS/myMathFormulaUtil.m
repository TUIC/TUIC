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

+ (CGFloat) pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, -originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

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


// isLeft(): test if a point is Left|On|Right of an infinite line.
//    Input:  three points P0, P1, and P2
//    Return: <0 for P2 left of the line through P0 and P1
//            =0 for P2 on the line
//            >0 for P2 right of the line
//    See: the January 2001 Algorithm on Area of Triangles
+ (CGFloat) isLeftwithP0:(CGPoint) P0 andP1:(CGPoint)P1 andP2:(CGPoint) P2
{
    return (P1.x - P0.x)*(P2.y - P0.y) - (P2.x - P0.x)*(P1.y - P0.y);
}

// simpleHull_2D():
//    Input:  V[] = polyline array of 2D vertex points 
//            n   = the number of points in V[]
//    Output: H[] = output convex hull array of vertices (max is n)
//    Return: h   = the number of points in H[]
+ (NSMutableArray*)simpleHull_2DwithV:(NSArray*)V andN:(NSInteger)n
{
    // initialize a deque D[] from bottom to top so that the
    // 1st three vertices of V[] are a counterclockwise triangle
    NSMutableArray* D = [[NSMutableArray alloc] initWithCapacity:2*n+1];
    for (int i =0; i<2*n+1; i++) {
        [D addObject:@"0"];
    }
    int bot = n-2, top = bot+3;   // initial bottom and top deque indices
    //D[bot] = D[top] = V[2];       // 3rd vertex is at both bot and top
    [D replaceObjectAtIndex:top withObject:[V objectAtIndex:2]];
    [D replaceObjectAtIndex:bot withObject:[D objectAtIndex:top]];
    
    CGPoint P0 = [[V objectAtIndex:0] locationInView:nil];
    CGPoint P1 = [[V objectAtIndex:1] locationInView:nil];
    CGPoint P2 = [[V objectAtIndex:2] locationInView:nil];
    
    if ([self isLeftwithP0:P0 andP1:P1 andP2:P2]<0) {
        [D replaceObjectAtIndex:bot+1 withObject:[V objectAtIndex:0]];
        [D replaceObjectAtIndex:bot+2 withObject:[V objectAtIndex:1]];
    }
    else{
        [D replaceObjectAtIndex:bot+1 withObject:[V objectAtIndex:1]];
        [D replaceObjectAtIndex:bot+2 withObject:[V objectAtIndex:0]];
    }
    /*
     if ([self isLeft(V[0], V[1], V[2])] > 0) {
     D[bot+1] = V[0];
     D[bot+2] = V[1];          // ccw vertices are: 2,0,1,2
     }
     else {
     D[bot+1] = V[1];
     D[bot+2] = V[0];          // ccw vertices are: 2,1,0,2
     }*/
    
    // compute the hull on the deque D[]
    for (int i=3; i < n; i++) {   // process the rest of vertices
        // test if next vertex is inside the deque hull
        CGPoint D_bot = [[D objectAtIndex:bot] locationInView:nil];
        CGPoint D_bot_1 = [[D objectAtIndex:bot+1] locationInView:nil];
        CGPoint V_i = [[V objectAtIndex:i] locationInView:nil];
        CGPoint D_top_1 = [[D objectAtIndex:top-1] locationInView:nil];
        CGPoint D_top = [[D objectAtIndex:top] locationInView:nil];
        
        if ([self isLeftwithP0:D_bot andP1:D_bot_1 andP2:V_i]<0 &&
            [self isLeftwithP0:D_top_1 andP1:D_top andP2:V_i]<0) {
            continue;
        }
        /*
         if ((isLeft(D[bot], D[bot+1], V[i]) > 0) &&
         (isLeft(D[top-1], D[top], V[i]) > 0) )
         continue;         // skip an interior vertex
         */
        // incrementally add an exterior vertex to the deque hull
        // get the rightmost tangent at the deque bot
        while ([self isLeftwithP0:D_bot andP1:D_bot_1 andP2:V_i]>=0) {
            ++bot;
            D_bot = [[D objectAtIndex:bot] locationInView:nil];
            D_bot_1 = [[D objectAtIndex:bot+1] locationInView:nil];
        }
        //while (isLeft(D[bot], D[bot+1], V[i]) <= 0)
        //    ++bot;                // remove bot of deque
        [D replaceObjectAtIndex:--bot withObject:[V objectAtIndex:i]];
        //D[--bot] = V[i];          // insert V[i] at bot of deque
        
        while ([self isLeftwithP0:D_top_1 andP1:D_top andP2:V_i]>=0) {
            --top;
            D_top_1 = [[D objectAtIndex:top-1] locationInView:nil];
            D_top = [[D objectAtIndex:top] locationInView:nil];
        }
        // get the leftmost tangent at the deque top
        // while (isLeft(D[top-1], D[top], V[i]) <= 0)
        //    --top;                // pop top of deque
        [D replaceObjectAtIndex:++top withObject:[V objectAtIndex:i]];
        //D[++top] = V[i];          // push V[i] onto top of deque
    }
    
    // transcribe deque D[] to the output hull array H[]
    NSMutableArray* H = [[NSMutableArray alloc] initWithCapacity:top-bot+1];
    for (int i=0; i<top-bot+1; i++) {
        [H addObject:@"0"];
    }
    int h;
    for (h=0; h <=(top-bot); h++){
        [H replaceObjectAtIndex:h withObject:[D objectAtIndex:bot+h]];
    }
    return H;
}

@end
