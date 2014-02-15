//
//  PlayingCard.m
//  MatchCardGame
//
//  Created by David Calvert on 2/14/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

-(NSString *)suit
{
    return _suit ? _suit : @"?";
}

-(void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

-(void)setRank:(NSUInteger)rank
{
    if (self.rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+(NSArray *)validSuits
{
    return @[@"♣︎",@"♥︎",@"♠︎",@"♦︎"];
}


+(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count]-1;
}

@end
