//
//  SetCardGameViewController.m
//  MatchCardGame
//
//  Created by David Calvert on 2/27/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController()

@property (weak, nonatomic) IBOutlet UITextView *matchTextView;
@property (weak, nonatomic) IBOutlet UILabel *scoreResult;

@end


@implementation SetCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad]; // always let super have a chance in lifecycle methods
    // do some setup of my MVC
    [self updateUI];
}

-(Deck *) createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
    //[super updateUI];
    NSMutableAttributedString *cardTextResult = [[NSMutableAttributedString alloc] init];
    for (UIButton *button in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:button];
        Card *card = [self.game cardAtIndex:cardButtonIndex];


        //[button setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [button setBackgroundImage:[self imageForCard:card] forState:UIControlStateNormal];
        [button setAlpha:card.isChosen ? 0.65: 1.0];  //dim the background for selection.
        button.enabled = !card.isMatched;

        for (Card *currentCard in self.game.currentCards) {
            if (currentCard == card) {
                [cardTextResult appendAttributedString:[self titleForCard:card]];
                if (card.isMatched) {
                    [button setAlpha:0.20]; //dim the background after it is matched.
                }
            }
        }
    }

    if (cardTextResult) {

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
            
            self.matchTextView.attributedText = result;
            
            
        } else if (self.game.lastScore < 0){
            //create the attributed text for the unsuccessful result of the 3 cards picked.
            NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
            [result appendAttributedString:cardTextResult];
            NSString *pointsResult = [NSString stringWithFormat:@"don't match! %d point penalty!", self.game.lastScore];
            NSAttributedString *scoreResult = [[NSAttributedString alloc] initWithString:pointsResult attributes:dict];
            [result appendAttributedString:scoreResult];
            
            self.matchTextView.attributedText = result;
            
            
        } else {
            self.matchTextView.attributedText = [[NSAttributedString alloc] init];
        }
    }
    self.scoreResult.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    //UIColor *cardColor = ((SetCard *)card).color;
    NSString *cardFigure = ((SetCard *)card).figure;
    NSNumber *cardShade = ((SetCard *)card).shade;
    NSNumber *strokeValue = nil;
    double alpha = 0.0;
    if ([cardShade intValue] == 1) { // dim
        alpha = 0.35;
        strokeValue = [NSNumber numberWithInt:([cardShade intValue]*-1)];
    } else if ([cardShade intValue] == 2) { // solid
        alpha = 1.0;
        strokeValue = [NSNumber numberWithInt:([cardShade intValue]*-1)];
    } else if ([cardShade intValue] == 3) { // outline
        alpha = 1.0;
        strokeValue = [NSNumber numberWithInt:([cardShade intValue]*2)];
    }
    UIColor *color = [((SetCard *)card).color colorWithAlphaComponent:alpha];
    UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:38.0f];
    NSDictionary *dict = @{NSForegroundColorAttributeName: color, NSStrokeWidthAttributeName: strokeValue, NSFontAttributeName: font};
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:cardFigure attributes:dict];

    return cardContents;
}

-(UIImage *)imageForCard:(Card *)card
{
    return [UIImage imageNamed:@"cardfront"];
}

@end
