//
//  WikiEngine.m
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"

@import XCTest;

@interface WikiEngineTests : XCTestCase

@end

@implementation WikiEngineTests

- ( void ) setUp
    {
    [ super setUp ];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];
    }

- ( void ) test_engineWithISOLanguageCode_
    {
    WikiEngine* positiveTestCase0 = [ WikiEngine engineWithISOLanguageCode: @"en" ];
    WikiEngine* positiveTestCase1 = [ WikiEngine engineWithISOLanguageCode: @"zh" ];
    WikiEngine* positiveTestCase2 = [ WikiEngine engineWithISOLanguageCode: @"fr" ];
    WikiEngine* positiveTestCase3 = [ WikiEngine engineWithISOLanguageCode: @"jp" ];
    WikiEngine* positiveTestCase4 = [ WikiEngine engineWithISOLanguageCode: @"de" ];

    XCTAssert( positiveTestCase0 );
    XCTAssert( positiveTestCase1 );
    XCTAssert( positiveTestCase2 );
    XCTAssert( positiveTestCase3 );
    XCTAssert( positiveTestCase4 );
    }

@end
