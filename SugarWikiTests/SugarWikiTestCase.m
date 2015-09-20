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

NSString* const kParsedWikiText = @"parsed-wiki-text";

// Private Interfaces
@interface SugarWikiTestCase ()
- ( void ) __init;
@end // Private Interfaces

// SugarWikiTestCase class
@implementation SugarWikiTestCase

#pragma mark Initializations
- ( instancetype ) initWithInvocation: ( NSInvocation* )_Invocation
    {
    if ( self = [ super initWithInvocation: _Invocation ] )
        [ self __init ];

    return self;
    }

- ( instancetype ) initWithSelector: ( SEL )_Selector
    {
    if ( self = [ super initWithSelector: _Selector ] )
        [ self __init ];

    return self;
    }

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
                   info: ( NSDictionary* )_InfoDict
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

        if ( ![ _InfoDict[ kParsedWikiText ] boolValue ] )
            XCTAssertFalse( lastRevision.isParsedContent );

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

#pragma mark Private Interfaces
- ( void ) __init
    {
    self->_httpSessionManager = [ [ AFHTTPSessionManager alloc ] initWithSessionConfiguration: [ NSURLSessionConfiguration defaultSessionConfiguration ] ];
    AFJSONResponseSerializer* JSONSerializer = [ [ AFJSONResponseSerializer alloc ] init ];
    [ self->_httpSessionManager setResponseSerializer: JSONSerializer ];

    // Samples 0
    self->_languageCodesSamples0 = @[ @"en", @"zh", @"fr", @"ja", @"de" ];
    self->_parametersSamples0 = @{ @"action" : @"query"
                                 , @"meta" : @"siteinfo"
                                 , @"format" : @"json"
                                 , @"sipro" : @"general|languages|namespaces"
                                 };

    self->_posTitleSamples = @[ @[ @"C++", @"Ruby", @"C", @"Madonna in the Church", @"Ada (programming language)", @"Type system" ]
                              , @[ @"Subroutine", @"Computer programming", @"Machine code", @"Barack Obama", @"Python (programming language)" ]
                              , @[ @"Compiler", @"Central processing unit", @"Syria", @"Syria-Cilicia commemorative medal", @"Syria-Lebanon Campaign order of battle" ]
                              , @[ @"Integrated circuit", @"Microprocessor", @"Semiconductor", @"Insulator (electricity)", @"Syria Fed Cup team" ]
                              , @[ @"Otto Pérez Molina", @"President of Guatemala", @"Taiwan", @"Kuomintang" ]
                              ];

    self->_posPageIDSamples = @[ @[ @7515928, @43093687, @12816866, @10523677, @43472938, @888445 ]
                               , @[ @5405, @28883152, @33099762, @33984313, @28175590 ]
                               , @[ @19001, @6902276, @6147074, @29287604, @46349164 ]
                               , @[ @14227967, @19961416, @7813116, @1955, @10280979 ]
                               , @[ @856, @8260899, @31290263, @615972, @14653, @9008741, @40479341, @28320793, @46256893 ]
                               ];

    self->_posQueryPropSamples = @[ // 0)
                                    @[ @"fileusage", @"extlinks" ]
                                 ];

    self->_posQueryPropParamSamples = @[ // 0)
                                         @{ @"fuprop" : @"pageid|title|redirect"
                                          , @"fulimit" : @"10"
                                          , @"ellimit" : @"10"
                                          , @"eloffset" : @""
                                          , @"fucontinue" : @""
                                          }
                                      ];


    self->_posListNameSamples = @[ // 0)
                                   @[ @"backlinks" ]

                                   // 1)
                                 , @[ @"allcategories", @"exturlusage" ]
                                 ];

    self->_posListParamsSamples = @[ // 0)
                                     @{ @"bltitle" : @"Main Page"
                                      , @"bllimit" : @"10"
                                      , @"blfilterredir" : @"redirects"
                                      }

                                     // 1)
                                   , @{ @"acprop" : @"size|hidden"
                                      , @"aclimit" : @"10"
                                      , @"acprefix" : @"C++"

                                      , @"euquery" : @"https://twitter.com"
                                      , @"eulimit" : @"10"
                                      }
                                   ];

    self->_posGeneratorListNameSamples = @[ // 0)
                                            @"allpages"
                                          ];

    self->_posGeneratorListParamsSamples = @[ // 0)
                                              @{ @"apfrom" : @"C++"
                                               , @"aplimit" : @"3"
                                               , @"apfilterredir" : @"nonredirects"
                                               }
                                            ];

    self->_posGeneratorRealPageQueryParamsSamples = @[ // 0)
                                                       @{ @"prop" : @"links|categories"
                                                        , @"pllimit" : @"500"
                                                        }
                                                     ];
    }

@end // SugarWikiTestCase class

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