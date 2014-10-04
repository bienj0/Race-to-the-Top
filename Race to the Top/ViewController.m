//
//  ViewController.m
//  Race to the Top
//
//  Created by Robin van 't Slot on 01-10-14.
//  Copyright (c) 2014 BrickInc. All rights reserved.
//

#import "ViewController.h"
#import "RTPathView.h"
#import "RTMountainPath.h"

#define RTMAP_STARTING_SCORE 15000
#define RTMAP_SCORE_DECREMENT_AMOUNT 100
#define RTTIMER_INTERVAL 0.1
#define RTWALL_PENALTY 500

@interface ViewController ()

@property (strong, nonatomic) IBOutlet RTPathView *pathView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapRecognizer.numberOfTapsRequired = 2;
    [self.pathView addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.pathView addGestureRecognizer:panRecognizer];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Scorelabel %i:", RTMAP_STARTING_SCORE];
    
    
}

-(void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    CGPoint fingerLocation = [panRecognizer locationInView:self.pathView];
    if (panRecognizer.state == UIGestureRecognizerStateBegan && fingerLocation.y < 750){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:RTTIMER_INTERVAL target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Scorelabel %i:", RTMAP_STARTING_SCORE];
    }
    else if (panRecognizer.state == UIGestureRecognizerStateChanged){
        for (UIBezierPath *path in [RTMountainPath mountainPathsForRect:self.pathView.bounds]){
            UIBezierPath *tapTarget = [RTMountainPath tapTargetForPath:path];
            if ([tapTarget containsPoint:fingerLocation]){
                [self decrementScoreByAmount:RTWALL_PENALTY];
        }
      }
    }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded && fingerLocation.y <= 175){
        [self.timer invalidate];
        self.timer = nil;
        
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure to start at the bottom" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

-(void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    NSLog(@"tap!");
    CGPoint tapLocation = [tapRecognizer locationInView:self.pathView];
    NSLog(@"taplocation is at (%f, %f)", tapLocation.x, tapLocation.y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timerFired
{
    [self decrementScoreByAmount:RTMAP_SCORE_DECREMENT_AMOUNT];
}

-(void)decrementScoreByAmount:(int)amount
{
    NSString *scoreText = [[self.scoreLabel.text componentsSeparatedByString:@" "]lastObject];
    int score = [scoreText intValue];
    score = score - amount;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score %i:", score];
}

@end
