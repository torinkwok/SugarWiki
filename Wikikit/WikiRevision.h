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

@interface WikiRevision : WikiJSONObject
    {
@protected
    SInt64 _ID;
    SInt64 _parentID;

    NSString __strong* _userName;
    SInt64 _userID;

    NSDate __strong* _timestamp;
    NSString __strong* _contentFormat;
    NSString __strong* _contentModel;
    NSString __strong* _content;

    NSUInteger _sizeInByte;

    NSString __strong* _comment;
    NSString __strong* _parsedComment;

    BOOL _isMinorEdit;

    NSString __strong* _SHA1;
    }

@property ( assign, readonly ) SInt64 ID;
@property ( assign ,readonly ) SInt64 parentID;

@property ( strong, readonly ) NSString* userName;
@property ( assign, readonly ) SInt64 userID;

@property ( strong, readonly ) NSDate* timestamp;
@property ( strong, readonly ) NSString* contentFormat;
@property ( strong, readonly ) NSString* contentModel;
@property ( strong, readonly ) NSString* content;

@property ( assign, readonly ) NSUInteger sizeInBytes;

@property ( strong, readonly ) NSString* comment;
@property ( strong, readonly ) NSString* parsedComment;

@property ( assign, readonly ) BOOL isMinorEdit;

@property ( assign, readonly ) NSString* SHA1;

+ ( instancetype ) revisionWithJSONDict: ( NSDictionary* )_JSONDict;

@end

/*================================================================================┐
|                              The MIT License (MIT)                              |
|                                                                                 |
|                           Copyright (c) 2015 Tong Guo                           |
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