//
//  PlayingCardGameViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 2/28/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchResults;
@end

@implementation PlayingCardGameViewController

-(CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    [game matchMode:2 usingMultiPassMatch:YES];
    return game;
}

//protected for subclasses
-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateUI
{
    for (UIButton *button in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
        
        button.enabled = !card.isMatched;
    }
    //populate match results and score labels.
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    if (self.game.lastScore > 0) {
        self.matchResults.text = [NSString stringWithFormat:@"Matched %@ for %d points",[self buildMatchedCardLabelText], self.game.lastScore];
    } else if (self.game.lastScore < 0){
        self.matchResults.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [self buildMatchedCardLabelText], self.game.lastScore];
    } else {
        self.matchResults.text = @"";
    }
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

-(NSString *)titleForCard:(Card *)card
{
    return [[NSString alloc] initWithString:card.isChosen ? card.contents : @""];
}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
