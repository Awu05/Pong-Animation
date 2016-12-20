//
//  ViewController.m
//  Animations
//
//  Created by Andy Wu on 12/19/16.
//  Copyright © 2016 Andy Wu. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Get screen Width and Height
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravityBeahvior = [UIGravityBehavior alloc];
    self.scoreText.text = [NSString stringWithFormat:@"%d", 0];
}


- (void) drawCirc {
    //Draws a circle
    CGRect ballFrame = CGRectMake(self.view.center.x, 150, 30, 30);
    self.ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball"]];
    
    self.ballView.alpha = 1.0f; // This is most advisably 1.0 (always)
    self.ballView.backgroundColor = [UIColor clearColor];
    self.ballView.frame = ballFrame;
    self.ballView.layer.cornerRadius = 30 / 2.0;
    
    [self.view addSubview:self.ballView];
    [self.view bringSubviewToFront:self.ballView];
    
    // Start ball off with a push
    self.pusher = [[UIPushBehavior alloc] initWithItems:@[self.ballView]
                                                   mode:UIPushBehaviorModeInstantaneous];
    self.pusher.pushDirection = CGVectorMake(0.25, 0.6);
    self.pusher.active = YES;
    // Because push is instantaneous, it will only happen once
    [self.animator addBehavior:self.pusher];
    
    
}

- (void)handleDrag:(UIPanGestureRecognizer*)sender {
//    CGFloat yPos = self.paddleView.frame.origin.y;
    CGPoint mousePos = [sender locationInView:sender.view.superview];
    CGPoint barPos = CGPointMake(mousePos.x, self.screenHeight*.825);
    sender.view.center = barPos;
    [self.animator updateItemUsingCurrentState:self.paddleView];
}



- (void) drawPaddle {
    //Draws a rectangle
    self.paddleView  = [[UIView alloc] initWithFrame:CGRectMake(self.screenWidth*.45, self.screenHeight*.80, self.screenWidth*.45, self.screenHeight*.05)];
    self.paddleView.backgroundColor = [UIColor lightGrayColor];
    self.paddleView.accessibilityIdentifier = @"box";
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    [self.paddleView addGestureRecognizer:panGesture];
    self.paddleView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.paddleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initAnimation
{
    
    [self.gravityBeahvior addItem:self.ballView];
    
    [self.animator addBehavior:self.gravityBeahvior];
    
    //Link:https://www.bignerdranch.com/blog/uikit-dynamics-and-ios-7-building-uikit-pong/
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ballView, self.paddleView]];
    
    // Remove rotation
    UIDynamicItemBehavior *ballDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    ballDynamicProperties.allowsRotation = NO;
    // Better collisions, no friction
    ballDynamicProperties.elasticity = 1.0;
    ballDynamicProperties.friction = 0.0;
    ballDynamicProperties.resistance = 0.0;
    [self.animator addBehavior:ballDynamicProperties];

    //Paddle Properties
    UIDynamicItemBehavior *paddleDynamicProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    paddleDynamicProperties.allowsRotation = NO;
    paddleDynamicProperties.density = 1000.0f;
    [self.animator addBehavior:paddleDynamicProperties];
    
    // Creates collision boundaries from the bounds of the dynamic animator's
    // reference view (self.view).
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    collisionBehavior.collisionDelegate = self;
    
    [self.animator addBehavior:collisionBehavior];
    
    self.animator = self.animator;
    
}

- (void) collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    if(self.ballView.frame.origin.y > 600) {
        [self.animator removeAllBehaviors];
        
        [self.gravityBeahvior removeItem:item];
        //self.gravityBeahvior = nil;
        self.startProp.hidden = NO;
    }
    
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 {
    self.score++;
    //Paddle and Ball
    if(item1 == self.ballView && item2 == self.paddleView) {
        self.scoreText.text = [NSString stringWithFormat:@"%d", self.score];
    } else if(item2 == self.ballView && item1 == self.paddleView) {
        self.scoreText.text = [NSString stringWithFormat:@"%d", self.score];
    }
    
}

- (void) startGame {
    
    [self.paddleView removeFromSuperview];
    [self.ballView removeFromSuperview];
    
    [self drawCirc];
    [self drawPaddle];
    
    [self initAnimation];
    
    //Reset Everything
    self.score = 0;

}

- (IBAction)startBtn:(id)sender {
    [self startGame];
    self.startProp.hidden = YES;
}

@end
