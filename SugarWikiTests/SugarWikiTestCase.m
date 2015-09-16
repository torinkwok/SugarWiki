/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|               ______                         _  _  _ _ _     _ _             |██
|              / _____)                       (_)(_)(_|_) |   (_) |            |██
|             ( (____  _   _  ____ _____  ____ _  _  _ _| |  _ _| |            |██
|              \____ \| | | |/ _  (____ |/ ___) || || | | |_/ ) |_|            |██
|              _____) ) |_| ( (_| / ___ | |   | || || | |  _ (| |_             |██
|             (______/|____/ \___ \_____|_|    \_____/|_|_| \_)_|_|            |██
|                           (_____|                                            |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "SugarWikiTestCase.h"

@implementation SugarWikiTestCase

- ( void ) testReturnedWikiQueryTask: ( WikiQueryTask* )_WikiQueryTask
    {
    printf( "==============================================================\n" );
    NSLog( @"%@", _WikiQueryTask );

    XCTAssertNotNil( _WikiQueryTask );
    XCTAssertTrue( [ _WikiQueryTask isKindOfClass: [ WikiQueryTask class ] ] );

    XCTAssertNotNil( _WikiQueryTask.HTTPMethod );
    XCTAssertNotNil( _WikiQueryTask.endPoint );
    XCTAssertNotNil( _WikiQueryTask.parameters );
    XCTAssertNotNil( _WikiQueryTask.sessionDataTask );
    }

- ( void ) testGenericWikiJSONObject: ( WikiJSONObject* )_WikiJSONObject
    {
    printf( "==============================================================\n" );
    NSLog( @"%@", _WikiJSONObject );

    XCTAssertNotNil( _WikiJSONObject );
    XCTAssertNotNil( _WikiJSONObject.json );
    XCTAssertTrue( [ _WikiJSONObject isKindOfClass: [ WikiJSONObject class ] ] );
    }

- ( void ) testSearchResult: ( WikiSearchResult* )_SearchResult
    {
    printf( "==============================================================\n" );
    NSLog( @"%@", _SearchResult );

    XCTAssertNotNil( _SearchResult );
    XCTAssertNotNil( _SearchResult.json );
    XCTAssertTrue( [ _SearchResult isKindOfClass: [ WikiSearchResult class ] ] );

    XCTAssertGreaterThanOrEqual( _SearchResult.wikiNamespace, 0 );

    [ self _testNSHTML: _SearchResult.resultSnippet ];
    [ self _testNSHTML: _SearchResult.resultTitleSnippet ];

    XCTAssertGreaterThanOrEqual( _SearchResult.size, 0 );
    XCTAssertGreaterThanOrEqual( _SearchResult.wordCount, 0 );

    XCTAssertNotNil( _SearchResult.timestamp );
    }

- ( void ) _testNSHTML: ( NSXMLElement* )_NSHTML
    {
    NSLog( @"%@", _NSHTML );

    XCTAssertNotNil( _NSHTML );
    XCTAssertTrue( [ _NSHTML isKindOfClass: [ NSXMLElement class ] ] );
    XCTAssertGreaterThan( _NSHTML.XMLString.length, 0 );
    XCTAssertGreaterThanOrEqual( _NSHTML.childCount, 0 );
    }

- ( void ) testWikiImage: ( WikiImage* )_Image
    {
    printf( "==============================================================\n" );
    NSLog( @"%@", _Image );

    XCTAssertNotNil( _Image );
    XCTAssertNotNil( _Image.json );
    XCTAssertTrue( [ _Image isKindOfClass: [ WikiImage class ] ] );

    XCTAssertNotNil( _Image.name );
    XCTAssertNotNil( _Image.title );
    XCTAssertNotNil( _Image.canonicalTitle );

    XCTAssertNotNil( _Image.timestamp );
    XCTAssertNotNil( _Image.user );
    XCTAssertGreaterThanOrEqual( _Image.userID, 0 );

    XCTAssertGreaterThanOrEqual( _Image.sizeInByte, 0 );

    XCTAssertGreaterThanOrEqual( _Image.width, 0.f );
    XCTAssertGreaterThanOrEqual( _Image.height, 0.f );

    XCTAssertNotNil( _Image.comment );
    XCTAssertNotNil( _Image.parsedComment );

    XCTAssertNotNil( _Image.URL );
    XCTAssertNotNil( _Image.descriptionURL );

    XCTAssertNotNil( _Image.SHA1 );

    XCTAssertGreaterThanOrEqual( _Image.bitDepth, 0 );
    }

- ( void ) testWikiContinuation: ( WikiContinuation* )_Continuation
    {
    printf( "==============================================================\n" );
    NSLog( @"%@", _Continuation );

    XCTAssertNotNil( _Continuation );
    XCTAssertNotNil( _Continuation.json );
    XCTAssertNotNil( _Continuation.continuations );
    XCTAssertTrue( [ _Continuation isMemberOfClass: [ __WikiContinuationInitial class ] ]
                        || [ _Continuation isMemberOfClass: [ __WikiContinuationCompleted class ] ]
                        || [ _Continuation isMemberOfClass: [ __WikiContinuationUncompleted class ] ] );

    if ( [ _Continuation isMemberOfClass: [ __WikiContinuationInitial class ] ] )
        {
        XCTAssertTrue( _Continuation.isInitial );
        XCTAssertFalse( _Continuation.isCompleted );
        }
    else if ( [ _Continuation isMemberOfClass: [ __WikiContinuationCompleted class ] ] )
        {
        XCTAssertFalse( _Continuation.isInitial );
        XCTAssertTrue( _Continuation.isCompleted );
        }
    else if ( [ _Continuation isMemberOfClass: [ __WikiContinuationUncompleted class ] ] )
        {
        XCTAssertFalse( _Continuation.isInitial );
        XCTAssertFalse( _Continuation.isCompleted );
        }
    }

- ( void ) testWikiPage: ( WikiPage* )_Page
    {
    printf( "==============================================================\n" );
    NSLog( @"%@", _Page );

    XCTAssertNotNil( _Page );
    XCTAssertNotNil( _Page.json );
    XCTAssertTrue( [ _Page isKindOfClass: [ WikiPage class ] ] );

    XCTAssertGreaterThanOrEqual( _Page.ID, 0 );
    XCTAssertGreaterThanOrEqual( _Page.wikiNamespace, 0 );

    XCTAssertNotNil( _Page.title );
    XCTAssertNotNil( _Page.displayTitle );
    XCTAssertNotNil( _Page.contentModel );
    XCTAssertNotNil( _Page.language );
    XCTAssertNotNil( _Page.touched );

    XCTAssertNotNil( _Page.URL );
    XCTAssertNotNil( _Page.editURL );
    XCTAssertNotNil( _Page.canonicalURL );

    XCTAssertGreaterThanOrEqual( _Page.talkID, 0 );

    if ( _Page.json[ @"extlinks" ] )
        XCTAssertNotNil( _Page.externalLinks );
    else
        XCTAssertNil( _Page.externalLinks );

    XCTAssertGreaterThanOrEqual( _Page.externalLinks.count, 0 );

    WikiRevision* lastRevision = _Page.lastRevision;
    XCTAssertNotNil( lastRevision );
        XCTAssertNotNil( lastRevision.json );
        XCTAssertGreaterThanOrEqual( lastRevision.ID, 0 );
        XCTAssertGreaterThanOrEqual( lastRevision.parentID, 0 );
        XCTAssertNotNil( lastRevision.userName );
        XCTAssertGreaterThanOrEqual( lastRevision.userID, 0 );
        XCTAssertNotNil( lastRevision.timestamp );
        XCTAssertNotNil( lastRevision.contentFormat );
        XCTAssertNotNil( lastRevision.contentModel );
        XCTAssertNotNil( lastRevision.content );
        XCTAssertGreaterThanOrEqual( lastRevision.sizeInBytes, 0 );
        XCTAssertNotNil( lastRevision.comment );
        XCTAssertNotNil( lastRevision.parsedComment );

//        NSData* lastRevisionContentData = [ lastRevision.content dataUsingEncoding: NSUTF8StringEncoding ];
//        XCTAssertEqual( lastRevisionContentData.length, lastRevision.sizeInBytes );

        XCTAssert( lastRevision.isMinorEdit || !lastRevision.isMinorEdit );

        XCTAssertNotNil( lastRevision.SHA1 );
        XCTAssertEqual( lastRevision.SHA1.length, 40 /* SHA-1 hash value is 40 digits long */ );
    }

@end

/*===============================================================================┐
|                                                                                |
|                           The MIT License (MIT)                                |
|                                                                                |
|                        Copyright (c) 2015 Tong Kuo                             |
|                                                                                |
| Permission is hereby granted, free of charge, to any person obtaining a copy   |
| of this software and associated documentation files (the "Software"), to deal  |
| in the Software without restriction, including without limitation the rights   |
| to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      |
|   copies of the Software, and to permit persons to whom the Software is        |
|         furnished to do so, subject to the following conditions:               |
|                                                                                |
| The above copyright notice and this permission notice shall be included in all |
|              copies or substantial portions of the Software.                   |
|                                                                                |
| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     |
| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       |
| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    |
|  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        |
| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
| OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                 SOFTWARE.                                      |
|                                                                                |
└===============================================================================*/