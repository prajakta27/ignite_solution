//
//  SearchedResultViewController.h
//  IgniteProblem
//
//  Created by Prajakta Vishwas Sonawane on 3/23/17.
//  Copyright © 2017 Prajakta Vishwas Sonawane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchedResultViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UIImageView *posterImage;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *imageArray,*idArr;
@property (strong, nonatomic) NSMutableDictionary *loadStatusDictionary;
@property (strong, nonatomic) IBOutlet  UILabel *titleLabel;
@property (strong, nonatomic) NSString *searchMovieString;
@property (nonatomic) NSNumber *indexSearchAPI;
@property (strong ,nonatomic) NSMutableDictionary *selectMovieInfo;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
