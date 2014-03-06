//
//  SetCardGameViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 2/27/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardGameHistoryViewController.h"

@interface SetCardGameViewController()

@end


@implementation SetCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad]; // always let super have a chance in lifecycle methods
    // do some setup of my MVC
    [self updateUI];
}

-(Deck *) createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setCardGameHistory"]) {
        
        CardGameHistoryViewController *historyViewController = segue.destinationViewController;
        historyViewController.history = self.history;
    }
}


-(void)setAttributesForButton:(UIButton *)button forCard:(Card *)card
{
    if (!card.matched) {
        [button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
    }
    [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
    [button setAlpha:card.isChosen ? 0.65: 1.0];  //dim the background for selection.
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    NSString *cardFigure = ((SetCard *)card).figure;
    NSNumber *cardShade = ((SetCard *)card).shade;
    NSNumber *strokeValue = nil;
    double alpha = 0.0;
    if ([cardShade intValue] == 1) { // dim
        alpha = 0.35;
        strokeValue = [NSNumber numberWithInt:([cardShade intValue]*-1)];
    } else if ([cardShade intValue] == 2) { // solid
        alpha = 1.0;
        strokeValue = [NSNumber numberWithInt:([cardShade intValue]*-1)];
    } else if ([cardShade intValue] == 3) { // outline
        alpha = 1.0;
        strokeValue = [NSNumber numberWithInt:([cardShade intValue]*2)];
    }
    UIColor *cardColor = [((SetCard *)card).color colorWithAlphaComponent:alpha];
    UIFont *cardFont=[UIFont fontWithName:@"Helvetica-Bold" size:38.0f];

    NSDictionary *dict = @{NSForegroundColorAttributeName: cardColor, NSStrokeWidthAttributeName: strokeValue, NSFontAttributeName: cardFont};
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:cardFigure attributes:dict];

    return cardContents;
}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:@"cardfront"];
}

@end
