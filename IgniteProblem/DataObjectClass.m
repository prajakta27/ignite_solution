//
//  DataObjectClass.m
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import "DataObjectClass.h"
#import <UIKit/UIKit.h>

@implementation DataObjectClass

static DataObjectClass *DataObjectObject =nil;

+(DataObjectClass*) getInstance
{
    if (DataObjectObject == nil) {
        
        DataObjectObject = [[self alloc] init];
    }
    return DataObjectObject;
}
-(void) handleFailureResponseWithRequest:(Request*) request withError:(NSError*)e
{
    NSLog(@"error-->>%@",e);
}

- (void)handleNetworkResponseWithRequest:(Request *)request withError:(NSError*)e
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                    message:@"There is some internet problem, Thank you"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"net not working");
    
}

- (void)handleSuccessResponseWithRequest:(Request *)request AndResponse:(Response *)response
{
    NSDictionary *resp = nil;
    resp = (NSDictionary *)response.responseData;
    if([response.responseData isKindOfClass:[NSDictionary class]])
    {
        resp = (NSDictionary *)response.responseData;
    }
    else if([response.responseData isKindOfClass:[NSArray class]]){
        
    }
    switch (request.requestID)
    {
        case POST_SERACH_MOVIE_REQUEST_ID:
            [self storeResponseForGetSearchApi:response];
            break;
            
        case POST_SELECTED_SERACHED_MOVIE_REQUEST_ID:
            [self storeResponseForGetSelectedSearchApi:response];
            break;
            
        default:
            break;
    }
    request.requestStatus.requestStatus = REQUEST_FINISHED;
    
}

-(void) storeResponseForGetSearchApi:(Response*)response
{
    NSMutableArray *resp = (NSMutableArray *)response.responseData;
    self.movieRespArray = [[NSMutableArray alloc]init];
    if([resp isKindOfClass:[NSDictionary class]])
    {
        self.movieRespArray = resp;
    }
}
-(void) storeResponseForGetSelectedSearchApi:(Response*)response
{
    NSMutableArray *resp = (NSMutableArray *)response.responseData;
    self.selctedMovieRespArray = [[NSMutableArray alloc]init];
    if([resp isKindOfClass:[NSDictionary class]])
    {
        self.selctedMovieRespArray = resp;
    }
}




@end
