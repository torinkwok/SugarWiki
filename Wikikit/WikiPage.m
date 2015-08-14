//
//  WikiPage.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiPage.h"

#import "_WikiJSON.h"

@implementation WikiPage

@dynamic json;

@dynamic ID;
@dynamic wikiNamespace;
@dynamic title;
@dynamic displayTitle;
@dynamic contentModel;
@dynamic language;
@dynamic touched;

@dynamic URL;
@dynamic editURL;
@dynamic canonicalURL;

@dynamic talkID;

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
        self->_json = _JSONDict;

        NSDictionary* values = [ self->_json allValues ].firstObject;

        self->_ID = _WikiSInt64WhichHasBeenParsedOutOfJSON( values, @"pageid" );
        self->_wikiNamespace = ( WikiNamespace )_WikiSInt64WhichHasBeenParsedOutOfJSON( values, @"ns" );
        self->_title = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"contentmodel" );
        self->_displayTitle = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"displaytitle" );
        self->_contentModel = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"contentmodel" );
        self->_language = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"pagelanguage" );

//        self->_touched =

        self->_URL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"fullurl" ) ];
        self->_editURL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"editurl" ) ];
        self->_canonicalURL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( values, @"canonicalurl" ) ];

        self->_talkID = _WikiSInt64WhichHasBeenParsedOutOfJSON( values, @"talkid" );
        }

    return self;
    }

#pragma mark Dynamic Properties

- ( SInt64 ) ID
    {
    return self->_ID;
    }

- ( WikiNamespace ) wikiNamespace
    {
    return self->_wikiNamespace;
    }

- ( NSString* ) title
    {
    return self->_title;
    }

- ( NSString* ) displayTitle
    {
    return self->_displayTitle;
    }

- ( NSString* ) contentModel
    {
    return self->_contentModel;
    }

- ( NSString* ) language
    {
    return self->_language;
    }

- ( NSDate* ) touched
    {
    return self->_touched;
    }

- ( NSURL* ) URL
    {
    return self->_URL;
    }

- ( NSURL* ) editURL
    {
    return self->_editURL;
    }

- ( NSURL* ) canonicalURL
    {
    return self->_canonicalURL;
    }

- ( SInt64 ) talkID
    {
    return self->_talkID;
    }

@end
