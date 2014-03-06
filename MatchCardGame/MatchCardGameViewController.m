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

-(void)setAttributesForButton:(UIButton *)button forCard:(Card *)card;
-(UIImage *)imageForCard:(Card *)card;
-(NSAttributedString *)titleForCard:(Card *)card;
-(void)displayResults:(NSMutableAttributedString *)cardTextResult;
@end

@implementation MatchCardGameViewController


-(CardMatchingGame *)game
{
    if (!_game) {
       _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                 usingDeck:[self createDeck]];
        self.history = [[NSMutableArray alloc] init];//track history of card choices.
    }

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
    //self.history = [[NSMutableArray alloc] init];
    [self updateUI];
}

- (void)updateUI
{
    NSMutableAttributedString *cardTextResult = [[NSMutableAttributedString alloc] init];
    
    for (UIButton *button in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        [self setAttributesForButton:button forCard:card];
        [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
        [button setAlpha:card.isChosen ? 0.65: 1.0];  //dim the background for selection.
        button.enabled = !card.isMatched;
        
        for (Card *currentCard in self.game.currentCards) {
            if (currentCard == card) {
                if (card.isChosen) {
                    [button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
                }
                [cardTextResult appendAttributedString:[self titleForCard:card]];
                if (card.isMatched) {
                    [button setAlpha:0.25]; //dim the background after it is matched.
                }
                
            }
        }
    }
    
    [self displayResults:cardTextResult];
}

- (void)displayResults:(NSMutableAttributedString *)cardTextResult
{
    if (cardTextResult) {
        
        //populate match results and score labels.
        UIFont *font=[UIFont fontWithName:@"Helvetica" size:12.0f];
        NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: font};
        if (self.game.lastScore > 0) {
            
            //create the attributed text for the successful result of the 3 cards picked.
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"Matched " attributes:dict];
            [result appendAttributedString:cardTextResult];
            NSString *pointsResult = [NSString stringWithFormat:@" for %d points!", self.game.lastScore];
            NSAttributedString *scoreResult = [[NSAttributedString alloc] initWithString:pointsResult attributes:dict];
            [result appendAttributedString:scoreResult];
            
            self.resultView.attributedText = result;
            [self.history insertObject:result atIndex:0];
            
            
        } else if (self.game.lastScore < 0){
            //create the attributed text for the unsuccessful result of the 3 cards picked.
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
            [result appendAttributedString:cardTextResult];
            NSString *pointsResult = [NSString stringWithFormat:@" don't match! %d point penalty!", abs(self.game.lastScore)];
            NSAttributedString *scoreResult = [[NSAttributedString alloc] initWithString:pointsResult attributes:dict];
            [result appendAttributedString:scoreResult];
            
            self.resultView.attributedText = result;
            [self.history insertObject:result atIndex:0];
            
            
        } else {
            
            self.resultView.text = @"";
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

-(void)setAttributesForButton:(UIButton *)button forCard:(Card *)card
{
    
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    return [[NSAttributedString alloc] init];
}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:@"cardfront"];
}


@end
