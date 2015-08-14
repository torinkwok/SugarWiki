//
//  WikiEngine.m
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"

@implementation WikiEngine

@dynamic ISOLanguageCode;

- ( NSString* ) ISOLanguageCode
    {
    return self->_ISOLanguageCode;
    }

#pragma  mark Creating Engine
+ ( instancetype ) engineWithLanguageISOLanguageCode: ( NSString* )_Code
    {
    return [ [ [ self class ] alloc ] initWithLanguageISOLanguageCode: _Code ];
    }

- ( instancetype ) initWithLanguageISOLanguageCode: ( NSString* )_Code
    {
    if ( !_ISOLanguageCode )
        return nil;

    NSArray* allCodes = [ NSLocale ISOLanguageCodes ];
    if ( [ allCodes containsObject: _Code ] )
    if ( self = [ super init ] )
        {
            self->_ISOLanguageCode = _Code;
        }

    return self;
    }

@end