//
//  SearchMovieViewController.m
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import "SearchMovieViewController.h"
#import "SearchedResultViewController.h"
#import "Reachability.h"
#import "PacketsFile.h"
#import "APIFile.h"
@interface SearchMovieViewController ()
{
    NSString *searchMovieStr;
     UIActivityIndicatorView *spinner;
     UIAlertView *loadingAlert;
}

@end

@implementation SearchMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.searchBtn.layer.masksToBounds = YES;
     self.searchStringTextView.delegate = self;
    
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Loading...." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor orangeColor]];
    spinner.center = CGPointMake(139.5, 75.5);
    [loadingAlert setValue:spinner forKey:@"accessoryView"];
    [spinner startAnimating];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
}

-(void)stopLoadingAlert
{
    if(loadingAlert != nil)
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)searchBtnClickedAction:(id)sender
{
    if (![self.searchStringTextView.text isEqualToString:@""] && ![self.searchStringTextView.text containsString:@"Search"]) {
        searchMovieStr = self.searchStringTextView.text;
        [self hideKeyBoard];
        [self searchMovieAPI:searchMovieStr];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter movie name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
}

-(void) searchMovieAPI:(NSString *)serachString
{
 
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please check your newtwork availability" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else
        {
            
            Request *pRequest = nil;
            [loadingAlert show];
            NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
            [dataDic setObject:serachString forKey:@"searchString"];
            [dataDic setObject:[NSNumber numberWithInt:1] forKey:@"pageNo"];
            [APIFile callServerAPIWithRequest:&pRequest httpMethodType:hTTPMethodPost AndDictionry:dataDic AndRequestIDIdentifier:POST_SERACH_MOVIE_REQUEST_ID];
            
            RequestStatus *reqSt=pRequest.requestStatus;
            [reqSt addObserver:self forKeyPath:KEY_PATH_REQUEST_STATUS options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:(__bridge void*)pRequest];
        }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    Request *pRequest = ((__bridge Request*)context);
    if(pRequest.requestID == POST_SERACH_MOVIE_REQUEST_ID)
    {
        if([[DataObjectClass getInstance]movieRespArray] != nil)
        {
            [self stopLoadingAlert];
            [self performSegueWithIdentifier:@"searchedmovieviewsegue" sender:self];
        }
    }
    [pRequest.requestStatus removeObserver:self forKeyPath:KEY_PATH_REQUEST_STATUS];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchedmovieviewsegue"]) {
        
        SearchedResultViewController *searchMovieVC = (SearchedResultViewController*)[segue destinationViewController];
        searchMovieVC.searchMovieString = searchMovieStr;
        
        
    }
}

- (BOOL)textViewShouldReturn:(UITextView *)textView
{
    [self.searchStringTextView resignFirstResponder];
    
    return YES;
}
-(void) hideKeyBoard
{
    [self.searchStringTextView resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.searchStringTextView isFirstResponder] == YES && [self.searchStringTextView.text isEqualToString:@"Search Your Favourite movie.."]) {
        self.searchStringTextView.text = @"";
    }
   
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
