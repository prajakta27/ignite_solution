//
//  DataObjectClass.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIFile.h"
@interface DataObjectClass : NSObject


+(DataObjectClass*) getInstance;
-(void)handleSuccessResponseWithRequest:(Request *)request AndResponse:(Response *)response;
- (void)handleNetworkResponseWithRequest:(Request *)request withError:(NSError*)e;
-(void) handleFailureResponseWithRequest:(Request*) request withError:(NSError*)e;
-(void) storeResponseForGetSearchApi:(Response*)response;
-(void) storeResponseForGetSelectedSearchApi:(Response*)response;


@property (nonatomic, strong) NSMutableArray *movieRespArray;
@property (nonatomic, strong) NSMutableArray *selctedMovieRespArray;


@end
