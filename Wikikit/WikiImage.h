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

    CGFloat _width;
    CGFloat _height;

    NSString __strong* _comment;
    NSString __strong* _parsedComment;

    NSURL __strong* _URL;
    NSURL __strong* _descriptionURL;

    NSString __strong* SHA1;

    NSUInteger _bitDepth;
    WikiNamespace _wikiNamespace;
    }

+ ( instancetype ) imageWithJSONDict: ( NSDictionary* )_JSONDict;

@end
