//
//  TUIC_2D_iOSViewController.m
//  TUIC-2D-iOS
//
//  Created by Daniel Tsai on 11/8/14.
//  Copyright 2011 NTU Mobile HCI Lab. All rights reserved.
//

#import "TUIC_2D_iOSViewController.h"
#import "TUIC_TrackingView.h"
#import "TouchImageView.h"
#import "TUIC_2D_Constant.h"

CGPoint lastObjectLocation;
CGFloat lastObjectOrientation;
NSMutableDictionary* imageDictionary;
int state;

#define IMAGE_WIDTH_LARGE 640
#define IMAGE_WIDTH 100.0
#define IMAGE_SPACE (kTUICObjectSize-30)

@implementation TUIC_2D_iOSViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)loadView{
    imageDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    TUIC_TrackingView* trackView = [[TUIC_TrackingView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    trackView.delegate = self;
    trackView.tag = 99999; //Don't be the same as TUIC tag ID.
    self.view = trackView;
    [trackView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [imageDictionary release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - 
#pragma TUIC_ObjectDelegate
- (void)TUIC_ObjectdidRecognized:(id)sender{
    TUIC_Object* object = (TUIC_Object*)sender;
    lastObjectLocation = CGPointMake(object.location.x+3, object.location.y+19); //Unknown initial offset
    lastObjectOrientation = object.orientationAngle;
    NSLog(@"Add object %d",object.tagID);
    switch (object.tagID) {
        case 0:
        {
            UIImage* image0 = [UIImage imageNamed:@"Picasso-1907.jpg"];
            UIImage* image1 = [UIImage imageNamed:@"Picasso-1912.jpg"];
            UIImage* image2 = [UIImage imageNamed:@"Picasso-1921.jpg"];
            UIImage* image3 = [UIImage imageNamed:@"Picasso-1931.jpg"];
            UIImage* image4 = [UIImage imageNamed:@"Picasso-1937.jpg"];
            
            CGRect imageRect = CGRectMake(0.0, 0.0, IMAGE_WIDTH, 0.0);
            imageRect.size.height = IMAGE_WIDTH * image0.size.height / image0.size.width;
            
            UIImageView* imageView0 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView3 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView4 = [[UIImageView alloc] initWithFrame:imageRect];
            
            imageView0.image = image0;
            imageView1.image = image1;
            imageView2.image = image2;
            imageView3.image = image3;
            imageView4.image = image4;
            
            imageView0.tag = object.tagID;
            imageView1.tag = object.tagID;
            imageView2.tag = object.tagID;
            imageView3.tag = object.tagID;
            imageView4.tag = object.tagID;
            
            imageView0.center = CGPointMake(object.location.x, object.location.y);
            imageView1.center = CGPointMake(object.location.x, object.location.y);
            imageView2.center = CGPointMake(object.location.x, object.location.y);
            imageView3.center = CGPointMake(object.location.x, object.location.y);
            imageView4.center = CGPointMake(object.location.x, object.location.y);
            
            imageView0.alpha = 0;
            imageView1.alpha = 0;
            imageView2.alpha = 0;
            imageView3.alpha = 0;
            imageView4.alpha = 0;
            
            imageView0.transform = CGAffineTransformMakeRotation(M_PI_2);
            imageView1.transform = CGAffineTransformMakeRotation(M_PI_2-72*M_PI/180);
            imageView2.transform = CGAffineTransformMakeRotation(M_PI_2+72*M_PI/180);
            imageView3.transform = CGAffineTransformMakeRotation(M_PI_2-144*M_PI/180);
            imageView4.transform = CGAffineTransformMakeRotation(M_PI_2+144*M_PI/180);
            
            [self.view addSubview:imageView0];
            [self.view addSubview:imageView1];
            [self.view addSubview:imageView2];
            [self.view addSubview:imageView3];
            [self.view addSubview:imageView4];
            
            [UIView beginAnimations:@"animate" context:NULL];
            [UIView setAnimationDuration:0.3];
            imageView0.center = CGPointMake(object.location.x, object.location.y-IMAGE_SPACE);
            imageView1.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2-72*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2-72*M_PI/180));
            imageView2.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2+72*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2+72*M_PI/180));
            imageView3.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2-144*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2-144*M_PI/180));
            imageView4.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2+144*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2+144*M_PI/180));
            
            imageView0.alpha = 1;
            imageView1.alpha = 1;
            imageView2.alpha = 1;
            imageView3.alpha = 1;
            imageView4.alpha = 1;
            [UIView commitAnimations];
            
            [imageView0 release];
            [imageView1 release];
            [imageView2 release];
            [imageView3 release];
            [imageView4 release];
            
            UIImage* image;
            if (object.orientationAngle >54 && object.orientationAngle<126) {
                image = [UIImage imageNamed:@"1907-LesDemoisellesdAvignon.jpg"];
                state = 0;
            }
            else if(object.orientationAngle>126 && object.orientationAngle<198){
                image = [UIImage imageNamed:@"1912-StillLifewithChairCaning.jpg"];
                state = 1;
            }
            else if(object.orientationAngle>198 && object.orientationAngle<270){
                image = [UIImage imageNamed:@"1937-Guernica.jpg"];
                state = 2;
            }
            else if(object.orientationAngle>270 && object.orientationAngle<342){
                image = [UIImage imageNamed:@"1931-WomanWithYellowHair.jpg"];
                state = 3;
            }
            else{
                image = [UIImage imageNamed:@"1921-ThreeMusicians.jpg"];
                state = 4;
            }
            imageRect = CGRectMake(0.0, 0.0, IMAGE_WIDTH_LARGE, 0.0);
            imageRect.size.height = IMAGE_WIDTH_LARGE * image.size.height / image.size.width;
            TouchImageView *touchImageView = [[TouchImageView alloc] initWithFrame:imageRect];
            touchImageView.image = image;
            touchImageView.tag = 99999;
            touchImageView.alpha = 0;
            [self.view addSubview:touchImageView];
            [UIView beginAnimations:@"animate" context:NULL];
            [UIView setAnimationDuration:0.3];
            touchImageView.alpha = 1;
            [UIView commitAnimations];
            [imageDictionary setObject:touchImageView forKey:[NSNumber numberWithInt:object.tagID]];
            [touchImageView release];
        }
            break;
        case 8:
        {
            UIImage* image0 = [UIImage imageNamed:@"Vangogh-1882.jpg"];
            UIImage* image1 = [UIImage imageNamed:@"Vangogh-1887.jpg"];
            UIImage* image2 = [UIImage imageNamed:@"Vangogh-1888.jpg"];
            UIImage* image3 = [UIImage imageNamed:@"Vangogh-1889.jpg"];
            UIImage* image4 = [UIImage imageNamed:@"Vangogh-1890.jpg"];
            
            CGRect imageRect = CGRectMake(0.0, 0.0, IMAGE_WIDTH, 0.0);
            imageRect.size.height = IMAGE_WIDTH * image0.size.height / image0.size.width;
            
            UIImageView* imageView0 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView3 = [[UIImageView alloc] initWithFrame:imageRect];
            UIImageView* imageView4 = [[UIImageView alloc] initWithFrame:imageRect];
            
            imageView0.image = image0;
            imageView1.image = image1;
            imageView2.image = image2;
            imageView3.image = image3;
            imageView4.image = image4;
            
            imageView0.tag = object.tagID;
            imageView1.tag = object.tagID;
            imageView2.tag = object.tagID;
            imageView3.tag = object.tagID;
            imageView4.tag = object.tagID;
            
            imageView0.center = CGPointMake(object.location.x, object.location.y);
            imageView1.center = CGPointMake(object.location.x, object.location.y);
            imageView2.center = CGPointMake(object.location.x, object.location.y);
            imageView3.center = CGPointMake(object.location.x, object.location.y);
            imageView4.center = CGPointMake(object.location.x, object.location.y);
            
            imageView0.alpha = 0;
            imageView1.alpha = 0;
            imageView2.alpha = 0;
            imageView3.alpha = 0;
            imageView4.alpha = 0;
            
            imageView0.transform = CGAffineTransformMakeRotation(M_PI_2);
            imageView1.transform = CGAffineTransformMakeRotation(M_PI_2-72*M_PI/180);
            imageView2.transform = CGAffineTransformMakeRotation(M_PI_2+72*M_PI/180);
            imageView3.transform = CGAffineTransformMakeRotation(M_PI_2-144*M_PI/180);
            imageView4.transform = CGAffineTransformMakeRotation(M_PI_2+144*M_PI/180);
            
            [self.view addSubview:imageView0];
            [self.view addSubview:imageView1];
            [self.view addSubview:imageView2];
            [self.view addSubview:imageView3];
            [self.view addSubview:imageView4];
            
            [UIView beginAnimations:@"animate" context:NULL];
            [UIView setAnimationDuration:0.3];
            imageView0.center = CGPointMake(object.location.x, object.location.y-IMAGE_SPACE);
            imageView1.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2-72*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2-72*M_PI/180));
            imageView2.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2+72*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2+72*M_PI/180));
            imageView3.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2-144*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2-144*M_PI/180));
            imageView4.center = CGPointMake(object.location.x-IMAGE_SPACE*cos(M_PI_2+144*M_PI/180), object.location.y-IMAGE_SPACE*sin(M_PI_2+144*M_PI/180));
            
            imageView0.alpha = 1;
            imageView1.alpha = 1;
            imageView2.alpha = 1;
            imageView3.alpha = 1;
            imageView4.alpha = 1;
            
            [UIView commitAnimations];
            
            [imageView0 release];
            [imageView1 release];
            [imageView2 release];
            [imageView3 release];
            [imageView4 release];
            
            UIImage* image;
            if (object.orientationAngle >54 && object.orientationAngle<126) {
                image = [UIImage imageNamed:@"1882-ViewOfTheHagueWithTheNewChurch.jpg"];
                state = 0;
            }
            else if(object.orientationAngle>126 && object.orientationAngle<198){
                image = [UIImage imageNamed:@"1887-APairofShoes.jpg"];
                state = 1;
            }
            else if(object.orientationAngle>198 && object.orientationAngle<270){
                image = [UIImage imageNamed:@"1890-PeasantWoman.jpg"];
                state =2;
            }
            else if(object.orientationAngle>270 && object.orientationAngle<342){
                image = [UIImage imageNamed:@"1889-selfPortrait.jpg"];
                state =3;
            }
            else{
                image = [UIImage imageNamed:@"1888-SunFlower.jpg"];
                state =4;
            }
            imageRect = CGRectMake(0.0, 0.0, IMAGE_WIDTH_LARGE, 0.0);
            imageRect.size.height = IMAGE_WIDTH_LARGE * image.size.height / image.size.width;
            TouchImageView *touchImageView = [[TouchImageView alloc] initWithFrame:imageRect];
            touchImageView.image = image;
            touchImageView.tag = 99999;
            touchImageView.alpha = 0;
            [self.view addSubview:touchImageView];
            [UIView beginAnimations:@"animate" context:NULL];
            [UIView setAnimationDuration:0.3];
            touchImageView.alpha = 1;
            [UIView commitAnimations];
            [imageDictionary setObject:touchImageView forKey:[NSNumber numberWithInt:object.tagID]];
            [touchImageView release];
        }
            break;
        default:
            break;
    }
}
- (void)TUIC_ObjectdidUpdate:(id)sender{
    TUIC_Object* object = (TUIC_Object*)sender;
    UIImage* image;
    int currentState;
    //Update Image
    switch (object.tagID) {
        case 8:
        {
            if (object.orientationAngle >54 && object.orientationAngle<126) {
                image = [UIImage imageNamed:@"1882-ViewOfTheHagueWithTheNewChurch.jpg"];
                currentState = 0;
            }
            else if(object.orientationAngle>126 && object.orientationAngle<198){
                image = [UIImage imageNamed:@"1887-APairofShoes.jpg"];
                currentState = 1;
            }
            else if(object.orientationAngle>198 && object.orientationAngle<270){
                image = [UIImage imageNamed:@"1890-PeasantWoman.jpg"];
                currentState = 2;
            }
            else if(object.orientationAngle>270 && object.orientationAngle<342){
                image = [UIImage imageNamed:@"1889-selfPortrait.jpg"];
                currentState = 3;
            }
            else{
                image = [UIImage imageNamed:@"1888-SunFlower.jpg"];
                currentState = 4;
            }
        }
            break;
        case 0:
        {
            if (object.orientationAngle >54 && object.orientationAngle<126) {
                image = [UIImage imageNamed:@"1907-LesDemoisellesdAvignon.jpg"];
                currentState = 0;
            }
            else if(object.orientationAngle>126 && object.orientationAngle<198){
                image = [UIImage imageNamed:@"1912-StillLifewithChairCaning.jpg"];
                currentState = 1;
            }
            else if(object.orientationAngle>198 && object.orientationAngle<270){
                image = [UIImage imageNamed:@"1937-Guernica.jpg"];
                currentState = 2;
            }
            else if(object.orientationAngle>270 && object.orientationAngle<342){
                image = [UIImage imageNamed:@"1931-WomanWithYellowHair.jpg"];
                currentState = 3;
            }
            else{
                image = [UIImage imageNamed:@"1921-ThreeMusicians.jpg"];
                currentState = 4;
            }
        }
        default:
            break;
    }
    if (currentState != state) {
        TouchImageView* imageView = [imageDictionary objectForKey:[NSNumber numberWithInt:object.tagID]];
        [UIView beginAnimations:@"animate" context:NULL];
        [UIView setAnimationDuration:0.3];
        imageView.alpha = 0;
        [UIView commitAnimations];
        [imageView removeFromSuperview];
        
        CGRect imageRect = CGRectMake(0.0, 0.0, IMAGE_WIDTH_LARGE, 0.0);
        imageRect.size.height = IMAGE_WIDTH_LARGE * image.size.height / image.size.width;
        TouchImageView *touchImageView = [[TouchImageView alloc] initWithFrame:imageRect];
        touchImageView.image = image;
        touchImageView.tag = 99999;
        touchImageView.alpha = 0;
        [self.view addSubview:touchImageView];
        [UIView beginAnimations:@"animate" context:NULL];
        [UIView setAnimationDuration:0.3];
        touchImageView.alpha = 1;
        [UIView commitAnimations];
        [imageDictionary setObject:touchImageView forKey:[NSNumber numberWithInt:object.tagID]];
        [touchImageView release];
        
        state = currentState;
    }
    
    //Update menu position
    CGFloat tx = object.location.x-lastObjectLocation.x;
    CGFloat ty = object.location.y-lastObjectLocation.y;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(tx, ty);
    
    for (UIView* subView in self.view.subviews) {
        if (subView.tag == object.tagID) {
            [self.view bringSubviewToFront:subView];
            subView.transform = CGAffineTransformConcat(subView.transform, transform);
        }
    }
    lastObjectLocation = object.location;
    lastObjectOrientation = object.orientationAngle;
}
- (void)TUIC_ObjectWillRemove:(id)sender{
    TUIC_Object* object = (TUIC_Object*)sender;
    TouchImageView* imageView = [imageDictionary objectForKey:[NSNumber numberWithInt:object.tagID]];
    [imageView removeFromSuperview];
    [imageDictionary removeObjectForKey:[NSNumber numberWithInt:object.tagID]];
    NSLog(@"Will remove object %d",object.tagID);
    for (UIView* subView in self.view.subviews) {
        if (subView.tag == object.tagID) {
            [subView removeFromSuperview];
        }
    }
}
@end
