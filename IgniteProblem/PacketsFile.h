//
//  PacketsFile.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestStatus;

@interface Request : NSObject
{
    NSURL				*mUrl;
    NSString			*mRequestMethod;
    int                 mRequestID;
    NSData              *mPostData;
    NSObject			*mOptionalData; // Optional data specific to request can be set
    RequestStatus       *mRequestStatus;
    
}



@property(nonatomic) int requestID;

@property(nonatomic,strong) NSString* requestMethod;
@property(nonatomic,strong) NSURL* url;
@property(nonatomic,strong) NSData* postData;
@property(nonatomic,strong) NSObject	*optionalData;
@property (nonatomic, strong) RequestStatus *requestStatus;

@end

@interface Response : NSObject
{
    id	mResponseData;
}
@property(nonatomic,strong) id responseData;
@end

#pragma mark RequestStatus--

typedef enum // Naming Conventions of the Enum's to be decided
{
    REQUEST_INITIALIZED,              //Set when Request object is created
    REQUEST_ON_NETWORKING,            //Set just before sending request in NSURLRequest delegate method
    REQUEST_ON_DATAPROCESSING,        //Set in JSONParserOperation callback method.
    REQUEST_FINISHED
}REQUESTSTATUS;



@interface RequestStatus : NSObject
{
    NSError *mRequestError;
    REQUESTSTATUS mRequestStatus;
    int mStatusCode;
    NSString *mStatusMessage;
}
@property(nonatomic, strong) NSError *requestError;
@property(nonatomic, unsafe_unretained) REQUESTSTATUS requestStatus;
@property(nonatomic) int statusCode;
@property(nonatomic, strong)NSString *statusMessage;



@end
