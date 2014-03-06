//
//  CardGameHistoryViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 3/3/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "CardGameHistoryViewController.h"

@interface CardGameHistoryViewController ()

@end

@implementation CardGameHistoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self displayHistoryViewText];
}

-(void)settext {
    self.historyView.attributedText = [[NSAttributedString alloc] initWithString:@"This is a test."];
}
-(void)displayHistoryViewText
{
    NSMutableAttributedString *displayText = [[NSMutableAttributedString alloc] init];
    for (NSAttributedString *item in self.history) {
        [displayText appendAttributedString:(NSMutableAttributedString *)item];
        [displayText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    self.historyView.attributedText = [[NSAttributedString alloc] initWithAttributedString:displayText];
}


@end
