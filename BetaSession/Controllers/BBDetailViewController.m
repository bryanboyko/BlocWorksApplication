//
//  BBDetailViewController.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBDetailViewController.h"
#import "BBExercise.h"
#import "BBImageStore.h"
#import "BBExerciseStore.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface BBDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *exerciseName;
@property (weak, nonatomic) IBOutlet UITextField *exerciseType;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIToolbar *albumButton;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;


@property (nonatomic, strong)MPMoviePlayerController *videoController;


- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)chooseFromPhotoAlbum:(id)sender;
- (IBAction)playVideo:(id)sender;


@end

@implementation BBDetailViewController


- (instancetype)initForNewExercise:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneExercise = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneExercise;
            
            UIBarButtonItem *cancelExercise = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelExercise;
            
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
            
            [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
            [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
            
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong init" reason:@"Use initForNewExercise" userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    BBExercise *exercise = self.exercise;
    
    self.exerciseName.text = exercise.exerciseName;
    self.exerciseType.text = exercise.exerciseStyle;
    self.exercise.videoURL = exercise.videoURL;
    
    
    NSString *itemKey = self.exercise.exerciseKey;
    if (itemKey) {
        // Get image for image key from the image store
        UIImage *imageToDisplay = [[BBImageStore sharedStore] imageForKey:itemKey];
        
        // Use that image to put on the screen in imageView
        self.imageView.image = imageToDisplay;
    } else {
        // Clear the imageView
        self.imageView.image = nil;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
    
    BBExercise *exercise = self.exercise;
    exercise.exerciseName = self.exerciseName.text;
    exercise.exerciseStyle = self.exerciseType.text;
    exercise.videoURL = self.exercise.videoURL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setExercise:(BBExercise *)exercise
{
    _exercise = exercise;
    self.navigationItem.title = _exercise.exerciseName;
}

- (IBAction)takePicture:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeMovie, nil];
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)chooseFromPhotoAlbum:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
    }
    
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)playVideo:(id)sender {
    NSLog(@"touched");
    if (self.exercise.videoURL) {
        self.videoController = [[MPMoviePlayerController alloc] init];
        [self.videoController  setContentURL:self.exercise.videoURL];
        [self.view addSubview:self.videoController.view];
        [self.videoController setFullscreen:YES];
        [self.videoController play];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.exercise.videoURL = info[UIImagePickerControllerMediaURL];

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]){
        // Saving the video / // Get the new unique filename
        NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath];
        UISaveVideoAtPathToSavedPhotosAlbum(sourcePath, nil, @selector(video:didFinishSavingWithError:contextInfo:),nil);
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(addImageToImageView) withObject:self afterDelay:0];
}



//required for saving video to album
- (void)video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSLog(@"Video Saving Error: %@", error);
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
    NSLog(@"saved?");
    
}

- (void)addImageToImageView
{
    //retrieve thumbnail from videoURL
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:self.exercise.videoURL options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    self.imageView.image = one;
    [self.exercise setThumbnailFromImage:one];

    
    if (one) {
        [[BBImageStore sharedStore] setImage:one forKey:self.exercise.exerciseKey];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageLabel.hidden = YES;
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageLabel.hidden = NO;
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)cancel:(id)sender
{
    //if user cancels, remove exercise from store
    [[BBExerciseStore sharedStore] removeExercise:self.exercise];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

@end

