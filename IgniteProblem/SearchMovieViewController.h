//
//  SearchMovieViewController.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchMovieViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextView *searchStringTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;


@end
