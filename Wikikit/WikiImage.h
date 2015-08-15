//
//  WikiImage.h
//  Wikikit
//
//  Created by Tong G. on 8/16/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiJSONObject.h"
#import "WikiConstants.h"

@interface WikiImage : WikiJSONObject
    {
@protected
    NSString __strong* _name;
    NSString __strong* _title;
    NSString __strong* _canonicalTitle;

    NSDate __strong* _timestamp;
    NSString __strong* _user;
    SInt64 _userID;

    NSUInteger _sizeInByte;

    CGFloat _width;
    CGFloat _height;

    NSString __strong* _comment;
    NSString __strong* _parsedComment;

    NSURL __strong* _URL;
    NSURL __strong* _descriptionURL;

    NSString __strong* _SHA1;

    NSUInteger _bitDepth;
    WikiNamespace _wikiNamespace;
    }

@property ( strong, readonly ) NSString* name;
@property ( strong, readonly ) NSString* title;
@property ( strong, readonly ) NSString* canonicalTitle;

@property ( strong, readonly ) NSDate* timestamp;
@property ( strong, readonly ) NSString* user;
@property ( assign, readonly ) SInt64 userID;

@property ( assign, readonly ) NSUInteger sizeInByte;

@property ( assign, readonly ) CGFloat width;
@property ( assign, readonly ) CGFloat height;

@property ( strong, readonly ) NSString* comment;
@property ( strong, readonly ) NSString* parsedComment;

@property ( strong, readonly ) NSURL* URL;
@property ( strong, readonly ) NSURL* descriptionURL;

@property ( strong, readonly ) NSString* SHA1;

@property ( assign, readonly ) NSUInteger bitDepth;
@property ( assign, readonly ) WikiNamespace wikiNamespace;

+ ( instancetype ) imageWithJSONDict: ( NSDictionary* )_JSONDict;

@end
