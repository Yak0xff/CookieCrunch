//
//  RWTMyScene.h
//  CookieCrunch
//

//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class RWTLevel;
@class RWTSwap;

@interface RWTMyScene : SKScene

@property (nonatomic, strong) RWTLevel *level;
@property (nonatomic, copy) void (^swipeHandler)(RWTSwap *swap);

- (void) addSpritesForCookies:(NSSet *)cookies;

- (void) addTiles;

- (void) animationSwap:(RWTSwap *)swap completion:(dispatch_block_t)completion;

- (void) animationInvalidSwap:(RWTSwap *)swap completion:(dispatch_block_t)completion;

- (void) animateMatchedCookies:(NSSet *)chains completion:(dispatch_block_t)completion;

- (void) animateFallingCookies:(NSArray *)columns completion:(dispatch_block_t)completion;

- (void) animateNewCookies:(NSArray *)columns completion:(dispatch_block_t)completion;

@end
