//
//  CardMatchingGame.m
//  MatchCardGame
//
//  Created by David Calvert on 2/17/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger lastScore;
@property (nonatomic, strong) NSMutableArray *cards; // array of Card

@property (nonatomic, readwrite) NSArray *currentCards;
@property NSUInteger howManyCardsToMatch;

@end
@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

static const int DEFAULT_MATCH_MODE = 2;

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init]; //super's designated initializer
    if (self) {
        [self matchMode:DEFAULT_MATCH_MODE];
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
            
        }
    }
    return self;
}

- (void)matchMode:(NSUInteger)cardsToMatch
{
    self.howManyCardsToMatch = cardsToMatch;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    self.lastScore = 0;
    Card *card = [self cardAtIndex:index];
    
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            
            NSMutableArray *workingCards = [self setUpWorkingCardArrays:card];
            
            if ([workingCards count] == (self.howManyCardsToMatch - 1)) {
                
                int matchScore = 0;
                NSArray *chosenCards = [NSArray arrayWithArray:workingCards];
                matchScore = [card match:chosenCards];
                
                if (self.howManyCardsToMatch > 2) {
                    //find the score of the 2nd and 3rd cards chosen and add to above score.
                    Card* insideCard = workingCards[0];
                    NSMutableArray *remainingChosenCards = [[NSMutableArray alloc] init];
                    for (int i=1; i < [workingCards count]; i++) {
                        [remainingChosenCards addObject:workingCards[i]];
                    }
                    matchScore += [insideCard match:remainingChosenCards];
                                        
                }
                if (matchScore) {
                    self.lastScore = matchScore * MATCH_BONUS;
                    self.score += self.lastScore;
                    card.matched = YES;
                    [self matchSelectedCards:workingCards];
                    
                } else {
                    self.lastScore = -MISMATCH_PENALTY;
                    self.score += self.lastScore;
                    [self toggleSelectedCards:workingCards with:NO];
                }
                self.score += -COST_TO_CHOOSE;
                

            }
            card.chosen = YES;
        }
    }

    NSLog(@"last score:%d",self.lastScore);
}

-(NSMutableArray *)setUpWorkingCardArrays:(Card *)card
{
    //build an array of the cards we are going to match and make this list public for controller.
    NSMutableArray *selectedCards = [[NSMutableArray alloc]init];
    for (Card *otherCard in self.cards) {
        if ((otherCard.isChosen)&&(!otherCard.isMatched)) {
            [selectedCards addObject:otherCard];
        }
    }
    
    //populate currentCards with an array of all currently selected cards.
    [selectedCards addObject:card];
    self.currentCards = [selectedCards copy];
    [selectedCards removeObjectAtIndex:[selectedCards count]-1];
    
    return selectedCards; //return array of cards without the current card for match calc processing.
}

-(void)matchSelectedCards:(NSMutableArray *)selectedCards
{
    for (Card *otherCard in selectedCards) {
        otherCard.matched = YES;
    }
}

-(void)toggleSelectedCards:(NSMutableArray *)selectedCards with:(BOOL)onoff
{
    for (Card *otherCard in selectedCards) {
        otherCard.chosen = onoff;
    }
}





@end
