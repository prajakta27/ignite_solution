//
//  SelectedMovieViewController.m
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import "SelectedMovieViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SelectedMovieViewController ()
{
    UIImage *placeHolderImage;
    UIButton *backBtn;
}

@end

@implementation SelectedMovieViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.scrollingView setContentOffset: CGPointMake(0,0)];
    [self viewForselectdScreen];
}

- (UIColor *)colorWithHexString:(NSString *)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


-(void) viewForselectdScreen
{
    
    UIImageView *posterImgView = [[UIImageView alloc] init];
    backBtn = [[UIButton alloc] init];
    UIImageView *backbttnImg = [[UIImageView alloc] init];
    UIView *castView = [[UIView alloc] init];
    UIView *titleAndReleseView = [[UIView alloc] init];
    UIView *detailView = [[UIView alloc] init];
    
    
    [posterImgView setFrame:CGRectMake(0, 0, self.scrollingView.frame.size.width, 350)];
    [_scrollingView addSubview:posterImgView];
    
    NSString *urlString;
    urlString = NULL;
    urlString = self.imgStr;
    placeHolderImage = [UIImage imageNamed:@"prescription_ph"];
    posterImgView.image = placeHolderImage;
    if(![urlString isEqual:[NSNull null]])
    {
        [posterImgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             posterImgView.image = image;
             
         }];
    }
    
    [backBtn setFrame:CGRectMake(30, 30, 50, 50)];
    [backbttnImg setFrame:CGRectMake(10, 10, 30, 30)];
    backbttnImg.image = [UIImage imageNamed:@"back-arrow-circle"];
    [backBtn addSubview:backbttnImg];
    [backBtn setUserInteractionEnabled:YES];
   
    [_scrollingView addSubview:backBtn];
    [_scrollingView bringSubviewToFront:backBtn];
     [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [castView setFrame:CGRectMake(0, posterImgView.frame.size.height-80, self.scrollingView.frame.size.width, 80)];
    UILabel *castLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, castView.frame.size.width-40,castView.frame.size.height )];
    castLabel.numberOfLines = 0;
    castLabel.textAlignment = NSTextAlignmentCenter;
    castLabel.textColor = [UIColor darkGrayColor];
    castLabel.text =[NSString stringWithFormat:@"Cast : %@",   self.cast];
    [castLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [castView addSubview:castLabel];
    [posterImgView addSubview:castView];
    
    [titleAndReleseView setFrame:CGRectMake(0, posterImgView.frame.origin.y+posterImgView.frame.size.height+1, self.scrollingView.frame.size.width, 100)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, titleAndReleseView.frame.size.width-40,41 )];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    titleLabel.text = self.titleStr;
    [titleAndReleseView setBackgroundColor:[UIColor orangeColor]];
    [titleAndReleseView setBackgroundColor:[self colorWithHexString:@"f5ab35"]];
    
    UILabel *relaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.size.height+5, titleAndReleseView.frame.size.width-40,41 )];
    [relaseLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
    relaseLabel.textAlignment = NSTextAlignmentCenter;
    relaseLabel.textColor = [UIColor whiteColor];
    relaseLabel.text = [NSString stringWithFormat:@"Release Year : %@",  self.releaseStr];
    
    [titleAndReleseView addSubview:titleLabel];
    [titleAndReleseView addSubview:relaseLabel];
    [self.scrollingView addSubview:titleAndReleseView];
    
    [detailView setFrame:CGRectMake(0, titleAndReleseView.frame.origin.y+titleAndReleseView.frame.size.height, self.scrollingView.frame.size.width, 300)];
    UITextView *detailsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, castView.frame.size.width-40,290)];
    
    [detailView addSubview:detailsTextView];
    [detailsTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    detailsTextView.textAlignment = NSTextAlignmentCenter;
    [self.scrollingView addSubview:detailView];
    detailsTextView.text = self.plotStr;
    if ( [detailsTextView.text isEqualToString:@"N/A"]) {
        detailsTextView.text = @"No Info Available";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction:(id)sender
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
