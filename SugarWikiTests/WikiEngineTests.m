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
#import "AFNetworking.h"

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
    }

@end

// Private Interfaces
@interface WikiEngineTests ()

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

- ( void ) testSearch
    {
    XCTestExpectation* jsonExpectation0 = [ self expectationWithDescription: @"🔍JSON Exception 0⃣️" ];
    XCTestExpectation* jsonExpectation1 = [ self expectationWithDescription: @"🔍JSON Exception 1⃣️" ];

    WikiQueryTask* WikiQueryTask = nil;

    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];
    WikiQueryTask =
        [ positiveTestCase searchAllPagesThatHaveValue: @"Ruby"
                                          inNamespaces: nil
                                              approach: WikiEngineSearchApproachPageText
                                                 limit: 10
                                               success:
        ^( NSArray* _Results )
            {
            for ( WikiSearchResult* _SearchResult in _Results )
                [ self _testSearchResult: _SearchResult ];

            WikiFulfillExpectation( jsonExpectation0 );
            } failure:
                ^( NSError* _Error )
                    {

                    }                stopAllOtherTasks: NO ];

    [ self _testReturnedWikiQueryTask: WikiQueryTask ];

    WikiQueryTask =
        [ positiveTestCase searchAllPagesThatHaveValue: @"C++"
                                          inNamespaces: @[ @( WikiNamespaceDraft ), @( WikiNamespaceWikipedia ) ]
                                              approach: WikiEngineSearchApproachPageText
                                                 limit: 10
                                               success:
        ^( NSArray* _MatchedPages )
            {
            for ( WikiSearchResult* _SearchResult in _MatchedPages )
                [ self _testSearchResult: _SearchResult ];

            WikiFulfillExpectation( jsonExpectation1 );
            } failure:
                ^( NSError* _Error )
                    {

                    }                stopAllOtherTasks: NO ];

    [ self _testReturnedWikiQueryTask: WikiQueryTask ];

    [ self waitForExpectationsWithTimeout: 150
                                  handler:
        ^( NSError* __nullable _Error )
            {
            NSLog( @"%@", _Error );
            } ];
    }

- ( void ) testpages_with_titles_
    {
    XCTestExpectation* jsonExpectation0 = [ self expectationWithDescription: @"🔍JSON Exception 0⃣️" ];
    XCTestExpectation* jsonExpectation1 = [ self expectationWithDescription: @"🔍JSON Exception 1⃣️" ];

    WikiQueryTask* WikiQueryTask = nil;

    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];
    WikiQueryTask =
        [ positiveTestCase pagesWithTitles: @[ @"C++", @"Ruby", @"C" ]
                                   success:
        ^( NSArray* _MatchedPages )
            {
            XCTAssertNotNil( _MatchedPages );
            for ( WikiPage* _WikiPage in _MatchedPages )
                [ self _testWikiPage: _WikiPage ];

            WikiFulfillExpectation( jsonExpectation0 );
            } failure:
                ^( NSError* _Error )
                    {

                    }    stopAllOtherTasks: NO ];

    [ self _testReturnedWikiQueryTask: WikiQueryTask ];

    WikiQueryTask =
        [ positiveTestCase pagesWithTitles: @[ @"Ruby on Rails", @"Washinton D.C." ]
                                   success:
        ^( NSArray* _MatchedPages )
            {
            XCTAssertNotNil( _MatchedPages );
            for ( WikiPage* _WikiPage in _MatchedPages )
                [ self _testWikiPage: _WikiPage ];

            WikiFulfillExpectation( jsonExpectation1 );
            } failure:
                ^( NSError* _Error )
                    {

                    }    stopAllOtherTasks: NO ];

    [ self _testReturnedWikiQueryTask: WikiQueryTask ];

    [ self waitForExpectationsWithTimeout: 150
                                  handler:
        ^( NSError* __nullable _Error )
            {
            NSLog( @"%@", _Error );
            } ];
    }

- ( void ) testFetchImage_success_failure_
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

        NSData* lastRevisionContentData = [ lastRevision.content dataUsingEncoding: NSUTF8StringEncoding ];
        XCTAssertEqual( lastRevisionContentData.length, lastRevision.sizeInBytes );

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