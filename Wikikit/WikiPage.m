//
//  WikiPage.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiPage.h"

@implementation WikiPage

+ ( instancetype ) pageWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ [ self class ] alloc ] initWithJSONDict: _JSONDict ];
    }

- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( !_JSONDict )
        return nil;

    if ( self = [ super init ] )
        {

        }

    return self;
    }

@end
