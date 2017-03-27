//
//  APIFile.m
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import "APIFile.h"


@implementation APIFile

static APIFile *APIfileObject =nil;


+ (APIFile*)getInstance
{
    if (APIfileObject == nil)
        APIfileObject = [[self alloc] init];
    
    return APIfileObject;
}

+ (void)callServerAPIWithRequest:(Request**)passedRequest httpMethodType:(HTTPMethodNames)httpMethodType AndDictionry:(NSDictionary*)dic AndRequestIDIdentifier:(REQUESTID)requestIDIdentifier
{
    
    NSString *url;
    switch (requestIDIdentifier)
    {
        case POST_SERACH_MOVIE_REQUEST_ID:
        {
           
            url = [NSString stringWithFormat:@"http://www.omdbapi.com/?s=%@&page=%@",[dic valueForKey:@"searchStr"],[dic valueForKey:@"PageNo"]];
        }
            break;
            
        case POST_SELECTED_SERACHED_MOVIE_REQUEST_ID:
        {
           
            url = [NSString stringWithFormat:@"http://www.omdbapi.com/?i=%@",[dic valueForKey:@"imdbID"]];
        }

            
        default:
            break;
    }
    
    Request *pRequest = [[Request alloc] init];
    NSString *aRequestURL = nil;
    
    if(httpMethodType == hTTPMethodGet)
        aRequestURL = url;
    else
        aRequestURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    pRequest.url = [NSURL URLWithString:aRequestURL];
    pRequest.requestID = requestIDIdentifier;
    if(passedRequest)
    {
        *passedRequest = pRequest;
    }
    
    if(httpMethodType == hTTPMethodPost)
    {
        [self sendPostAPIWithURI:url requestId:requestIDIdentifier withDictionry:[dic mutableCopy] forRequest:pRequest];
    }
    
    else  if(httpMethodType == hTTPMethodGet)
    {
        [self sendGetAPIWithURI:url requestId:requestIDIdentifier forRequest:pRequest];
    }
    
}
+(void)sendPostAPIWithURI:(NSString*)urlString requestId:(REQUESTID)requestID withDictionry:(NSMutableDictionary*)dic forRequest:(Request*)pRequest
{
    
    
    NSString *data = [dic valueForKey:@"data"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSString* webStringURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:webStringURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [data dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"RESPONSE: %@",response);
        NSLog(@"DATA: %@",data);
        
        if (!error) {
            // Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    // Error Parsing JSON
                    [[DataObjectClass getInstance] handleFailureResponseWithRequest:pRequest withError:jsonError];
                    
                } else {
                    // Success Parsing JSON
                    // Log NSDictionary response:
                    Response *response = [[Response alloc]init];
                    response.responseData = jsonResponse;
                    [[DataObjectClass getInstance] handleSuccessResponseWithRequest:pRequest AndResponse:response];
                    NSLog(@"resp-->>%@",jsonResponse);
                }
            }  else
            {
                //Web server is returning an error
            }
        } else {
            // Fail
            NSLog(@"error : %@", error.description);
        }
    }];
    [postDataTask resume];
}

+(void)sendGetAPIWithURI:(NSString*)urlString requestId:(REQUESTID)requestID forRequest:(Request*)pRequest
{
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *encodedUrlAsString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"RESPONSE: %@",response);
        NSLog(@"DATA: %@",data);
        
        if (!error) {
            // Success
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    // Error Parsing JSON
                    [[DataObjectClass getInstance] handleFailureResponseWithRequest:pRequest withError:jsonError];
                    
                } else {
                    // Success Parsing JSON
                    // Log NSDictionary response:
                    Response *response = [[Response alloc]init];
                    response.responseData = jsonResponse;
                    [[DataObjectClass getInstance] handleSuccessResponseWithRequest:pRequest AndResponse:response];
                    
                    NSLog(@"resp-->>%@",jsonResponse);
                }
            }  else
            {
                //Web server is returning an error
            }
        }
        else
        {
            NSLog(@"error : %@", error.description);
        }
    }] resume];
    
    
}



@end
