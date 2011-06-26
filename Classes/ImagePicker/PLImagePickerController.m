//
//  PLImagePickerController.m
//  
//
//  Created by Sergey Nikitenko on 6/25/11.
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
            /*
            UIButton* squareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            squareButton.frame = CGRectOffset(cancelButton.frame, pickerBar.frame.size.width-2*cancelButton.frame.origin.x-cancelButton.frame.size.width, 0);
            [squareButton configureAsPrototypeButton:cancelButton];
            [squareButton setTitle:@"Square" forState:UIControlStateNormal];
            [squareButton addTarget:self action:@selector(onSquareBtn:) forControlEvents:UIControlEventTouchUpInside];
            [pickerBar addSubview:squareButton];
            */ 
            
            UIImage* squareImage = [UIImage imageNamed:@"SquareView.png"];
            squareView = [[[UIImageView alloc] initWithImage:squareImage] autorelease];
            squareView.frame = CGRectMake(0, 0, 320, 427);
            squareView.hidden = YES;
            [[[[pickerBar superview] superview] superview] addSubview:squareView];
            
            UIButton* squareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            squareBtn.frame = CGRectMake(20, 10, 83, 35);
            [squareBtn setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
            [squareBtn addTarget:self action:@selector(onSquareBtn:) forControlEvents:UIControlEventTouchUpInside];
            [[[[[pickerBar superview] superview] superview] superview] addSubview:squareBtn];
            
            
            [cancelButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
            cancelButton.frame = CGRectMake(cancelButton.frame.origin.x+10, cancelButton.frame.origin.y, cancelButton.frame.size.height, cancelButton.frame.size.height);
            
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
    if(squareView.hidden)
    {
        [sender setImage:[UIImage imageNamed:@"Full.png"] forState:UIControlStateNormal];
        //[sender setTitle:@"Full" forState:UIControlStateNormal];
        squareView.hidden = NO;
    }
    else
    {
        [sender setImage:[UIImage imageNamed:@"Square.png"] forState:UIControlStateNormal];
        //[sender setTitle:@"Square" forState:UIControlStateNormal];
        squareView.hidden = YES;
    }
}


@end
