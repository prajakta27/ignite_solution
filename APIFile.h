//
//  APIFile.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketsFile.h"
#import "StringsConstants.h"
#import "DataObjectClass.h"

@interface APIFile : NSObject

+ (APIFile*)getInstance;
-(void) sendHTTPGet:(NSString*)APIurl withRequestIDIdentifier:(REQUESTID)requestIDIdentifier;

+ (void)callServerAPIWithRequest:(Request**)passedRequest httpMethodType:(HTTPMethodNames)httpMethodType AndDictionry:(NSDictionary*)dic AndRequestIDIdentifier:(REQUESTID)requestIDIdentifier;

@end
