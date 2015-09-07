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

#import "NSDate+SugarWiki.h"

// NSDate + WikiKit
@implementation NSDate ( SugarWiki )

+ ( instancetype ) dateWithMediaWikiJSONDateString: ( NSString* )_JSONDateString
    {
    NSString* yearString = [ _JSONDateString substringWithRange: NSMakeRange( 0, 4 ) ];
    NSString* monthString = [ _JSONDateString substringWithRange: NSMakeRange( 5, 2 ) ];
    NSString* dayString = [ _JSONDateString substringWithRange: NSMakeRange( 8, 2 ) ];
    NSString* hourString = [ _JSONDateString substringWithRange: NSMakeRange( 11, 2 ) ];
    NSString* minString = [ _JSONDateString substringWithRange: NSMakeRange( 14, 2 ) ];
    NSString* secString = [ _JSONDateString substringWithRange: NSMakeRange( 17, 2 ) ];

    NSDateComponents* dateComponents = [ [ NSDateComponents alloc ] init ];
    // GMT (GMT) offset 0, the standard Greenwich Mean Time, that's pretty important!
    [ dateComponents setTimeZone: [ NSTimeZone timeZoneForSecondsFromGMT: 0 ] ];

    [ dateComponents setYear: yearString.integerValue ];
    [ dateComponents setMonth: monthString.integerValue ];
    [ dateComponents setDay: dayString.integerValue ];
    [ dateComponents setHour: hourString.integerValue ];
    [ dateComponents setMinute: minString.integerValue ];
    [ dateComponents setSecond: secString.integerValue ];

    NSDate* rawDate = [ [ NSCalendar autoupdatingCurrentCalendar ] dateFromComponents: dateComponents ];
    return [ rawDate dateWithLocalTimeZone ];
    }

- ( NSDate* ) dateWithLocalTimeZone
    {
    return [ self dateWithCalendarFormat: nil timeZone: [ NSTimeZone localTimeZone ] ];
    }

@end // NSDate + WikiKit

/*================================================================================┐
|                              The MIT License (MIT)                              |
|                                                                                 |
|                           Copyright (c) 2015 Tong Kuo                           |
|                                                                                 |
|  Permission is hereby granted, free of charge, to any person obtaining a copy   |
|  of this software and associated documentation files (the "Software"), to deal  |
|  in the Software without restriction, including without limitation the rights   |
|    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell    |
|      copies of the Software, and to permit persons to whom the Software is      |
|            furnished to do so, subject to the following conditions:             |
|                                                                                 |
| The above copyright notice and this permission notice shall be included in all  |
|                 copies or substantial portions of the Software.                 |
|                                                                                 |
|   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
|    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     |
|   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   |
|     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      |
|  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
|  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                    SOFTWARE.                                    |
└================================================================================*/