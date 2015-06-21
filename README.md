# WBLayoutView
Provides a linear auto layout view along either x or y axis, with various alignment options.
This view works much like something that may or may not be provided by another company in an upcoming
release of their software.

##Usage

    WBLayoutView *layoutView = [[WBLayoutView alloc] initWithFrame:<some frame>];
    layoutView.axis = UILayoutConstraintAxisVertical; // or UILayoutConstraintAxisHorizontal
    layoutView.alignment = WBLayoutAlignmentCenter; // see WBLayoutView.h for other options
    layoutView.spacing = 8.0; // adds 8.0 pt spacing between views
    [someView addSubview:layoutView];
    layoutView.center = <some point>; // position in your main view
    [layoutView addArrangedSubview:<some subview #1>];   // add your subviews you want arranged
    •
    •
    •
    [layoutView addArrangedSubview:<some subview #n>];  // last subview
    [layoutView addSubview:<some non-arranged subview>];  // add subviews that are managed independently
    
