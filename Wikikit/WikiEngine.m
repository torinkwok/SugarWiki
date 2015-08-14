//
//  WikiEngine.m
//  Wikikit
//
//  Created by Tong G. on 8/14/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiEngine.h"
#import "WikiHTTPSessionManager.h"
#import "WikiSessionDataTask.h"

// Private Interfaces
@interface WikiEngine ()

- ( void ) _initEndpoint: ( NSURL* )_EndpointURL;
- ( instancetype ) _initWithCommonsEndpoint;

@end // Private Interfaces

// WikiEngine class
@implementation WikiEngine

@dynamic endpoint;
@dynamic wikiHTTPSessionManager;
@dynamic ISOLanguageCode;

- ( NSURL* ) endpoint
    {
    return self->_endpoint;
    }

- ( WikiHTTPSessionManager* ) wikiHTTPSessionManager
    {
    return self->_wikiHTTPSessionManager;
    }

- ( NSString* ) ISOLanguageCode
    {
    return self->_ISOLanguageCode;
    }

#pragma mark Creating Engine
+ ( instancetype ) engineWithISOLanguageCode: ( NSString* )_Code
    {
    return [ [ [ self class ] alloc ] initWithISOLanguageCode: _Code ];
    }

- ( instancetype ) initWithISOLanguageCode: ( NSString* )_Code
    {
    if ( !_ISOLanguageCode )
        return nil;

    NSArray* allCodes = [ NSLocale ISOLanguageCodes ];
    if ( [ allCodes containsObject: _Code ] )
    if ( self = [ super init ] )
        {
        self->_ISOLanguageCode = _Code;
        NSURL* url = [ NSURL URLWithString:
            [ NSString stringWithFormat: @"https://%@.wikipedia.org/w/api.php/", self->_ISOLanguageCode ] ];

        [ self _initEndpoint: url ];
        }

    return self;
    }

- ( instancetype ) _initWithCommonsEndpoint
    {
    if ( self = [ super init ] )
        {
        NSURL* url = [ NSURL URLWithString: @"https://commons.wikimedia.org/w/api.php" ];
        [ self _initEndpoint: url ];
        }

    return self;
    }

#pragma mark Private Interfaces
- ( void ) _initEndpoint: ( NSURL* )_EndpointURL
    {
    self->_endpoint = _EndpointURL;
    self->_wikiHTTPSessionManager = [ [ WikiHTTPSessionManager alloc ] initWithBaseURL: self->_endpoint ];
    }

@end // WikiEngine class