//
//  WikiEngine.h
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

/**
  */
@interface WikiEngine : NSObject
    {
@protected
    NSString __strong* _ISOLanguageCode;
    }

@property ( strong, readonly ) NSString* ISOLanguageCode;

#pragma mark Creating Engine
+ ( instancetype ) engineWithLanguageISOLanguageCode: ( NSString* )_ISOLanguageCode;
- ( instancetype ) initWithLanguageISOLanguageCode: ( NSString* )_ISOLanguageCode;

+ ( instancetype ) commonsEngine;

@end // WikiEngine class