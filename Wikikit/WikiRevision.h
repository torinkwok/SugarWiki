//
//  WikiRevision.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "WikiJSONObject.h"

@interface WikiRevision : WikiJSONObject
    {
@protected
    SInt64 _ID;
    SInt64 _parentID;

    NSString __strong* _userName;
    SInt64 _userID;

    NSDate __strong* _timestamp;
    NSString __strong* _contentFormat;
    NSString __strong* _contentModel;
    NSString __strong* _content;

    NSUInteger _sizeInByte;

    NSString __strong* _comment;
    NSString __strong* _parsedComment;

    BOOL _isMinorEdit;

    NSString __strong* _SHA1;
    }

@property ( assign, readonly ) SInt64 ID;
@property ( assign ,readonly ) SInt64 parentID;

@property ( strong, readonly ) NSString* userName;
@property ( assign, readonly ) SInt64 userID;

@property ( strong, readonly ) NSDate* timestamp;
@property ( strong, readonly ) NSString* contentFormat;
@property ( strong, readonly ) NSString* contentModel;
@property ( strong, readonly ) NSString* content;

@property ( assign, readonly ) NSUInteger sizeInBytes;

@property ( strong, readonly ) NSString* comment;
@property ( strong, readonly ) NSString* parsedComment;

@property ( assign, readonly ) BOOL isMinorEdit;

@property ( assign, readonly ) NSString* SHA1;

+ ( instancetype ) revisionWithJSONDict: ( NSDictionary* )_JSONDict;

@end
