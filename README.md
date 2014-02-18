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

    //kh_contentScrollView returns scroll view that manages content offset after keyboard appearance
    -(UIScrollView*)kh_contentScrollView
    {
       return self.scrollView;
    }

    //kh_contentActiveView returns control that should be visible after keyboard appearance
    -(UIView*)kh_contentActiveView
    {
       return self.loginButton;
    }

