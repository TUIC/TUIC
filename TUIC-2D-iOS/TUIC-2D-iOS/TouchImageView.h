//
//  TouchImageView.h
//  MultiTouchDemo
//
//  Created by Jason Beaver on 5/29/08.
//  Copyright 2008 Apple Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchImageView : UIImageView {
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
}

@end
