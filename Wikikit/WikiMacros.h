//
//  WikiMacros.h
//  Wikikit
//
//  Created by Tong G. on 8/15/15.
//  Copyright © 2015 TongKuo. All rights reserved.
//

#define __THROW_EXCEPTION__WHEN_INVOKED_PURE_VIRTUAL_METHOD_ \
    @throw [ NSException exceptionWithName: NSGenericException \
                         reason: [ NSString stringWithFormat: @"unimplemented pure virtual method `%@` in `%@` " \
                                                               "from instance: %p" \
                                                            , NSStringFromSelector( _cmd ) \
                                                            , NSStringFromClass( [ self class ] ) \
                                                            , self ] \
                       userInfo: nil ]
