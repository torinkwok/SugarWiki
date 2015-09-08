/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|               ______                         _  _  _ _ _     _ _             |██
|              / _____)                       (_)(_)(_|_) |   (_) |            |██
|             ( (____  _   _  ____ _____  ____ _  _  _ _| |  _ _| |            |██
|              \____ \| | | |/ _  (____ |/ ___) || || | | |_/ ) |_|            |██
|              _____) ) |_| ( (_| / ___ | |   | || || | |  _ (| |_             |██
|             (______/|____/ \___ \_____|_|    \_____/|_|_| \_)_|_|            |██
|                           (_____|                                            |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import <objc/message.h>

#import "__WikiJSONUtilities.h"

id _WikiCocoaValueWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey )
    {
    id cocoaValue = _JSONObject[ _JSONPropertyKey ];

    if ( !cocoaValue || ( ( id )cocoaValue == [ NSNull null ] ) )
        return nil;

    return cocoaValue;
    }

NSUInteger _WikiSInt64WhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey )
    {
    NSNumber* cocoaNumber = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );
    assert( !cocoaNumber || [ cocoaNumber respondsToSelector: @selector( integerValue ) ] );
    return cocoaNumber ? cocoaNumber.longLongValue : 0;
    }

CGFloat _WikiCGFloatWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey )
    {
    NSNumber* cocoaNumber = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );
    assert( !cocoaNumber || [ cocoaNumber respondsToSelector: @selector( doubleValue ) ] );
    return cocoaNumber ? cocoaNumber.doubleValue : 0.f;
    }

NSUInteger _WikiUnsignedIntWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey )
    {
    NSNumber* cocoaNumber = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );
    assert( !cocoaNumber || [ cocoaNumber respondsToSelector: @selector( unsignedIntegerValue ) ] );
    return cocoaNumber ? cocoaNumber.unsignedIntegerValue : 0U;
    }

BOOL _WikiBooleanWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey )
    {
    NSNumber* cocoaBool = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );
    assert( !cocoaBool || [ cocoaBool respondsToSelector: @selector( boolValue ) ] );
    return cocoaBool ? cocoaBool.boolValue : NO;
    }

NSSize _WikiSizeWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject, NSString* _JSONPropertyKey )
    {
    NSSize size = NSMakeSize( -1.f, -1.f );

    NSDictionary* JSONObjectDict = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );
    assert( !JSONObjectDict || [ JSONObjectDict respondsToSelector: @selector( valueForKey: ) ] );
    size.height = [ [ JSONObjectDict valueForKey: @"h" ] doubleValue ];
    size.width = [ [ JSONObjectDict valueForKey: @"w" ] doubleValue ];

    return size;
    }

NSArray* _WikiArrayValueWhichHasBeenParsedOutOfJSON( NSDictionary* _JSONObject
                                                   , NSString* _JSONPropertyKey
                                                   , Class _KindOfElements
                                                   , SEL _InitMethodsOfElements
                                                   )
    {
    NSMutableArray* wrappedObjects = nil;

    id objects = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );

    NSArray* tmpContainer = nil;

    if ( [ objects isKindOfClass: [ NSArray class ] ] )
        tmpContainer = objects;
    else if ( [ objects isKindOfClass: [ NSDictionary class ] ] )
        tmpContainer = @[ objects ];

    if ( ( ( NSArray* )objects ).count > 0 )
        {
        wrappedObjects = [ NSMutableArray array ];

        for ( NSDictionary* objectElem in tmpContainer )
            @try {
            id cocoaObject = objc_msgSend( _KindOfElements, _InitMethodsOfElements, objectElem );

            if ( cocoaObject )
                [ wrappedObjects addObject: cocoaObject ];
            } @catch ( NSException* _Ex )
                { NSLog( @"%@", _Ex ); }
        }

    return wrappedObjects ? [ wrappedObjects copy ] : nil;
    }

/*================================================================================┐
|                              The MIT License (MIT)                              |
|                                                                                 |
|                           Copyright (c) 2015 Tong Kuo                           |
|                                                                                 |
|  Permission is hereby granted, free of charge, to any person obtaining a copy   |
|  of this software and associated documentation files (the "Software"), to deal  |
|  in the Software without restriction, including without limitation the rights   |
|    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    |
|      copies of the Software, and to permit persons to whom the Software is      |
|            furnished to do so, subject to the following conditions:             |
|                                                                                 |
| The above copyright notice and this permission notice shall be included in all  |
|                 copies or substantial portions of the Software.                 |
|                                                                                 |
|   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
|    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
|   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   |
|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      |
|  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
|  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                    SOFTWARE.                                    |
└================================================================================*/