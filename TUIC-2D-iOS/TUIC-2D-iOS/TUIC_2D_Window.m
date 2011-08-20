//
//  TUIC_2D_Window.m
//  TUIC-2D-iOS
//
//  Created by  on 11/8/15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TUIC_2D_Window.h"
#import "TUIC_Object.h"
#import "myMathFormulaUtil.h"

#define kTouchDelayTimer 0.3

#define kTUICObjectSize 200.0
#define kTUICObjectTolerance 9

#define kGridSize 10000

#define B0 1
#define B1 2
#define B2 4
#define B3 8
#define B4 16
#define B5 32
#define B6 64
#define B7 128
#define B8 256

@implementation TUIC_2D_Window

@synthesize checkedTouchSet;
@synthesize unknownTouchSet;
@synthesize TUICObjects;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)becomeKeyWindow{
    unknownTouchSet = [[NSMutableSet alloc] initWithCapacity:10];
    checkedTouchSet = [[NSMutableSet alloc] initWithCapacity:10];
    TUICObjects = [[NSMutableArray alloc] initWithCapacity:3];
    [NSTimer scheduledTimerWithTimeInterval:kTouchDelayTimer target:self selector:@selector(recognizeTouch) userInfo:nil repeats:YES];
    [super becomeKeyWindow];
}

- (void)sendEvent:(UIEvent *)event{
    for (UITouch* touch in [event allTouches]) {
        if ([checkedTouchSet containsObject:touch])
            continue;
        
        BOOL touchInObject = NO;
        int index;
        for (index=0 ; index< [TUICObjects count]; index++) {
            TUIC_Object* tag = [TUICObjects objectAtIndex:index];
            if ([tag.touchPoints indexOfObject:touch] != NSNotFound) {
                touchInObject = YES;
                break;
            }
        }
        if (touchInObject) {
            TUIC_Object* tag = [TUICObjects objectAtIndex:index];
            if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
                if ([tag.touchPoints indexOfObject:touch]<3) {
                    [TUICObjects removeObject:tag];
                }
        }
        else{
            if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled)
                [unknownTouchSet removeObject:touch];
            else
                [unknownTouchSet addObject:touch];
        }

    }
    //[super sendEvent:event];
}

- (void)recognizeTouch{
    if ([unknownTouchSet count]<3) {
        return;
    }
    
    //NSArray* V = [[NSArray alloc] initWithArray:[unknownTouchSet allObjects]];
    //NSMutableArray* convexHull = [self simpleHull_2DwithV:V andN:[V count]];
    //[convexHull removeObjectAtIndex:[convexHull count]-1];
    
    int matchDistance=0;
    NSMutableArray* registPoint = [[NSMutableArray alloc] initWithCapacity:4];
    //Finding regist points
    for (UITouch* touch1 in unknownTouchSet) {
        NSLog(@"-----------");
        for (UITouch* touch2 in unknownTouchSet) {
            if (touch1 != touch2) {
                CGPoint P0 = [touch1 locationInView:self.rootViewController.view];
                CGPoint P1 = [touch2 locationInView:self.rootViewController.view];
                CGFloat distance = [myMathFormulaUtil calculatePtDistance:P0 andPoint2:P1];
                NSLog(@"distance: %f",distance);
                if (distance<=kTUICObjectSize+kTUICObjectTolerance &&
                    distance>=kTUICObjectSize-kTUICObjectTolerance) {
                    matchDistance++;
                    [registPoint addObject:touch2];
                }
            }
        }
        //Two corners were finded
        if (matchDistance == 2){
            CGPoint C0 = [ touch1 locationInView:self.rootViewController.view];
            CGPoint C1 = [[registPoint objectAtIndex:0] locationInView:self.rootViewController.view];
            CGPoint C2 = [[registPoint objectAtIndex:1] locationInView:self.rootViewController.view];
            CGFloat distance = [myMathFormulaUtil calculatePtDistance:C1 andPoint2:C2];
            //Only right triangle would be recognize
            if (distance<=kTUICObjectSize*sqrt(2.0)+kTUICObjectTolerance &&
                distance>=kTUICObjectSize*sqrt(2.0)-kTUICObjectTolerance) {
                
                TUIC_Object* newTag = [[TUIC_Object alloc] init];
                newTag.location = [myMathFormulaUtil calculateCenterWithC1:C1 andC2:C2];
                newTag.tagID = 0;
                [newTag.touchPoints addObject:touch1];
                //Sort by clockwise direction
                if ([self isLeftwithP0:C0 andP1:C1 andP2:C2]<0) {
                    [newTag.touchPoints addObject:[registPoint objectAtIndex:1]];
                    [newTag.touchPoints addObject:[registPoint objectAtIndex:0]];
                }
                else{
                    [newTag.touchPoints addObject:[registPoint objectAtIndex:0]];
                    [newTag.touchPoints addObject:[registPoint objectAtIndex:1]];
                }
                [TUICObjects addObject:newTag];
                NSLog(@"New Object Found!");
            }
            else
                NSLog(@"C1, C2 not found");
        }
        else
            NSLog(@"Not Corner");
        //Reset for next point
        [registPoint removeAllObjects];
        matchDistance = 0;
    }
    
    for (TUIC_Object* tag in TUICObjects) {
        for (UITouch* touch in tag.touchPoints) {
            [unknownTouchSet removeObject:touch];
        }
    }
    
    
    [checkedTouchSet addObjectsFromArray:[unknownTouchSet allObjects]];    
    //Find payLoad points
    for (TUIC_Object* tag in TUICObjects) {
        for (UITouch* touch in unknownTouchSet) {
            CGPoint C0 = [[tag.touchPoints objectAtIndex:0] locationInView:self.rootViewController.view];
            CGPoint C1 = [[tag.touchPoints objectAtIndex:1] locationInView:self.rootViewController.view];
            CGPoint C2 = [[tag.touchPoints objectAtIndex:2] locationInView:self.rootViewController.view];
            CGPoint P = [touch locationInView:self.rootViewController.view];
            CGFloat distance = [myMathFormulaUtil calculatePtDistance:C0 andPoint2:P];
            
            if (distance<=kTUICObjectSize*sqrt(2.0)+kTUICObjectTolerance) {
                if ([self isLeftwithP0:C0 andP1:C1 andP2:P]>0 && [self isLeftwithP0:C0 andP1:C2 andP2:P]<0) {
                    int product1 = roundf([self isLeftwithP0:C0 andP1:C1 andP2:P]/kGridSize);
                    int product2 = -roundf([self isLeftwithP0:C0 andP1:C2 andP2:P]/kGridSize);
                    NSLog(@"product1: %d, product2: %d",product1,product2);
                    switch (product1) {
                        case 1:
                            switch (product2) {
                                case 1:
                                    tag.tagID |= B0;
                                    break;
                                case 2:
                                    tag.tagID |= B1;
                                    break;
                                case 3:
                                    tag.tagID |= B2;
                                    break;
                                default:
                                    break;
                            }
                            break;
                        case 2:
                            switch (product2) {
                                case 1:
                                    tag.tagID |= B3;
                                    break;
                                case 2:
                                    tag.tagID |= B4;
                                    break;
                                case 3:
                                    tag.tagID |= B5;
                                    break;
                                default:
                                    break;
                            }
                            break;
                        case 3:
                            switch (product2) {
                                case 1:
                                    tag.tagID |= B6;
                                    break;
                                case 2:
                                    tag.tagID |= B7;
                                    break;
                                case 3:
                                    tag.tagID |= B8;
                                    break;
                                default:
                                    break;
                            }
                            break;
                        default:
                            break;
                    }
                    
                    NSLog(@"c0c1: %f, c0c2:%f",[self isLeftwithP0:C0 andP1:C1 andP2:P],[self isLeftwithP0:C0 andP1:C2 andP2:P]);
                    [tag.touchPoints addObject:touch];
                    [checkedTouchSet removeObject:touch];
                }
            }
        }
        NSLog(@"tagID: %d", tag.tagID);
    }
    [unknownTouchSet removeAllObjects];
    
    [registPoint release];
    
    //[V release];
}

// isLeft(): test if a point is Left|On|Right of an infinite line.
//    Input:  three points P0, P1, and P2
//    Return: <0 for P2 left of the line through P0 and P1
//            =0 for P2 on the line
//            >0 for P2 right of the line
//    See: the January 2001 Algorithm on Area of Triangles
- (CGFloat) isLeftwithP0:(CGPoint) P0 andP1:(CGPoint)P1 andP2:(CGPoint) P2
{
    return (P1.x - P0.x)*(P2.y - P0.y) - (P2.x - P0.x)*(P1.y - P0.y);
}

// simpleHull_2D():
//    Input:  V[] = polyline array of 2D vertex points 
//            n   = the number of points in V[]
//    Output: H[] = output convex hull array of vertices (max is n)
//    Return: h   = the number of points in H[]
- (NSMutableArray*)simpleHull_2DwithV:(NSArray*)V andN:(NSInteger)n
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
    
    CGPoint P0 = [[V objectAtIndex:0] locationInView:self.rootViewController.view];
    CGPoint P1 = [[V objectAtIndex:1] locationInView:self.rootViewController.view];
    CGPoint P2 = [[V objectAtIndex:2] locationInView:self.rootViewController.view];
    
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
        CGPoint D_bot = [[D objectAtIndex:bot] locationInView:self.rootViewController.view];
        CGPoint D_bot_1 = [[D objectAtIndex:bot+1] locationInView:self.rootViewController.view];
        CGPoint V_i = [[V objectAtIndex:i] locationInView:self.rootViewController.view];
        CGPoint D_top_1 = [[D objectAtIndex:top-1] locationInView:self.rootViewController.view];
        CGPoint D_top = [[D objectAtIndex:top] locationInView:self.rootViewController.view];
        
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
            D_bot = [[D objectAtIndex:bot] locationInView:self.rootViewController.view];
            D_bot_1 = [[D objectAtIndex:bot+1] locationInView:self.rootViewController.view];
        }
        //while (isLeft(D[bot], D[bot+1], V[i]) <= 0)
        //    ++bot;                // remove bot of deque
        [D replaceObjectAtIndex:--bot withObject:[V objectAtIndex:i]];
        //D[--bot] = V[i];          // insert V[i] at bot of deque
        
        while ([self isLeftwithP0:D_top_1 andP1:D_top andP2:V_i]>=0) {
            --top;
            D_top_1 = [[D objectAtIndex:top-1] locationInView:self.rootViewController.view];
            D_top = [[D objectAtIndex:top] locationInView:self.rootViewController.view];
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


- (void)dealloc {
    [checkedTouchSet release];    
    [unknownTouchSet release];
    [TUICObjects release];
    [super dealloc];
}

@end
