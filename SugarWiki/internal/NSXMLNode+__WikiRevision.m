/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 _______    _             _                 _                 |██
|                (_______)  (_)           | |               | |                |██
|                    _ _ _ _ _ ____   ___ | |  _ _____  ____| |                |██
|                   | | | | | |  _ \ / _ \| |_/ ) ___ |/ ___)_|                |██
|                   | | | | | | |_| | |_| |  _ (| ____| |    _                 |██
|                   |_|\___/|_|  __/ \___/|_| \_)_____)_|   |_|                |██
|                             |_|                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "NSXMLNode+__WikiRevision.h"

#import "SugarWiki.h"

// NSXMLNode + PWOpenedPagePreview
@implementation NSXMLNode ( PWOpenedPagePreview )

@dynamic isInComplicatedSet;
@dynamic isCoordinate;

- ( BOOL ) isInComplicatedSet
    {
    if ( [ self.name isEqualToString: @"h1" ]
            || [ self.name isEqualToString: @"h2" ]
            || [ self.name isEqualToString: @"h3" ]
            || [ self.name isEqualToString: @"h4" ]
            || [ self.name isEqualToString: @"h5" ]
            || [ self.name isEqualToString: @"div" ]
            || [ self.name isEqualToString: @"sup" ]
            || [ self.name isEqualToString: @"table" ]
            || [ self.name isEqualToString: @"dl" ]
            || [ self.name isEqualToString: @"img" ]
            || [ self.name isEqualToString: @"br" ]

            || ( [ self.name isEqualToString: @"p" ]
                    && ( self.nextNode.kind == NSXMLTextKind )
                    && [ self.nextNode.stringValue isEqualToString: @"\n" ] )

            || ( [ self.name isEqualToString: @"p" ]
                    && ( self.childCount == 0 ) ) )
        return YES;

    return NO;
    }

- ( BOOL ) isCoordinate
    {
    if ( self.kind == NSXMLElementKind && [ self.name isEqualToString: @"span" ] )
        {
        __SugarArray_of( NSXMLNode* ) attrs = [ ( NSXMLElement* )self attributes ];

        for ( NSXMLNode* _Attr in attrs )
            if ( [ _Attr.stringValue isEqualToString: @"coordinates" ] )
                return YES;
        }

    return NO;
    }

@end // NSXMLNode + PWOpenedPagePreview

/*=============================================================================┐
|                                                                              |
|                                        `-://++/:-`    ..                     |
|                    //.                :+++++++++++///+-                      |
|                    .++/-`            /++++++++++++++/:::`                    |
|                    `+++++/-`        -++++++++++++++++:.                      |
|                     -+++++++//:-.`` -+++++++++++++++/                        |
|                      ``./+++++++++++++++++++++++++++/                        |
|                   `++/++++++++++++++++++++++++++++++-                        |
|                    -++++++++++++++++++++++++++++++++`                        |
|                     `:+++++++++++++++++++++++++++++-                         |
|                      `.:/+++++++++++++++++++++++++-                          |
|                         :++++++++++++++++++++++++-                           |
|                           `.:++++++++++++++++++/.                            |
|                              ..-:++++++++++++/-                              |
|                             `../+++++++++++/.                                |
|                       `.:/+++++++++++++/:-`                                  |
|                          `--://+//::-.`                                      |
|                                                                              |
└=============================================================================*/