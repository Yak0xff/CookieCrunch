//
//  RWTLevel.h
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTCookie.h"
#import "RWTTile.h"
#import "RWTSwap.h"
#import "RWTChain.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface RWTLevel : NSObject


- (instancetype) initWithFile:(NSString *)fileName;

- (RWTTile *) tileAtColumn:(NSInteger)column row:(NSInteger)row;

- (NSSet *) shuffle;

- (RWTCookie *) cookieAtColumn:(NSInteger)column row:(NSInteger)row;

- (void) performSwap:(RWTSwap *)swap;

- (BOOL) isPossibleSwap:(RWTSwap *)swap;

- (NSSet *) removeMatches;

- (NSArray *) fillHoles;

- (NSArray *) topUpCookies;

- (void) detectPossibleSwaps;

@end
