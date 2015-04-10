//
//  Animal.m
//  Memoria!!
//
//  Created by Pedro Alcaide on 07/04/15.
//  Copyright (c) 2015 Pedro Alcaide. All rights reserved.
//

#import "Animal.h"

@implementation Animal

static NSArray *animais;
static NSArray *listaDeAnimais;

+ (void)initialize
{
    if (self == [Animal class]) {
        if (animais == nil) {
            animais = @[@"vaca", @"macaco", @"galinha",@"porco", @"pato", @"leoa", @"coruja", @"pinto", @"gato", @"cachorro", @"ovelha", @"elefante"];
        }
    }
}

+(NSArray *)getListaAnimais {
    if (listaDeAnimais == nil) {
        NSMutableArray *lista = [[NSMutableArray alloc] init];
        
        for (NSString *animal in animais) {
            Animal *x = [[Animal alloc] init];
            x.tipo = animal;
            x.ehMacho = true;
            NSError *err;
            NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"som_%@.mp3", x.tipo] ofType:nil]];
            x.som = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
            [x.som prepareToPlay];
            [lista addObject:x];
        }
        for (NSString *animal in animais) {
            Animal *x = [[Animal alloc] init];
            x.tipo = animal;
            x.ehMacho = false;
            NSError *err;
            NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"som_%@.mp3", x.tipo] ofType:nil]];
            x.som = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
            [x.som prepareToPlay];
            [lista addObject:x];
        }
        
        NSUInteger count = [lista count];
        for (NSUInteger i = 0; i < count; ++i) {
            NSInteger remainingCount = count - i;
            NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
            [lista exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
        
        listaDeAnimais = [NSArray arrayWithArray:lista];
    }
    
    return listaDeAnimais;
}

-(NSString *)getNomeImagem {
    return [NSString stringWithFormat:@"%@_%@.png", self.tipo, self.ehMacho?@"macho":@"femea"];
}

@end

