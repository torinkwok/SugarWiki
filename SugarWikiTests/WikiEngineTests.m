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

#import "SugarWikiTestCase.h"

@import XCTest;

// Utility Functions
void WikiFulfillExpectation( XCTestExpectation* _Expection );

// WikiEngineTests class
@interface WikiEngineTests : SugarWikiTestCase
@end

@implementation WikiEngineTests

- ( void ) setUp
    {
    [ super setUp ];
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];
    }

- ( void ) test_engineWithISOLanguageCode_
    {
    for ( NSString* _LauguageCode in _languageCodesSamples0 )
        {
        WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: _LauguageCode ];
        XCTAssertNotNil( positiveTestCase );

        NSURL* positiveEndpoint0 = positiveTestCase.endpoint;
        XCTAssertNotNil( positiveEndpoint0 );

        XCTestExpectation* jsonException = [ self expectationWithDescription: [ NSString stringWithFormat: @"JSON Exception (%@) \nParas: ?%@", positiveEndpoint0, _parametersSamples0 ] ];
        NSURLSessionDataTask* positiveSessionDataTask0 =
            [ self->_httpSessionManager GET: positiveEndpoint0.absoluteString
                                 parameters: _parametersSamples0
                                    success:
            ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
                {
                NSLog( @"%@", _ResponseObject );
                [ jsonException fulfill ];
                }
                                    failure:
            ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
                {
                NSLog( @"%@", _Error );
                } ];

        [ positiveSessionDataTask0 resume ];

        [ self waitForExpectationsWithTimeout: 15
                                      handler:
            ^( NSError* __nullable _Error )
                {
                if ( !_Error )
                    NSLog( @"✅Succeeded to test execute asynchronously" );
                else
                    NSLog( @"❌Failed to test execute asynchronously: %@", _Error );

                XCTAssertNil( _Error );
                } ];

        XCTAssertNotNil( positiveTestCase.wikiHTTPSessionManager );
        XCTAssertNotNil( positiveTestCase.ISOLanguageCode );
        }
    }

- ( void ) test_commonsEngine_
    {
    WikiEngine* positiveTestCase = [ WikiEngine commonsEngine ];

    NSURL* positiveEndpoint0 = positiveTestCase.endpoint;
    XCTAssertNotNil( positiveEndpoint0 );

    XCTestExpectation* jsonException = [ self expectationWithDescription: [ NSString stringWithFormat: @"JSON Exception (%@) \nParas: ?%@", positiveEndpoint0, self->_parametersSamples0 ] ];
    NSURLSessionDataTask* positiveSessionDataTask0 =
        [ self->_httpSessionManager GET: positiveEndpoint0.absoluteString
                             parameters: self->_parametersSamples0
                                success:
        ^( NSURLSessionDataTask* __nonnull _Task, id  __nonnull _ResponseObject )
            {
            NSLog( @"%@", _ResponseObject );
            [ jsonException fulfill ];
            }
                                failure:
        ^( NSURLSessionDataTask* __nonnull _Task, NSError* __nonnull _Error )
            {
            NSLog( @"%@", _Error );
            } ];

    [ positiveSessionDataTask0 resume ];

    [ self waitForExpectationsWithTimeout: 15
                                  handler:
        ^( NSError* __nullable _Error )
            {
            if ( !_Error )
                NSLog( @"✅Succeeded to test execute asynchronously" );
            else
                NSLog( @"❌Failed to test execute asynchronously: %@", _Error );

            XCTAssertNil( _Error );
            } ];

    XCTAssertNotNil( positiveTestCase.wikiHTTPSessionManager );
    XCTAssertNil( positiveTestCase.ISOLanguageCode );
    }

- ( void ) test_queryLists_genericMethod_
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int index = 0;
    for ( __SugarArray_of( NSString* ) _PosSample in self->_posListNameSamples )
        {
        WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
        BOOL __block isCompleteBatch = NO;

        while ( !continuation.isCompleted && !isCompleteBatch )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", index ] ];
            WikiQueryTask* WikiQueryTask =
            [ positiveTestCase queryLists: _PosSample
                                    limit: 10
                          otherParameters: self->_posListParamsSamples[ index ]
                             continuation: continuation
                                  success:
                ^( __SugarDictionary_of( NSString*, __SugarArray_of( WikiJSONObject* ) ) _Results
                                       , WikiContinuation* _Continuation
                                       , BOOL _IsBatchComplete )
                    {
                    continuation = _Continuation;
                    isCompleteBatch = _IsBatchComplete;
                    [ self testWikiContinuation: continuation ];

                    XCTAssertNotNil( _Results );
                    XCTAssert( _Results.count <= _PosSample.count );

                    for ( NSString* _OriginalSampleListName in _PosSample )
                        {
                        // Be sure that the _Result do contain all the original sample list names
                        __SugarArray_of( WikiJSONObject* ) genericJSONObjects = _Results[ _OriginalSampleListName ];
                        XCTAssert( genericJSONObjects || !genericJSONObjects );
                        XCTAssert( genericJSONObjects.count >= 0 );

                        for ( WikiJSONObject* _GenericJSONObject in genericJSONObjects )
                            [ self testGenericWikiJSONObject: _GenericJSONObject ];
                        }

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }
                        stopAllOtherTasks: NO ];

            [ self testReturnedWikiQueryTask: WikiQueryTask ];

            [ self waitForExpectationsWithTimeout: 15
                                          handler:
                ^( NSError* __nullable _Error )
                    {
                    if ( _Error )
                        NSLog( @"%@", _Error );
                    } ];
            }

        index++;
        }
    }

- ( void ) test_pos_generator_genericMethod_
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int index = 0;
    for ( NSString* _PosSample in self->_posGeneratorListNameSamples )
        {
        WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
        BOOL __block isBatchComplete = NO;

        while ( !continuation.isCompleted && !isBatchComplete )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", index ] ];
            WikiQueryTask* WikiQueryTask =
            [ positiveTestCase queryByGeneratorList: _PosSample
                                     listParameters: self->_posGeneratorListParamsSamples[ index ]
                           realPagesQueryParameters: self->_posGeneratorRealPageQueryParamsSamples[ index ]
                                       continuation: continuation
                                            success:
                ^( __SugarArray_of( WikiPage* ) _Results, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                    {
                    continuation = _Continuation;
                    isBatchComplete = _IsBatchComplete;
                    [ self testWikiContinuation: continuation ];

                    for ( WikiPage* _WikiPage in _Results )
                        [ self testWikiPage: _WikiPage info: nil ];

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }
                        stopAllOtherTasks: NO ];

            [ self testReturnedWikiQueryTask: WikiQueryTask ];

            [ self waitForExpectationsWithTimeout: 15
                                          handler:
                ^( NSError* __nullable _Error )
                    {
                    if ( _Error )
                        NSLog( @"%@", _Error );
                    } ];
            }

        index++;
        }
    }

- ( void ) test_pos_queryProperties_genericMethod_
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    NSMutableArray* posSamples = [ NSMutableArray arrayWithCapacity: self->_posTitleSamples.count + self->_posPageIDSamples.count ];
    [ posSamples addObjectsFromArray: self->_posTitleSamples ];
    [ posSamples addObjectsFromArray: self->_posPageIDSamples ];
    for ( __SugarArray_of( NSObject* ) _PosSample in posSamples )
        {
        int index = 0;
        for ( __SugarArray_of( NSString* ) _PropSample in self->_posQueryPropSamples )
            {
            WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
            BOOL __block isBatchComplete = NO;

            NSArray __block* mergedWikiPages = nil;

            while ( !continuation.isCompleted && !isBatchComplete )
                {
                XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", index ] ];

                NSMutableArray* queryProps = [ NSMutableArray arrayWithArray: positiveTestCase.__pageQueryGeneralProps ];
                [ queryProps addObjectsFromArray: _PropSample ];

                NSMutableDictionary* parameters = [ NSMutableDictionary dictionary ];

                [ parameters addEntriesFromDictionary: @{ [ _PosSample.firstObject isKindOfClass: [ NSNumber class ] ] ? @"pageids" : @"titles" : _PosSample } ];
                [ parameters addEntriesFromDictionary: positiveTestCase.__pageQueryGeneralPropParams ];
                [ parameters addEntriesFromDictionary: self->_posQueryPropParamSamples[ index ] ];

                WikiQueryTask* WikiQueryTask =
                    [ positiveTestCase queryProperties: queryProps
                                       otherParameters: parameters
                                          continuation: continuation
                                               success:
                    ^( __SugarArray_of( WikiPage* ) _WikiPages, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                        {
                        if ( !mergedWikiPages )
                            mergedWikiPages = _WikiPages;
                        else
                            [ mergedWikiPages mergeWikiObjectsFrom: _WikiPages ];

                        continuation = _Continuation;
                        isBatchComplete = _IsBatchComplete;

                        [ self testWikiContinuation: continuation ];

                        XCTAssertNotNil( mergedWikiPages );
                        XCTAssertEqual( mergedWikiPages.count, _PosSample.count );
                        NSLog( @">>> (Log🐑) Matched Pages Count vs. Positive Sample Count: %lu vs. %lu", mergedWikiPages.count, _PosSample.count );

                        for ( WikiPage* _WikiPage in mergedWikiPages )
                            [ self testWikiPage: _WikiPage info: nil ];

                        WikiFulfillExpectation( jsonExpectation );
                        } failure:
                            ^( NSError* _Error )
                                {
                                NSLog( @"❌%@", _Error );
                                }    stopAllOtherTasks: NO ];

                [ self testReturnedWikiQueryTask: WikiQueryTask ];

                [ self waitForExpectationsWithTimeout: 15
                                              handler:
                    ^( NSError* __nullable _Error )
                        {
                        if ( _Error )
                            NSLog( @"%@", _Error );
                        } ];
                }

            index++;
            }
        }
    }

- ( void ) test_pos_search_without_generator
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __SugarArray_of( NSString* ) _PosSample in self->_posTitleSamples )
        {
        for ( NSString* _TitleSample in _PosSample )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];
            WikiQueryTask* WikiQueryTask =
            [ positiveTestCase searchAllPagesThatHaveValue: _TitleSample
                                              inNamespaces: nil
                                                  approach: WikiEngineSearchApproachPageText
                                                     limit: 10
                                             usesGenerator: NO
                                              continuation: nil
                                                   success:
                ^( __SugarArray_of( WikiSearchResult* ) _Results, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                    {
                    XCTAssertNotNil( _Results );

                    for ( WikiSearchResult* _SearchResult in _Results )
                        [ self testSearchResult: _SearchResult ];

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }    stopAllOtherTasks: NO ];

            [ self testReturnedWikiQueryTask: WikiQueryTask ];

            [ self waitForExpectationsWithTimeout: 15
                                          handler:
                ^( NSError* __nullable _Error )
                    {
                    if ( _Error )
                        NSLog( @"%@", _Error );
                    } ];

            count++;
            }
        }
    }

- ( void ) test_pos_search_with_generator
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __SugarArray_of( NSString* ) _PosSample in self->_posTitleSamples )
        {
        for ( NSString* _TitleSample in _PosSample )
            {
            WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
            BOOL __block isBatchComplete = NO;

            if ( !continuation.isCompleted )
                {
                XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];
                WikiQueryTask* WikiQueryTask =
                [ positiveTestCase searchAllPagesThatHaveValue: _TitleSample
                                                  inNamespaces: nil
                                                      approach: WikiEngineSearchApproachPageText
                                                         limit: 10
                                                 usesGenerator: YES
                                                  continuation: continuation
                                                       success:
                    ^( __SugarArray_of( WikiPage* ) _ResultPages, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                        {
                        XCTAssertNotNil( _ResultPages );

                        continuation = _Continuation;
                        isBatchComplete = _IsBatchComplete;
                        [ self testWikiContinuation: continuation ];

                        for ( WikiPage* _WikiPage in _ResultPages )
                            [ self testWikiPage: _WikiPage info: nil ];

                        WikiFulfillExpectation( jsonExpectation );
                        } failure:
                            ^( NSError* _Error )
                                {
                                NSLog( @"❌%@", _Error );
                                }    stopAllOtherTasks: NO ];

                [ self testReturnedWikiQueryTask: WikiQueryTask ];

                [ self waitForExpectationsWithTimeout: 15
                                              handler:
                    ^( NSError* __nullable _Error )
                        {
                        if ( _Error )
                            NSLog( @"%@", _Error );
                        } ];
                }

            count++;
            }
        }
    }

- ( void ) test_pos_pages_with_titles
    {
    [ self pagesWithTitlesWithParseRevision: YES ];
    [ self pagesWithTitlesWithParseRevision: NO ];
    }

- ( void ) test_pos_pages_with_pageIDs
    {
    [ self pagesWithPageIDsWithParseRevision: YES ];
    [ self pagesWithPageIDsWithParseRevision: NO ];
    }

- ( void ) pagesWithTitlesWithParseRevision: ( BOOL )_YesOrNO
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __SugarArray_of( NSString* ) _PosSample in self->_posTitleSamples )
        {
        WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
        BOOL __block isBatchComplete = NO;

        NSArray __block* mergedWikiPages = nil;
        while ( !continuation.isCompleted && !isBatchComplete )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];

            WikiQueryTask* wikiQueryTask =
                [ positiveTestCase pagesWithTitles: _PosSample
                                 parseLastRevision: _YesOrNO
                                      continuation: nil
                                           success:
                ^( NSArray* _MatchedPages, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                    {
                    if ( !mergedWikiPages )
                        mergedWikiPages = _MatchedPages;
                    else
                        [ mergedWikiPages mergeWikiObjectsFrom: _MatchedPages ];

                    continuation = _Continuation;
                    isBatchComplete = _IsBatchComplete;
                    [ self testWikiContinuation: continuation ];

                    XCTAssertNotNil( mergedWikiPages );

                    if ( _YesOrNO )
                        XCTAssertEqual( mergedWikiPages.count, 1 );
                    else
                        XCTAssertEqual( mergedWikiPages.count, _PosSample.count );
                    NSLog( @">>> (Log🐑) Matched Pages Count vs. Positive Sample Count: %lu vs. %lu", mergedWikiPages.count, _PosSample.count );

                    for ( WikiPage* _WikiPage in mergedWikiPages )
                        [ self testWikiPage: _WikiPage info: @{ kParsedWikiText : @( _YesOrNO ) } ];

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }    stopAllOtherTasks: NO ];

            [ self testReturnedWikiQueryTask: wikiQueryTask ];

            [ self waitForExpectationsWithTimeout: 15000
                                          handler:
                ^( NSError* __nullable _Error )
                    {
                    if ( _Error )
                        NSLog( @"%@", _Error );
                    } ];
            }

        count++;
        }
    }

- ( void ) pagesWithPageIDsWithParseRevision: ( BOOL )_YesOrNO
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __SugarArray_of( NSNumber* ) _PosSample in self->_posPageIDSamples )
        {
        WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
        BOOL __block isBatchComplete = NO;

        NSArray __block* mergedWikiPages = nil;
        while ( !continuation.isCompleted && !isBatchComplete )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];

            WikiQueryTask* WikiQueryTask =
                [ positiveTestCase pagesWithPageIDs: _PosSample
                                  parseLastRevision: _YesOrNO
                                       continuation: nil
                                            success:
                ^( NSArray* _MatchedPages, WikiContinuation* _Continuation, BOOL _IsBatchComplete )
                    {
                    if ( !mergedWikiPages )
                        mergedWikiPages = _MatchedPages;
                    else
                        [ mergedWikiPages mergeWikiObjectsFrom: _MatchedPages ];

                    continuation = _Continuation;
                    isBatchComplete = _IsBatchComplete;
                    [ self testWikiContinuation: continuation ];

                    XCTAssertNotNil( _MatchedPages );

                    if ( _YesOrNO )
                        XCTAssertEqual( mergedWikiPages.count, 1 );
                    else
                        XCTAssertEqual( _MatchedPages.count, _PosSample.count );
                    NSLog( @">>> (Log🐑) Matched Pages Count vs. Positive Sample Count: %lu vs. %lu", _MatchedPages.count, _PosSample.count );

                    for ( WikiPage* _WikiPage in _MatchedPages )
                        [ self testWikiPage: _WikiPage info: @{ kParsedWikiText : @( _YesOrNO ) } ];

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }    stopAllOtherTasks: NO ];

            [ self testReturnedWikiQueryTask: WikiQueryTask ];

            [ self waitForExpectationsWithTimeout: 15
                                          handler:
                ^( NSError* __nullable _Error )
                    {
                    if ( _Error )
                        NSLog( @"%@", _Error );
                    } ];
            }

        count++;
        }
    }

- ( void ) test_pos_fetchImage_success_failure_
    {
    XCTestExpectation* jsonExpectation0 = [ self expectationWithDescription: @"🌋JSON Exception 0⃣️" ];

    WikiQueryTask* WikiQueryTask = nil;

    WikiEngine* positiveTestCase = [ WikiEngine commonsEngine ];
    WikiQueryTask =
        [ positiveTestCase fetchImage: @"CPP ‒ Convention People's Party logo.jpg"
                              success:
        ^( WikiImage* _Image )
            {
            [ self testWikiImage: _Image ];
            WikiFulfillExpectation( jsonExpectation0 );
            } failure:
                ^( NSError* _Error )
                    {
                    NSLog( @"❌%@", _Error );
                    }
                    stopAllOtherTasks: NO ];

    [ self testReturnedWikiQueryTask: WikiQueryTask ];

    [ self waitForExpectationsWithTimeout: 15
                                  handler:
        ^( NSError* __nullable _Error )
            {
            NSLog( @"%@", _Error );
            } ];
    }

@end // WikiEngineTests class

// Utility Functions
void WikiFulfillExpectation( XCTestExpectation* _Expection )
    {
    NSLog( @"🍺Fulfilled %@(%p)", _Expection, _Expection );
    [ _Expection fulfill ];
    }

/*===============================================================================┐
|                                                                                |
|                           The MIT License (MIT)                                |
|                                                                                |
|                        Copyright (c) 2015 Tong Kuo                             |
|                                                                                |
| Permission is hereby granted, free of charge, to any person obtaining a copy   |
| of this software and associated documentation files (the "Software"), to deal  |
| in the Software without restriction, including without limitation the rights   |
| to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      |
|   copies of the Software, and to permit persons to whom the Software is        |
|         furnished to do so, subject to the following conditions:               |
|                                                                                |
| The above copyright notice and this permission notice shall be included in all |
|              copies or substantial portions of the Software.                   |
|                                                                                |
| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     |
| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       |
| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    |
|  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        |
| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
| OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                 SOFTWARE.                                      |
|                                                                                |
└===============================================================================*/