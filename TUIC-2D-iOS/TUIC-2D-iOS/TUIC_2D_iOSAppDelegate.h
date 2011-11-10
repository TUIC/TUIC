//
//  TUIC_2D_iOSAppDelegate.h
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIC_2D_Window.h"
#import "TUIC_2D_iOSViewController.h"

@interface TUIC_2D_iOSAppDelegate : NSObject <UIApplicationDelegate>{
    TUIC_2D_iOSViewController *_viewController;

}
@property (nonatomic, retain)UIWindow* window;

@end
