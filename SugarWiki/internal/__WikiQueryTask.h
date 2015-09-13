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

#import "WikiQueryTask.h"

// Private Interfaces
@interface WikiQueryTask ()

@property ( strong, readwrite ) NSURLSessionDataTask* sessionDataTask;

@property ( strong, readwrite ) NSString* HTTPMethod;
@property ( strong, readwrite ) NSURL* endPoint;

@property ( assign, readwrite ) WikiQueryOptions queryOptions;
@property ( strong, readwrite ) __SugarDictionary_of( NSString*, NSString* ) parameters;
@property ( strong, readwrite ) __SugarArray_of( NSString* ) listNames;
@property ( strong, readwrite ) __SugarArray_of( NSString* ) propNames;

@end // Private Interfaces

// WikiQueryTask + SugarWikiPrivate
@interface WikiQueryTask ( SugarWikiPrivate )

#pragma mark Private Initializations ( only used by friend classes )
+ ( instancetype ) __sessionTaskWithHTTPMethod: ( NSString* )_HTTPMethod
                                      endPoint: ( NSURL* )_EndPoint
                                    parameters: ( NSDictionary* )_ParamsDict
                            URLSessionDataTask: ( NSURLSessionDataTask* )_SessionDataTask;

- ( instancetype ) __initWithHTTPMethod: ( NSString* )_HTTPMethod
                               endPoint: ( NSURL* )_EndPoint
                             parameters: ( NSDictionary* )_ParamsDict
                     URLSessionDataTask: ( NSURLSessionDataTask* )_SessionDataTask;

@end // WikiQueryTask + SugarWikiPrivate

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