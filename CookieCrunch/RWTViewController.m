//
//  RWTViewController.m
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import "RWTViewController.h"
#import "RWTMyScene.h"
#import "RWTLevel.h"

@interface RWTViewController ()

@property (nonatomic, strong) RWTLevel *level;
@property (nonatomic, strong) RWTMyScene *scene;

@end

@implementation RWTViewController

- (void) beginGame {
    [self shuffle];
}

- (void) shuffle {
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    
    SKView *skView = (SKView *)self.view;
    skView.multipleTouchEnabled = NO;
    
    self.scene = [RWTMyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    self.level = [[RWTLevel alloc] initWithFile:@"Level_1"];
    self.scene.level = self.level;
    
    [self.scene addTiles];
    
    
    id block = ^(RWTSwap *swap) {
        self.view.userInteractionEnabled = NO;
        
        if ([self.level isPossibleSwap:swap]) {
            [self.level performSwap:swap];
            [self.scene animationSwap:swap completion:^{
//                self.view.userInteractionEnabled = YES;
                [self handleMatches];
            }];
        } else {
            [self.scene animationInvalidSwap:swap completion:^{
                self.view.userInteractionEnabled = YES;
            }];
        }  
    };
    
    self.scene.swipeHandler = block;
    
    [skView presentScene:self.scene];
    
    [self beginGame];
}


- (void) handleMatches {
    NSSet *chains = [self.level removeMatches];
    
    if ([chains count] == 0) {
        [self beginNextTurn];
        return;
    }
    
    [self.scene animateMatchedCookies:chains completion:^{
        NSArray *columns = [self.level fillHoles];
        [self.scene animateFallingCookies:columns completion:^{
            NSArray *newcolumns = [self.level topUpCookies];
            [self.scene animateNewCookies:newcolumns completion:^{
//                self.view.userInteractionEnabled = YES;
                [self handleMatches];
            }];
        }];
    }];
}

- (void) beginNextTurn {
    [self.level detectPossibleSwaps];
    self.view.userInteractionEnabled = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
