//
//  WikiJSONObjectTests.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import XCTest;

#import "WikiJSONObject.h"

// WikiJSONObjectTests class
@interface WikiJSONObjectTests : XCTestCase

@end

@implementation WikiJSONObjectTests

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

- ( void ) test_pureVirtual_initWithJSONDict_
    {
    WikiJSONObject* positiveTestCase0 = [ [ WikiJSONObject alloc ] initWithJSONDict: @{} ];
    XCTAssertNotNil( positiveTestCase0 );
    XCTAssertNotNil( positiveTestCase0.json );

    WikiJSONObject* negativeTestCase0 = [ [ WikiJSONObject alloc ] initWithJSONDict: nil ];
    XCTAssertNil( negativeTestCase0 );

    WikiJSONObject* negativeTestCase1 = [ [ WikiJSONObject alloc ] initWithJSONDict: ( NSDictionary* )@[ @"testItem0", @"testItem1" ] ];
    XCTAssertNil( negativeTestCase1 );
    }

@end // WikiJSONObjectTests class