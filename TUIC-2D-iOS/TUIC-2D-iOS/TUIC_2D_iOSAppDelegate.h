//
//  TUIC_2D_iOSAppDelegate.h
//  TUIC-2D-iOS
//
//  Created by  on 11/8/14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUIC_2D_iOSViewController;

@interface TUIC_2D_iOSAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet TUIC_2D_iOSViewController *viewController;

@end
