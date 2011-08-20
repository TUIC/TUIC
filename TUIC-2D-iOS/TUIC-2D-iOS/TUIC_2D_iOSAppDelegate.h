//
//  TUIC_2D_iOSAppDelegate.h
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUIC_2D_iOSViewController;
@class TUIC_2D_Window;

@interface TUIC_2D_iOSAppDelegate : NSObject <UIApplicationDelegate>
{
    TUIC_2D_Window *_window;
    TUIC_2D_iOSViewController *_viewController;

}

@property (nonatomic, retain) IBOutlet TUIC_2D_Window *window;
@property (nonatomic, retain) IBOutlet TUIC_2D_iOSViewController *viewController;

@end
