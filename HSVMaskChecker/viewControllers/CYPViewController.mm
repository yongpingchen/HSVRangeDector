//
//  CYPViewController.m
//  HSVMaskChecker
//
//  Created by will on 14-6-1.
//  Copyright (c) 2014年 AllRoundHut. All rights reserved.
//

#import "CYPViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import <opencv2/imgproc/imgproc_c.h>
#import <CoreMedia/CoreMedia.h>
#import <opencv2/objdetect/objdetect.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
using namespace std;
using namespace cv;


@interface CYPViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *sliderArray;
    NSArray *valueLabelArray;
    
    UIPopoverController *objPopView;
    
    UIImage *originImage;
    
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
    int currentValue = valueLabel.text.intValue;
    if (currentValue == value) {
        return;
    }
    valueLabel.text = [NSString stringWithFormat:@"%d",value];
    
    //mask the image
    IplImage *iplImage = [CYPViewController CreateIplImageFromUIImage:originImage];
    
    //ipl imaeg is also converted to HSV; hue is used to find certain color
    IplImage *imgHSV = cvCreateImage(cvGetSize(iplImage), 8, 3);
    cvCvtColor(iplImage, imgHSV, CV_BGR2HSV);
    
    IplImage *imgThreshed = cvCreateImage(cvGetSize(iplImage), 8, 1);
    
    //it is important to release all images EXCEPT the one that is going to be passed to
    //the didFinishProcessingImage: method and displayed in the UIImageView
    cvReleaseImage(&iplImage);
    
    //filter all pixels in defined range, everything in range will be white, everything else
    //is going to be black
//    cvInRangeS(imgHSV, cvScalar(0, 0, 255), cvScalar(45, 72, 255), imgThreshed);
    cvInRangeS(imgHSV, cvScalar(_minHValueLabel.text.intValue, _minSValueLabel.text.intValue, _minVValueLabel.text.intValue), cvScalar(_maxHValueLabel.text.intValue, _maxSValueLabel.text.intValue, _maxVValueLabel.text.intValue), imgThreshed);
    cvReleaseImage(&imgHSV);
    
    //UIImage view couln't directly load grey image, so need to convert gray image to BGR image
    IplImage* grayImagePlus = cvCreateImage(cvGetSize(imgThreshed), IPL_DEPTH_8U, 3);
    cvCvtColor(imgThreshed, grayImagePlus, CV_GRAY2BGR);
    UIImage *convertedImage = [CYPViewController UIImageFromIplImage:grayImagePlus];
    cvReleaseImage(&grayImagePlus);
    [_photoImage setImage:convertedImage];
    
    cvReleaseImage(&imgThreshed);

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
        //keep a copy of origin image
        originImage = [newImage copy];
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

+ (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}


+(UIImage *)UIImageFromIplImage:(IplImage *)image
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
    
}


@end
