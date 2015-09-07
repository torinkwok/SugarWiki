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

#import "WikiEngine.h"
#import "AFNetworking.h"
#import "WikiHTTPSessionManager.h"
#import "WikiSessionTask.h"
#import "WikiPage.h"
#import "WikiImage.h"
#import "WikiSearchResult.h"

#import "_WikiJSON.h"

NSString* const kGET = @"GET";
NSString* const kPOST = @"POST";
NSString* const kHEAD = @"HEAD";
NSString* const kPUS = @"PUS";
NSString* const kPATCH = @"PATCH";
NSString* const kDELETE = @"DELETE";

// Private Interfaces
@interface WikiEngine ()

- ( void ) _initEndpoint: ( NSURL* )_EndpointURL;
- ( instancetype ) _initWithCommonsEndpoint;

- ( void ) _cancelAll;

@end // Private Interfaces

// WikiEngine class
@implementation WikiEngine

@dynamic endpoint;
@dynamic wikiHTTPSessionManager;
@dynamic ISOLanguageCode;

- ( NSURL* ) endpoint
    {
    return self->_endpoint;
    }

- ( WikiHTTPSessionManager* ) wikiHTTPSessionManager
    {
    return self->_wikiHTTPSessionManager;
    }

- ( NSString* ) ISOLanguageCode
    {
    return self->_ISOLanguageCode;
    }

#pragma mark Creating Engine
+ ( instancetype ) engineWithISOLanguageCode: ( NSString* )_Code
    {
    return [ [ [ self class ] alloc ] initWithISOLanguageCode: _Code ];
    }

- ( instancetype ) initWithISOLanguageCode: ( NSString* )_Code
    {
    if ( !_Code )
        return nil;

    NSArray* allCodes = [ NSLocale ISOLanguageCodes ];
    if ( [ allCodes containsObject: _Code ] )
        {
        if ( self = [ super init ] )
            {
            self->_ISOLanguageCode = _Code;
            NSURL* url = [ NSURL URLWithString:
                [ NSString stringWithFormat: @"https://%@.wikipedia.org/w/api.php/", self->_ISOLanguageCode ] ];

            [ self _initEndpoint: url ];
            }
        }

    return self;
    }

+ ( instancetype ) commonsEngine
    {
    return [ [ [ self class ] alloc ] _initWithCommonsEndpoint ];
    }

#pragma mark Controlling Query Task
@dynamic hasCompletedAllQueryTasks;
@dynamic numberOfRunningQueryTasks;

- ( BOOL ) hasCompletedAllQueryTasks
    {
    return self.numberOfRunningQueryTasks == 0;
    }

- ( NSUInteger ) numberOfRunningQueryTasks
    {
    return self->_tmpSessionTasksPool.count;
    }

- ( void ) cancelAll
    {
    [ self _cancelAll ];
    }

#pragma mark Generic Methods
- ( WikiSessionTask* ) fetchResourceWithParameters: ( NSDictionary* )_Params
                                        HTTPMethod: ( NSString* )_HTTPMethod
                                           success: ( void (^)( NSURLSessionDataTask* _Task, id _ResponseObject ) )_SuccessBlock
                                           failure: ( void (^)( NSURLSessionDataTask* _Task, NSError* _Error ) )_FailureBlock
                                 stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSURLSessionDataTask* dataTask = nil;

    void ( ^__successBlock )( NSURLSessionDataTask* __nonnull, id  __nonnull ) =
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            if ( _SuccessBlock )
                {
                if ( _SuccessBlock )
                    _SuccessBlock( _Task, _ResponseObject );

                // Done! Kill task by removing it from the temporary session tasks pool😈
                [ self->_tmpSessionTasksPool removeObject: _Task ];
                }
            };

    void ( ^__failureBlock )( NSURLSessionDataTask* __nonnull, NSError* __nonnull ) =
        ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
            {
            if ( _FailureBlock )
                _FailureBlock( _Task, _Error );

            [ self->_tmpSessionTasksPool removeObject: _Task ];
            };

    if ( [ _HTTPMethod isEqualToString: kGET ] )
        dataTask = [ self->_wikiHTTPSessionManager GET: self->_endpoint.absoluteString parameters: _Params success: __successBlock failure: __failureBlock ];


    if ( dataTask )
        {
        if ( !self->_tmpSessionTasksPool )
            self->_tmpSessionTasksPool = [ NSMutableArray array ];

        if ( _WillStop )
            [ self _cancelAll ];

        [ self->_tmpSessionTasksPool addObject: dataTask ];
        [ dataTask resume ];
        }

    return [ WikiSessionTask sessionTaskWithHTTPMethod: _HTTPMethod
                                            parameters: _Params
                                    URLSessionDataTask: dataTask ];
    }

// Convenience
- ( WikiSessionTask* ) fetchResourceWithParameters: ( NSDictionary* )_Params
                                        HTTPMethod: ( NSString* )_HTTPMethod
                                           success: ( void (^)( NSURLSessionDataTask* _Task, id _ResponseObject ) )_SuccessBlock
                                           failure: ( void (^)( NSURLSessionDataTask* _Task, NSError* _Error ) )_FailureBlock
    {
    return [ self fetchResourceWithParameters: _Params
                                   HTTPMethod: _HTTPMethod
                                      success: _SuccessBlock
                                      failure: _FailureBlock
                            stopAllOtherTasks: NO ];
    }

#pragma mark Search
- ( WikiSessionTask* ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                                      inNamespaces: ( NSArray* )_Namespaces
                                          approach: ( WikiEngineSearchApproach )_SearchApproach
                                             limit: ( NSUInteger )_Limit
                                           success: ( void (^)( WikiSearchResults* _SearchResults ) )_SuccessBlock
                                           failure: ( void (^)( NSError* _Error ) )_FailureBlock
                                 stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSString* srnamespace = nil;
    if ( _Namespaces.count > 0 )
        srnamespace = [ _Namespaces componentsJoinedByString: @"|" ];

    NSDictionary* parameters = @{ @"action" : @"query"
                                , @"format" : @"json"
                                , @"list" : @"search"
                                , @"srsearch" : _SearchValue
                                , @"srprop" : @"size|wordcount|timestamp|snippet|titlesnippet|sectionsnippet"
                                , @"srlimit" : @( _Limit ).stringValue
                                , @"srnamespace" : srnamespace ?: @"0"
                                };

    return [ self fetchResourceWithParameters: parameters
                                   HTTPMethod: kGET
                                      success:
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            if ( _SuccessBlock )
                {
                NSDictionary* searchResultJSON = ( ( NSDictionary* )_ResponseObject )[ @"query" ];
                NSArray* searchResults = _WikiArrayValueWhichHasBeenParsedOutOfJSON( searchResultJSON, @"search", [ WikiSearchResult class ], @selector( searchResultWithJSONDict: ) );
                _SuccessBlock( searchResults );
                }
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
             stopAllOtherTasks: _WillStop ];
    }

// Convenience
- ( WikiSessionTask* ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                                      inNamespaces: ( NSArray* )_Namespaces
                                          approach: ( WikiEngineSearchApproach )_SearchApproach
                                             limit: ( NSUInteger )_Limit
                                           success: ( void (^)( WikiSearchResults* _SearchResults ) )_SuccessBlock
                                           failure: ( void (^)( NSError* _Error ) )_FailureBlock
    {
    return [ self searchAllPagesThatHaveValue: _SearchValue
                                 inNamespaces: _Namespaces
                                     approach: _SearchApproach
                                        limit: _Limit
                                      success: _SuccessBlock
                                      failure: _FailureBlock
                            stopAllOtherTasks: NO ];
    }

#pragma Images API
- ( WikiSessionTask* ) fetchImage: ( NSString* )_ImageName
                          success: ( void (^)( WikiImage* _Image ) )_SuccessBlock
                          failure: ( void (^)( NSError* _Error ) )_FailureBlock
                stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSString* normalizedImageName = [ _ImageName stringByReplacingOccurrencesOfString: @" " withString: @"_" ];
    NSDictionary* parameters = @{ @"action" : @"query"
                                , @"format" : @"json"
                                , @"list" : @"allimages"
                                , @"aifrom" : normalizedImageName
                                , @"aisort" : @"name"
                                , @"aiprop" : @"timestamp|url|metadata|commonmetadata|extmetadata|dimensions|userid|user|parsedcomment|canonicaltitle|sha1|bitdepth|comment|parsedcomment"

                                , @"ailimit" : @"1"
                                };

    return [ self fetchResourceWithParameters: parameters
                                   HTTPMethod: kGET
                                      success:
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            // If the image exists
            NSDictionary* imageJSON = [ ( ( NSDictionary* )_ResponseObject )[ @"query" ][ @"allimages" ] firstObject ];
            if ( [ imageJSON[ @"name" ] isEqualToString: normalizedImageName ] )
                {
                WikiImage* wikiImage = [ WikiImage imageWithJSONDict: imageJSON ];

                if ( _SuccessBlock )
                    _SuccessBlock( wikiImage );
                }
            else
                {
                if ( _FailureBlock )
                    // TODO:
                    _FailureBlock( [ NSError errorWithDomain: @"fuck" code: 134 userInfo: nil ] );
                }
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
             stopAllOtherTasks: _WillStop ];
    }

// Convenience
- ( WikiSessionTask* ) fetchImage: ( NSString* )_ImageName
                          success: ( void (^)( WikiImage* _Image ) )_SuccessBlock
                          failure: ( void (^)( NSError* _Error ) )_FailureBlock
    {
    return [ self fetchImage: _ImageName success: _SuccessBlock failure: _FailureBlock stopAllOtherTasks: NO ];
    }

#pragma mark Private Interfaces
- ( void ) _initEndpoint: ( NSURL* )_EndpointURL
    {
    self->_endpoint = _EndpointURL;
    self->_wikiHTTPSessionManager = [ [ WikiHTTPSessionManager alloc ] initWithBaseURL: self->_endpoint ];

    AFJSONResponseSerializer* jsonSerializer = [ [ AFJSONResponseSerializer alloc ] init ];

    [ self->_wikiHTTPSessionManager setResponseSerializer: jsonSerializer ];
    }

- ( instancetype ) _initWithCommonsEndpoint
    {
    if ( self = [ super init ] )
        {
        NSURL* url = [ NSURL URLWithString: @"https://commons.wikimedia.org/w/api.php" ];
        [ self _initEndpoint: url ];
        }

    return self;
    }

- ( void ) _cancelAll
    {
    if ( self->_tmpSessionTasksPool.count > 0 )
        {
        for ( NSURLSessionDataTask* _RunningDataTask in self->_tmpSessionTasksPool )
            [ _RunningDataTask cancel ];

        [ self->_tmpSessionTasksPool removeAllObjects ];
        }
    }

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