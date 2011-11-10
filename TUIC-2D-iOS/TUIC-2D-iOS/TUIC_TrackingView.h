//
//  TUIC_TrackingView.h
//  TUIC-2D-iOS
//
//  Created by Xman on 11/11/2.
//  Copyright (c) 2011年 MHCI_Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIC_Object.h"

@interface TUIC_TrackingView : UIView{
    NSMutableSet* unknownTouches;
    NSMutableSet* checkedTouches;
    NSMutableArray* TUIC_Objects;
    id<TUIC_ObjectDelegate> delegate;
}
@property(nonatomic, retain)id<TUIC_ObjectDelegate> delegate;

@end
