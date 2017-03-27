//
//  SearchedResultViewController.m
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import "SearchedResultViewController.h"
#import "DataObjectClass.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import "SelectedMovieViewController.h"
UIImage *placeHolderImage;

@interface SearchedResultViewController ()
{
    UIImage *selectImage;
    NSMutableArray *selectedMovieArr;
    UIActivityIndicatorView *spinner;
    UIAlertView *loadingAlert;
    NSString *posterImgString;
}

@end

@implementation SearchedResultViewController
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.loadStatusDictionary = [[NSMutableDictionary alloc] init];
    self.posterImage = [[UIImageView alloc]init];
    self.indexSearchAPI = [NSNumber numberWithInt:1];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleLabel.text = self.searchMovieString;
    placeHolderImage = [UIImage imageNamed:@"prescription_ph"];
    if ([[DataObjectClass getInstance]movieRespArray])
    {
        self.imageArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *imageUrlFetchDic in [[[DataObjectClass getInstance] movieRespArray] valueForKey:@"Search"])
        {
                    NSString *urlString = [imageUrlFetchDic objectForKey:@"Poster"];
                    [self.imageArray addObject:urlString];
                    [self.idArr addObject:[imageUrlFetchDic objectForKey:@"id"]];
          
        }
    }
    
    [self.collectionView reloadData];
    loadingAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Loading...." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setColor:[UIColor orangeColor]];
    spinner.center = CGPointMake(139.5, 75.5);
    [loadingAlert setValue:spinner forKey:@"accessoryView"];
    [spinner startAnimating];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  
    return [[[[DataObjectClass getInstance] movieRespArray] valueForKey:@"Search"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.backgroundColor = [UIColor lightGrayColor];
    
    //return cell;
    self.posterImage = [[UIImageView alloc] init];
    [self.posterImage setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    NSString *urlString = NULL;
    if(indexPath.row < [self.imageArray count])
        urlString = [self.imageArray objectAtIndex:indexPath.row];

    [self.loadStatusDictionary setObject:placeHolderImage forKey:[NSNumber numberWithInteger:indexPath.row]];

    if(![urlString isEqual:[NSNull null]])
    {
        __block NSInteger index = indexPath.row;
        [self.posterImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if((image != nil) && (index>=0))
             {
                 [self.loadStatusDictionary setObject:image forKey:[NSNumber numberWithInteger:index]];
                 
             }
             
         }];
    }
    UIView *titleAndLabelView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, cell.frame.size.width, 30)];
    NSMutableArray *arr = [[[DataObjectClass getInstance] movieRespArray] valueForKey:@"Search"];
    
    titleLabel.text =  [[arr valueForKey:@"Title"]objectAtIndex:indexPath.row];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *releaseStr = [[UILabel alloc] initWithFrame:CGRectMake(3, titleLabel.frame.origin.y + titleLabel.frame.size.height +5 , cell.frame.size.width, 30)];
    releaseStr.text = [NSString stringWithFormat:@"Release year : %@", [[arr valueForKey:@"Year"]objectAtIndex:indexPath.row]];
    [releaseStr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16]];
    [releaseStr setTextColor:[UIColor whiteColor]];
    
    
    [titleAndLabelView setFrame:CGRectMake(0, cell.frame.size.height - 80,cell.frame.size.width , 80)];
    titleAndLabelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [titleAndLabelView addSubview:titleLabel];
    [titleAndLabelView addSubview:releaseStr];
    [self.posterImage addSubview:titleAndLabelView];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:self.posterImage];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if(distanceFromBottom < height)
    {
        int value = [self.indexSearchAPI intValue];
        self.indexSearchAPI = [NSNumber numberWithInt:value + 1];
        [self searchMovieAPI:self.searchMovieString];
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
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        [dataDic setObject:serachString forKey:@"searchString"];
        [dataDic setObject:self.indexSearchAPI forKey:@"pageNo"];
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
            [self.collectionView reloadData];
        }
    }
    else if(pRequest.requestID == POST_SELECTED_SERACHED_MOVIE_REQUEST_ID)
    {
        if([[DataObjectClass getInstance]selctedMovieRespArray] != nil)
        {
            NSLog(@"------>>>%@",[[DataObjectClass getInstance]selctedMovieRespArray]);
            selectedMovieArr = [[DataObjectClass getInstance]selctedMovieRespArray];
            [self stopLoadingAlert];
            [self performSegueWithIdentifier:@"selectedmoviesegue" sender:self];
        }
    }
    [pRequest.requestStatus removeObserver:self forKeyPath:KEY_PATH_REQUEST_STATUS];
}
-(void)stopLoadingAlert
{
    if(loadingAlert != nil)
        [loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *imdbIDNo = [[[[[DataObjectClass getInstance] movieRespArray] valueForKey:@"Search"] valueForKey:@"imdbID"]objectAtIndex:indexPath.row];
    
    selectImage = [self.loadStatusDictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]];
    [self searchSelectedMovieAPI:imdbIDNo];
    [loadingAlert show];
    
    posterImgString = [[[[[DataObjectClass getInstance] movieRespArray] valueForKey:@"Search"] valueForKey:@"Poster"]objectAtIndex:indexPath.row];
    
    
}

-(void) searchSelectedMovieAPI:(NSString *)imdbIDNo
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
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
        [dataDic setObject:imdbIDNo forKey:@"imdbID"];
        [APIFile callServerAPIWithRequest:&pRequest httpMethodType:hTTPMethodPost AndDictionry:dataDic AndRequestIDIdentifier:POST_SELECTED_SERACHED_MOVIE_REQUEST_ID];
        
        RequestStatus *reqSt=pRequest.requestStatus;
        [reqSt addObserver:self forKeyPath:KEY_PATH_REQUEST_STATUS options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:(__bridge void*)pRequest];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectedmoviesegue"]) {
        
        SelectedMovieViewController *selectedMovieVC = (SelectedMovieViewController*)[segue destinationViewController];
        
        selectedMovieVC.imgStr = posterImgString;
        selectedMovieVC.titleStr = [selectedMovieArr valueForKey:@"Title"];
        selectedMovieVC.plotStr = [selectedMovieArr valueForKey:@"Plot"];
        selectedMovieVC.cast = [selectedMovieArr valueForKey:@"Actors"];
        selectedMovieVC.releaseStr = [selectedMovieArr valueForKey:@"Year"];
    
    }
}

-(IBAction)backBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
