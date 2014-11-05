//
//  RWTCookie.h
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

static const NSUInteger NumCookieType = 6;

@interface RWTCookie : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSUInteger cookieType;
@property (nonatomic, strong) SKSpriteNode *sprite;

- (NSString *) spriteName;

- (NSString *) highlightSpriteName;


@end
