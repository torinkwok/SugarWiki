//
//  WikiJSONObject.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiJSONObject.h"
#import "WikiMacros.h"

@implementation WikiJSONObject

@dynamic json;

#pragma mark Dynamic Properties

- ( NSDictionary* ) json
    {
    return self->_json;
    }

#pragma mark Pure Virtual Initializations
- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD_;
    return nil;
    }

@end
