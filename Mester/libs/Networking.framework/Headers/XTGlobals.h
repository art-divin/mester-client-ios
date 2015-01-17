//
//  XTGloblals.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 07/12/14.
//  Copyright (c) 2014 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;
@class XTResponseError;

#ifndef XTGlobals
#define XTGlobals

typedef void (^XTCompletionBlock)(NSDictionary *responseDic, XTResponseError *responseError);

NS_INLINE void XTLog(NSString *fmt, ...) {
	va_list list;
	va_start(list, fmt);
	NSLogv(fmt, list);
	va_end(list);
};

#endif
