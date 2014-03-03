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

}







@end
