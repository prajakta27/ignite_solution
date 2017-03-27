//
//  StringsConstants.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#ifndef StringsConstants_h
#define StringsConstants_h


typedef enum
{
    POST_SERACH_MOVIE_REQUEST_ID,
    POST_SELECTED_SERACHED_MOVIE_REQUEST_ID,
//    POST_RESULT_REQUEST_ID,
//    POST_TOKEN_REQUEST_ID,
    
    
}REQUESTID;

typedef enum
{
    hTTPMethodGet,
    hTTPMethodPost,
    hTTPMethodPut,
    hTTPMethodDelete,
} HTTPMethodNames;

#define KEY_PATH_REQUEST_STATUS @"requestStatus"
#define STEPONE  @"1"
#define STEPTWO  @"2"
#define STEPTHREE  @"3"
#define STEPFOUR  @"4"




#endif /* StringsConstants_h */
