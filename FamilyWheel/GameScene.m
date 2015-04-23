//
//  GameScene.m
//  FamilyWheel
//
//  Created by Thiago Borges Gonçalves Penna on 4/6/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

#import "GameScene.h"
#import "ChildrenGame.h"
#import "MemoriaScene.h"

BOOL hasTouched = false;

@interface GameScene ()

@property (nonatomic) SKAction *playTick;
@property (nonatomic) SKAction *shakePin;

@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameScene

float nextTickAngle = 11.25;
float startCountdownTime;
int currentSpace = -1;
SKSpriteNode *wheel;
SKNode *popup;

-(void)didMoveToView:(SKView *)view {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"Estrelas"] == nil) {
        [defaults setValue:@"0" forKey:@"Estrelas"];
    }
    NSInteger points = [[defaults valueForKey:@"Estrelas"] integerValue];
    SKLabelNode *estrelas = (SKLabelNode *)[self childNodeWithName:@"estrelas"];
    [estrelas setText:[NSString stringWithFormat:@"%ld", points]];
    
    hasTouched = false;
    
    //Primeiro SETUP : Esconder partes da hierarquia;
    popup = [[SKNode alloc] init];
    [self addChild:popup];
    for (SKNode *child in [self children]) {
        if (child.name.length > 5) {
            if ([[child.name substringToIndex:5] isEqualToString:@"PopUp"]) {
                [child removeFromParent];
                [popup addChild:child];
                [child setHidden:YES];
            }
        }
    }
    
    [popup setHidden:YES];
    
    self.playTick = [SKAction playSoundFileNamed:@"click.wav" waitForCompletion:NO];
    
    SKAction *clockwise = [SKAction rotateByAngle:-M_PI_4/4 duration:0.1];
    clockwise.timingMode = SKActionTimingEaseIn;
    SKAction *counterClockwise = [SKAction rotateByAngle:M_PI_4/4 duration:0.1];
    counterClockwise.timingMode = SKActionTimingEaseOut;
    SKAction *seq = [SKAction sequence:@[clockwise, counterClockwise]];
    self.shakePin = seq;
    
    wheel = (SKSpriteNode *)[self childNodeWithName:@"wheel"];
    [wheel.physicsBody applyAngularImpulse:10000];
    
    NSArray *childrenGames = [ChildrenGame getGamesList];
    
    UIColor *vermelho = [UIColor colorWithRed:208/255.0f green:56/255.0f blue:57/255.0f alpha:1];
    UIColor *bege = [UIColor colorWithRed:249/255.0f green:232/255.0f blue:203/255.0f alpha:1];
    
    for (int i = 1; i <= 16; i++) {
        ChildrenGame *game = childrenGames[i-1];
        
        //Criar placeholder da posicao na roda
        SKNode *position = [[SKNode alloc] init];
        position.position = CGPointMake(sinf(22.5*i*M_PI/180)*500, cosf(22.5*i*M_PI/180)*500);
        position.zRotation = -22.5*i*M_PI/180;
        position.zPosition = 1;
        [wheel addChild:position];
        
        //Criar sprite com a imagem da brincadeira
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@%@", game.imageName, (i%2 == 1?@"Bege":@"Vermelho")]];
        sprite.zPosition = 2;
        sprite.size = CGSizeMake(120, 120);
        [position addChild:sprite];
        
        //Criar label com o nome da brincadeira
        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Bariol-Regular"];
        nameLabel.text = game.name;
        nameLabel.fontSize = 36;
        nameLabel.fontColor = (i%2 == 1?bege:vermelho);
        nameLabel.position = CGPointMake(0, 180);
        [position addChild:nameLabel];
        
        //Criar label com a pontuacao da brincadeira
        SKLabelNode *pointsLabel = [SKLabelNode labelNodeWithFontNamed:@"Bariol-Regular"];
        pointsLabel.text = [NSString stringWithFormat:@"%ld★", (long)game.pointsEarned];
        pointsLabel.fontSize = 48;
        pointsLabel.fontColor = (i%2 == 1?bege:vermelho);
        pointsLabel.position = CGPointMake(0, -110);
        [position addChild:pointsLabel];
    }
    /*
     for () {
     SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
     sprite.zRotation = -22.5*i*M_PI/180;
     sprite.size = CGSizeMake(100, 100);
     }
     */
    SKTexture *wheelTextureWithChilds = [view textureFromNode:wheel];
    [wheel setTexture:wheelTextureWithChilds];
    
    for (SKSpriteNode *child in [wheel children]) {
        [child removeFromParent];
    }
    //sprite.position = CGPointMake(1500, 1500);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        for(SKNode *touchedNode in [self nodesAtPoint:location]) {
            if (!touchedNode.hidden && touchedNode.name != nil) {
                NSLog(@"Cliquei em %@", touchedNode.name);
                if ([touchedNode.name isEqualToString:@"wheel"]) {
                    wheel.physicsBody.angularDamping = 0.9;
                    hasTouched = true;
                }
                if ([touchedNode.name isEqualToString:@"PopUp_Skip"]) {
                    [self restartScene];
                }
                if ([touchedNode.name isEqualToString:@"PopUp_Time"] && [((SKLabelNode *)touchedNode).text isEqualToString:@"OK"]) {
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSInteger points = [[defaults valueForKey:@"Estrelas"] integerValue];
                    ChildrenGame *game = [ChildrenGame getGamesList][currentSpace];
                    points += game.pointsEarned;
                    [defaults setValue:[NSString stringWithFormat:@"%ld", points] forKey:@"Estrelas"];

                    [self restartScene];
                }
                if ([touchedNode.name isEqualToString:@"Game"]) {
                    
                    MemoriaScene *scene = [MemoriaScene unarchiveFromFile:@"MemoriaScene"];
                    scene.scaleMode = SKSceneScaleModeAspectFit;
                    
                    // Present the scene.
                    [self.view presentScene:scene];
                    
                }
            }
        }
    }
}

-(void)restartScene
{
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene.
    [self.view presentScene:scene];
}

-(void)update:(CFTimeInterval)currentTime {
    float angularVelocity =  wheel.physicsBody.angularVelocity;
    
    if (angularVelocity >= 0.2) {
        float currentAngle = wheel.zRotation/M_PI*180;
        if (currentAngle < 0) currentAngle += 360;
        //playSound
        if (currentAngle >= nextTickAngle) {
            if (!(nextTickAngle == 11.25 && currentAngle > 348.5)) {
                currentSpace = (currentSpace + 1)%16;
                nextTickAngle = (nextTickAngle + 22.5);
                if (nextTickAngle > 360) nextTickAngle -= 360;
                [self runAction:self.playTick];
                
                [[self childNodeWithName:@"mark"] runAction:self.shakePin];
            }
        }
        
        SKShader *shader = wheel.shader;
        SKUniform *u_1 = shader.uniforms[0];
        u_1.floatValue = angularVelocity/4000;
    } else {
        wheel.physicsBody.angularDamping = 10;
        if (popup.hidden) {
            ChildrenGame *game = [ChildrenGame getGamesList][currentSpace];
            
            SKSpriteNode *image = (SKSpriteNode *)[popup childNodeWithName:@"PopUp_Image"];
            [image setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@%@", game.imageName, @"Vermelho"]]];
            
            SKLabelNode *points = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Points"];
            [points setText:[NSString stringWithFormat:@"%ld★", (long)game.pointsEarned]];
            
            SKLabelNode *instructions = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Instructions"];
            [instructions setText:game.instructions];
            
            SKLabelNode *instructions2 = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Instructions2"];
            [instructions2 setText:game.instructions2];
            
            SKLabelNode *time = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Time"];
            [time setText:[NSString stringWithFormat:@"%ld", (long)game.secondsOfPlay]];
            
            [popup setHidden:NO];
            for (SKNode *child in [popup children]) {
                [child setHidden:NO];
            }
            startCountdownTime = currentTime +1;
            [popup setAlpha:0];
            [popup runAction:[SKAction fadeInWithDuration:1]];
            } else {
            ChildrenGame *game = [ChildrenGame getGamesList][currentSpace];
            SKLabelNode *time = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Time"];
            long seconds = ((long)game.secondsOfPlay - (long)(currentTime - startCountdownTime));
            if (seconds > 0) {
                [time setText:[NSString stringWithFormat:@"%ld", seconds]];
            } else {
                [time setText:@"OK"];
                SKLabelNode *skip = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Skip"];
                [skip setHidden:YES];
                SKLabelNode *segundos = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Segundos"];
                [segundos setHidden:YES];
                SKLabelNode *por = (SKLabelNode *)[popup childNodeWithName:@"PopUp_Por"];
                [por setHidden:YES];
            }
            
        }
    }
}

@end
