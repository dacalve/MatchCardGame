//
//  MatchCardGameViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 2/13/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "MatchCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface MatchCardGameViewController ()

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchResults;
@property (nonatomic) NSUInteger howManyCardsToMatch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *howManyCardsSegmentedControl;
@end

@implementation MatchCardGameViewController

- (NSUInteger)howManyCardsToMatch
{
    if (_howManyCardsToMatch == 0) {
        _howManyCardsToMatch = 2; //set default to 2.
    }
    return _howManyCardsToMatch;
}
- (IBAction)howManyCardsControl:(id)sender {
    [self setCardsToMatch:sender];
}

-(void)setCardsToMatch:(UISegmentedControl *)howManyCardsSegmentedControl
{
    NSInteger selectedSegment = howManyCardsSegmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        self.howManyCardsToMatch = 2;
    } else {
        self.howManyCardsToMatch = 3;
    }
    [self.game matchMode:self.howManyCardsToMatch];
}

-(CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    [_game matchMode:self.howManyCardsToMatch];
    return _game;
}

-(PlayingCardDeck *) createDeck
{
    return [[PlayingCardDeck alloc]init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    self.howManyCardsSegmentedControl.enabled = NO;
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)reDealButton:(UIButton *)sender {
    self.game = nil;
    self.howManyCardsSegmentedControl.enabled = YES;
    [self setCardsToMatch:self.howManyCardsSegmentedControl];
    [self updateUI];
}

- (void)updateUI
{
    NSMutableString *matchedCardText = [[NSMutableString alloc]init];
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
    return card.isChosen ? card.contents : @"";
}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}





@end
