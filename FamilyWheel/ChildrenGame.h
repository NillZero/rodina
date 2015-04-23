//
//  ChildrenGame.h
//  FamilyWheel
//
//  Created by Thiago Borges Gonçalves Penna on 4/8/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ChildrenGame : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *instructions;
@property (nonatomic, copy) NSString *instructions2;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic) NSInteger pointsEarned;
@property (nonatomic) NSInteger secondsOfPlay;

+(NSArray *)getGamesList;

@end
