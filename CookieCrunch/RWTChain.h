//
//  RWTChain.h
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWTCookie;

typedef NS_ENUM(NSUInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
};

@interface RWTChain : NSObject

@property (nonatomic, strong, readonly) NSArray *cookies;

@property (nonatomic, assign) ChainType chainType;

- (void) addCookie:(RWTCookie *)cookie;

@end
