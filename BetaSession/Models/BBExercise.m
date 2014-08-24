//
//  BBExercise.m
//  BetaSession
//
//  Created by Bryan Boyko on 8/15/14.
//  Copyright (c) 2014 Bryan Boyko. All rights reserved.
//

#import "BBExercise.h"

@implementation BBExercise

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _exerciseName = [aDecoder decodeObjectForKey:@"exerciseName"];
        _exerciseStyle = [aDecoder decodeObjectForKey:@"exerciseStyle"];
        _exerciseKey = [aDecoder decodeObjectForKey:@"exerciseKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        _videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
    }
    return self;
}

- (instancetype)initWithExerciseName:(NSString *)exerciseName exerciseStyle:(NSString *)exerciseStyle videoURL:(NSURL *)videoURL
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _exerciseName = exerciseName;
        _exerciseStyle = exerciseStyle;
        _videoURL = videoURL;
        
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _exerciseKey = key;
    }
    
    // Return the address of the newly initialized object
    return self;
}

- (instancetype)initWithExerciseName:(NSString *)exerciseName
{
    return [self initWithExerciseName:exerciseName
                        exerciseStyle:@""
                             videoURL:nil];
}

- (instancetype)init
{
    return [self initWithExerciseName:@"exercise"];
}

- (void)dealloc
{
    NSLog(@"Destroyed: %@", self);
}


- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"exerciseName: %@, exerciseStyle: %@",
     self.exerciseName,
     self.exerciseStyle];
    return descriptionString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.exerciseName forKey:@"exerciseName"];
    [aCoder encodeObject:self.exerciseStyle forKey:@"exerciseStyle"];
    [aCoder encodeObject:self.exerciseKey forKey:@"exerciseKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
}

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize originalSizeImage = image.size;
    
    //make thumbnail size
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    //scaling ration to maintain same aspect ratio
    float ratio = MAX(newRect.size.width / originalSizeImage.width, newRect.size.height / originalSizeImage.height);
    
    //create transparent bitmap with scaling factor equal to size of screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    //create rounded rectangle path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //make subsqequent drawing clip to this rounded rectangle
    [path addClip];
    
    //center image in thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * originalSizeImage.width;
    projectRect.size.height = ratio * originalSizeImage.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    //draw the image on it
    [image drawInRect:projectRect];
    
    //Get image from image context and keep it as thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    //cleanup image context resources
    UIGraphicsEndImageContext();
}

@end
