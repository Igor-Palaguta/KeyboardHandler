#import "NSObject+KeyboardHandler.h"

#import <objc/runtime.h>

@implementation NSObject (KeyboardHandler)

-(BOOL)kh_notification:( NSNotification* )notification_
               getRect:( CGRect* )keyboard_rect_
             getHeight:( CGFloat* )height_ __attribute__((nonnull))
{
   NSValue* end_frame_ = [ [ notification_ userInfo ] objectForKey: UIKeyboardFrameEndUserInfoKey ];
   NSValue* begin_frame_ = [ [ notification_ userInfo ] objectForKey: UIKeyboardFrameBeginUserInfoKey ];
   if ( CGRectEqualToRect(end_frame_.CGRectValue, begin_frame_.CGRectValue) )
   {
      return NO;
   }

   *keyboard_rect_ = [ end_frame_ CGRectValue ];
   *height_ = fmin( keyboard_rect_->size.height, keyboard_rect_->size.width );
   return YES;
}

-(void)kh_notification:( NSNotification* )notification_
           getDuration:( NSTimeInterval* )duration_
            getOptions:( UIViewAnimationOptions* )animation_options_ __attribute__((nonnull))
{
   *duration_ = [ notification_.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue ];
   UIViewAnimationCurve animation_curve_ = [ notification_.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue ];
   
   *animation_options_ = animation_curve_ << 16;
}


-(void)kh_didShowKeyboardWithNotification:( NSNotification* )notification_
{
   CGRect keyboard_rect_ = CGRectZero;
   CGFloat height_ = 0.f;

   BOOL did_change_rect_ = [ self kh_notification: notification_
                                          getRect: &keyboard_rect_
                                        getHeight: &height_ ];

   if ( !did_change_rect_ )
   {
      return;
   }
   
   [ self kh_didShowKeyboardWithHeight: height_ inRect: keyboard_rect_ ];
   [ self kh_setKeyboardVisible: YES ];
}

-(void)kh_willHideKeyboardWithDuration:( NSTimeInterval )duration_
                               options:( UIViewAnimationOptions )options_
{
   //do nothing
}

-(void)kh_willHideKeyboardWithNotification:( NSNotification* )notification_
{
   CGRect keyboard_rect_ = CGRectZero;
   CGFloat height_ = 0.f;
   BOOL did_change_rect_ = [ self kh_notification: notification_
                                          getRect: &keyboard_rect_
                                        getHeight: &height_ ];

   if ( !did_change_rect_ )
   {
      return;
   }

   NSTimeInterval duration_ = 0.0;
   UIViewAnimationOptions options_ = 0;

   [ self kh_notification: notification_
              getDuration: &duration_
               getOptions: &options_ ];

   [ self kh_willHideKeyboardWithDuration: duration_ options: options_ ];

   [ self kh_removeInset ];
   [ self kh_setKeyboardVisible: NO ];
}

-(void)kh_willShowKeyboardWithHeight:( CGFloat )height_
                              inRect:( CGRect )rect_
                            duration:( NSTimeInterval )duration_
                             options:( UIViewAnimationOptions )options_
{
   //do nothing
}

-(void)kh_willShowKeyboardWithNotification:( NSNotification* )notification_
{
   CGRect keyboard_rect_ = CGRectZero;
   CGFloat height_ = 0.f;

   BOOL did_change_rect_ = [ self kh_notification: notification_
                                          getRect: &keyboard_rect_
                                        getHeight: &height_ ];

   if ( !did_change_rect_ )
   {
      return;
   }
   
   NSTimeInterval duration_ = 0.0;
   UIViewAnimationOptions options_ = 0;
   
   [ self kh_notification: notification_
              getDuration: &duration_
               getOptions: &options_ ];
   
   [ self kh_willShowKeyboardWithHeight: height_
                              inRect: keyboard_rect_
                            duration: duration_
                             options: options_ ];
}

-(void)kh_subscribeKeyboardNotifications
{
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( kh_didShowKeyboardWithNotification: )
                                                   name: UIKeyboardDidShowNotification
                                                 object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( kh_didHideKeyboard )
                                                   name: UIKeyboardDidHideNotification
                                                 object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( kh_willShowKeyboardWithNotification: )
                                                   name: UIKeyboardWillShowNotification
                                                 object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( kh_willHideKeyboardWithNotification: )
                                                   name: UIKeyboardWillHideNotification
                                                 object: nil ];
}

-(void)kh_unsubscribeKeyboardNotifications
{
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardDidShowNotification
                                                    object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardDidHideNotification
                                                    object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardWillShowNotification
                                                    object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardWillHideNotification
                                                    object: nil ];
}

-(UIScrollView*)kh_contentScrollView
{
   return nil;
}

-(UIView*)kh_contentActiveView
{
   return nil;
}

-(CGFloat)kh_bottomInsetInContentView
{
   return 0.f;
}

-(void)kh_removeInset
{
   UIEdgeInsets content_inset_ = self.kh_contentScrollView.contentInset;
   content_inset_.bottom = [ self kh_bottomInsetInContentView ];
   
   self.kh_contentScrollView.contentInset = content_inset_;
   self.kh_contentScrollView.scrollIndicatorInsets = content_inset_;
}

-(void)kh_didHideKeyboard
{
   //do nothing
}

-(void)kh_didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )keyboard_rect_
{
   UIScrollView* scroll_view_ = self.kh_contentScrollView;
   if ( scroll_view_ )
   {
      CGRect scroll_window_rect_ = [ scroll_view_ convertRect: scroll_view_.bounds toView: nil ];

      CGRect keyboard_intersection_ = CGRectIntersection( keyboard_rect_, scroll_window_rect_ );

      UIEdgeInsets content_inset_ = scroll_view_.contentInset;

      content_inset_.bottom = UIDeviceOrientationIsLandscape([ UIDevice currentDevice ].orientation)//landscape mode
      ? keyboard_intersection_.size.width
      : keyboard_intersection_.size.height;

      scroll_view_.contentInset = content_inset_;
      scroll_view_.scrollIndicatorInsets = content_inset_;

      UIView* active_view_ = self.kh_contentActiveView;
      if ( active_view_ )
      {
         CGRect content_rect_ = [ active_view_ convertRect: active_view_.bounds
                                                    toView: scroll_view_ ];

         [ UIView animateWithDuration: 0.3f
                           animations:
          ^{
            [ scroll_view_ scrollRectToVisible: content_rect_
                                      animated: NO ];
         } ];
      }
   }
}

-(void)kh_setKeyboardVisible:( BOOL )visible_
{
   objc_setAssociatedObject( self
                            , @selector(kh_isKeyboardVisible)
                            , @(visible_)
                            , OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(BOOL)kh_isKeyboardVisible
{
   return [ objc_getAssociatedObject( self, @selector(kh_isKeyboardVisible) ) boolValue ];
}

@end

@implementation UIScrollView (KeyboardHandler)

-(void)kh_setContentSizeWithBottomView:( UIView* )bottom_view_
                          bottomMargin:( CGFloat )bottom_margin_
{
   CGRect bottom_view_rect_ = [ bottom_view_ convertRect: bottom_view_.bounds toView: self ];
   self.contentSize = CGSizeMake( self.bounds.size.width, CGRectGetMaxY( bottom_view_rect_ ) + bottom_margin_ );
}

-(void)kh_setContentSizeWithBottomView:( UIView* )bottom_view_
{
   [ self kh_setContentSizeWithBottomView: bottom_view_ bottomMargin: 10.f ];
}

@end

