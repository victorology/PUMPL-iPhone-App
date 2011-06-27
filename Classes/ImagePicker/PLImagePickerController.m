//
//  PLImagePickerController.m
//  
//
//  Created by Sergey Nikitenko on 5/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PLImagePickerController.h"

@interface UIButton (configureAsPrototype)
-(void) configureAsPrototypeButton:(UIButton*)prototypeButton;
@end

@implementation UIButton (configureAsPrototype)
-(void) configureAsPrototypeButton:(UIButton*)prototypeButton
{
    [self setBackgroundImage:[prototypeButton backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setBackgroundImage:[prototypeButton backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self setTitleColor:[prototypeButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setTitleShadowColor:[prototypeButton titleShadowColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.titleLabel.font = prototypeButton.titleLabel.font;
    self.titleLabel.shadowOffset = prototypeButton.titleLabel.shadowOffset;
}
@end




@implementation PLImagePickerController

-(UIView*) childOfRootView:(UIView*)rootView withPath:(NSArray*)path
{
    UIView* node = rootView;
    for(id pathItem in path)
    {
        if(![node isKindOfClass:[UIView class]])
            return nil;

        NSArray* childViews = [node subviews];
        int childViewIndex = [pathItem intValue];
        if(!(childViewIndex<[childViews count]))
            return nil;
        
        node = [childViews objectAtIndex:childViewIndex];
    }
    return node;
}


-(BOOL) configureOverlay
{
    NSArray* pickerBarPath = [NSArray arrayWithObjects:@"0",@"0",@"0",@"2",@"1",@"1", nil]; // tested with 4.3
    UIView* pickerBar = [self childOfRootView:self.view withPath:pickerBarPath];
    
    if(!pickerBar)
    {
        NSArray* pickerBarPath2 = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"2",@"1",@"1", nil]; // tested with 4.2.1
        pickerBar = [self childOfRootView:self.view withPath:pickerBarPath2];
    }

    if(pickerBar && [[pickerBar subviews] count] >=1)
    {
        UIButton* cancelButton = [[pickerBar subviews] objectAtIndex:1];
        if([cancelButton isKindOfClass:[UIButton class]])
        {
            UIButton* squareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            squareButton.frame = CGRectOffset(cancelButton.frame, pickerBar.frame.size.width-2*cancelButton.frame.origin.x-cancelButton.frame.size.width, 0);
            [squareButton configureAsPrototypeButton:cancelButton];
            [squareButton setTitle:@"Square" forState:UIControlStateNormal];
            [squareButton addTarget:self action:@selector(onSquareBtn:) forControlEvents:UIControlEventTouchUpInside];
            [pickerBar addSubview:squareButton];
            
            
            UIImage* squareImage = [UIImage imageNamed:@"croppedCameraOverlay.png"];
            squareView = [[[UIImageView alloc] initWithImage:squareImage] autorelease];
            squareView.frame = CGRectMake(0, 0, 320, 427);
            squareView.hidden = YES;
            [[[[pickerBar superview] superview] superview] addSubview:squareView];
            return YES;
        }
    }
    return NO;
}

-(void) viewDidAppear: (BOOL)animated
{
	[super viewDidAppear:animated];
    
    if(self.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        BOOL success = [self configureOverlay];
        if(!success)
        {
            NSLog(@"[PLImagePickerController configureOverlay] failed. Trying again...");
            [self performSelector:@selector(configureOverlay) withObject:nil afterDelay:0];
        }
    }
}

 
-(void) onSquareBtn:(id)sender
{
    if([[sender titleForState:UIControlStateNormal] isEqualToString:@"Square"])
    {
        [sender setTitle:@"Full" forState:UIControlStateNormal];
        squareView.hidden = NO;
    }
    else
    {
        [sender setTitle:@"Square" forState:UIControlStateNormal];
        squareView.hidden = YES;
    }
}


@end
