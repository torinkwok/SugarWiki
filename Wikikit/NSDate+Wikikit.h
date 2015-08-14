//
//  NSDate+Wikikit.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

@import Foundation;

// NSDate + Wikikit
@interface NSDate ( Wikikit )

+ ( instancetype ) dateWithMediaWikiJSONDateString: ( NSString* )_JSONDateString;

- ( NSDate* ) dateWithLocalTimeZone;

@end // NSDate + Wikikit