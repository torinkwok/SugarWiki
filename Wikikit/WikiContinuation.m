//
//  WikiContinuation.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiContinuation.h"

// WikiContinuation class
@implementation WikiContinuation

+ ( instancetype ) continuationWithContinueElementJSON: ( NSArray* )_ContinueElementJSON
    {
    return [ [ [ self class ] alloc ] initWithContinueElementJSON: _ContinueElementJSON ];
    }

- ( instancetype ) initWithContinueElementJSON: ( NSArray* )_ContinueElementJSON
    {
    if ( !_ContinueElementJSON )
        return nil;

    if ( self = [ super init ] )
        {
//        NSDictionary* submoduleSpecContinuation = _ContinueElementJSON.firstObject;
//        NSDictionary* continuation = _ContinueElementJSON.lastObject;
        }

    return self;
    }

@end // WikiContinuation class
