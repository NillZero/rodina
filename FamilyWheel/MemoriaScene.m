#import "MemoriaScene.h"
#import "Animal.h"
#import "GameSelection.h"

@interface MemoriaScene ()

@property (nonatomic, strong) SKSpriteNode *selectedNode;
@property (nonatomic) SKSpriteNode *firstCard;

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

@implementation MemoriaScene

int firstCardIndex = -1;
bool isWaiting = false;
float timeStartedWaiting = 0;

int currentPlayerIndex = 0;
int scores[2] = {0, 0};
SKNode *popup;
bool fimDeJogo = false;
bool comecouJogo = false;

Animal *firstAnimal;
Animal *secondAnimal;



-(void)didMoveToView:(SKView *)view {
    
    firstCardIndex = -1;
    isWaiting = false;
    timeStartedWaiting = 0;
    
    currentPlayerIndex = 0;
    scores[0] = 0;
    scores[1] = 0;
    fimDeJogo = false;
    comecouJogo = false;
    
    firstAnimal = nil;
    secondAnimal = nil;
    
    popup = [self childNodeWithName:@"PopUp_Window"];
    [popup setHidden:YES];
    
    NSMutableArray *animais = [Animal getListaAnimais];
    for (Animal *animal in animais) {
        NSLog(@"%@", [animal getNomeImagem]);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
    
}


- (void)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    for (SKSpriteNode *touchedNode in [self nodesAtPoint:touchLocation]) {
        
        if (touchedNode.name != nil && !touchedNode.hidden) {
            if ([touchedNode.name isEqualToString:@"Voltar"]) {
                [Animal randomizeAnimalsOrder];
                GameSelection *scene = [GameSelection unarchiveFromFile:@"GameSelection"];
                scene.scaleMode = SKSceneScaleModeAspectFit;
                
                // Present the scene.
                [self.view presentScene:scene];
            } else if ([touchedNode.name isEqualToString:@"Replay"]) {
                if (fimDeJogo) {
                    [Animal randomizeAnimalsOrder];
                    MemoriaScene *scene = [MemoriaScene unarchiveFromFile:@"MemoriaScene"];
                    scene.scaleMode = SKSceneScaleModeAspectFit;
                    
                    // Present the scene.
                    [self.view presentScene:scene];
                }
            } else if ([touchedNode.name isEqualToString:@"Botao"]){
                comecouJogo = true;
                [[self childNodeWithName:@"PopUp_Inicio"] setHidden:YES];
                
                SKLabelNode *currentPlayer = (SKLabelNode *)[self childNodeWithName:[NSString stringWithFormat: @"Jogador%d", currentPlayerIndex + 1]];
                SKAction *grow = [SKAction scaleTo:1.1 duration:0.5];
                grow.timingMode = SKActionTimingEaseInEaseOut;
                SKAction *shrink = [SKAction scaleTo:0.9 duration:0.5];
                grow.timingMode = SKActionTimingEaseInEaseOut;
                SKAction *seq = [SKAction sequence:@[grow, shrink]];
                
                [currentPlayer runAction:[SKAction repeatActionForever:seq]];
           }
        }
        
        //2
        if (comecouJogo) {
            if(![touchedNode isEqual:self.firstCard]) {
                [_selectedNode removeAllActions];
                [_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
                
                NSMutableArray *animais = [Animal getListaAnimais];
                
                if (isWaiting) {
                    return;
                }
                
                //NSLog(@"%@", touchedNode.name);
                if ([[touchedNode.name substringToIndex:5] isEqualToString:@"Carta"]) {
                    //Selecionei uma carta
                    _selectedNode = touchedNode;
                    int clickedCardIndex = [[_selectedNode.name substringFromIndex:5] intValue];
                    Animal *animal = (Animal *)(animais[clickedCardIndex]);
                    [_selectedNode setTexture:[SKTexture textureWithImageNamed:[animal getNomeImagem]]];
                    
                    if (firstCardIndex == -1) {
                        //Primeira jogada
                        firstCardIndex = clickedCardIndex;
                        self.firstCard = _selectedNode;
                        firstAnimal = animal;
                        [firstAnimal.som setCurrentTime:0];
                        [secondAnimal.som pause];
                        [firstAnimal.som play];
                    } else {
                        isWaiting = true;
                        timeStartedWaiting = 0;
                        secondAnimal = animal;
                        [firstAnimal.som pause];
                        [secondAnimal.som setCurrentTime:0];
                        [secondAnimal.som play];
                    }
                }
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (isWaiting) {
        if (timeStartedWaiting == 0) {
            timeStartedWaiting = currentTime;
        } else {
            if (timeStartedWaiting + 1 < currentTime) {
                NSMutableArray *animais = [Animal getListaAnimais];
                int clickedCardIndex = [[_selectedNode.name substringFromIndex:5] intValue];
                Animal *animal = animais[clickedCardIndex];
                Animal *firstCardAnimal = animais[firstCardIndex];
                if ([animal.tipo isEqualToString:firstCardAnimal.tipo]) {
                    [self.firstCard removeFromParent];
                    [_selectedNode removeFromParent];
                    firstCardIndex = -1;
                    isWaiting = false;
                    
                    scores[currentPlayerIndex] ++;
                    NSLog(@"%d x %d", scores[0], scores[1]);
                    SKLabelNode *scoreToChange = (SKLabelNode *)[self childNodeWithName:[NSString stringWithFormat: @"Score%d", currentPlayerIndex + 1]];
                    scoreToChange.text = [NSString stringWithFormat:@"%d PONTO%@", scores[currentPlayerIndex], scores[currentPlayerIndex] == 1?@"":@"S" ];
                    
                    if (scores[0] + scores[1] == 12) {
                        if (scores[0] > scores[1]) {
                            [(SKLabelNode *)[popup childNodeWithName:@"PopUp_Jogador"] setText: @"JOGADOR 1"];
                        }
                        else if (scores[0] < scores[1]){
                            [(SKLabelNode *)[popup childNodeWithName:@"PopUp_Jogador"] setText: @"JOGADOR 2"];
                        }
                        else {
                            [(SKLabelNode *)[popup childNodeWithName:@"PopUp_Jogador"] setText: @""];
                            [(SKLabelNode *)[popup childNodeWithName:@"PopUp_Ganhou"] setText: @"EMPATE!"];
                        }
                        
                        [popup setHidden:NO];
                        fimDeJogo = true;
                    }
                    
                } else {
                    [self.firstCard setTexture:[SKTexture textureWithImageNamed:@"Costas"]];
                    [_selectedNode setTexture:[SKTexture textureWithImageNamed:@"Costas"]];
                    firstCardIndex = -1;
                    self.firstCard = nil;
                    isWaiting = false;
                    firstAnimal = nil;
                    secondAnimal = nil;
                    
                    SKLabelNode *lastPlayer = (SKLabelNode *)[self childNodeWithName:[NSString stringWithFormat: @"Jogador%d", currentPlayerIndex + 1]];
                    [lastPlayer setScale:1];
                    [lastPlayer removeAllActions];
                    currentPlayerIndex = (currentPlayerIndex + 1)%2;
                    
                    SKLabelNode *currentPlayer = (SKLabelNode *)[self childNodeWithName:[NSString stringWithFormat: @"Jogador%d", currentPlayerIndex + 1]];
                    SKAction *grow = [SKAction scaleTo:1.1 duration:0.5];
                    grow.timingMode = SKActionTimingEaseInEaseOut;
                    SKAction *shrink = [SKAction scaleTo:0.9 duration:0.5];
                    grow.timingMode = SKActionTimingEaseInEaseOut;
                    SKAction *seq = [SKAction sequence:@[grow, shrink]];
                    
                    [currentPlayer runAction:[SKAction repeatActionForever:seq]];
                    
                }
            }
        }
    }
    
    
}

@end

