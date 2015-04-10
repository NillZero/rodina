#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Animal : NSObject

@property (nonatomic) BOOL ehMacho;
@property (nonatomic, copy) NSString *tipo;
@property (nonatomic) AVAudioPlayer *som;


+(NSMutableArray *)getListaAnimais;
-(NSString *)getNomeImagem;
+(void)randomizeAnimalsOrder;

@end
