//
//  CreditCardViewController.m
//  LotipleApp
//
//  Created by kueecc on 11. 5. 1..
//  Copyright 2011 Home. All rights reserved.
//

#import "CreditCardViewController.h"

#import "Settings.h"
#import "Cards.h"
#import "Util.h"

@implementation CreditCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	Settings* settings = [Settings instance];
	
	num1Tf.text = settings.cardNum1;
	num2Tf.text = settings.cardNum2;
	num3Tf.text = settings.cardNum3;
	num4Tf.text = settings.cardNum4;
	monthTf.text = settings.cardMonth;
	yearTf.text = settings.cardYear;
	[cardCb setTitle:settings.cardType forState:UIControlStateNormal];
	
	
	[num1Tf becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showPicker
{	
	pickerAs = [[UIActionSheet alloc] initWithTitle:@""
										   delegate:nil//self
								  cancelButtonTitle:nil//@"Done"
							 destructiveButtonTitle:nil//@"Cancel"
								  otherButtonTitles:nil];
	
	[pickerAs addSubview:mypickerView];
	
	[pickerAs setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	[pickerAs showInView:self.view];
	[pickerAs setBounds:CGRectMake(0,0,320, 436 + 45)];	
}

#pragma mark - Event handlers

- (IBAction)editingChanged:(id)sender;
{
	UITextField* textField = (UITextField*)sender;
	
	// 뭐..이런건 그냥 하드코딩이 진리
	NSUInteger length = [textField.text length];
	
	if (length == 2)
	{
		if (textField == monthTf)
			[yearTf becomeFirstResponder];
	}
	else if (length == 4)
	{
		if (textField == num1Tf)
			[num2Tf becomeFirstResponder];
		if (textField == num2Tf)
			[num3Tf becomeFirstResponder];
		if (textField == num3Tf)
			[num4Tf becomeFirstResponder];
		if (textField == num4Tf)
			[monthTf becomeFirstResponder];
	}
}

- (IBAction)buttonClicked:(id)sender
{
	if (sender == cardCb)
	{
		[self showPicker];
	}
	else if (sender == resetBtn)
	{
		num1Tf.text = @"";
		num2Tf.text = @"";
		num3Tf.text = @"";
		num4Tf.text = @"";
		monthTf.text = @"";
		yearTf.text = @"";
		[cardCb setTitle:@"" forState:UIControlStateNormal];
		
		[num1Tf becomeFirstResponder];
	}
	else if (sender == acceptBtn)
	{
		NSString* message = nil;
		
		if (message)
		{
			[Util showAlertView:self message:message];
		}
		else
		{
			Settings* settings = [Settings instance];
			settings.cardNum1 = num1Tf.text;
			settings.cardNum2 = num2Tf.text;
			settings.cardNum3 = num3Tf.text;
			settings.cardNum4 = num4Tf.text;
			settings.cardMonth = monthTf.text;
			settings.cardYear = yearTf.text;
			settings.cardType = [cardCb titleForState:UIControlStateNormal];
			
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
	
}

- (IBAction)pickerButtonClicked:(id)sender
{
	if (sender == pickerCancelBtn)
	{
		
	}
	else if (sender == pickerAcceptBtn)
	{
		NSString* cardName = [Cards nameForType:selectedRow];
		[cardCb setTitle:cardName forState:UIControlStateNormal];
	}
	
	[pickerAs dismissWithClickedButtonIndex:-1 animated:YES];
	[pickerAs release];
	pickerAs = nil;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSUInteger newLength = [textField.text length] + [string length] - range.length;

	int cutline = 0;
	
	if (textField == monthTf) cutline = 2;
	else cutline = 4;
	
	return (newLength <= cutline);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (textField == monthTf)
	{
		int month = [monthTf.text intValue];
		if (month < 10)
			monthTf.text = [NSString stringWithFormat:@"%02d", month];
	}
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [Cards nameForType:(CardType)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	selectedRow = row;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return CardTypeCount;
}


@end
