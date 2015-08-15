//
//  WikiImage.m
//  Wikikit
//
//  Created by Tong G. on 8/16/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiImage.h"

@implementation WikiImage

+ ( instancetype ) imageWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ [ self class ] alloc ] initWithJSONDict: _JSONDict ];
    }

- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( self = [ super initWithJSONDict: _JSONDict ] )
        {
        
        }

    return self;

    }

@end
