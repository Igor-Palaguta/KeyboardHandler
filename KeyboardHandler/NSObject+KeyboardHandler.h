#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (KeyboardHandler)

-(void)kh_subscribeKeyboardNotifications;
-(void)kh_unsubscribeKeyboardNotifications;

-(void)kh_didHideKeyboard;
-(void)kh_didShowKeyboardWithHeight:( CGFloat )height_
                             inRect:( CGRect )rect_;

-(void)kh_willHideKeyboardWithDuration:( NSTimeInterval )duration_
                               options:( UIViewAnimationOptions )options_;

-(void)kh_willShowKeyboardWithHeight:( CGFloat )height_
                              inRect:( CGRect )rect_
                            duration:( NSTimeInterval )duration_
                             options:( UIViewAnimationOptions )options_;

-(BOOL)kh_isKeyboardVisible;

@end

@interface UIScrollView (KeyboardHandler)

-(void)kh_setContentSizeWithBottomView:( UIView* )view_
                          bottomMargin:( CGFloat )bottom_margin_;

-(void)kh_setContentSizeWithBottomView:( UIView* )view_;

@end
