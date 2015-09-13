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

#import "WikiContinuation.h"

#import "__WikiJSONObject.h"
#import "__WikiContinuation.h"

#import "__WikiContinuationInitial.h"
#import "__WikiContinuationCompleted.h"
#import "__WikiContinuationUncompleted.h"

// WikiContinuation class
@implementation WikiContinuation

@dynamic continuations;

@dynamic isInitial;
@dynamic isCompleted;

#pragma mark
+ ( instancetype ) initialContinuation
    {
    return [ [ self alloc ] __initWithJSONDict: @{} isInitial: YES ];
    }

#pragma mark Dynamic Properties
- ( __SugarDictionary_of( NSString*, NSString* ) ) continuations
    {
    return self->_json;
    }

- ( BOOL ) isInitial
    {
    __throw_exception_due_to_invocation_of_pure_virtrual_method_;
    }

- ( BOOL ) isCompleted
    {
    __throw_exception_due_to_invocation_of_pure_virtrual_method_;
    }

@end // WikiContinuation class

// WikiContinuation + SugarWikiPrivate
@implementation WikiContinuation ( SugarWikiPrivate )

#pragma mark Private Initializations ( only used by friend classes )
+ ( instancetype ) __continuationWithJSONDict: ( NSDictionary* )_JSONDict
    {
    return [ [ self alloc ] __initWithJSONDict: _JSONDict isInitial: NO ];
    }

- ( instancetype ) __initWithJSONDict: ( NSDictionary* )_JSONDict isInitial: ( BOOL )_YesOrNo
    {
    self->_json = _JSONDict ?: @{};

    WikiContinuation* clusterMember = nil;

    if ( _YesOrNo )
        clusterMember = [ [ __WikiContinuationInitial alloc ] __initWithJSONDict: self->_json ];

    else if ( ( _JSONDict.count > 0 ) && !_YesOrNo )
        clusterMember = [ [ __WikiContinuationUncompleted alloc ] __initWithJSONDict: self->_json ];

    else if ( ( _JSONDict.count == 0 ) && !_YesOrNo )
        clusterMember = [ [ __WikiContinuationCompleted alloc ] __initWithJSONDict: self->_json ];

    return clusterMember;
    }

#pragma mark Debugging
- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @">>> (Log👺) %@ <%p>: %@", NSStringFromClass( self.class), self, self.json.description ];
    }

@end // WikiContinuation + SugarWikiPrivate

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