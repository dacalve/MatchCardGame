//
//  MatchCardGameViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 2/13/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "MatchCardGameViewController.h"
#import "Deck.h"


@interface MatchCardGameViewController ()

@property (nonatomic) NSUInteger howManyCardsToMatch;

@end

@implementation MatchCardGameViewController

-(CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];

    return _game;
}

-(Deck *) createDeck //abstract method
{
    return nil;
}

- (NSUInteger)howManyCardsToMatch
{
    if (_howManyCardsToMatch == 0) {
        _howManyCardsToMatch = 3; //set default to 2.
    }
    return _howManyCardsToMatch;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)reDealButton:(UIButton *)sender {
    self.game = nil;
    [self updateUI];
}

- (void)updateUI
{
//    for (UIButton *button in self.cardButtons) {
//        int cardButtonIndex = [self.cardButtons indexOfObject:button];
//        Card *card = [self.game cardAtIndex:cardButtonIndex];
//        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        //[button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
//        
//        button.enabled = !card.isMatched;
//        //break;
//    }
//    //populate match results and score labels.
//    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
//    if (self.game.lastScore > 0) {
//            self.matchResults.text = [NSString stringWithFormat:@"Matched %@ for %d points",[self buildMatchedCardLabelText], self.game.lastScore];
//    } else if (self.game.lastScore < 0){
//        self.matchResults.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [self buildMatchedCardLabelText], self.game.lastScore];
//    } else {
//        self.matchResults.text = @"";
//    }
}







@end
