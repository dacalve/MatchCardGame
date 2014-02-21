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
@property (nonatomic, strong) NSMutableArray *cards; // array of Card
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
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            //match against other cards.
            //int cardsChosen = 0;
            NSMutableArray *selectedCards = [[NSMutableArray alloc]init];
            for (Card *otherCard in self.cards) {
                if ((otherCard.isChosen)&&(!otherCard.isMatched)) {
                    [selectedCards addObject:otherCard];
                }
            }
            
            if ([selectedCards count] == (self.howManyCardsToMatch - 1)) {
                NSArray *chosenCards = [NSArray arrayWithArray:selectedCards];
                int matchScore = [card match:chosenCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    [self matchSelectedCards:selectedCards];
                    
                } else {
                    self.score -= MISMATCH_PENALTY;
                    [self toggleSelectedCards:selectedCards with:NO];
                }
                self.score -= COST_TO_CHOOSE;
            }

            card.chosen = YES;
            
        }
    }
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
