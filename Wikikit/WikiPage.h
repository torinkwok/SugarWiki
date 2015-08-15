//
//  WikiPage.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

#import "WikiJSONObject.h"
#import "WikiConstants.h"

@class WikiRevision;

@interface WikiPage : WikiJSONObject
    {
@protected
    SInt64 _ID;
    WikiNamespace _wikiNamespace;
    NSString __strong* _title;
    NSString __strong* _displayTitle;
    NSString __strong* _contentModel;
    NSString __strong* _language;
    NSDate __strong* _touched;

    NSURL __strong* _URL;
    NSURL __strong* _editURL;
    NSURL __strong* _canonicalURL;

    SInt64 _talkID;

    NSString __strong* _defaultSort;
    NSString __strong* _pageImageName;
    NSString __strong* _wikiBaseItem;

    WikiRevision __strong* _lastRevision;
    }

@property ( assign, readonly ) SInt64 ID;
@property ( assign, readonly ) WikiNamespace wikiNamespace;
@property ( strong, readonly ) NSString* title;
@property ( strong, readonly ) NSString* displayTitle;
@property ( strong, readonly ) NSString* contentModel;
@property ( strong, readonly ) NSString* language;
@property ( strong, readonly ) NSDate* touched;

@property ( strong, readonly ) NSURL* URL;
@property ( strong, readonly ) NSURL* editURL;
@property ( strong, readonly ) NSURL* canonicalURL;

@property ( assign, readonly ) SInt64 talkID;

@property ( strong, readonly ) NSString* defaultSort;
@property ( strong, readonly ) NSString* pageImageName;
@property ( strong, readonly ) NSString* wikiBaseItem;

@property ( strong, readonly ) WikiRevision* lastRevision;

+ ( instancetype ) pageWithJSONDict: ( NSDictionary* )_JSONDict;

@end
