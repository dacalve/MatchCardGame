//
//  MatchCardGameViewController.h
//  MatchCardGame
//
//  Created by David Calvert on 2/13/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//
//  Abstract class - must implement abstract methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface MatchCardGameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
//protected for subclasses
-(Deck *) createDeck; //abstract method

-(void) updateUI;

@end
