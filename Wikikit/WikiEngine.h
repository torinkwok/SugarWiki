//
//  WikiEngine.h
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

@class WikiHTTPSessionManager;
@class WikiSessionDataTask;
@class WikiPage;

typedef NS_ENUM( NSUInteger, WikiEngineSearchWhat )
    { WikiEngineSearchWhatPageTitles    = 0
    , WikiEngineSearchWhatPageText      = 1
    , WikiEngineSearchWhatNearMatch     = 2
    };

/**
  */
@interface WikiEngine : NSObject
    {
@protected
    NSURL __strong* _endpoint;

    WikiHTTPSessionManager __strong* _wikiHTTPSessionManager;

    // @[ WikiSessionDataTask, WikiSessionDataTask, WikiSessionDataTask, … ]
    NSMutableArray __strong* _wikiDataSessionTasks;

    NSString __strong* _ISOLanguageCode;
    }

@property ( strong, readonly ) NSURL* endpoint;
@property ( strong, readonly ) WikiHTTPSessionManager* wikiHTTPSessionManager;
@property ( strong, readonly ) NSString* ISOLanguageCode;

#pragma mark Creating Engine
+ ( instancetype ) engineWithISOLanguageCode: ( NSString* )_ISOLanguageCode;
- ( instancetype ) initWithISOLanguageCode: ( NSString* )_ISOLanguageCode;

+ ( instancetype ) commonsEngine;

#pragma mark Search
- ( void ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                                  what: ( WikiEngineSearchWhat )_SearchWhat
                                 limit: ( NSUInteger )_Limit
                               success: ( void (^)( NSArray* _MatchedPages ) )_SuccessBlock
                               failure: ( void (^)( NSError* _Error ) )_FailureBlock;

@end // WikiEngine class