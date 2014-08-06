//
//  ViewController.m
//  BTCropAndResizeImage
//
//  Created by MAC on 7/16/14.
//  Copyright (c) 2014 DanielDuong. All rights reserved.
//

#import "ViewController.h"
#import "resizeImage.h"
#import "testViewController.h"
#import "mutilpleScreen.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIImage *imageToCrop;
}
@synthesize imageView,boundView;
@synthesize lkBackImage;
@synthesize lkTabBar;

@synthesize viewBound;
@synthesize btnBarCrop;
@synthesize height;
@synthesize viewBottom;
- (void)viewDidLoad
{
    [super viewDidLoad];
    height = 1.0;
    if (IS_IOS7) {
        if (IS_IPHONE_5) {
            NSLog(@"is retina4 ios7");
            CGRect theFrame;
            //get frame from toolbar to set new location
            theFrame= [viewBottom frame];
            theFrame.origin.y = 519;
            viewBottom.frame = theFrame;
            height = 519.0-44.0;
            //get frame from imageview to set new height
            theFrame=[imageView frame];
            theFrame.size.height = height;
            imageView.frame = theFrame;
        } else{
            NSLog(@"is retina3.5 ios7");//retina3.5 ios7 //retina4 ios7  -------------3.5inch iOS7
            CGRect theFrame;
            //get frame from toolbar to set new location
            theFrame= [viewBottom frame];
            theFrame.origin.y = 430;
            viewBottom.frame = theFrame;
            height = 430.0-44.0;
            //get frame from imageview to set new height
            theFrame=[imageView frame];
            theFrame.size.height = height;
            imageView.frame = theFrame;
            
            
        }
    }else {
        NSLog(@"ios6"); //480x320
        CGRect theFrame;
        //get frame from toolbar to set new location
        theFrame= [viewBottom frame];
        theFrame.origin.y = 413;
        viewBottom.frame = theFrame;
        height = 413.0-44.0;
        //get frame from imageview to set new height
        theFrame=[imageView frame];
        theFrame.size.height = height;
        imageView.frame = theFrame;
    }
    
	// Do any additional setup after loading the view, typically from a nib.
    imageView.image = lkBackImage;
    
    //author dvduongth
    if (imageView.image ==nil) {
        viewBound.hidden = true;
        btnBarCrop.enabled = false;
    }
    
    
   // [self setTabBarItem:lkTabBar.tabBarItem];
    
    ImagePicker = [[UIImagePickerController alloc]init];
    ImagePicker.delegate = self;
    @try{

        ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:ImagePicker animated:YES completion:NULL];
    }
    @catch(NSException *ex)
    {
        NSString *string = [[NSString alloc]initWithFormat:@"Lỗi không kết nối được Camera. Kiểm tra lại thiết bị Camera nhé!"];
        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Message" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [message show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Pan gesture recognizer action
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [recognizer translationInView:self.view];
            
            //allow dragging only in Y coordinates by only updating the Y coordinate with translation position
            recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            
            //get the top edge coordinate for the top left corner of crop frame
            float topEdgePosition = CGRectGetMinY(boundView.frame);
            
            //get the bottom edge coordinate for bottom left corner of crop frame
            float bottomEdgePosition = CGRectGetMaxY(boundView.frame);
            
            //if the top edge coordinate is less than or equal to 53
            if (topEdgePosition <= 44) {
                
                //draw drag view in max top position
                
                boundView.frame = CGRectMake(0, 44, 320, 320);
                
            }
            
            //if bottom edge coordinate is greater than or equal to 480
<<<<<<< HEAD
            
            if (bottomEdgePosition >=(44+height)) {
                
                //draw drag view in max bottom position
                boundView.frame = CGRectMake(0, (44+height)-320, 320, 320);
=======

            if (bottomEdgePosition >=430) {
                
                //draw drag view in max bottom position
                boundView.frame = CGRectMake(0, 110, 320, 320);

>>>>>>> FETCH_HEAD
            }
            
        }
            
        default:
            
            break;
            
            
    }
    
    
}


//receiver image return
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *imageChoose = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:imageChoose];
    [self dismissViewControllerAnimated:YES completion:NULL];
    btnBarCrop.enabled =true;
    viewBound.hidden = false;
    
}
//click cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

//action click camera
- (IBAction)CameraClicked:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]init];
    actionSheet.delegate = self;
    [actionSheet addButtonWithTitle:@"Camera"];
    [actionSheet addButtonWithTitle:@"PhotoLibrary"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex=actionSheet.numberOfButtons -1;
    [actionSheet showInView:[self.view window]];
    
}


#pragma mark -
#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save To Camera Roll"]) {
    if (buttonIndex == 0){
        //save photo
        @try{

            ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

            [self presentViewController:ImagePicker animated:YES completion:NULL];
        }
        @catch(NSException *ex)
        {
            NSString *string = [[NSString alloc]initWithFormat:@"Error %@ \nCó lẽ là không có thiết bị Camera đi kèm",ex];
            UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Message" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [message show];
        }
    }
    if (buttonIndex ==1) {
        
        ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

        [self presentViewController:ImagePicker animated:YES completion:NULL];
    }
}

//truyen du lieu sang view crop image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FilterView"]) {
        NSLog(@"CroppedView was choose");
        testViewController *destViewController = segue.destinationViewController;
        destViewController.lkBoundView = self.boundView;
        destViewController.lkImageToCrop= self.imageView.image;
        destViewController.lkViewController = self;
        destViewController.lkHeight = height;
    }
}


@end
