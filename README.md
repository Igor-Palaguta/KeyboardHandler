KeyboardHandler
===============

Usage sample

-(void)viewWillAppear:(BOOL)animated_
{
   [ super viewWillAppear: animated_ ];

   [ self kh_subscribeKeyboardNotifications ];
}

-(void)viewWillDisappear:(BOOL)animated_
{
   [ super viewWillDisappear: animated_ ];

   [ self kh_unsubscribeKeyboardNotifications ];
}

-(UIScrollView*)kh_contentScrollView
{
   return self.scrollView;
}

-(UIView*)kh_contentActiveView
{
   return self.loginButton;
}

