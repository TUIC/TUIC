//
//  TUIC_TrackingView.m
//  TUIC-2D-iOS
//
//  Created by Xman on 11/11/2.
//  Copyright (c) 2011年 MHCI Lab. All rights reserved.
//

#import "TUIC_TrackingView.h"
#import "TUIC_Object.h"

#import "TUIC_2D_Constant.h"
#import "myMathFormulaUtil.h"

@implementation TUIC_TrackingView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame] == nil) {
        return nil;
    }
    unknownTouches = [[NSMutableSet alloc] initWithCapacity:0];
    checkedTouches = [[NSMutableSet alloc] initWithCapacity:0];
    TUIC_Objects = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    [NSTimer scheduledTimerWithTimeInterval:kTouchDelayTimer 
                                     target:self 
                                   selector:@selector(recognizeTouch) 
                                   userInfo:nil 
                                    repeats:YES];
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [unknownTouches unionSet:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch* touch in touches) {
        TUIC_Object* object;
        for (object in TUIC_Objects){
            if ([object.touchPoints indexOfObject:touch]!=NSNotFound) {
                break;
            }
        }
        [object updateObject];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //Classify touches into different set.
    for (UITouch* touch in touches) {        
        BOOL touchFromObject = NO;
        TUIC_Object* object;
        for (object in TUIC_Objects){
            if ([object.touchPoints indexOfObject:touch]!=NSNotFound) {
                touchFromObject = YES;
                break;
            }
        }
        if (touchFromObject) {
            if ([object.touchPoints indexOfObject:touch]<3) {
                //Delete the object which register point have been removed.
                [delegate TUIC_ObjectWillRemove:object];
                [TUIC_Objects removeObject:object];
            }
            else{
                [object.touchPoints removeObject:touch];
            }
        }
        else{
            //touch may be unknown or checked.
            [unknownTouches removeObject:touch];
            [checkedTouches removeObject:touch];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)dealloc{
    [unknownTouches release];
    [checkedTouches release];
    [TUIC_Objects release];
    [delegate release];
    [super dealloc];
}

- (void)recognizeTouch{
    //Return if less than 3 touch points. 
    if ([unknownTouches count]<3) {
        return;
    }
    
    int numMatchDistance=0;
    NSMutableArray* registPoint = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* objects = [[NSMutableArray alloc] initWithCapacity:0];
    
    //Find regist points by comparing distances between each others.
    for (UITouch* touch1 in unknownTouches) {
        //NSLog(@"-----------touch location: %f,%f",[touch1 locationInView:nil].x,[touch1 locationInView:nil].y);
        CGPoint P0 = [touch1 locationInView:self];
        for (UITouch* touch2 in unknownTouches) {
            if (touch1 != touch2) {
                CGPoint P1 = [touch2 locationInView:self];
                CGFloat distance = [myMathFormulaUtil calculatePtDistance:P0 andPoint2:P1];
                //NSLog(@"distance: %f",distance);
                
                //Add as register point, if match the given size. 
                if (distance<=kTUICObjectSize+kTUICObjectTolerance &&
                    distance>=kTUICObjectSize-kTUICObjectTolerance) {
                    numMatchDistance++;
                    [registPoint addObject:touch2];
                    //NSLog(@"insert index: %d",[registPoint indexOfObject:touch2]);
                }
            }
        }
        //NSLog(@"numMatchDistance:%d",numMatchDistance);
        //When it comes the corner (only the corner point would match twice)
        //check if it match TUIC form.
        if (numMatchDistance >= 2){
            CGPoint C1,C2;
            CGFloat distance;
            BOOL find = NO;
            int i,j;
            
            //Check the other two register points distance.
            for (i =0 ; i<[registPoint count]-1; i++) {
                for (j=i+1; j<[registPoint count]; j++) {
                    C1 = [[registPoint objectAtIndex:i] locationInView:self];
                    C2 = [[registPoint objectAtIndex:j] locationInView:self];
                    distance = [myMathFormulaUtil calculatePtDistance:C1 andPoint2:C2];
                    //NSLog(@"c1c2 distance:%f",distance);
                    
                    if (distance<=(kTUICObjectSize+kTUICObjectTolerance)*sqrt(2.0) &&
                        distance>=(kTUICObjectSize-kTUICObjectTolerance)*sqrt(2.0)){ 
                        find = YES;
                        break;
                    }
                }
                
                if (find) {
                    TUIC_Object* newTag = [[TUIC_Object alloc] init];
                    newTag.tagID = 0;
                    newTag.delegate = self.delegate;
                    [newTag.touchPoints addObject:touch1];
                    
                    //Sort by clockwise direction
                    if ([myMathFormulaUtil isLeftwithP0:P0 andP1:C1 andP2:C2]<0) {
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:j]];
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:i]];
                    }
                    else{
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:i]];
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:j]];
                    }
                    [objects addObject:newTag];
                    newTag.location = [myMathFormulaUtil calculateCenterWithC1:C1 andC2:C2];
                    newTag.orientationAngle = [myMathFormulaUtil pointPairToBearingDegrees:P0 secondPoint:newTag.location];
                    [newTag release];
                    //NSLog(@"New Object Found!");
                    break;
                }
            }
        }
        //Reset for next iteration
        [registPoint removeAllObjects];
        numMatchDistance = 0;
    }
    
    for (TUIC_Object* tag in objects) {
        for (UITouch* touch in tag.touchPoints) {
            [unknownTouches removeObject:touch];
        }
    }
    
    [checkedTouches addObjectsFromArray:[unknownTouches allObjects]]; 
    
    //Find payLoad points
    for (TUIC_Object* tag in objects) {
        for (UITouch* touch in unknownTouches) {
            CGPoint C0 = [[tag.touchPoints objectAtIndex:0] locationInView:self];
            CGPoint C1 = [[tag.touchPoints objectAtIndex:1] locationInView:self];
            CGPoint C2 = [[tag.touchPoints objectAtIndex:2] locationInView:self];
            CGPoint P = [touch locationInView:self];
            CGFloat distance = [myMathFormulaUtil calculatePtDistance:C0 andPoint2:P];
            
            if (distance<=kTUICObjectSize*sqrt(2.0)+kTUICObjectTolerance) {
                if ([myMathFormulaUtil isLeftwithP0:C0 andP1:C1 andP2:P]>0 && [myMathFormulaUtil isLeftwithP0:C0 andP1:C2 andP2:P]<0) {
                    int product1 = kGridRation*roundf([myMathFormulaUtil isLeftwithP0:C0 andP1:C1 andP2:P]/kGridSize);
                    int product2 = kGridRation*(-roundf([myMathFormulaUtil isLeftwithP0:C0 andP1:C2 andP2:P]/kGridSize));
                    NSLog(@"product1: %d, product2: %d",product1,product2);
                    
                    //Set id by payload bit postion.
                    switch (product2) {
                        case 1:
                            switch (product1) {
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
                            switch (product1) {
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
                            switch (product1) {
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
                    NSLog(@"c0c1: %f, c0c2:%f",[myMathFormulaUtil isLeftwithP0:C0 andP1:C1 andP2:P],[myMathFormulaUtil isLeftwithP0:C0 andP1:C2 andP2:P]);
                    [tag.touchPoints addObject:touch];
                    [checkedTouches removeObject:touch];
                }
            }
        }
        NSLog(@"tagID: %d", tag.tagID);
    }
    [unknownTouches removeAllObjects];
    [TUIC_Objects addObjectsFromArray:objects];
    for (TUIC_Object* object in objects) {
        [delegate TUIC_ObjectdidRecognized:object];
    }
    [registPoint release];
    [objects release];
}

@end
