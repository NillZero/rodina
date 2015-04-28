//
//  GameScene.m
//  GameSelection
//
//  Created by Thiago Borges Gonçalves Penna on 4/15/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

#import "GameSelection.h"
#import "MemoriaScene.h"
#import "GameScene.h"
#import "SoonScene.h"

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

@implementation GameSelection

SKNode *listOfGamesParent;
CGPoint scrollPosition;
NSMutableDictionary *touchDictionary;
float ySpeed;
float yMin;
float yMax;

-(void)didMoveToView:(SKView *)view {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"Estrelas"] == nil) {
        [defaults setValue:@"0" forKey:@"Estrelas"];
    }
    NSInteger points = [[defaults valueForKey:@"Estrelas"] integerValue];
    SKLabelNode *estrelas = (SKLabelNode *)[self childNodeWithName:@"estrelas"];
    [estrelas setText:[NSString stringWithFormat:@"%ld", points]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
    ySpeed = 0;
    listOfGamesParent = [self childNodeWithName:@"ListOfGamesParent"];
    scrollPosition = CGPointMake(listOfGamesParent.position.x, listOfGamesParent.position.y);
    yMin = scrollPosition.y;
    yMax = 558;
    touchDictionary = [[NSMutableDictionary alloc] init];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    scrollPosition.y = listOfGamesParent.position.y;
    [listOfGamesParent removeAllActions];
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        NSString *stringLocation = [NSString stringWithFormat:@"%d,%d", (int)touchLocation.x, (int)touchLocation.y];
        NSMutableArray *coordinates = [touchDictionary valueForKey:stringLocation];
        coordinates = [[NSMutableArray alloc] init];
        [coordinates addObject:[NSValue valueWithCGPoint:touchLocation]];
        [touchDictionary setValue:coordinates forKey:stringLocation];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    float previousYSum = 0;
    float currentYSum = 0;
    for (UITouch *touch in touches) {
        
        CGPoint previousTouchLocation = [touch previousLocationInNode:self];
        float previousX = previousTouchLocation.x;
        float previousY = previousTouchLocation.y;
        NSString *stringPreviousLocation = [NSString stringWithFormat:@"%d,%d", (int)previousX, (int)previousY];
        
        CGPoint touchLocation = [touch locationInNode:self];
        float currentX = touchLocation.x;
        float currentY = touchLocation.y;
        NSString *stringLocation = [NSString stringWithFormat:@"%d,%d", (int)currentX, (int)currentY];
        
        NSMutableArray *coordinates = [touchDictionary valueForKey:stringPreviousLocation];
        [coordinates addObject:[NSValue valueWithCGPoint:touchLocation]];
        [touchDictionary removeObjectForKey:stringPreviousLocation];
        
        if (coordinates.count > 9) {
            [coordinates removeObjectAtIndex:0];
        }
        
        [touchDictionary setValue:coordinates forKey:stringLocation];
        
        previousYSum += previousY;
        currentYSum += currentY;
    }
    
    scrollPosition.y -= (previousYSum - currentYSum)/touches.count;
    listOfGamesParent.position = scrollPosition;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%lu - %lu", (unsigned long)touchDictionary.count, (unsigned long)touches.count);
    
    for (UITouch *touch in touches) {
        CGPoint previousTouchLocation = [touch previousLocationInNode:self];
        float previousX = previousTouchLocation.x;
        float previousY = previousTouchLocation.y;
        NSString *stringPreviousLocation = [NSString stringWithFormat:@"%d,%d", (int)previousX, (int)previousY];
        
        CGPoint touchLocation = [touch locationInNode:self];
        float currentX = touchLocation.x;
        float currentY = touchLocation.y;
        NSString *stringCurrentLocation = [NSString stringWithFormat:@"%d,%d", (int)currentX, (int)currentY];
        
        NSMutableArray *coordinates = [touchDictionary valueForKey:stringPreviousLocation];
        [touchDictionary removeObjectForKey:stringPreviousLocation];
        if (coordinates == nil) {
            coordinates = [touchDictionary valueForKey:stringCurrentLocation];
            [touchDictionary removeObjectForKey:stringCurrentLocation];
        }
        
        [coordinates addObject:[NSValue valueWithCGPoint:touchLocation]];
        
        if (touchDictionary.count == 0) {
            if (coordinates.count < 5) {
                for (SKNode *node in [self nodesAtPoint:touchLocation]) {
                    if (node.name != nil) {
                        if ([node.name isEqualToString:@"MemoriaScene"]) {
                            MemoriaScene *scene = [MemoriaScene unarchiveFromFile:@"MemoriaScene"];
                            scene.scaleMode = SKSceneScaleModeAspectFit;
                            
                            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
                            // Present the scene.
                            [self.view presentScene:scene];
                        }
                        if ([node.name isEqualToString:@"Roleta"]) {
                            GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
                            scene.scaleMode = SKSceneScaleModeAspectFit;
                            
                            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
                            // Present the scene.
                            [self.view presentScene:scene];
                        }
                        if ([node.name isEqualToString:@"Soon"]) {
                            SoonScene *scene = [SoonScene unarchiveFromFile:@"SoonScene"];
                            scene.scaleMode = SKSceneScaleModeAspectFit;
                            
                            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
                            // Present the scene.
                            [self.view presentScene:scene];
                        }
                    }
                }
            } else {
                CGVector direction = [self getAverageMovementWithArray:coordinates];
                ySpeed += direction.dy/2;
            }
        }
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    if (touchDictionary.count == 0) {
        scrollPosition.y += ySpeed;
        ySpeed *= 0.8;
        if (fabs(ySpeed) < 10) ySpeed = 0;
        
        if (ySpeed == 0) {
            if (scrollPosition.y < yMin) {
                scrollPosition.y = (yMin + scrollPosition.y)/2;
            }
            if (scrollPosition.y > yMax) {
                scrollPosition.y = (yMax + scrollPosition.y)/2;
            }
        }
        listOfGamesParent.position = scrollPosition;
    }
}

-(CGVector)getAverageMovementWithArray:(NSArray *)coordinates {
    CGPoint point = [coordinates[0] CGPointValue];
    float xSum = -point.x * coordinates.count;
    float ySum = -point.y * coordinates.count;
    for (NSValue *value in coordinates) {
        CGPoint point = [value CGPointValue];
        xSum += point.x;
        ySum += point.y;
    }
    return CGVectorMake(xSum / coordinates.count, ySum / coordinates.count);
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    touchDictionary = [[NSMutableDictionary alloc] init];
}

@end
