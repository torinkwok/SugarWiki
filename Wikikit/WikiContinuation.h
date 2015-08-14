//
//  WikiContinuation.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

// WikiContinuation class
@interface WikiContinuation : NSObject

@property ( readwrite, strong ) NSString* submoduleElement;
@property ( readwrite, strong ) NSString* continuation;

+ ( instancetype ) continuationWithContinueElementJSON: ( NSArray* )_ContinueElementJSON;
- ( instancetype ) initWithContinueElementJSON: ( NSArray* )_ContinueElementJSON;

@end // WikiContinuation class
