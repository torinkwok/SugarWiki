//
//  WikiJSONObjectTests.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import XCTest;

#import "WikiJSONObject.h"

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
    WikiJSONObject* positiveTestCase0 = nil;
    XCTAssertThrowsSpecificNamed( positiveTestCase0 = [ [ WikiJSONObject alloc ] initWithJSONDict: @{} ]
                                , NSException
                                , NSGenericException
                                );
    }

- ( void ) testPerformanceExample
    {
    // This is an example of a performance test case.
    [ self measureBlock:
        ^{
        // Put the code you want to measure the time of here.
        } ];
}

@end
