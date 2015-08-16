//
//  _WikiJSON.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

id _WikiCocoaValueWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey );

NSUInteger _WikiSInt64WhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey );

CGFloat _WikiCGFloatWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey );

NSUInteger _WikiUnsignedIntWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey );

BOOL _WikiBooleanWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey );

NSSize _WikiSizeWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey );

NSArray* _WikiArrayValueWhichHasBeenParsedOutOfJSON
    ( NSDictionary* _JSONObject, NSString* _JSONPropertyKey, Class _KindOfElements, SEL _InitMethodsOfElements );