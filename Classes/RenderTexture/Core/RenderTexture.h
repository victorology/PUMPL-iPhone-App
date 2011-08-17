//
//  RenderTexture.h
//  GLES
//
//  Created by Sergey Nikitenko on 7/16/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@class GLTexture;
@interface RenderTexture : NSObject {
    
	GLint oldFBO;
	GLuint renderFBO;
    
    GLTexture* texRender;
    GLTexture* texOriginal;
}

//@property (nonatomic, readonly) GLTexture* texure;
//@property (nonatomic, readonly) GLTexture* originalTexure;

@property (nonatomic, readonly) CGSize contentSize;

+ (void)loadBaseProgram;

- (id)initWithImage:(UIImage*)img;
- (void)drawInRect:(CGRect)rect;

-(BOOL)saveBuffer:(NSString*)fileName;
-(UIImage*)getUIImage;


@end

