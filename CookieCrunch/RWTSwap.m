//
//  RWTSwap.m
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import "RWTSwap.h"
#import "RWTCookie.h"

@implementation RWTSwap


- (BOOL) isEqual:(id)object {
    if (![object isKindOfClass:[RWTSwap class]]) {
        return NO;
    }
    
    RWTSwap *other = (RWTSwap *)object;
    return (other.cookieA == self.cookieA && other.cookieB == self.cookieB) || (other.cookieB == self.cookieA && other.cookieA == self.cookieB);
}

- (NSUInteger) hash {
    return [self.cookieA hash] ^ [self.cookieB hash];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@ swap %@ with %@",[super description],self.cookieA,self.cookieB];
}

@end
