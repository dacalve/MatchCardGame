//
//  SetCard.h
//  MatchCardGame
//
//  Created by David Calvert on 2/27/14.
//  Copyright (c) 2014 David Calvert. All rights reserved.
//

#import "Card.h"


@interface SetCard : Card

@property (strong, nonatomic) UIColor *color; //red, green, blue
@property (strong, nonatomic) NSString *figure; //circle, square, triangle
@property (nonatomic) NSNumber *shade; //number of shapes (transparent, medium, opaque)

+(NSArray *)validFigures;
+(NSArray *)validColors;
+(NSArray *)validShades;

@end
