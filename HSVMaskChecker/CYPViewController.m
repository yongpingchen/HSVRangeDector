//
//  CYPViewController.m
//  HSVMaskChecker
//
//  Created by will on 14-6-1.
//  Copyright (c) 2014年 AllRoundHut. All rights reserved.
//

#import "CYPViewController.h"

@interface CYPViewController ()
{
    NSArray *sliderArray;
    NSArray *valueLabelArray;
    
}
@property (weak, nonatomic) IBOutlet UISlider *minHValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *minSValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *minVValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *maxHValueSlier;
@property (weak, nonatomic) IBOutlet UISlider *maxSValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *maxVValueSlider;
@property (weak, nonatomic) IBOutlet UILabel *minHValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minSValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minVValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxHValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxSValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxVValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *minHSVColorImage;
@property (weak, nonatomic) IBOutlet UIImageView *maxHSVColorImage;

- (IBAction)changeSliderValue:(id)sender;

@end

@implementation CYPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    sliderArray = @[_minHValueSlider, _minSValueSlider, _minVValueSlider, _maxHValueSlier, _maxSValueSlider, _maxVValueSlider];
    valueLabelArray = @[_minHValueLabel, _minSValueLabel, _minVValueLabel, _maxHValueLabel, _maxSValueLabel, _maxVValueLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeSliderValue:(id)sender {
    int value = [(UISlider *)sender value];
    NSInteger index = [sliderArray indexOfObject:sender];
    UILabel *valueLabel = [valueLabelArray objectAtIndex:index];
    valueLabel.text = [NSString stringWithFormat:@"%d",value];
    
}
@end
