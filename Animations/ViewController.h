//
//  ViewController.h
//  Animations
//
//  Created by Andy Wu on 12/19/16.
//  Copyright © 2016 Andy Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreText;


@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;

@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGFloat screenWidth;

@property (nonatomic, retain) UIView *ballView;
@property (nonatomic, retain) UIView *paddleView;

@property (nonatomic, retain) UIView *blockView1;
@property (nonatomic, retain) UIView *blockView2;
@property (nonatomic, retain) UIView *blockView3;

@property (nonatomic, retain) UIPushBehavior *pusher;

@property int score;

@property (weak, nonatomic) IBOutlet UIButton *startProp;
- (IBAction)startBtn:(id)sender;


@end

