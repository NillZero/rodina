//
//  GameScene.m
//  Soon
//
//  Created by Thiago Borges Gonçalves Penna on 4/24/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

#import "SoonScene.h"
#import "GameSelection.h"

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

@implementation SoonScene

-(void)didMoveToView:(SKView *)view {
    
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
        
        if ([touchedNode.name isEqualToString:@"Voltar"]) {
            GameSelection *scene = [GameSelection unarchiveFromFile:@"GameSelection"];
            scene.scaleMode = SKSceneScaleModeAspectFit;
            
            // Present the scene.
            [self.view presentScene:scene];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
