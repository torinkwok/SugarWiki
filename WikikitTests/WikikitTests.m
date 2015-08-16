//
//  WikikitTests.m
//  WikikitTests
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import XCTest;

#import "WikikitInfo.h"

// WikikitTests class
@interface WikikitTests : XCTestCase

@end

@implementation WikikitTests

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

- ( void ) testVersionNumber
    {
    XCTAssertEqual( [ WikikitInfo versionNumber ], 1.f );
    XCTAssertEqualObjects( [ WikikitInfo versionString ], @"1.0" );
    }

- ( void ) testPerformanceExample
    {
    // This is an example of a performance test case.
    [ self measureBlock: ^{
        // Put the code you want to measure the time of here.
        } ];
    }

@end // WikikitTests class