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

@interface PlayingCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *resultView;

@end

@implementation PlayingCardGameViewController

-(CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    [game matchMode:2 usingMultiPassMatch:NO];
    return game;
}

//protected for subclasses
-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateUI
{
    NSMutableAttributedString *cardTextResult = [[NSMutableAttributedString alloc] init];
    
    for (UIButton *button in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        if (!card.matched) {
            [button setAttributedTitle:[[NSAttributedString alloc] init] forState:UIControlStateNormal];
        }
        [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
        
        button.enabled = !card.isMatched;
        
        for (Card *currentCard in self.game.currentCards) {
            if (currentCard == card) {
                if (card.isChosen) {
                    [button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
                }
                [cardTextResult appendAttributedString:[self titleForCard:card]];
//                if (card.isMatched) {
//                    [button setAlpha:0.20]; //dim the background after it is matched.
//                }
            }
        }
    }
    
    //populate match results and score labels.
    UIFont *font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: font};
    if (self.game.lastScore > 0) {

        //create the attributed text for the successful result of the 3 cards picked.
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"Matched " attributes:dict];
        [result appendAttributedString:cardTextResult];
        NSString *pointsResult = [NSString stringWithFormat:@" for %d points", self.game.lastScore];
        NSAttributedString *scoreResult = [[NSAttributedString alloc] initWithString:pointsResult attributes:dict];
        [result appendAttributedString:scoreResult];
        
        self.resultView.attributedText = result;
    
    } else if (self.game.lastScore < 0){
        //create the attributed text for the unsuccessful result of the 3 cards picked.
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
        [result appendAttributedString:cardTextResult];
        NSString *pointsResult = [NSString stringWithFormat:@"don't match! %d point penalty!", abs(self.game.lastScore)];
        NSAttributedString *scoreResult = [[NSAttributedString alloc] initWithString:pointsResult attributes:dict];
        [result appendAttributedString:scoreResult];
        
        self.resultView.attributedText = result;
        
    } else {
        
        self.resultView.text = @"";
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];

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

-(NSAttributedString *)titleForCard:(Card *)card
{
    //Choose red color if the suit is diamond or heart.
    UIColor *color = ([@[@"♥︎",@"♦︎"] containsObject:((PlayingCard *)card).suit]) ? [UIColor redColor] : [UIColor blackColor];
    //UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:24.0f];//[UIFont preferredFontForTextStyle:UIFontTextStyleBody]
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSDictionary *dict = @{NSForegroundColorAttributeName:color, NSFontAttributeName:font};
    return [[NSAttributedString alloc] initWithString:card.contents attributes:dict];

}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
