/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                       _  _  _ _ _     _ _     _       _                      |██
|                      (_)(_)(_|_) |   (_) |   (_)  _  | |                     |██
|                       _  _  _ _| |  _ _| |  _ _ _| |_| |                     |██
|                      | || || | | |_/ ) | |_/ ) (_   _)_|                     |██
|                      | || || | |  _ (| |  _ (| | | |_ _                      |██
|                       \_____/|_|_| \_)_|_| \_)_|  \__)_|                     |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import <objc/message.h>

#import "_WikiJSON.h"

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

    NSDictionary* objects = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( _JSONObject, _JSONPropertyKey );
    if ( objects.count > 0 )
        {
        wrappedObjects = [ NSMutableArray array ];
        for ( NSDictionary* objectElem in objects.allValues )
            @try {
                id cocoaObject = objc_msgSend( _KindOfElements, _InitMethodsOfElements, objectElem );
                [ wrappedObjects addObject: cocoaObject ];
                } @catch ( NSException* _Ex )
                    { NSLog( @"%@", _Ex ); }
        }

    return wrappedObjects ? [ wrappedObjects copy ] : nil;
    }