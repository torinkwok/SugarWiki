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
#import "WikiPage.h"
#import "WikiImage.h"
#import "WikiSearchResult.h"
#import "WikiRevision.h"
#import "WikiQueryTask.h"
#import "SugarWikiDefines.h"
#import "AFNetworking.h"
#import "WikiContinuation.h"

#import "__WikiEngine.h"

@import XCTest;

// Utility Functions
void WikiFulfillExpectation( XCTestExpectation* _Expection );

// WikiEngineTests class
@interface WikiEngineTests : XCTestCase
    {
    AFHTTPSessionManager __strong* _httpSessionManager;

    // Samples 0
    NSArray __strong* _languageCodesSamples0;
    NSDictionary __strong* _parametersSamples0;

    __NSArray_of( __NSArray_of( NSString* ) ) _posTitleSamples;
    __NSArray_of( __NSArray_of( NSNumber* ) ) _posPageIDSamples;

    __NSArray_of( __NSArray_of( NSString* ) ) _posQueryPropSamples;
    __NSArray_of( __NSDictionary_of( NSString*, NSString* ) ) _posQueryPropParamSamples;

    __NSArray_of( __NSArray_of( NSString* ) ) _posListNameSamples;
    __NSArray_of( __NSDictionary_of( NSString*, NSString* ) ) _posListParamsSamples;
    }

@end

// Private Interfaces
@interface WikiEngineTests ()

- ( void ) _testReturnedWikiQueryTask: ( WikiQueryTask* )_WikiQueryTask;
- ( void ) _testGenericWikiJSONObject: ( WikiJSONObject* )_WikiJSONObject;
- ( void ) _testWikiPage: ( WikiPage* )_Page;
- ( void ) _testWikiImage: ( WikiImage* )_Image;

@end // Private Interfaces

@implementation WikiEngineTests

- ( void ) setUp
    {
    [ super setUp ];

    self->_httpSessionManager = [ [ AFHTTPSessionManager alloc ] initWithSessionConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];
    AFJSONResponseSerializer* JSONSerializer = [ [ AFJSONResponseSerializer alloc ] init ];
    [ self->_httpSessionManager setResponseSerializer: JSONSerializer ];

    // Samples 0
    self->_languageCodesSamples0 = @[ @"en", @"zh", @"fr", @"ja", @"de" ];
    self->_parametersSamples0 = @{ @"action" : @"query"
                                 , @"meta" : @"siteinfo"
                                 , @"format" : @"json"
                                 , @"sipro" : @"general|languages|namespaces"
                                 };

    self->_posTitleSamples = @[ @[ @"C++", @"Ruby", @"C", @"Madonna in the Church", @"Ada (programming language)", @"Type system" ]
                              , @[ @"Subroutine", @"Computer programming", @"Machine code", @"Barack Obama", @"Python (programming language)" ]
                              , @[ @"Compiler", @"Central processing unit", @"Syria", @"Syria-Cilicia commemorative medal", @"Syria-Lebanon Campaign order of battle" ]
                              , @[ @"Integrated circuit", @"Microprocessor", @"Semiconductor", @"Insulator (electricity)", @"Syria Fed Cup team" ]
                              , @[ @"Otto Pérez Molina", @"President of Guatemala", @"Taiwan", @"Kuomintang" ]
                              ];

    self->_posPageIDSamples = @[ @[ @7515928, @43093687, @12816866, @10523677, @43472938, @888445 ]
                               , @[ @5405, @28883152, @33099762, @33984313, @28175590 ]
                               , @[ @19001, @6902276, @6147074, @29287604, @46349164 ]
                               , @[ @14227967, @19961416, @7813116, @1955, @10280979 ]
                               , @[ @856, @8260899, @31290263, @615972, @14653, @9008741, @40479341, @28320793, @46256893 ]
                               ];

    self->_posQueryPropSamples = @[ // 0)
                                    @[ @"fileusage", @"extlinks" ]
                                 ];

    self->_posQueryPropParamSamples = @[ // 0)
                                         @{ @"fuprop" : @"pageid|title|redirect"
                                          , @"fulimit" : @"10"
                                          , @"ellimit" : @"10"
                                          , @"eloffset" : @""
                                          , @"fucontinue" : @""
                                          }
                                      ];


    self->_posListNameSamples = @[ // 0)
//                                   @[ @"backlinks", @"random" ]

                                   // 1)
                                  @[ @"allcategories" ]
                                 ];

    self->_posListParamsSamples = @[ // 0)
//                                     @{ /*@"bltitle" : @"C++"*/
//                                        @"rnlimit" : @"10"
//                                      , @"aifrom" : @"C++"
//                                      , @"affrom" : @"C++"
//                                      }

                                     // 1)
                                    @{ @"acprop" : @"size|hidden"
                                     , @"aclimit" : @"10"
                                     , @"acprefix" : @"C++"
                                     }
                                   ];
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

        [ self waitForExpectationsWithTimeout: 150
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

    [ self waitForExpectationsWithTimeout: 150
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

- ( void ) test_queryLists_genericMethod
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __NSArray_of( NSString* ) _PosSample in self->_posListNameSamples )
        {
        WikiContinuation __block* continuation = [ WikiContinuation initialContinuation ];
        XCTAssertTrue( continuation.isInitial );
        XCTAssertFalse( continuation.isCompleted );

        while ( !continuation.isCompleted )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];
            WikiQueryTask* WikiQueryTask =
            [ positiveTestCase queryLists: _PosSample
                                    limit: 10
                          otherParameters: self->_posListParamsSamples[ count ]
                             continuation: continuation
                                  success:
                ^( __NSDictionary_of( NSString*, __NSArray_of( WikiJSONObject* ) ) _Results, WikiContinuation* _Continuation )
                    {
                    continuation = _Continuation;

                    XCTAssertNotNil( _Results );
                    XCTAssertEqual( _Results.count, _PosSample.count );

                    for ( NSString* _OriginalSampleListName in _PosSample )
                        {
                        // Be sure that the _Result do contain all the original sample list names
                        __NSArray_of( WikiJSONObject* ) genericJSONObjects = _Results[ _OriginalSampleListName ];
                        XCTAssertNotNil( genericJSONObjects );
                        XCTAssertGreaterThan( genericJSONObjects.count, 0 );

                        for ( WikiJSONObject* _GenericJSONObject in genericJSONObjects )
                            [ self _testGenericWikiJSONObject: _GenericJSONObject ];
                        }

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }
                        stopAllOtherTasks: NO ];

            [ self _testReturnedWikiQueryTask: WikiQueryTask ];

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

- ( void ) test_pos_queryProperties_genericMethod
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    NSMutableArray* posSamples = [ NSMutableArray arrayWithCapacity: self->_posTitleSamples.count + self->_posPageIDSamples.count ];
    [ posSamples addObjectsFromArray: self->_posTitleSamples ];
    [ posSamples addObjectsFromArray: self->_posPageIDSamples ];
    for ( __NSArray_of( NSObject* ) _PosSample in posSamples )
        {
        int count = 0;
        for ( __NSArray_of( NSString* ) _PropSample in self->_posQueryPropSamples )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];

            NSMutableArray* queryProps = [ NSMutableArray arrayWithArray: positiveTestCase.__pageQueryGeneralProps ];
            [ queryProps addObjectsFromArray: _PropSample ];

            NSMutableDictionary* parameters = [ NSMutableDictionary dictionary ];

            [ parameters addEntriesFromDictionary: @{ [ _PosSample.firstObject isKindOfClass: [ NSNumber class ] ] ? @"pageids" : @"titles" : _PosSample } ];
            [ parameters addEntriesFromDictionary: positiveTestCase.__pageQueryGeneralPropParams ];
            [ parameters addEntriesFromDictionary: self->_posQueryPropParamSamples[ count ] ];

            WikiQueryTask* WikiQueryTask =
                [ positiveTestCase queryProperties: queryProps
                                   otherParameters: parameters
                                           success:
                ^( __NSArray_of( WikiPage* ) _WikiPages )
                    {
                    XCTAssertNotNil( _WikiPages );
                    XCTAssertEqual( _WikiPages.count, _PosSample.count );
                    NSLog( @">>> (Log🐑) Matched Pages Count vs. Positive Sample Count: %lu vs. %lu", _WikiPages.count, _PosSample.count );

                    for ( WikiPage* _WikiPage in _WikiPages )
                        [ self _testWikiPage: _WikiPage ];

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {
                            NSLog( @"❌%@", _Error );
                            }    stopAllOtherTasks: NO ];

            [ self _testReturnedWikiQueryTask: WikiQueryTask ];

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

- ( void ) test_pos_search
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __NSArray_of( NSString* ) _PosSample in self->_posTitleSamples )
        {
        for ( NSString* _TitleSample in _PosSample )
            {
            XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];
            WikiQueryTask* WikiQueryTask =
            [ positiveTestCase searchAllPagesThatHaveValue: _TitleSample
                                              inNamespaces: nil
                                                  approach: WikiEngineSearchApproachPageText
                                                     limit: 10
                                                   success:
                ^( NSArray* _Results )
                    {
                    XCTAssertNotNil( _Results );

                    for ( WikiSearchResult* _SearchResult in _Results )
                        [ self _testSearchResult: _SearchResult ];

                    WikiFulfillExpectation( jsonExpectation );
                    } failure:
                        ^( NSError* _Error )
                            {

                            }    stopAllOtherTasks: NO ];

            [ self _testReturnedWikiQueryTask: WikiQueryTask ];

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

- ( void ) test_pos_pages_with_titles_
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __NSArray_of( NSString* ) _PosSample in self->_posTitleSamples )
        {
        XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];

        WikiQueryTask* WikiQueryTask =
            [ positiveTestCase pagesWithTitles: _PosSample
                                       success:
            ^( NSArray* _MatchedPages )
                {
                XCTAssertNotNil( _MatchedPages );
                XCTAssertEqual( _MatchedPages.count, _PosSample.count );
                NSLog( @">>> (Log🐑) Matched Pages Count vs. Positive Sample Count: %lu vs. %lu", _MatchedPages.count, _PosSample.count );

                for ( WikiPage* _WikiPage in _MatchedPages )
                    [ self _testWikiPage: _WikiPage ];

                WikiFulfillExpectation( jsonExpectation );
                } failure:
                    ^( NSError* _Error )
                        {
                        NSLog( @"❌%@", _Error );
                        }    stopAllOtherTasks: NO ];

        [ self _testReturnedWikiQueryTask: WikiQueryTask ];

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

- ( void ) test_pos_pages_with_pageIDs_
    {
    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];

    int count = 0;
    for ( __NSArray_of( NSNumber* ) _PosSample in self->_posPageIDSamples )
        {
        XCTestExpectation* jsonExpectation = [ self expectationWithDescription: [ NSString stringWithFormat: @"🔥JSON Exception %d", count ] ];

        WikiQueryTask* WikiQueryTask =
            [ positiveTestCase pagesWithPageIDs: _PosSample
                                        success:
            ^( NSArray* _MatchedPages )
                {
                XCTAssertNotNil( _MatchedPages );
                XCTAssertEqual( _MatchedPages.count, _PosSample.count );
                NSLog( @">>> (Log🐑) Matched Pages Count vs. Positive Sample Count: %lu vs. %lu", _MatchedPages.count, _PosSample.count );

                for ( WikiPage* _WikiPage in _MatchedPages )
                    [ self _testWikiPage: _WikiPage ];

                WikiFulfillExpectation( jsonExpectation );
                } failure:
                    ^( NSError* _Error )
                        {
                        NSLog( @"❌%@", _Error );
                        }    stopAllOtherTasks: NO ];

        [ self _testReturnedWikiQueryTask: WikiQueryTask ];

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
            [ self _testWikiImage: _Image ];
            WikiFulfillExpectation( jsonExpectation0 );
            } failure:
                ^( NSError* _Error )
                    {
                    NSLog( @"❌%@", _Error );
                    }
                    stopAllOtherTasks: NO ];

    [ self _testReturnedWikiQueryTask: WikiQueryTask ];

    [ self waitForExpectationsWithTimeout: 150
                                  handler:
        ^( NSError* __nullable _Error )
            {
            NSLog( @"%@", _Error );
            } ];
    }

#pragma mark Private Interfaces
- ( void ) _testReturnedWikiQueryTask: ( WikiQueryTask* )_WikiQueryTask
    {
    NSLog( @"%@", _WikiQueryTask );
    printf( "==============================================================\n" );

    XCTAssertNotNil( _WikiQueryTask );
    XCTAssertTrue( [ _WikiQueryTask isKindOfClass: [ WikiQueryTask class ] ] );

    XCTAssertNotNil( _WikiQueryTask.HTTPMethod );
    XCTAssertNotNil( _WikiQueryTask.endPoint );
    XCTAssertNotNil( _WikiQueryTask.parameters );
    XCTAssertNotNil( _WikiQueryTask.sessionDataTask );
    }

- ( void ) _testGenericWikiJSONObject: ( WikiJSONObject* )_WikiJSONObject
    {
    NSLog( @"%@", _WikiJSONObject );
    printf( "==============================================================\n" );

    XCTAssertNotNil( _WikiJSONObject );
    XCTAssertNotNil( _WikiJSONObject.json );
    XCTAssertTrue( [ _WikiJSONObject isKindOfClass: [ WikiJSONObject class ] ] );
    }

- ( void ) _testSearchResult: ( WikiSearchResult* )_SearchResult
    {
    NSLog( @"%@", _SearchResult );
    printf( "==============================================================\n" );

    XCTAssertNotNil( _SearchResult );
    XCTAssertNotNil( _SearchResult.json );
    XCTAssertTrue( [ _SearchResult isKindOfClass: [ WikiSearchResult class ] ] );

    XCTAssertGreaterThanOrEqual( _SearchResult.wikiNamespace, 0 );

    XCTAssertNotNil( _SearchResult.title );
    XCTAssertNotNil( _SearchResult.resultSnippet );
    XCTAssert( _SearchResult.resultTitleSnippet || !_SearchResult.resultTitleSnippet );

    XCTAssertGreaterThanOrEqual( _SearchResult.size, 0 );
    XCTAssertGreaterThanOrEqual( _SearchResult.wordCount, 0 );

    XCTAssertNotNil( _SearchResult.timestamp );
    }

- ( void ) _testWikiPage: ( WikiPage* )_Page
    {
    NSLog( @"%@", _Page );
    printf( "==============================================================\n" );


    XCTAssertNotNil( _Page );
    XCTAssertNotNil( _Page.json );
    XCTAssertTrue( [ _Page isKindOfClass: [ WikiPage class ] ] );

    XCTAssertGreaterThanOrEqual( _Page.ID, 0 );
    XCTAssertGreaterThanOrEqual( _Page.wikiNamespace, 0 );

    XCTAssertNotNil( _Page.title );
    XCTAssertNotNil( _Page.displayTitle );
    XCTAssertNotNil( _Page.contentModel );
    XCTAssertNotNil( _Page.language );
    XCTAssertNotNil( _Page.touched );

    XCTAssertNotNil( _Page.URL );
    XCTAssertNotNil( _Page.editURL );
    XCTAssertNotNil( _Page.canonicalURL );

    XCTAssertGreaterThanOrEqual( _Page.talkID, 0 );

    WikiRevision* lastRevision = _Page.lastRevision;
    XCTAssertNotNil( lastRevision );
        XCTAssertNotNil( lastRevision.json );
        XCTAssertGreaterThanOrEqual( lastRevision.ID, 0 );
        XCTAssertGreaterThanOrEqual( lastRevision.parentID, 0 );
        XCTAssertNotNil( lastRevision.userName );
        XCTAssertGreaterThanOrEqual( lastRevision.userID, 0 );
        XCTAssertNotNil( lastRevision.timestamp );
        XCTAssertNotNil( lastRevision.contentFormat );
        XCTAssertNotNil( lastRevision.contentModel );
        XCTAssertNotNil( lastRevision.content );
        XCTAssertGreaterThanOrEqual( lastRevision.sizeInBytes, 0 );
        XCTAssertNotNil( lastRevision.comment );
        XCTAssertNotNil( lastRevision.parsedComment );

//        NSData* lastRevisionContentData = [ lastRevision.content dataUsingEncoding: NSUTF8StringEncoding ];
//        XCTAssertEqual( lastRevisionContentData.length, lastRevision.sizeInBytes );

        XCTAssert( lastRevision.isMinorEdit || !lastRevision.isMinorEdit );

        XCTAssertNotNil( lastRevision.SHA1 );
        XCTAssertEqual( lastRevision.SHA1.length, 40 /* SHA-1 hash value is 40 digits long */ );
    }

- ( void ) _testWikiImage: ( WikiImage* )_Image
    {
    XCTAssertNotNil( _Image );
    XCTAssertNotNil( _Image.json );
    XCTAssertTrue( [ _Image isKindOfClass: [ WikiImage class ] ] );

    XCTAssertNotNil( _Image.name );
    XCTAssertNotNil( _Image.title );
    XCTAssertNotNil( _Image.canonicalTitle );

    XCTAssertNotNil( _Image.timestamp );
    XCTAssertNotNil( _Image.user );
    XCTAssertGreaterThanOrEqual( _Image.userID, 0 );

    XCTAssertGreaterThanOrEqual( _Image.sizeInByte, 0 );

    XCTAssertGreaterThanOrEqual( _Image.width, 0.f );
    XCTAssertGreaterThanOrEqual( _Image.height, 0.f );

    XCTAssertNotNil( _Image.comment );
    XCTAssertNotNil( _Image.parsedComment );

    XCTAssertNotNil( _Image.URL );
    XCTAssertNotNil( _Image.descriptionURL );

    XCTAssertNotNil( _Image.SHA1 );

    XCTAssertGreaterThanOrEqual( _Image.bitDepth, 0 );
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