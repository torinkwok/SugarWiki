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

@import Foundation;

#import "SugarWikiDefines.h"
#import "WikiConstants.h"

@class WikiHTTPSessionManager;
@class WikiQueryTask;
@class WikiListsQueryTask;

@class WikiJSONObject;
@class WikiPage;
@class WikiImage;
@class WikiSearchResult;

typedef NS_ENUM( NSUInteger, WikiEngineSearchApproach )
    { WikiEngineSearchApproachPageTitles    = 0
    , WikiEngineSearchApproachPageText      = 1
    , WikiEngineSearchApproachNearMatch     = 2
    };

// WikiEngine class
@interface WikiEngine : NSObject
    {
@protected
    NSURL                   __strong* _endpoint;
    WikiHTTPSessionManager  __strong* _wikiHTTPSessionManager;
    NSMutableArray          __strong* _tmpSessionTasksPool;

    NSString __strong* _ISOLanguageCode;
    }

@property ( strong, readonly ) NSURL* endpoint;
@property ( strong, readonly ) WikiHTTPSessionManager* wikiHTTPSessionManager;
@property ( strong, readonly ) NSString* ISOLanguageCode;

#pragma mark Creating Engine
// TODO: Init with a bulk of language codes
+ ( instancetype ) engineWithISOLanguageCode: ( NSString* )_ISOLanguageCode;
- ( instancetype ) initWithISOLanguageCode: ( NSString* )_ISOLanguageCode;

+ ( instancetype ) commonsEngine;

#pragma mark Controlling Query Task
@property ( assign, readonly ) BOOL hasCompletedAllQueryTasks;
@property ( assign, readonly ) NSUInteger numberOfRunningQueryTasks;
- ( void ) cancelAll;

#pragma mark Generic Methods to GET and POST
- ( WikiQueryTask* ) fetchResourceWithParameters: ( __NSDictionary_of( NSString*, NSString* ) )_Params
                                      HTTPMethod: ( NSString* )_HTTPMethod
                                         success: ( void (^)( WikiQueryTask* _WikiQueryTask, id _ResponseObject ) )_SuccessBlock
                                         failure: ( void (^)( WikiQueryTask* _WikiQueryTask, NSError* _Error ) )_FailureBlock
                               stopAllOtherTasks: ( BOOL )_WillStop;

#pragma mark Generic Methods to Query

/** Lists differ from properties in two aspects - 
    *instead of appending data to the elements in the *WikiPage* object,
    each list has its own separated branch in the `query` element*.

    Also, list output is limited by number of items, 
    and may be continued using the `query-continue` element. 
    
    Unless indicated otherwise, modules listed on this page can be used as generators.
  */
- ( WikiQueryTask* ) queryLists: ( __NSArray_of( NSString* ) )_Lists
                          limit: ( NSUInteger )_Limit
                otherParameters: ( __NSDictionary_of( NSString*, NSString* ) )_ParamsDict
                        success: ( void (^)( __NSDictionary_of( NSString*, __NSArray_of( WikiJSONObject* ) ) _Results ) )_SuccessBlock
                        failure: ( void (^)( NSError* _Error ) )_FailureBlock
              stopAllOtherTasks: ( BOOL )_WillStop;

- ( WikiQueryTask* ) queryProperties: ( __NSArray_of( NSString* ) )_PropValues
                     otherParameters: ( __NSDictionary_of( NSString*, NSString* ) )_ParamsDict
                             success: ( void (^)( __NSDictionary_of( NSString*, __NSArray_of( WikiJSONObject* ) ) _Results ) )_SuccessBlock
                             failure: ( void (^)( NSError* _Error ) )_FailureBlock
                   stopAllOtherTasks: ( BOOL )_WillStop;

#pragma mark Searching

/** @name Searching */

- ( WikiQueryTask* ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                                    inNamespaces: ( NSArray* )_Namespaces
                                        approach: ( WikiEngineSearchApproach )_SearchApproach
                                           limit: ( NSUInteger )_Limit
                                         success: ( void (^)( WikiSearchResults _SearchResults ) )_SuccessBlock
                                         failure: ( void (^)( NSError* _Error ) )_FailureBlock
                               stopAllOtherTasks: ( BOOL )_WillStop;
#pragma mark Pages

/** @name Pages */

- ( WikiQueryTask* ) pagesWithTitles: ( __NSArray_of( NSString* ) )_Titles
                             success: ( void (^)( __NSArray_of( WikiPage* ) _MatchedPage ) )_SuccessBlock
                             failure: ( void (^)( NSError* _Error ) )_FailureBlock
                   stopAllOtherTasks: ( BOOL )_WillStop;

- ( WikiQueryTask* ) pagesWithPageIDs: ( __NSArray_of( NSNumber* ) )_PageIDs
                              success: ( void (^)( __NSArray_of( WikiPage* ) _MatchedPage ) )_SuccessBlock
                              failure: ( void (^)( NSError* _Error ) )_FailureBlock
                    stopAllOtherTasks: ( BOOL )_WillStop;

#pragma Images API
- ( WikiQueryTask* ) fetchImage: ( NSString* )_ImageName
                        success: ( void (^)( WikiImage* _Image ) )_SuccessBlock
                        failure: ( void (^)( NSError* _Error ) )_FailureBlock
              stopAllOtherTasks: ( BOOL )_WillStop;

@end // WikiEngine class

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