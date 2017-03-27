//
//  SelectedMovieViewController.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedMovieViewController : UIViewController
@property (strong, nonatomic) NSString *imgStr;
@property (strong, nonatomic) NSString *plotStr;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *releaseStr;
@property (strong, nonatomic) NSString *cast;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollingView;




@end
