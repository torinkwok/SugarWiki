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

#import "WikiRevision.h"
#import "NSDate+SugarWiki.h"

#import "__WikiJSONObject.h"
#import "__WikiRevision.h"

#import "__WikiJSONUtilities.h"

// WikiRevision class
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

@end // WikiRevision class

// WikiRevision + SugarWikiPrivate
@implementation WikiRevision ( SugarWikiPrivate )

#pragma mark Private Initializations ( only used by friend classes )
+ ( instancetype ) __revisionWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ [ self class ] alloc ] __initWithJSONDict: _JSONDict ];
    }

// Overrides WikiJSONObject
- ( instancetype ) __initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( self = [ super __initWithJSONDict: _JSONDict ] )
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

@end // WikiRevision + SugarWikiPrivate

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