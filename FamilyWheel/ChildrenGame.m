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
                game.imageName = [NSString stringWithFormat:@"Abraco_"];
                switch (i) {
                    case 1:
                        game.name = @"Abraço";
                        game.instructions = @"Abrace alguém";
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 5;
                        break;
                    case 2:
                        game.name = @"Pega-Pega";
                        game.instructions = @"Brinque de Pega-pega";
                        game.imageName = [NSString stringWithFormat:@"PegaPega_"];
                        game.pointsEarned = 30;
                        game.secondsOfPlay = 60;
                        break;
                    case 3:
                        game.name = @"Esconde-Esconde";
                        game.instructions = @"Brinque de Esconde-Esconde";
                        game.imageName = [NSString stringWithFormat:@"PegaPega_"];
                        game.pointsEarned = 40;
                        game.secondsOfPlay = 120;
                        break;
                    case 4:
                        game.name = @"Mímica de Animais";
                        game.instructions = @"Imite um animal, para que os outros adivinhem";
                        game.imageName = [NSString stringWithFormat:@"Animal_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 5:
                        game.name = @"Mímica de Personagens";
                        game.instructions = @"Imite um personagem, para que os outros adivinhem";
                        game.imageName = [NSString stringWithFormat:@"Personagem_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 6:
                        game.name = @"Mímica de Profissões";
                        game.instructions = @"Imite uma profissão, para que os outros adivinhem";
                        game.imageName = [NSString stringWithFormat:@"Personagem_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 7:
                        game.name = @"Jo Ken Po";
                        game.instructions = @"Jogue Jo Ken Po (Pedra, Papel e Tesoura)";
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 15;
                        break;
                    case 8:
                        game.name = @"Adoleta";
                        game.instructions = @"Brinque de Adoleta";
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 15;
                        break;
                    case 9:
                        game.name = @"Cantar uma música";
                        game.instructions = @"Cante uma canção em família";
                        game.pointsEarned = 30;
                        game.secondsOfPlay = 60;
                        break;
                    case 10:
                        game.name = @"Telefone sem fio";
                        game.instructions = @"(No mínimo 3 pessoas) Brinque de telefone sem fio";
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 11:
                        game.name = @"Conversa";
                        game.instructions = @"Fale sobre o seu dia";
                        game.pointsEarned = 15;
                        game.secondsOfPlay = 90;
                        break;
                    case 12:
                        game.name = @"Pausa!";
                        game.instructions = @"Vá tomar um gole d’Água";
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 30;
                        break;
                    case 13:
                        game.name = @"Beijo";
                        game.instructions = @"Beije o rosto de alguém";
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 5;
                        break;
                    case 14:
                        game.name = @"Estátua";
                        game.instructions = @"Fique parado na posição em que você está";
                        game.imageName = [NSString stringWithFormat:@"PegaPega_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 15;
                        break;
                    case 15:
                        game.name = @"Pule em uma perna só";
                        game.instructions = @"Fique pulando em uma perna só";
                        game.imageName = [NSString stringWithFormat:@"PegaPega_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 15;
                        break;
                    case 16:
                        game.name = @"Fazer careta";
                        game.instructions = @"Faça caretas";
                        game.imageName = [NSString stringWithFormat:@"Personagem_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 15;
                        break;
                }
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
