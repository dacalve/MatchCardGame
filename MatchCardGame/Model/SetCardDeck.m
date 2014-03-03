//
//  SetCardDeck.m
//  MatchCardGame
//
//  Created by David Calvert on 2/27/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init
{
    self = [super init];
    if (self) {
        for (NSString *figure in SetCard.validFigures) {
            for (UIColor *color in SetCard.validColors) {
                for (NSNumber *shade in SetCard.validShades) {
                    SetCard *card = [[SetCard alloc] init];
                    card.figure = figure;
                    card.color = color;
                    card.shade = shade;
                    [self addCard:card];
                }
            }
        }
    }
    
    return self;
}


@end
