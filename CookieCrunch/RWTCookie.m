//
//  RWTCookie.m
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import "RWTCookie.h"

@implementation RWTCookie

- (NSString *) spriteName {
    static NSString *const spriteNames[] = {
        @"Croissant",
        @"Cupcake",
        @"Danish",
        @"Donut",
        @"Macaroon",
        @"SugarCookie",
    };
    
    return spriteNames[self.cookieType - 1];
}

- (NSString *) highlightSpriteName {
    static NSString * const highlightSpriteNames[] = {
        @"Croissant-Highlighted",
        @"Cupcake-Highlighted",
        @"Danish-Highlighted",
        @"Donut-Highlighted",
        @"Macaroon-Highlighted",
        @"SugarCookie-Highlighted",
    };
    return highlightSpriteNames[self.cookieType - 1];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"type:%ld square:(%ld,%ld)",(long)self.cookieType,(long)self.column,(long)self.row];
}

@end
