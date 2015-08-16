//
//  WikiEngine.m
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"
#import "AFNetworking.h"
#import "WikiHTTPSessionManager.h"
#import "WikiSessionDataTask.h"
#import "WikiPage.h"
#import "WikiImage.h"

#import "_WikiJSON.h"

////! Project version number for Wikikit.
//double WikikitInfoNumber = 1.0;
//
////! Project version string for Wikikit.
//NSString const* WikikitInfoString = @"1.0";

// Private Interfaces
@interface WikiEngine ()

- ( void ) _initEndpoint: ( NSURL* )_EndpointURL;
- ( instancetype ) _initWithCommonsEndpoint;

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

#pragma mark Search
- ( void ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                          inNamespaces: ( NSArray* )_Namespaces
                                  what: ( WikiEngineSearchWhat )_SearchWhat
                                 limit: ( NSUInteger )_Limit
                               success: ( void (^)( NSArray* _MatchedPages ) )_SuccessBlock
                               failure: ( void (^)( NSError* _Error ) )_FailureBlock
    {
    NSString* srnamespace = nil;
    if ( _Namespaces.count > 0 )
        srnamespace = [ _Namespaces componentsJoinedByString: @"|" ];

    NSDictionary* parameters = @{ @"action" : @"query"
                                , @"format" : @"json"
                                , @"generator" : @"search"
                                , @"gsrsearch" : _SearchValue
                                , @"gsrprop" : @"size|wordcount|timestamp|snippet|titlesnippet|sectionsnippet"
                                , @"gsrlimit" : @( _Limit ).stringValue
                                , @"prop" : @"info|pageprops|categories|categoryinfo|imageinfo|revisions"
                                , @"inprop" : @"url|watched|talkid|preload|displaytitle"
                                , @"rvprop" : @"content|ids|flags|timestamp|user|userid|comment|parsedcomment|size|sha1"
                                , @"gsrnamespace" : srnamespace ?: @"0"
                                };

    NSURLSessionDataTask* dataTask = [ self->_wikiHTTPSessionManager
               GET: @"GET"
        parameters: parameters
           success:
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            if ( _SuccessBlock )
                {
                // Done! Kill task by removing it from the temporary session tasks pool😈
                [ self->_tmpSessionTasksPool removeObject: _Task ];

                NSDictionary* pagesJSON = ( ( NSDictionary* )_ResponseObject )[ @"query" ];
                NSArray* matchedPages = _WikiArrayValueWhichHasBeenParsedOutOfJSON( pagesJSON, @"pages", [ WikiPage class ], @selector( pageWithJSONDict: ) );
                _SuccessBlock( matchedPages );
                }
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    // Error occured! Kill task by removing it from the temporary session tasks pool😈
                    [ self->_tmpSessionTasksPool removeObject: _Task ];

                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    } ];

    if ( !self->_tmpSessionTasksPool )
        self->_tmpSessionTasksPool = [ NSMutableArray array ];

    [ self->_tmpSessionTasksPool addObject: dataTask ];
    [ dataTask resume ];
    }

- ( void ) fetchImage: ( NSString* )_ImageName
              success: ( void (^)( WikiImage* _Image ) )_SuccessBlock
              failure: ( void (^)( NSError* _Error ) )_FailureBlock
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

    NSURLSessionDataTask* dataTask = [ self->_wikiHTTPSessionManager
               GET: @"GET"
        parameters: parameters
           success:
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            // Done! Kill task by removing it from the temporary session tasks pool😈
            [ self->_tmpSessionTasksPool removeObject: _Task ];

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
                    // Error occured! Kill task by removing it from the temporary session tasks pool😈
                    [ self->_tmpSessionTasksPool removeObject: _Task ];

                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    } ];

    if ( !self->_tmpSessionTasksPool )
        self->_tmpSessionTasksPool = [ NSMutableArray array ];

    [ self->_tmpSessionTasksPool addObject: dataTask ];
    [ dataTask resume ];
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

@end // WikiEngine class