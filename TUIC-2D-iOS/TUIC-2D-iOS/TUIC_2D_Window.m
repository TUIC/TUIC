//
//  TUIC_2D_Window.m
//  TUIC-2D-iOS
//
//  Created by Xman on 11/8/15.
//  Copyright 2011年 MHCI Lab All rights reserved.
//

#import "TUIC_2D_Window.h"
#import "TUIC_Object.h"
#import "myMathFormulaUtil.h"

#define kTouchDelayTimer 0.5

#define kTUICObjectSize 200.0
#define kTUICObjectTolerance 20

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

- (void)becomeKeyWindow{
    //Initialization.
    unknownTouchSet = [[NSMutableSet alloc] initWithCapacity:10];
    checkedTouchSet = [[NSMutableSet alloc] initWithCapacity:10];
    TUICObjects = [[NSMutableArray alloc] initWithCapacity:3];
    //Recognize touches by polling.
    [NSTimer scheduledTimerWithTimeInterval:kTouchDelayTimer target:self selector:@selector(recognizeTouch) userInfo:nil repeats:YES];
    
    [super becomeKeyWindow];
}

- (void)sendEvent:(UIEvent *)event{
    //Classify touches into different set.
    for (UITouch* touch in [event allTouches]) {
        //Skip if checked. 
        if ([checkedTouchSet containsObject:touch])
            continue;
        
        BOOL touchFromObject = NO;
        //Check if touch from an object
        TUIC_Object* object;
        for (object in TUICObjects){
            if ([object.touchPoints indexOfObject:touch]!=NSNotFound) {
                touchFromObject = YES;
                break;
            }
        }
        
        if (touchFromObject) {
            if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled){
                if ([object.touchPoints indexOfObject:touch]<3) {
                    //Delete the object which register point have been removed.
                    [TUICObjects removeObject:object];
                }
                else{
                    [object.touchPoints removeObject:touch];
                }
            }
        }
        else{
            if (touch.phase == UITouchPhaseEnded || touch.phase == UITouchPhaseCancelled){
                //touch may be unknown or checked.
                [unknownTouchSet removeObject:touch];
                [checkedTouchSet removeObject:touch];
            }
            else{
                [unknownTouchSet addObject:touch];
            }
        }

    }
    //[super sendEvent:event];
}

- (void)recognizeTouch{
    //Return if less than 3 touch points. 
    if ([unknownTouchSet count]<3) {
        return;
    }
    
    int numMatchDistance=0;
    NSMutableArray* registPoint = [[NSMutableArray alloc] initWithCapacity:3];
    
    //Find regist points by comparing distances between each others.
    for (UITouch* touch1 in unknownTouchSet) {
        //NSLog(@"-----------touch location: %f,%f",[touch1 locationInView:nil].x,[touch1 locationInView:nil].y);
        CGFloat distances[12];
        CGPoint P0 = [touch1 locationInView:nil];
        for (UITouch* touch2 in unknownTouchSet) {
            if (touch1 != touch2) {
                CGPoint P1 = [touch2 locationInView:nil];
                CGFloat distance = [myMathFormulaUtil calculatePtDistance:P0 andPoint2:P1];
                //NSLog(@"distance: %f",distance);
                
                //Add as register point, if match the given size. 
                if (distance<=kTUICObjectSize+kTUICObjectTolerance &&
                    distance>=kTUICObjectSize-kTUICObjectTolerance) {
                    distances[numMatchDistance] = distance;
                    numMatchDistance++;
                    [registPoint addObject:touch2];
                    //NSLog(@"insert index: %d",[registPoint indexOfObject:touch2]);
                }
            }
        }
        
        //When it comes the corner- only the corner point would match twice
        //check if it match TUIC form.
        if (numMatchDistance >= 2){
            CGPoint C1,C2;
            CGFloat distance;
            BOOL find = NO;
            int i,j;
            
            //Check the other two register points distance.
            for (i =0 ; i<[registPoint count]-1; i++) {
                for (j=i+1; j<[registPoint count]; j++) {
                    C1 = [[registPoint objectAtIndex:i] locationInView:nil];
                    C2 = [[registPoint objectAtIndex:j] locationInView:nil];
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
                    [newTag.touchPoints addObject:touch1];
                    //Sort by clockwise direction
                    if ([self isLeftwithP0:P0 andP1:C1 andP2:C2]<0) {
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:j]];
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:i]];
                    }
                    else{
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:i]];
                        [newTag.touchPoints addObject:[registPoint objectAtIndex:j]];
                    }
                    [TUICObjects addObject:newTag];
                    //NSLog(@"New Object Found!");
                    break;
                }
            }
        }
        //Reset for next iteration
        [registPoint removeAllObjects];
        numMatchDistance = 0;
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
            CGPoint C0 = [[tag.touchPoints objectAtIndex:0] locationInView:nil];
            CGPoint C1 = [[tag.touchPoints objectAtIndex:1] locationInView:nil];
            CGPoint C2 = [[tag.touchPoints objectAtIndex:2] locationInView:nil];
            CGPoint P = [touch locationInView:nil];
            CGFloat distance = [myMathFormulaUtil calculatePtDistance:C0 andPoint2:P];
            
            if (distance<=kTUICObjectSize*sqrt(2.0)+kTUICObjectTolerance) {
                if ([self isLeftwithP0:C0 andP1:C1 andP2:P]>0 && [self isLeftwithP0:C0 andP1:C2 andP2:P]<0) {
                    int product1 = roundf([self isLeftwithP0:C0 andP1:C1 andP2:P]/kGridSize);
                    int product2 = -roundf([self isLeftwithP0:C0 andP1:C2 andP2:P]/kGridSize);
                    //NSLog(@"product1: %d, product2: %d",product1,product2);
                    
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
                    
                    //NSLog(@"c0c1: %f, c0c2:%f",[self isLeftwithP0:C0 andP1:C1 andP2:P],[self isLeftwithP0:C0 andP1:C2 andP2:P]);
                    [tag.touchPoints addObject:touch];
                    [checkedTouchSet removeObject:touch];
                }
            }
        }
        //NSLog(@"tagID: %d", tag.tagID);
    }
    [unknownTouchSet removeAllObjects];
    
    [registPoint release];
}

- (void)dealloc {
    [checkedTouchSet release];    
    [unknownTouchSet release];
    [TUICObjects release];
    [super dealloc];
}

@end
