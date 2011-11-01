//
//  main.m
//  TUIC-2D-iOS
//
//  Created by  on 11/8/14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIC_2D_iOSAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([TUIC_2D_iOSAppDelegate class]));
    [pool release];
    return retVal;
}
