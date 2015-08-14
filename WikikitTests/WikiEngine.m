//
//  WikiEngine.m
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"
#import "AFNetworking.h"

@import XCTest;

@interface WikiEngineTests : XCTestCase
    {
    AFHTTPSessionManager __strong* _httpSessionManager;
    }

@end

@implementation WikiEngineTests

- ( void ) setUp
    {
    [ super setUp ];

    self->_httpSessionManager = [ [ AFHTTPSessionManager alloc ] initWithSessionConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];
    AFJSONResponseSerializer* JSONSerializer = [ [ AFJSONResponseSerializer alloc ] init ];
    [ self->_httpSessionManager setResponseSerializer: JSONSerializer ];
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];
    }

- ( void ) test_engineWithISOLanguageCode_
    {
    NSArray* languageCodes = @[ @"en", @"zh", @"fr", @"ja", @"de" ];

    NSDictionary* paras = @{ @"action" : @"query"
                           , @"meta" : @"siteinfo"
                           , @"format" : @"json"
                           , @"sipro" : @"general|languages|namespaces"
                           };

    for ( NSString* _LauguageCode in languageCodes )
        {
        WikiEngine* positiveTestCase0 = [ WikiEngine engineWithISOLanguageCode: _LauguageCode ];
        XCTAssertNotNil( positiveTestCase0 );

        NSURL* positiveEndpoint0 = positiveTestCase0.endpoint;
        XCTAssertNotNil( positiveEndpoint0 );

        XCTestExpectation* jsonException = [ self expectationWithDescription: [ NSString stringWithFormat: @"JSON Exception (%@) \nParas: ?%@", positiveEndpoint0, paras ] ];
        NSURLSessionDataTask* positiveSessionDataTask0 =
            [ self->_httpSessionManager GET: positiveEndpoint0.absoluteString
                                 parameters: paras
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

        XCTAssertNotNil( positiveTestCase0.wikiHTTPSessionManager );
        XCTAssertNotNil( positiveTestCase0.ISOLanguageCode );
        }
    }

@end
