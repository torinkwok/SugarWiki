//
//  WikiJSONObject.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiJSONObject.h"

@implementation WikiJSONObject

@dynamic json;

#pragma mark Dynamic Properties

- ( NSDictionary* ) json
    {
    return self->_json;
    }

@end
