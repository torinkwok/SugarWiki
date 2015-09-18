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
#import "WikiContinuation.h"

#import "__WikiEngine.h"
#import "__WikiJSONObject.h"
#import "__WikiQueryTask.h"
#import "__WikiImage.h"
#import "__WikiSearchResult.h"
#import "__WikiPage.h"
#import "__WikiRevision.h"
#import "__WikiContinuation.h"

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
NSString* const kParamKeyGenerator = @"generator";
NSString* const kParamKeyProp = @"prop";
NSString* const kParamContinue = @"continue";

NSString* const kParamValActionQuery = @"query";

NSString* const kParamValFormatJSON = @"json";
NSString* const kParamValFormatHTML = @"jsonfm";

NSString* const kParamValBatchComplete = @"batchcomplete";
NSString* const kParamValListPages = @"pages";
NSString* const kParamValListSearch = @"search";
NSString* const kParamValListAllImages = @"allimages";

NSString* const kParamKeyRevision = @"revision";
NSString* const kParamParseRevision = @"rvparse";

// Private Interfaces
@interface WikiEngine ()

- ( void ) _initEndpoint: ( NSURL* )_EndpointURL;
- ( instancetype ) _initWithCommonsEndpoint;

- ( void ) _cancelAll;

- ( void ) __wikiClassAndSELDerivedFromQueryValue: ( NSString* )_QueryValue :( Class* )_Class :( SEL* )_SEL;
- ( NSDictionary* ) __normalizedParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_UnnormalizedParams;

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
        if ( self = [ self init ] )
            {
            self->_ISOLanguageCode = _Code;
            NSURL* url = [ NSURL URLWithString:
                [ NSString stringWithFormat: @"https://%@.wikipedia.org/w/api.php/", self->_ISOLanguageCode ] ];

            [ self _initEndpoint: url ];
            }
        }

    return self;
    }

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        self->__rvprop = @[ @"ids", @"flags", @"timestamp", @"comment", @"user"
                          , @"size", @"sha1", @"contentmodel", @"parsedcomment"
                          , @"content"
                          ];

        self->__inprop = @[ @"url", @"watched", @"talkid", @"preload", @"displaytitle" ];

        self->__aiprop = @[ @"timestamp", @"url", @"metadata", @"commonmetadata", @"extmetadata"
                          , @"dimensions", @"userid", @"user", @"parsedcomment", @"canonicaltitle"
                          , @"sha1", @"bitdepth", @"comment", @"parsedcomment"
                          ];

        self->__srprop = @[ @"size", @"wordcount", @"timestamp", @"snippet", @"titlesnippet", @"sectionsnippet" ];

        self->__pageQueryGeneralProps = @[ @"info", @"revisions", @"pageprops" ];

        self->__pageQueryGeneralPropParams = @{ @"prop" : self->__pageQueryGeneralProps
                                              , @"rvprop" : self->__rvprop, @"rvsection" : @"1"
                                              , @"inprop" : self->__inprop
                                              };
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
- ( WikiQueryTask* ) fetchResourceWithParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_Params
                                      HTTPMethod: ( NSString* )_HTTPMethod
                                         success: ( void (^)( WikiQueryTask* _WikiQueryTask, id _ResponseObject ) )_SuccessBlock
                                         failure: ( void (^)( WikiQueryTask* _WikiQueryTask, NSError* _Error ) )_FailureBlock
                               stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _Params.count > 0 ) && ( _HTTPMethod.length > 0 ) );

    NSURLSessionDataTask* dataTask = nil;
    NSDictionary* normalizedParams = [ self __normalizedParameters: _Params ];
    WikiQueryTask* queryTask = [ WikiQueryTask __sessionTaskWithHTTPMethod: _HTTPMethod
                                                                  endPoint: self->_endpoint
                                                                parameters: normalizedParams
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
        dataTask = [ self->_wikiHTTPSessionManager GET: self->_endpoint.absoluteString parameters: normalizedParams success: __successBlock failure: __failureBlock ];

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
- ( WikiQueryTask* ) queryLists: ( __SugarArray_of( NSString* ) )_Lists
                          limit: ( NSUInteger )_Limit
                otherParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_ParamsDict
                   continuation: ( WikiContinuation* )_Continuation
                        success: ( void (^)( __SugarDictionary_of( NSString*, __SugarArray_of( WikiJSONObject* ) ) _Results
                                 , WikiContinuation* _Continuation
                                 , BOOL _IsBatchComplete ) )_SuccessBlock
                        failure: ( void (^)( NSError* _Error ) )_FailureBlock
              stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _Lists ) && ( _ParamsDict.count > 0 ) );

    NSMutableDictionary* paramsDict = [ NSMutableDictionary dictionaryWithDictionary: _ParamsDict ];
    [ paramsDict addEntriesFromDictionary: @{ kParamKeyAction : kParamValActionQuery
                                            , kParamKeyFormat : kParamValFormatJSON
                                            , kParamKeyList : _Lists ?: @""
                                            , kParamContinue : _Continuation ?: @""
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

            WikiContinuation* continuation =
                [ WikiContinuation __continuationWithJSONDict: resultsJSONDict[ @"continue" ] ];

            if ( _SuccessBlock )
                _SuccessBlock( results, continuation, ( resultsJSONDict[ kParamValBatchComplete ] != nil ) );
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }       stopAllOtherTasks: _WillStop ];
    }

- ( WikiQueryTask* ) queryByGeneratorList: ( NSString* )_ListName
                           listParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_ListParamsDict
                 realPagesQueryParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_PagesQueryParamDict
                             continuation: ( WikiContinuation* )_Continuation
                                  success: ( void (^)( __SugarArray_of( WikiPage* ) _Results
                                           , WikiContinuation* _Continuation
                                           , BOOL _IsBatchComplete ) )_SuccessBlock
                                  failure: ( void (^)( NSError* _Error ) )_FailureBlock
                        stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _ListName.length > 0 ) && ( _ListParamsDict.count > 0 ) );

    NSMutableDictionary* finalParamsDict = [ NSMutableDictionary dictionaryWithDictionary:
        @{ kParamKeyGenerator : _ListName
         , kParamKeyAction : kParamValActionQuery
         , kParamKeyFormat : kParamValFormatJSON
         , kParamContinue : _Continuation ?: @""
         } ];

    NSMutableDictionary* generatorParams = [ NSMutableDictionary dictionaryWithCapacity: _ListParamsDict.count ];
    for ( NSString* _Key in _ListParamsDict )
        [ generatorParams addEntriesFromDictionary: @{ [ @"g" stringByAppendingString: _Key ] :  _ListParamsDict[ _Key ] } ];

    [ finalParamsDict addEntriesFromDictionary: generatorParams ];
    [ finalParamsDict addEntriesFromDictionary: ( ( _PagesQueryParamDict.count > 0 ) ? _PagesQueryParamDict : self->__pageQueryGeneralPropParams ) ];

    return [ self fetchResourceWithParameters: finalParamsDict
                                   HTTPMethod: kGET
                                      success:
        ^( WikiQueryTask* __nonnull _QueryTask, id  __nonnull _ResponseObject )
            {
            NSDictionary* resultsJSONDict = ( NSDictionary* )_ResponseObject;
            NSDictionary* pageResultsJSONDict = resultsJSONDict[ kParamValActionQuery ][ kParamValListPages ];

            __SugarMutableArray_of( WikiPage* ) finalResults = [ NSMutableArray array ];
            for ( NSDictionary* _WikiPageJSONDict in pageResultsJSONDict )
                {
                WikiPage* wikiPage = [ WikiPage __pageWithJSONDict: pageResultsJSONDict[ _WikiPageJSONDict ] ];

                if ( wikiPage )
                    [ finalResults addObject: wikiPage ];
                }

            WikiContinuation* continuation =
                [ WikiContinuation __continuationWithJSONDict: resultsJSONDict[ @"continue" ] ];

            if ( _SuccessBlock )
                _SuccessBlock( finalResults, continuation, ( resultsJSONDict[ kParamValBatchComplete ] != nil ) );
            } failure:
                ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }       stopAllOtherTasks: _WillStop ];
    }

- ( WikiQueryTask* ) queryProperties: ( __SugarArray_of( NSString* ) )_PropValues
                     otherParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_ParamsDict
                        continuation: ( WikiContinuation* )_Continuation
                             success: ( void (^)( __SugarArray_of( WikiPage* ) _Results
                                      , WikiContinuation* _Continuation
                                      , BOOL _IsBatchComplete ) )_SuccessBlock
                             failure: ( void (^)( NSError* _Error ) )_FailureBlock
                   stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _PropValues.count > 0 ) && ( _ParamsDict.count > 0 ) );

    NSMutableDictionary* paramsDict = [ NSMutableDictionary dictionaryWithDictionary: _ParamsDict ];
    [ paramsDict addEntriesFromDictionary: @{ kParamKeyAction : kParamValActionQuery
                                            , kParamKeyFormat : kParamValFormatJSON
                                            , kParamKeyProp : _PropValues
                                            , kParamContinue : _Continuation ?: @""
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

            WikiContinuation* continuation =
                [ WikiContinuation __continuationWithJSONDict: resultsJSONDict[ @"continue" ] ];

            if ( _SuccessBlock )
                _SuccessBlock( results, continuation, ( resultsJSONDict[ kParamValBatchComplete ] != nil ) );
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
                                   usesGenerator: ( BOOL )_UsesGenerator
                                    continuation: ( WikiContinuation* )_Continuation
                                         success: ( void (^)( __SugarArray_of( WikiJSONObject* )
                                                  , WikiContinuation* _Continuation
                                                  , BOOL _IsBatchComplete ) )_SuccessBlock
                                         failure: ( void (^)( NSError* _Error ) )_FailureBlock
                               stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _SearchValue.length > 0 ) );

    NSDictionary* parameters = @{ @"srsearch" : _SearchValue
                                , @"srprop" : self->__srprop
                                , @"srlimit" : @( _Limit ).stringValue
                                , @"srnamespace" : _Namespaces ?: @"0"
                                };

    WikiQueryTask* queryTask = nil;

    if ( _UsesGenerator )
        {
        queryTask = [ self queryByGeneratorList: kParamValListSearch
                                 listParameters: parameters
                       realPagesQueryParameters: self->__pageQueryGeneralPropParams
                                   continuation: _Continuation
                                        success:
            ^ ( __SugarArray_of( WikiPage* )_Results
              , WikiContinuation* _Continuation
              , BOOL _IsBatchComplete )
                {
                if ( _SuccessBlock )
                    _SuccessBlock( _Results, _Continuation, _IsBatchComplete );
                } failure: ^( NSError* _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }         stopAllOtherTasks: _WillStop ];
        }
    else
        {
        queryTask = [ self queryLists: @[ kParamValListSearch ]
                                limit: 10
                      otherParameters: parameters
                         continuation: _Continuation
                              success:
            ^( __SugarDictionary_of( NSString*, __SugarArray_of( WikiJSONObject* ) ) _Results
             , WikiContinuation* _Continuation
             , BOOL _IsBatchComplete )
                {
                if ( _SuccessBlock )
                    _SuccessBlock( _Results[ kParamValListSearch ], _Continuation, _IsBatchComplete );
                } failure:
                    ^( NSError* _Error )
                        {
                        if ( _Error && _FailureBlock )
                            _FailureBlock( _Error );
                        }
               stopAllOtherTasks: _WillStop ];
        }

    return queryTask;
    }

#pragma mark Pages
- ( WikiQueryTask* ) pagesWithTitles: ( __SugarArray_of( NSString* ) )_Titles
                       parseRevision: ( BOOL )_ParseRevision
                        continuation: ( WikiContinuation* )_Continuation
                             success: ( void (^)( __SugarArray_of( WikiPage* ) _MatchedPage
                                      , WikiContinuation* _Continuation
                                      , BOOL _IsBatchComplete ) )_SuccessBlock
                             failure: ( void (^)( NSError* _Error ) )_FailureBlock
                   stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _Titles.count > 0 ) );

    __SugarArray_of( NSString* ) finalTitles = _Titles;
    __SugarMutableDictionary_of( NSString*, NSString* ) finalParams =
        [ NSMutableDictionary dictionaryWithDictionary: self->__pageQueryGeneralPropParams ];

    if ( _ParseRevision )
        {
        finalTitles = [ finalTitles subarrayWithRange: NSMakeRange( 0, 1 ) ];
        [ finalParams addEntriesFromDictionary: @{ kParamParseRevision : @"" } ];
        }

    NSMutableDictionary* parameters = [ NSMutableDictionary dictionaryWithObject: finalTitles forKey: @"titles" ];
    [ parameters addEntriesFromDictionary: finalParams ];

    return [ self queryProperties: self->__pageQueryGeneralProps
                  otherParameters: parameters
                     continuation: _Continuation
                          success:
        ^( __SugarArray_of( WikiPage* ) _Results, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
            {
            if ( _SuccessBlock )
                _SuccessBlock( _Results, _Continuation, _IsBatchComplete );
            } failure:
                ^( NSError* _Error )
                    {
                    if ( _Error && _FailureBlock )
                        _FailureBlock( _Error );
                    }
          stopAllOtherTasks: _WillStop ];
    }

- ( WikiQueryTask* ) pagesWithPageIDs: ( __SugarArray_of( NSNumber* ) )_PageIDs
                        parseRevision: ( BOOL )_ParseRevision
                         continuation: ( WikiContinuation* )_Continuation
                              success: ( void (^)( __SugarArray_of( WikiPage* ) _MatchedPage
                                       , WikiContinuation* _Continuation
                                       , BOOL _IsBatchComplete ) )_SuccessBlock
                              failure: ( void (^)( NSError* _Error ) )_FailureBlock
                    stopAllOtherTasks: ( BOOL )_WillStop
    {
    NSParameterAssert( ( _PageIDs.count > 0 ) );

    __SugarArray_of( NSNumber* ) finalIDs = _PageIDs;
    __SugarMutableDictionary_of( NSString*, NSString* ) finalParams =
        [ NSMutableDictionary dictionaryWithDictionary: self->__pageQueryGeneralPropParams ];

    if ( _ParseRevision )
        {
        finalIDs = [ finalIDs subarrayWithRange: NSMakeRange( 0, 1 ) ];
        [ finalParams addEntriesFromDictionary: @{ kParamParseRevision : @"" } ];
        }

    NSMutableDictionary* parameters = [ NSMutableDictionary dictionaryWithObject: finalIDs forKey: @"pageids" ];
    [ parameters addEntriesFromDictionary: finalParams ];

    return [ self queryProperties: self->__pageQueryGeneralProps
                  otherParameters: parameters
                     continuation: _Continuation
                          success:
        ^( __SugarArray_of( WikiPage* ) _Results, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
            {
            if ( _SuccessBlock )
                _SuccessBlock( _Results, _Continuation, _IsBatchComplete );
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
                                , @"aiprop" : self->__aiprop
                                , @"ailimit" : @"1"
                                };

    return [ self queryLists: @[ kParamValListAllImages ]
                       limit: 1
             otherParameters: parameters
                continuation: nil
                     success:
        ^( __SugarDictionary_of( NSString*, __SugarArray_of( WikiJSONObject* ) ) _Results
                               , WikiContinuation* _Continuation
                               , BOOL _IsBatchComplete )
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
    if ( self = [ self init ] )
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

- ( NSDictionary* ) __normalizedParameters: ( __SugarDictionary_of( NSString*, NSString* ) )_UnnormalizedParams
    {
    NSMutableDictionary* normalizedParams = [ NSMutableDictionary dictionaryWithCapacity: _UnnormalizedParams.count ];
    for ( NSString* _ParamName in _UnnormalizedParams )
        {
        id paramValue = _UnnormalizedParams[ _ParamName ];

        if ( [ paramValue isKindOfClass: [ NSArray class ] ] )
            [ normalizedParams addEntriesFromDictionary: @{ _ParamName : [ paramValue componentsJoinedByString: @"|" ] } ];

        else if ( [ paramValue isKindOfClass: [ NSString class ] ] )
            [ normalizedParams addEntriesFromDictionary: @{ _ParamName : paramValue } ];

        else if ( [ paramValue isKindOfClass: [ NSNumber class ] ] )
            [ normalizedParams addEntriesFromDictionary: @{ _ParamName : [ ( NSNumber* )paramValue stringValue ] } ];

        else if ( [ paramValue isKindOfClass: [ WikiContinuation class ] ] )
            {
            WikiContinuation* continuation = ( WikiContinuation* )paramValue;

            if ( continuation.isInitial )
                [ normalizedParams addEntriesFromDictionary: @{ _ParamName : @"" } ];
            else
                [ normalizedParams addEntriesFromDictionary: [ continuation continuations ] ];
            }
        }

    return [ normalizedParams copy ];
    }

@end // WikiEngine class

// WikiEngine + SugarWikiPrivate
@implementation WikiEngine ( SugarWikiPrivate )

@dynamic __pageQueryGeneralPropParams;

#pragma mark Dynamic Properties
- ( __SugarDictionary_of( NSString*, NSString* ) ) __pageQueryGeneralPropParams
    {
    return self->__pageQueryGeneralPropParams;
    }

- ( __SugarArray_of( NSString* ) ) __pageQueryGeneralProps
    {
    return self->__pageQueryGeneralProps;
    }

@end // WikiEngine + SugarWikiPrivate

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