//
//  XTConfiguration.h
//  NetworkingLibrary
//
//  Created by Ruslan Alikhamov on 08/01/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, XTConfigurationType) {
	XTConfigurationTypeDev = 0,
	XTConfigurationTypeProd
};

@interface XTConfiguration : NSObject

+ (instancetype)configurationWithType:(XTConfigurationType)type;

@end
