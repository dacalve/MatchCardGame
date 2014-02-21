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

//- (IBAction)matchNumberControl:(id)sender forEvent:(UIEvent *)event {
//    
//    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
//    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;    
//    if (selectedSegment == 0) {
//        self.howManyCardsToMatch = 2;
//    } else{
//        self.howManyCardsToMatch = 3;
//    }
//    [self.game matchMode:self.howManyCardsToMatch];
//}
-(void)setCardsToMatch:(UISegmentedControl *)howManyCardsSegmentedControl
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) howManyCardsSegmentedControl;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
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
    int buttonsChosen = 0;
    for (UIButton *button in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
        button.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    }
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
