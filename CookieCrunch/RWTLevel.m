//
//  RWTLevel.m
//  CookieCrunch
//
//  Created by Robin.Chao on 14-6-2.
//  Copyright (c) 2014年 Robin.Chao. All rights reserved.
//

#import "RWTLevel.h" 

@interface RWTLevel ()

@property (nonatomic, strong) NSSet *possibleSwaps;

@end

@implementation RWTLevel{
    RWTCookie *_cookies[NumColumns][NumRows];
    RWTTile *_tiles[NumColumns][NumRows];
}

- (NSSet *) shuffle {
    
    NSSet *set;
    do {
        set = [self creatInitialCookies];
        
        [self detectPossibleSwaps];
        
        NSLog(@"possible swaps : %@",self.possibleSwaps);
    }
    while ([self.possibleSwaps count] == 0);
    
    return set;
}

- (NSSet *) creatInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            
            if (_tiles[column][row] != nil) {
                NSUInteger cookieType = arc4random_uniform(NumCookieType) + 1;
                
                RWTCookie *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
                
                [set addObject:cookie];
            }
        }
    }
    
    return set;
}

- (RWTCookie *)createCookieAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cookieType {
    RWTCookie *cookie = [[RWTCookie alloc] init];
    
    cookie.cookieType = cookieType;
    cookie.column = column;
    cookie.row = row;
    _cookies[column][row] = cookie;
    
    return cookie;
}

- (RWTCookie *) cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Incalid row : %ld", (long)row);
    
    return _cookies[column][row];
}

- (instancetype) initWithFile:(NSString *)fileName {
    self = [super init];
    if (self) {
        NSDictionary *dictionary = [self loadJSON:fileName];
        
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                
                NSInteger tileRow = NumRows - row - 1;
                
                if ([value integerValue] == 1) {
                    _tiles[column][tileRow] = [[RWTTile alloc] init];
                }
            }];
        }];
    }
    return self;
}


- (RWTTile *) tileAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column : %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _tiles[column][row];
}

- (NSDictionary *) loadJSON:(NSString *)filename {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path == nil) {
        NSLog(@"Could not find level file : %@",filename);
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error : %@",path,error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@",filename,error);
        return nil;
    }
    
    return dictionary;
}

- (void) performSwap:(RWTSwap *)swap {
    NSInteger columnA = swap.cookieA.column;
    NSInteger rowA = swap.cookieA.row;
    
    NSInteger columnB = swap.cookieB.column;
    NSInteger rowB = swap.cookieB.row;
    
    _cookies[columnA][rowA] = swap.cookieB;
    swap.cookieB.column = columnA;
    swap.cookieB.row = rowA;
    
    _cookies[columnB][rowB] = swap.cookieA;
    swap.cookieA.column = columnB;
    swap.cookieA.row = rowB;
}

- (BOOL)hasChainAtColumn:(NSInteger)column row:(NSInteger)row {
    NSUInteger cookieType = _cookies[column][row].cookieType;
    
    NSUInteger horzLength = 1;
    for (NSInteger i = column - 1; i >= 0 && _cookies[i][row].cookieType == cookieType; i--, horzLength++) ;
    for (NSInteger i = column + 1; i < NumColumns && _cookies[i][row].cookieType == cookieType; i++, horzLength++) ;
    if (horzLength >= 3) return YES;
    
    NSUInteger vertLength = 1;
    for (NSInteger i = row - 1; i >= 0 && _cookies[column][i].cookieType == cookieType; i--, vertLength++) ;
    for (NSInteger i = row + 1; i < NumRows && _cookies[column][i].cookieType == cookieType; i++, vertLength++) ;
    return (vertLength >= 3);
}

- (void) detectPossibleSwaps {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            
            RWTCookie *cookie = _cookies[column][row];
            if (cookie != nil) {
                if (column < NumColumns - 1) {
                    RWTCookie *other = _cookies[column + 1][row];
                    if (other != nil) {
                        _cookies[column][row] = other;
                        _cookies[column + 1][row] = cookie;
                        
                        if ([self hasChainAtColumn:column + 1 row:row] || [self hasChainAtColumn:column row:row]) {
                            RWTSwap *swap = [[RWTSwap alloc] init];
                            swap.cookieA = cookie;
                            swap.cookieB = other;
                            [set addObject:swap];
                        }
                        
                        _cookies[column][row] = cookie;
                        _cookies[column + 1][row] = other;
                    }
                }
                
                if (row < NumRows - 1) {
                    RWTCookie *other = _cookies[column][row + 1];
                    if (other != nil) {
                        _cookies[column][row] = other;
                        _cookies[column][row + 1] = cookie;
                        
                        if ([self hasChainAtColumn:column row:row + 1] || [self hasChainAtColumn:column row:row]) {
                            RWTSwap *swap = [[RWTSwap alloc] init];
                            swap.cookieA = cookie;
                            swap.cookieB = other;
                            [set addObject:swap];
                        }
                        _cookies[column][row] = cookie;
                        _cookies[column][row + 1] = other;
                    }
                }
            }
        }
    }
    self.possibleSwaps = set;
}

- (BOOL) isPossibleSwap:(RWTSwap *)swap {
    return [self.possibleSwaps containsObject:swap];
}


- (NSSet *) detectHorizontalMatches {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0 ; column < NumColumns - 2;) {
            
            if (_cookies[column][row] != nil) {
                NSUInteger matchType = _cookies[column][row].cookieType;
                
                if (_cookies[column + 1][row].cookieType == matchType && _cookies[column + 2][row].cookieType == matchType) {
                    
                    RWTChain *chain = [[RWTChain alloc] init];
                    chain.chainType = ChainTypeHorizontal;
                    
                    do {
                        [chain addCookie:_cookies[column][row]];
                        column += 1;
                    }
                    while (column < NumColumns && _cookies[column][row].cookieType == matchType);
                    
                    [set addObject:chain];
                    
                    continue;
                }
            }
            column += 1;
        }
    }
    return set;
}


- (NSSet *) detectVerticalMatches {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger column = 0 ; column < NumColumns; column++) {
        for (NSInteger row = 0; row < NumRows - 2; ) {
            NSUInteger matchType = _cookies[column][row].cookieType;
            
            if (_cookies[column][row + 1].cookieType == matchType && _cookies[column][row + 2].cookieType == matchType) {
                
                RWTChain *chain = [[RWTChain alloc] init];
                chain.chainType = ChainTypeVertical;
                
                do {
                    [chain addCookie:_cookies[column][row]];
                    row += 1;
                }
                while (row < NumRows && _cookies[column][row].cookieType == matchType);
                
                [set addObject:chain];
                continue;
            }
            row += 1;
        }
    }
    return set;
}


- (NSSet *) removeMatches {
    NSSet *horizontalChains = [self detectHorizontalMatches];
    NSSet *verticalChains = [self detectVerticalMatches];
    
    [self removeCookies:horizontalChains];
    [self removeCookies:verticalChains];
    
    return [horizontalChains setByAddingObjectsFromSet:verticalChains];
}

- (void) removeCookies:(NSSet *)chains {
    for (RWTChain *chain in chains) {
        for (RWTCookie *cookie in chain.cookies) {
            _cookies[cookie.column][cookie.row] = nil;
        }
    }
}

- (NSArray *) fillHoles {
    NSMutableArray *columns = [NSMutableArray array];
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        NSMutableArray *array;
        for (NSInteger row = 0; row < NumRows; row++) {
            
            if (_tiles[column][row] != nil && _cookies[column][row] == nil) {
                for (NSInteger lookup = row + 1; lookup < NumRows; lookup++) {
                    RWTCookie *cookie = _cookies[column][lookup];
                    if (cookie != nil) {
                        _cookies[column][lookup] = nil;
                        _cookies[column][row] = cookie;
                        cookie.row = row;
                        
                        if (array == nil) {
                            array = [NSMutableArray array];
                            [columns addObject:array];
                        }
                        
                        [array addObject:cookie];
                        
                        break;
                    }
                }
            }
        }
    }
    return columns;
}

- (NSArray *) topUpCookies {
    NSMutableArray *columns = [NSMutableArray array];
    
    NSUInteger cookieType = 0;
    
    for (NSInteger column = 0; column < NumColumns; column++) {
        NSMutableArray *array;
        
        for (NSInteger row = NumRows - 1; row >= 0 && _cookies[column][row] == nil; row--) {
            if (_tiles[column][row] != nil) {
                NSUInteger newCookieType;
                do {
                    newCookieType = arc4random_uniform(NumCookieType) + 1;
                }
                while (newCookieType == cookieType);
                
                cookieType = newCookieType;
                
                RWTCookie *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
                
                if (array == nil) {
                    array = [NSMutableArray array];
                    [columns addObject:array];
                }
                [array addObject:cookie];
            }
        }
    }
    
    
    return columns;
}

@end
