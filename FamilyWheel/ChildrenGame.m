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
                        game.instructions2 = @"";
                        game.imageName = [NSString stringWithFormat:@"Abraco_"];
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 5;
                        break;
                    case 2:
                        game.name = @"Pega-Pega";
                        game.instructions = @"Brinque de";
                        game.instructions2 = @"Pega-Pega";
                        game.imageName = [NSString stringWithFormat:@"PegaPega_"];
                        game.pointsEarned = 30;
                        game.secondsOfPlay = 60;
                        break;
                    case 3:
                        game.name = @"Esconde-Esconde";
                        game.instructions = @"Brinque de";
                        game.instructions2 = @"Esconde-Esconde";
                        game.imageName = [NSString stringWithFormat:@"Esconde_"];
                        game.pointsEarned = 40;
                        game.secondsOfPlay = 120;
                        break;
                    case 4:
                        game.name = @"Animais";
                        game.instructions = @"Imite um animal";
                        game.instructions2 = @"para que os outros adivinhem";
                        game.imageName = [NSString stringWithFormat:@"Animal_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 5:
                        game.name = @"Personagens";
                        game.instructions = @"Imite um personagem";
                        game.instructions2 = @"para que os outros adivinhem";
                        game.imageName = [NSString stringWithFormat:@"Personagem_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 6:
                        game.name = @"Profissões";
                        game.instructions = @"Imite uma profissão";
                        game.instructions2 = @"para que os outros adivinhem";
                        game.imageName = [NSString stringWithFormat:@"Profissional_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 7:
                        game.name = @"Jo Ken Po";
                        game.instructions = @"Jogue Jo Ken Po ";
                        game.instructions2 = @"(Pedra, Papel e Tesoura)";
                        game.imageName = [NSString stringWithFormat:@"JoKenPo_"];
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 15;
                        break;
                    case 8:
                        game.name = @"Adoleta";
                        game.instructions = @"Brinque de Adoleta";
                        game.instructions2 = @"";
                        game.imageName = [NSString stringWithFormat:@"Adoleta_"];
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 15;
                        break;
                    case 9:
                        game.name = @"Música";
                        game.instructions = @"Cante uma canção";
                        game.instructions2 = @"em família";
                        game.imageName = [NSString stringWithFormat:@"Cantar_"];
                        game.pointsEarned = 30;
                        game.secondsOfPlay = 60;
                        break;
                    case 10:
                        game.name = @"Telefone sem fio";
                        game.instructions = @"(No mínimo 3 pessoas)";
                        game.instructions2 = @"Brinque de telefone sem fio";
                        game.imageName = [NSString stringWithFormat:@"Telefone_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 30;
                        break;
                    case 11:
                        game.name = @"Conversa";
                        game.instructions = @"Fale sobre o";
                        game.instructions2 = @"seu dia";
                        game.imageName = [NSString stringWithFormat:@"Conversar_"];
                        game.pointsEarned = 15;
                        game.secondsOfPlay = 90;
                        break;
                    case 12:
                        game.name = @"Pausa!";
                        game.instructions = @"Vá tomar um";
                        game.instructions2 = @"gole d'Água";
                        game.imageName = [NSString stringWithFormat:@"Pause_"];
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 30;
                        break;
                    case 13:
                        game.name = @"Beijo";
                        game.instructions = @"Beije o rosto";
                        game.instructions2 = @"de alguém";
                        game.imageName = [NSString stringWithFormat:@"Beijo_"];
                        game.pointsEarned = 5;
                        game.secondsOfPlay = 5;
                        break;
                    case 14:
                        game.name = @"Estátua";
                        game.instructions = @"Fique parado na posição";
                        game.instructions2 = @"em que você está";
                        game.imageName = [NSString stringWithFormat:@"Estatua_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 15;
                        break;
                    case 15:
                        game.name = @"Uma perna só";
                        game.instructions = @"Fique pulando em";
                        game.instructions2 = @"uma perna só";
                        game.imageName = [NSString stringWithFormat:@"Pular_"];
                        game.pointsEarned = 10;
                        game.secondsOfPlay = 15;
                        break;
                    case 16:
                        game.name = @"Fazer careta";
                        game.instructions = @"Faça caretas";
                        game.instructions2 = @"";
                        game.imageName = [NSString stringWithFormat:@"Careta_"];
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
