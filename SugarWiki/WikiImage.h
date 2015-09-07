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

#import "WikiJSONObject.h"
#import "WikiConstants.h"

@interface WikiImage : WikiJSONObject
    {
@protected
    NSString __strong* _name;
    NSString __strong* _title;
    NSString __strong* _canonicalTitle;

    NSDate __strong* _timestamp;
    NSString __strong* _user;
    SInt64 _userID;

    NSUInteger _sizeInByte;

    CGFloat _width;
    CGFloat _height;

    NSString __strong* _comment;
    NSString __strong* _parsedComment;

    NSURL __strong* _URL;
    NSURL __strong* _descriptionURL;

    NSString __strong* _SHA1;

    NSUInteger _bitDepth;
    WikiNamespace _wikiNamespace;
    }

@property ( strong, readonly ) NSString* name;
@property ( strong, readonly ) NSString* title;
@property ( strong, readonly ) NSString* canonicalTitle;

@property ( strong, readonly ) NSDate* timestamp;
@property ( strong, readonly ) NSString* user;
@property ( assign, readonly ) SInt64 userID;

@property ( assign, readonly ) NSUInteger sizeInByte;

@property ( assign, readonly ) CGFloat width;
@property ( assign, readonly ) CGFloat height;

@property ( strong, readonly ) NSString* comment;
@property ( strong, readonly ) NSString* parsedComment;

@property ( strong, readonly ) NSURL* URL;
@property ( strong, readonly ) NSURL* descriptionURL;

@property ( strong, readonly ) NSString* SHA1;

@property ( assign, readonly ) NSUInteger bitDepth;
@property ( assign, readonly ) WikiNamespace wikiNamespace;

+ ( instancetype ) imageWithJSONDict: ( NSDictionary* )_JSONDict;

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