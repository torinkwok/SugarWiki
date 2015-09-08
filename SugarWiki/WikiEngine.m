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

#import "WikiQueryTask.h"

#import "WikiPage.h"
#import "WikiImage.h"
#import "WikiRevision.h"
#import "WikiSearchResult.h"

#import "__WikiJSONObject.h"
#import "__WikiQueryTask.h"
#import "__WikiImage.h"
#import "__WikiSearchResult.h"
#import "__WikiPage.h"
#import "__WikiRevision.h"

#import "__WikiJSONUtilities.h"

NSString* const kGET = @"GET";
NSString* const kPOST = @"POST";
NSString* const kHEAD = @"HEAD";
NSString* const kPUS = @"PUS";
NSString* const kPATCH = @"PATCH";
NSString* const kDELETE = @"DELETE";

NSString* const kParamKeyAction = @"action";
NSString* const kParamKeyFormat = @"format";
NSString* const kParamKeyList = @"list";
NSString* const kParamKeyProp = @"prop";

NSString* const kParamValActionQuery = @"query";

NSString* const kParamValFormatJSON = @"json";
NSString* const kParamValFormatHTML = @"jsonfm";

NSString* const kParamValListPages = @"pages";
NSString* const kParamValListSearch = @"search";
NSString* const kParamValListAllImages = @"allimages";

// Private Interfaces
@interface WikiEngine ()

- ( void ) _initEndpoint: ( NSURL* )_EndpointURL;
- ( instancetype ) _initWithCommonsEndpoint;

- ( void ) _cancelAll;

- ( void ) __wikiClassAndSELDerivedFromQueryValue: ( NSString* )_QueryValue :( Class* )_Class :( SEL* )_SEL;

@end // Private Interfaces

// WikiEngine class
@implementation WikiEngine

@dynamic endpoint;
@dynamic wikiHTTPSessionManager;
@dynamic ISOLanguageCode;

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

#pragma mark Generic Methods to GET and POST
- ( WikiQueryTask* ) fetchResourceWithParameters: ( __NSDictionary_of( NSString*, NSString* ) )_Params
                                      HTTPMethod: ( NSString* )_HTTPMethod
                                         success: ( void (^)( WikiQueryTask* _WikiQueryTask, id _ResponseObject ) )_SuccessBlock
                                         failure: ( void (^)( WikiQueryTask* _WikiQueryTask, NSError* _Error ) )_FailureBlock
                               stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _Params.count > 0 ) && ( _HTTPMethod.length > 0 ) );

    NSURLSessionDataTask* dataTask = nil;
    WikiQueryTask* queryTask = [ WikiQueryTask __sessionTaskWithHTTPMethod: _HTTPMethod
                                                                  endPoint: self->_endpoint
                                                                parameters: _Params
                                                        URLSessionDataTask: nil ];

    void ( ^__successBlock )( NSURLSessionDataTask* __nonnull, id  __nonnull ) =
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            if ( _SuccessBlock )
                _SuccessBlock( queryTask, _ResponseObject );

            // Done! Kill task by removing it from the temporary session tasks pool😈
            [ self->_tmpSessionTasksPool removeObject: _Task ];
            };

    void ( ^__failureBlock )( NSURLSessionDataTask* __nonnull, NSError* __nonnull ) =
        ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
            {
            if ( _FailureBlock )
                _FailureBlock( queryTask, _Error );

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
        [ queryTask setSessionDataTask: dataTask ];

        [ dataTask resume ];
        }

    return queryTask;
    }

#pragma mark Generic Methods to Query
- ( WikiQueryTask* ) queryLists: ( __NSArray_of( NSString* ) )_Lists
                          limit: ( NSUInteger )_Limit
                otherParameters: ( __NSDictionary_of( NSString*, NSString* ) )_ParamsDict
                        success: ( void (^)( __NSDictionary_of( NSString*, __NSArray_of( WikiJSONObject* ) ) _Results ) )_SuccessBlock
                        failure: ( void (^)( NSError* _Error ) )_FailureBlock
              stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _Lists ) && ( _ParamsDict.count > 0 ) );

    NSString* joinedLists =  [ _Lists componentsJoinedByString: @"|" ];
    NSMutableDictionary* paramsDict = [ NSMutableDictionary dictionaryWithDictionary: _ParamsDict ];
    [ paramsDict addEntriesFromDictionary: @{ kParamKeyAction : kParamValActionQuery
                                            , kParamKeyFormat : kParamValFormatJSON
                                            , kParamKeyList : joinedLists
                                            } ];

    return [ self fetchResourceWithParameters: paramsDict
                                   HTTPMethod: kGET
                                      success:
        ^( WikiQueryTask* __nonnull _QueryTask, id  __nonnull _ResponseObject )
            {
            NSDictionary* resultsJSONDict = ( NSDictionary* )_ResponseObject;
            NSDictionary* queryResultsJSONDict = resultsJSONDict[ kParamValActionQuery ];

            NSMutableDictionary* results = [ NSMutableDictionary dictionary ];
            for ( NSString* _Key in _QueryTask.listNames )
                {
                NSArray* jsons = queryResultsJSONDict[ _Key ];

                if ( jsons )
                    {
                    Class elementClass = NULL;
                    SEL initSEL = NULL;

                    [ self __wikiClassAndSELDerivedFromQueryValue: _Key :&elementClass :&initSEL ];
                    NSArray* wikiJSONObjects = _WikiArrayValueWhichHasBeenParsedOutOfJSON( queryResultsJSONDict
                                                                                         , _Key
                                                                                         , elementClass
                                                                                         , initSEL
                                                                                         );
                    if ( wikiJSONObjects )
                        [ results addEntriesFromDictionary: @{ _Key : wikiJSONObjects } ];
                    }
                }

            if ( _SuccessBlock )
                _SuccessBlock( results );
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }       stopAllOtherTasks: _WillStop ];
    }


- ( WikiQueryTask* ) queryProperties: ( __NSArray_of( NSString* ) )_PropValues
                     otherParameters: ( __NSDictionary_of( NSString*, NSString* ) )_ParamsDict
                             success: ( void (^)( __NSArray_of( WikiPage* ) _Results ) )_SuccessBlock
                             failure: ( void (^)( NSError* _Error ) )_FailureBlock
                   stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _PropValues.count > 0 ) && ( _ParamsDict.count > 0 ) );

    NSString* joinedPropsValues = [ _PropValues componentsJoinedByString: @"|" ];

    NSMutableDictionary* paramsDict = [ NSMutableDictionary dictionaryWithDictionary: _ParamsDict ];
    [ paramsDict addEntriesFromDictionary: @{ kParamKeyAction : kParamValActionQuery
                                            , kParamKeyFormat : kParamValFormatJSON
                                            , kParamKeyProp : joinedPropsValues
                                            } ];

    return [ self fetchResourceWithParameters: paramsDict
                                   HTTPMethod: kGET
                                      success:
        ^( WikiQueryTask* __nonnull _QueryTask, id  __nonnull _ResponseObject )
            {
            NSDictionary* resultsJSONDict = ( NSDictionary* )_ResponseObject;

            NSString* queryValue = @"pages";
            NSDictionary* queryResultsJSONDict = resultsJSONDict[ kParamValActionQuery ][ queryValue ];

            NSMutableArray* results = [ NSMutableArray array ];
            for ( NSString* _Key in queryResultsJSONDict )
                {
                NSDictionary* jsons = queryResultsJSONDict[ _Key ];

                if ( jsons )
                    {
                    WikiPage* wikiPage = [ WikiPage __pageWithJSONDict: jsons ];
                    if ( wikiPage )
                        [ results addObject: wikiPage ];
                    }
                }

            if ( _SuccessBlock )
                _SuccessBlock( results );
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }       stopAllOtherTasks: _WillStop ];
    }

#pragma mark Searching
- ( WikiQueryTask* ) searchAllPagesThatHaveValue: ( NSString* )_SearchValue
                                    inNamespaces: ( NSArray* )_Namespaces
                                        approach: ( WikiEngineSearchApproach )_SearchApproach
                                           limit: ( NSUInteger )_Limit
                                         success: ( void (^)( WikiSearchResults _SearchResults ) )_SuccessBlock
                                         failure: ( void (^)( NSError* _Error ) )_FailureBlock
                               stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _SearchValue.length > 0 ) );

    NSString* srnamespace = nil;
    if ( _Namespaces.count > 0 )
        srnamespace = [ _Namespaces componentsJoinedByString: @"|" ];

    NSDictionary* parameters = @{ @"srsearch" : _SearchValue
                                , @"srprop" : @"size|wordcount|timestamp|snippet|titlesnippet|sectionsnippet"
                                , @"srlimit" : @( _Limit ).stringValue
                                , @"srnamespace" : srnamespace ?: @"0"
                                };

    return [ self queryLists: @[ kParamValListSearch ]
                       limit: 10
             otherParameters: parameters
                     success:
        ^( __NSDictionary_of( NSString*, __NSArray_of( WikiJSONObject* ) ) _Results )
            {
            if ( _SuccessBlock )
                _SuccessBlock( _Results[ kParamValListSearch ] );
            } failure:
                ^( NSError* _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
           stopAllOtherTasks: _WillStop ];
    }

#pragma mark Pages
- ( WikiQueryTask* ) pagesWithTitles: ( __NSArray_of( NSString* ) )_Titles
                             success: ( void (^)( __NSArray_of( WikiPage* ) _MatchedPage ) )_SuccessBlock
                             failure: ( void (^)( NSError* _Error ) )_FailureBlock
                   stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _Titles.count > 0 ) );

    NSString* joindedTitles = [ _Titles componentsJoinedByString: @"|" ];

    NSDictionary* parameters = @{ @"titles" : joindedTitles
                                , @"rvprop" : @"ids|flags|timestamp|comment|user|size|sha1|contentmodel|parsedcomment|content"
                                , @"continue" : @""
                                , @"inprop" : @"url|watched|talkid|preload|displaytitle"
                                , @"rvsection" : @"0"
                                };

    return [ self queryProperties: @[ @"info", @"revisions", @"pageprops" ]
                  otherParameters: parameters
                          success:
        ^( __NSArray_of( WikiPage* ) _Results )
            {
            if ( _SuccessBlock )
                _SuccessBlock( _Results );
            } failure:
                ^( NSError* _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
          stopAllOtherTasks: _WillStop ];
    }

- ( WikiQueryTask* ) pagesWithPageIDs: ( __NSArray_of( NSNumber* ) )_PageIDs
                              success: ( void (^)( __NSArray_of( WikiPage* ) _MatchedPage ) )_SuccessBlock
                              failure: ( void (^)( NSError* _Error ) )_FailureBlock
                    stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _PageIDs.count > 0 ) );

    NSString* joindedPageIDs = [ _PageIDs componentsJoinedByString: @"|" ];

    NSDictionary* parameters = @{ @"pageids" : joindedPageIDs
                                , @"rvprop" : @"ids|flags|timestamp|comment|user|size|sha1|contentmodel|parsedcomment|content"
                                , @"continue" : @""
                                , @"inprop" : @"url|watched|talkid|preload|displaytitle"
                                , @"rvsection" : @"0"
                                };

    return [ self queryProperties: @[ @"info", @"revisions", @"pageprops" ]
                  otherParameters: parameters
                          success:
        ^( __NSArray_of( WikiPage* ) _Results )
            {
            if ( _SuccessBlock )
                _SuccessBlock( _Results );
            } failure:
                ^( NSError* _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
          stopAllOtherTasks: _WillStop ];
    }

#pragma Images API
- ( WikiQueryTask* ) fetchImage: ( NSString* )_ImageName
                        success: ( void (^)( WikiImage* _Image ) )_SuccessBlock
                        failure: ( void (^)( NSError* _Error ) )_FailureBlock
              stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _ImageName.length > 0 ) );

    NSString* normalizedImageName = [ _ImageName stringByReplacingOccurrencesOfString: @" " withString: @"_" ];

    NSDictionary* parameters = @{ @"aifrom" : normalizedImageName
                                , @"aisort" : @"name"
                                , @"aiprop" : @"timestamp|url|metadata|commonmetadata|extmetadata|dimensions|userid|user|parsedcomment|canonicaltitle|sha1|bitdepth|comment|parsedcomment"
                                , @"ailimit" : @"1"
                                };

    return [ self queryLists: @[ kParamValListAllImages ]
                       limit: 10
             otherParameters: parameters
                     success:
        ^( __NSDictionary_of( NSString*, __NSArray_of( WikiJSONObject* ) ) _Results )
            {
            // If the image exists
            WikiImage* wikiImage = _Results[ kParamValListAllImages ].firstObject;
            if ( [ wikiImage.name isEqualToString: normalizedImageName ] )
                {
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
                ^( NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
          stopAllOtherTasks: _WillStop ];
    }

#pragma mark Dynamic Properties
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

- ( void ) __wikiClassAndSELDerivedFromQueryValue: ( NSString* )_QueryValue
                                                 :( Class* )_Class
                                                 :( SEL* )_SEL
    {
    NSParameterAssert( ( _Class ) && ( _SEL ) );

    if ( [ _QueryValue isEqualToString: @"pages" ] )
        {
        *_Class = [ WikiPage class ];
        *_SEL = @selector( __pageWithJSONDict: );
        }
    else if ( [ _QueryValue isEqualToString: @"allimages" ] )
        {
        *_Class = [ WikiImage class ];
        *_SEL = @selector( __imageWithJSONDict: );
        }
    else if ( [ _QueryValue isEqualToString: @"search" ] )
        {
        *_Class = [ WikiSearchResult class ];
        *_SEL = @selector( __searchResultWithJSONDict: );
        }
    else if ( [ _QueryValue isEqualToString: @"revisions" ] )
        {
        *_Class = [ WikiRevision class ];
        *_SEL = @selector( __revisionWithJSONDict: );
        }
    else
        {
        *_Class = [ WikiJSONObject class ];
        *_SEL = @selector( __jsonObjectWithJSONDict: );
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