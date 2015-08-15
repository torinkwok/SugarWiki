//
//  WikiRevision.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiRevision.h"
#import "NSDate+Wikikit.h"

#import "_WikiJSON.h"

@implementation WikiRevision

@dynamic ID;
@dynamic parentID;

@dynamic userName;
@dynamic userID;

@dynamic timestamp;
@dynamic contentFormat;
@dynamic contentModel;
@dynamic content;

@dynamic sizeInBytes;

@dynamic comment;
@dynamic parsedComment;

+ ( instancetype ) revisionWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ [ self class ] alloc ] initWithJSONDict: _JSONDict ];
    }

// Overrides WikiJSONObject
- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( self = [ super initWithJSONDict: _JSONDict ] )
        {
        self->_ID = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"revid" );
        self->_parentID = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"parentid" );

        self->_userName = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"user" );
        self->_userID = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"userid" );

        self->_timestamp = [ NSDate dateWithMediaWikiJSONDateString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"timestamp" ) ];
        self->_contentFormat = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"contentformat" );
        self->_contentModel = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"contentmodel" );
        self->_content = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"*" );

        self->_sizeInByte = _WikiUnsignedIntWhichHasBeenParsedOutOfJSON( self->_json, @"size" );

        self->_comment = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"comment" );
        self->_parsedComment = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"parsedcomment" );

        self->_isMinorEdit = ( _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"minor" ) ) ? YES : NO;

        self->_SHA1 = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"sha1" );
        }

    return self;
    }

#pragma mark Dynmaic Properties
- ( SInt64 ) ID
    {
    return self->_ID;
    }

- ( SInt64 ) parentID
    {
    return self->_parentID;
    }

- ( NSString* ) userName
    {
    return self->_userName;
    }

- ( SInt64 ) userID
    {
    return self->_userID;
    }

- ( NSDate* ) timestamp
    {
    return self->_timestamp;
    }

- ( NSString* ) contentFormat
    {
    return self->_contentFormat;
    }

- ( NSString* ) contentModel
    {
    return self->_contentModel;
    }

- ( NSString* ) content
    {
    return self->_content;
    }

- ( NSUInteger ) sizeInBytes
    {
    return self->_sizeInByte;
    }

- ( NSString* ) comment
    {
    return self->_comment;
    }

- ( NSString* ) parsedComment
    {
    return self->_parsedComment;
    }

- ( BOOL ) isMinorEdit
    {
    return self->_isMinorEdit;
    }

- ( NSString* ) SHA1
    {
    return self->_SHA1;
    }

@end
