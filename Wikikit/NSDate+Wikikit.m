//
//  NSDate+Wikikit.m
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#import "NSDate+Wikikit.h"

// NSDate + Wikikit
@implementation NSDate ( Wikikit )

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

@end // NSDate + Wikikit