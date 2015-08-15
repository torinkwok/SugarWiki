//
//  WikiEngine.m
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"
#import "WikiPage.h"
#import "WikiRevision.h"
#import "AFNetworking.h"

@import XCTest;

@interface WikiEngineTests : XCTestCase
    {
    AFHTTPSessionManager __strong* _httpSessionManager;

    // Samples 0
    NSArray __strong* _languageCodesSamples0;
    NSDictionary __strong* _parametersSamples0;
    }

@end

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

- ( void ) _testWikiPage: ( WikiPage* )_Page
    {
    NSLog( @"%@", _Page );
    printf( "==============================================================\n" );

    XCTAssertNotNil( _Page.json );

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

void WikiFulfillExpectation( XCTestExpectation* _Expection )
    {
    NSLog( @"🍺Fulfilled %@(%p)", _Expection, _Expection );
    [ _Expection fulfill ];
    }

- ( void ) testSearch
    {
    XCTestExpectation* jsonExpectation0 = [ self expectationWithDescription: @"JSON Exception 0⃣️" ];
    XCTestExpectation* jsonExpectation1 = [ self expectationWithDescription: @"JSON Exception 1⃣️" ];

    WikiEngine* positiveTestCase = [ WikiEngine engineWithISOLanguageCode: @"en" ];
    [ positiveTestCase searchAllPagesThatHaveValue: @"Ruby"
                                      inNamespaces: nil
                                              what: WikiEngineSearchWhatPageText
                                             limit: 10
                                           success:
        ^( NSArray* _MatchedPages )
            {
            for ( WikiPage* _Page in _MatchedPages )
                [ self _testWikiPage: _Page ];

            WikiFulfillExpectation( jsonExpectation0 );
            } failure:
                ^( NSError* _Error )
                    {

                    } ];

    [ positiveTestCase searchAllPagesThatHaveValue: @"C++"
                                      inNamespaces: @[ @( WikiNamespaceDraft ), @( WikiNamespaceWikipedia ) ]
                                              what: WikiEngineSearchWhatPageText
                                             limit: 10
                                           success:
        ^( NSArray* _MatchedPages )
            {
            for ( WikiPage* _Page in _MatchedPages )
                [ self _testWikiPage: _Page ];

            WikiFulfillExpectation( jsonExpectation1 );
            } failure:
                ^( NSError* _Error )
                    {

                    } ];

    [ self waitForExpectationsWithTimeout: 15
                                  handler:
        ^( NSError* __nullable _Error )
            {
            NSLog( @"%@", _Error );
            } ];
    }

@end
