//
//  WikiImage.m
//  Wikikit
//
//  Created by Tong G. on 8/16/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiImage.h"
#import "NSDate+Wikikit.h"

#import "_WikiJSON.h"

@implementation WikiImage

@dynamic name;
@dynamic title;
@dynamic canonicalTitle;

@dynamic timestamp;
@dynamic user;
@dynamic userID;

@dynamic sizeInByte;

@dynamic width;
@dynamic height;

@dynamic comment;
@dynamic parsedComment;

@dynamic URL;
@dynamic descriptionURL;

@dynamic SHA1;

@dynamic bitDepth;
@dynamic wikiNamespace;

+ ( instancetype ) imageWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ [ self class ] alloc ] initWithJSONDict: _JSONDict ];
    }

- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( self = [ super initWithJSONDict: _JSONDict ] )
        {
        self->_name = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"name" );
        self->_title = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"title" );
        self->_canonicalTitle = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"canonicaltitle" );

        self->_timestamp = [ NSDate dateWithMediaWikiJSONDateString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"timestamp" ) ];
        self->_user = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"user" );
        self->_userID = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"userid" );

        self->_sizeInByte = _WikiUnsignedIntWhichHasBeenParsedOutOfJSON( self->_json, @"size" );
        self->_width = _WikiCGFloatWhichHasBeenParsedOutOfJSON( self->_json, @"width" );
        self->_height = _WikiCGFloatWhichHasBeenParsedOutOfJSON( self->_json, @"height" );

        self->_comment = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"comment" );
        self->_parsedComment = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"parsedcomment" );

        self->_URL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"url" ) ];
        self->_descriptionURL = [ NSURL URLWithString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"descriptionurl" ) ];

        self->_SHA1 = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"sha1" );

        self->_bitDepth = _WikiUnsignedIntWhichHasBeenParsedOutOfJSON( self->_json, @"bitdepth" );
        self->_wikiNamespace = ( WikiNamespace )_WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"ns" );
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( NSString* ) name
    {
    return self->_name;
    }

- ( NSString* ) title
    {
    return self->_title;
    }

- ( NSString* ) canonicalTitle
    {
    return self->_canonicalTitle;
    }

- ( NSDate* ) timestamp
    {
    return self->_timestamp;
    }

- ( NSString* ) user
    {
    return self->_user;
    }

- ( SInt64 ) userID
    {
    return self->_userID;
    }

- ( NSUInteger ) sizeInByte
    {
    return self->_sizeInByte;
    }

- ( CGFloat ) width
    {
    return self->_width;
    }

- ( CGFloat ) height
    {
    return self->_height;
    }

- ( NSString* ) comment
    {
    return self->_comment;
    }

- ( NSString* ) parsedComment
    {
    return self->_parsedComment;
    }

- ( NSURL* ) URL
    {
    return self->_URL;
    }

- ( NSURL* ) descriptionURL
    {
    return self->_descriptionURL;
    }

- ( NSString* ) SHA1
    {
    return self->_SHA1;
    }

- ( NSUInteger ) bitDepth
    {
    return self->_bitDepth;
    }

- ( WikiNamespace ) wikiNamespace
    {
    return self->_wikiNamespace;
    }

@end
