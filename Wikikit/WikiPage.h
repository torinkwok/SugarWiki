//
//  WikiPage.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

typedef NS_ENUM( SInt64, WikiNamespace )
    { WikiNamespaceUnknown = 0
    , WikiNamespaceMedia = -2
    , WikiNamespaceSpecial = -1
    , WikiNamespaceTalk = 1
    , WikiNamespaceUser = 2
    , WikiNamespaceUserTalk = 3
    , WikiNamespaceWikipedia = 4
    , WikiNamespaceWikipediaTalk = 5
    , WikiNamespaceFile = 6
    , WikiNamespaceFileTalk = 7
    , WikiNamespaceMediaWiki = 8
    , WikiNamespaceMediaWikiTalk = 9
    , WikiNamespaceTemplate = 10
    , WikiNamespaceTamplateTalk = 11
    , WikiNamespaceHelp = 12
    , WikiNamespaceHelpTalk = 13
    , WikiNamespaceCategory = 14
    , WikiNamespaceCategoryTalk = 15
    , WikiNamespacePortal = 100
    , WikiNamespacePortalTalk = 101
    , WikiNamespaceBook = 108
    , WikiNamespaceBookTalk = 109
    , WikiNamespaceDraft = 118
    , WikiNamespaceDraftTalk = 119
    , WikiNamespaceEducationProgram = 446
    , WikiNamespaceEducationProgramTalk = 447
    , WikiNamespaceTimedText = 710
    , WikiNamespaceTimedTextTalk = 711
    , WikiNamespaceModule = 828
    , WikiNamespaceModuleTalk = 829
    , WikiNamespaceGadget = 2300
    , WikiNamespaceGadgetTalk = 2301
    , WikiNamespaceGadgetDefinition = 2302
    , WikiNamespaceGadgetDefinitionTalk = 2303
    , WikiNamespaceTopic = 2600
    };

@interface WikiPage : NSObject
    {
@protected
    NSDictionary __strong* _json;

    SInt64 _id;
    WikiNamespace _namespace;
    NSString __strong* _title;
    NSString __strong* _displayTitle;
    NSString __strong* _contentModel;
    NSString __strong* _language;
    NSDate __strong* _touched;

    NSURL __strong* _URL;
    NSURL __strong* _editURL;
    NSURL __strong* _canonicalURL;

    SInt64 _talkID;
    }

@property ( strong, readonly ) NSDictionary* json;

+ ( instancetype ) pageWithJSONDict: ( NSDictionary* )_JSONDict;
- ( instancetype ) initWithJSONDict: ( NSDictionary* )_JSONDict;

@end
