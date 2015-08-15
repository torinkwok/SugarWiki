//
//  WikiPage.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiPage.h"
#import "NSDate+Wikikit.h"

#import "_WikiJSON.h"

@implementation WikiPage

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

// Overrides WikiJSONObject
- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( !_JSONDict )
        return nil;

    if ( self = [ super init ] )
        {
        self->_json = _JSONDict;

        self->_ID = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"pageid" );
        self->_wikiNamespace = ( WikiNamespace )_WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"ns" );
        self->_title = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"title" );
        self->_displayTitle = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"displaytitle" );
        self->_contentModel = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"contentmodel" );
        self->_language = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"pagelanguage" );

        self->_touched = [ NSDate dateWithMediaWikiJSONDateString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"touched" ) ];

        self->_URL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"fullurl" ) ];
        self->_editURL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"editurl" ) ];
        self->_canonicalURL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"canonicalurl" ) ];

        self->_talkID = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"talkid" );

        NSDictionary* pagepropsJSON = self->_json[ @"pageprops" ];
        if ( pagepropsJSON )
            {
            self->_defaultSort = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( pagepropsJSON, @"defaultsort" );
            self->_pageImageName = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( pagepropsJSON, @"page_image" );
            self->_wikiBaseItem = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( pagepropsJSON, @"wikibase_item" );
            }
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

- ( NSString* ) defaultSort
    {
    return self->_defaultSort;
    }

- ( NSString* ) pageImageName
    {
    return self->_pageImageName;
    }

- ( NSString* ) wikiBaseItem
    {
    return self->_wikiBaseItem;
    }

#pragma mark Debugging
- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @"ID: %@\n"
                                         "Wiki Namespace: %@\n"
                                         "Title: %@\n"
                                         "Display Title: %@\n"
                                         "Content Model: %@\n"
                                         "Language: %@\n"
                                         "Touched: %@\n"
                                         "URL: %@\n"
                                         "Edit URL: %@\n"
                                         "Conanical URL: %@\n"
                                         "Talk ID: %@\n"
                                         "Default Sort: %@\n"
                                         "Page Image Name: %@\n"
                                         "WikiBase Item: %@\n"
           , @( self->_ID )
           , @( self->_wikiNamespace )
           , self->_title
           , self->_displayTitle
           , self->_contentModel
           , self->_language
           , self->_touched
           , self->_URL
           , self->_editURL
           , self->_canonicalURL
           , @( self->_talkID )
           , self->_defaultSort
           , self->_pageImageName
           , self->_wikiBaseItem
           ];
    }

@end
