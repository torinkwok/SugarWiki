//
//  WikiJSONObject.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

@interface WikiJSONObject : NSObject
    {
@protected
    NSDictionary __strong* _json;
    }

@property ( strong, readonly ) NSDictionary* json;

@end
