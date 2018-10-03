//  MyIOSSdk.h


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AdSupport/AdSupport.h>

@interface MyIOSSdk :UIViewController{
    @public NSDictionary *mLaunchOptions;
}
+(MyIOSSdk*)getMyinstance;
+(Boolean)getIsSelfNotice;
+(MyIOSSdk*)sendU3dMessage:(NSString *)messageName param:(NSDictionary *)dict isToken:(Boolean)isToken;
+(MyIOSSdk*)sendU3dMessageToken:(NSString *)messageName dict:(NSData *)dict;
-(void)showMessageView:(NSArray*)phones title:(NSString*)title body:(NSString*)body;
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
-(NSString*)getIdfa;
-(void)initNotice:(NSString*)pKey pMsgObj:(NSString*)nStr pMode:(int)pMode;
-(void)initLxNotice:(NSString*)pMsgObj;
@end

