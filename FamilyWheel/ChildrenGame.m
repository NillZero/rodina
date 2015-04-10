//
//  ChildrenGame.m
//  FamilyWheel
//
//  Created by Thiago Borges Gonçalves Penna on 4/8/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

#import "ChildrenGame.h"

@implementation ChildrenGame

static NSMutableArray *gamesList;

+ (void)initialize
{
    if (self == [ChildrenGame class]) {
        if (gamesList == nil)
        {
            gamesList = [[NSMutableArray alloc] init];
            for (int i = 1; i <= 16; i++) {
                ChildrenGame *game = [[ChildrenGame alloc] init];
                //switch (i) {
                    //case 1:
                        game.name = [NSString stringWithFormat:@"BRINCADEIRA %d", i];
                        game.instructions = [NSString stringWithFormat:@"Brinque de %d em família.", i];
                        game.imageName = [NSString stringWithFormat:@"Abraco_%@", i%2 == 1?@"Bege":@"Vermelho"];
                        game.pointsEarned = i*10;
                        game.secondsOfPlay = i*2;
                //        break;
                //}
                [gamesList addObject:game];
            }
            
            NSUInteger count = [gamesList count];
            for (NSUInteger i = 0; i < count; ++i) {
                NSInteger remainingCount = count - i;
                NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
                [gamesList exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
            }
        }
    }
}

+(NSArray *)getGamesList {
    return gamesList;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%@ por %ld segundos) -> %ld pontos", self.name, self.instructions, (long)self.secondsOfPlay, (long)self.pointsEarned];
}
@end
