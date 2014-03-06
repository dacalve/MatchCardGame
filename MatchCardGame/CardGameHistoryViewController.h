//
//  CardGameHistoryViewController.h
//  MatchCardGame
//
//  Created by David Calvert on 3/3/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardGameHistoryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *historyView;
@property (strong, nonatomic) NSMutableArray *history;


@end
