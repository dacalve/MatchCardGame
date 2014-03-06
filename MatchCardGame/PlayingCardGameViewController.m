//
//  PlayingCardGameViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 2/28/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardGameHistoryViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playingCardHistory"]) {

        CardGameHistoryViewController *historyViewController = segue.destinationViewController;
        historyViewController.history = self.history;
    }
}

-(CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    [game matchMode:2 usingMultiPassMatch:NO];//set number to match and combination match.
    return game;
}

//protected for subclasses
-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

//build the (un)matched cards portion of the match results.
-(NSMutableString *)buildMatchedCardLabelText
{
    NSMutableString *matchedCardText = [[NSMutableString alloc]init];
    for (Card *card in self.game.currentCards) {
        [matchedCardText appendString:card.contents];
    }
    return matchedCardText;
}

-(void)setAttributesForButton:(UIButton *)button forCard:(Card *)card
{
    if (!card.matched) {
        //clear the title so doesn't show thru the background.
        [button setAttributedTitle:[[NSAttributedString alloc] init] forState:UIControlStateNormal];

    } else {
        [button setAlpha:0.25]; //dim the background after it is matched.
    }
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    //Choose red color if the suit is diamond or heart.
    UIColor *color = ([@[@"♥︎",@"♦︎"] containsObject:((PlayingCard *)card).suit]) ? [UIColor redColor] : [UIColor blackColor];
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font};
    return [[NSAttributedString alloc] initWithString:card.contents attributes:dict];

}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
