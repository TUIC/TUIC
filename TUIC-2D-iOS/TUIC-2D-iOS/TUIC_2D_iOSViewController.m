//
//  TUIC_2D_iOSViewController.m
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "TUIC_2D_iOSViewController.h"

@implementation TUIC_2D_iOSViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.view = [[TUIC_2DTrackingView alloc] init];
	[self.view setNeedsDisplay];
}


@end
