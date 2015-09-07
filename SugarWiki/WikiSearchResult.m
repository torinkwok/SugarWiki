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

#import "WikiSearchResult.h"
#import "NSDate+SugarWiki.h"

#import "__WikiJSONObject.h"

#import "__WikiJSON.h"

// WikiSearchResult class
@implementation WikiSearchResult

@dynamic wikiNamespace;

@dynamic title;
@dynamic resultSnippet;
@dynamic resultTitleSnippet;

@dynamic size;
@dynamic wordCount;

#pragma mark Initializations
+ ( instancetype ) searchResultWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ self alloc ] __initWithJSONDict: _JSONDict ];
    }

- ( instancetype ) __initWithJSONDict: ( NSDictionary* )_JSONDict
    {
    if ( self = [ super __initWithJSONDict: _JSONDict ] )
        {
        self->_wikiNamespace = ( WikiNamespace )_WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"namespace" );

        self->_title = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"title" );
        self->_resultSnippet = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"snippet" );
        self->_resultTitleSnippet = _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"titlesnippet" );

        self->_size = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"size" );
        self->_wordCount = _WikiSInt64WhichHasBeenParsedOutOfJSON( self->_json, @"wordcount" );

        self->_timestamp = [ NSDate dateWithMediaWikiJSONDateString: _WikiCocoaValueWhichHasBeenParsedOutOfJSON( self->_json, @"timestamp" ) ];
        }

    return self;
    }

#pragma mark Dynamic Properties
- ( WikiNamespace ) wikiNamespace
    {
    return self->_wikiNamespace;
    }

- ( NSString* ) title
    {
    return self->_title;
    }

- ( NSString* ) resultSnippet
    {
    return self->_resultSnippet;
    }

- ( NSString* ) resultTitleSnippet
    {
    return self->_resultTitleSnippet;
    }

- ( SInt64 ) size
    {
    return self->_size;
    }

- ( SInt64 ) wordCount
    {
    return self->_wordCount;
    }

- ( NSDate* ) timestamp
    {
    return self->_timestamp;
    }

@end // WikiSearchResult class

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