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

@import Foundation;

#import "WikiJSONObject.h"
#import "WikiConstants.h"

@class WikiRevision;

@interface WikiPage : WikiJSONObject <NSCopying>
    {
@protected
    SInt64 _ID;
    WikiNamespace _wikiNamespace;
    NSString __strong* _title;
    NSString __strong* _displayTitle;
    NSString __strong* _contentModel;
    NSString __strong* _language;
    NSDate __strong* _touched;

    NSURL __strong* _URL;
    NSURL __strong* _editURL;
    NSURL __strong* _canonicalURL;

    SInt64 _talkID;

    NSString __strong* _defaultSort;
    NSString __strong* _pageImageName;
    NSString __strong* _wikiBaseItem;

    WikiRevision __strong* _lastRevision;
    }

@property ( assign, readonly ) SInt64 ID;
@property ( assign, readonly ) WikiNamespace wikiNamespace;
@property ( strong, readonly ) NSString* title;
@property ( strong, readonly ) NSString* displayTitle;
@property ( strong, readonly ) NSString* contentModel;
@property ( strong, readonly ) NSString* language;
@property ( strong, readonly ) NSDate* touched;

@property ( strong, readonly ) NSURL* URL;
@property ( strong, readonly ) NSURL* editURL;
@property ( strong, readonly ) NSURL* canonicalURL;

@property ( assign, readonly ) SInt64 talkID;

@property ( strong, readonly ) NSString* defaultSort;
@property ( strong, readonly ) NSString* pageImageName;
@property ( strong, readonly ) NSString* wikiBaseItem;

@property ( strong, readonly ) WikiRevision* lastRevision;

+ ( instancetype ) pageWithJSONDict: ( NSDictionary* )_JSONDict;

@end

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