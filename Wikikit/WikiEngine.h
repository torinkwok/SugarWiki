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

@end // WikiEngine class