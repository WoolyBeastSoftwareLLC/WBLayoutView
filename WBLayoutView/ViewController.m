//
//  ViewController.m
//  WBLayoutView
//
//  Created by Scott Chandler on 6/15/15.
//  Copyright (c) 2015 Wooly Beast Software LLC. All rights reserved.
//

#import "ViewController.h"
#import "WBLayoutView.h"

@interface ViewController ()
@property (nonatomic,weak) UILabel *testLabel;
- (UILabel *)createTestLabel;

@property (nonatomic,weak) UIImageView *testImageView;
- (UIImageView *)createTestImageView;

@property (nonatomic,weak) UITextField *testTextField;
- (UITextField *)createTestTextField;

@property (nonatomic,weak) WBLayoutView *layoutView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//	WBLayoutView *layoutView = [[WBLayoutView alloc] initWithFrame:(CGRect){CGPointZero,(CGSize){200.0,15.0}}];
	WBLayoutView *layoutView = [[WBLayoutView alloc] initWithFrame:CGRectZero];
	layoutView.axis = UILayoutConstraintAxisVertical;
	layoutView.spacing = 5.0;
	layoutView.alignment = WBLayoutViewAlignmentCenter;
	layoutView.autoresizingMask = UIViewAutoresizingNone;
	[self.view addSubview:layoutView];
	_layoutView = layoutView;
	layoutView.center = (CGPoint){CGRectGetMidX(self.view.bounds),CGRectGetMidY(self.view.bounds)};
	
	NSDictionary *viewMap = @{@"testLabel" : [self createTestLabel],
							  @"testImageView" : [self createTestImageView],
							  @"testTextField" : [self createTestTextField]};

	for ( UIView *view in [viewMap allValues]) {
		[layoutView addArrangedSubview:view];
	}
	
	[self setValuesForKeysWithDictionary:viewMap];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.25 animations:^{
			self.testImageView.hidden = YES;
		}];
	});
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		self.layoutView.axis = UILayoutConstraintAxisHorizontal;
	});
	
}
#pragma mark -

- (UILabel *)createTestLabel
{
	UILabel *label = [UILabel new];
	label.text = @"Test Label";
	label.translatesAutoresizingMaskIntoConstraints = NO;
	[label sizeToFit];
	return label;
}

- (UIImageView *)createTestImageView
{
	CGRect rect = (CGRect){CGPointZero,(CGSize){42.0,42.0}};
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
	[[UIColor redColor] setFill];
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
	[path fill];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.translatesAutoresizingMaskIntoConstraints = NO;
	[imageView sizeToFit];
	return imageView;
}

- (UITextField *)createTestTextField
{
	UITextField *textField = [UITextField new];
	textField.placeholder = @"Test Text Field";
	textField.translatesAutoresizingMaskIntoConstraints = NO;
	[textField sizeToFit];
	return textField;
}


@end
