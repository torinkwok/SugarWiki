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


// Define some preprocessor macros that allow generics to be adopted in a backwards-compatible manner.
#if __has_feature(objc_generics)
#   define __SugarWiki_GENERICS(class, ...)        class<__kindof __VA_ARGS__>
#else
#   define __SugarWiki_GENERICS(class, ...)        class
#endif

// Using generics with collection containers is so common in SugarWiki
// that it gets a dedicated preprocessor macro for better readability.
#define __NSArray_of(type)                  __SugarWiki_GENERICS(NSArray, type)*
#define __NSMutableArray_of(type)           __SugarWiki_GENERICS(NSMutableArray, type)*
#define __NSSet_of(type)                    __SugarWiki_GENERICS(NSSet, type)*
#define __NSDictionary_of(keytype, valtype) __SugarWiki_GENERICS(NSDictionary, keytype,valtype)*

#define __throw_exception_due_to_invocation_of_pure_virtrual_method_ \
    @throw [ NSException exceptionWithName: NSGenericException reason: [ NSString stringWithFormat: @"unimplemented pure virtual method `%@` in `%@` from instance: %p", NSStringFromSelector( _cmd ), NSStringFromClass( [ self class ] ), self ] userInfo: nil ]

@class WikiSearchResult;
typedef __NSArray_of( WikiSearchResult* ) WikiSearchResults;

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