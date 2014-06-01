//
//  CYPViewController.m
//  HSVMaskChecker
//
//  Created by will on 14-6-1.
//  Copyright (c) 2014年 AllRoundHut. All rights reserved.
//

#import "CYPViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface CYPViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *sliderArray;
    NSArray *valueLabelArray;
    
    UIPopoverController *objPopView;
    
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
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

- (IBAction)changeSliderValue:(id)sender;
- (IBAction)tapLoadPhoto:(id)sender;

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

- (IBAction)tapLoadPhoto:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        
        objPopView = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [objPopView presentPopoverFromRect:CGRectMake(842, 163, 0, 0)
                                    inView:self.view
                  permittedArrowDirections:UIPopoverArrowDirectionRight
                                  animated:YES];
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    //    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        CGSize newSize;
        newSize.width = 674;
        newSize.height = 768;
        
        if (image.size.height < image.size.width) {
            UIImage *lanscapeImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
            image = lanscapeImage;
        }
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _photoImage.image = newImage;
        NSError *error;
        NSLog(@"error:%@",error.description);
        [objPopView dismissPopoverAnimated:YES];

    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
}



@end
