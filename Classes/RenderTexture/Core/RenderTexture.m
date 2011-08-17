//
//  RenderTexture.m
//  GLES
//
//  Created by Sergey Nikitenko on 7/16/11.
//  Hire me at odesk! ( www.odesk.com/users/~~1bd7ccce67734b51 )
//  Copyright 2011 DiDi Networks, Ltd. All rights reserved.
//


#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "RenderTexture.h"
#import "GLTexture.h"
#import "GLProgram.h"

static GLProgram* baseProgram = nil;

@implementation RenderTexture

//@synthesize texure = texRender;
//@synthesize originalTexure = texOriginal;
//@synthesize contentSize;

-(id) initWithImage:(UIImage*)img 
{
    self = [super init];
    if(self)
    {
        GLint saveName;
        glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
        
        TextureRawData textureRawData;
        if( textureDataFromImage(&textureRawData, img.CGImage) )
        {
            texRender = [[GLTexture alloc] initWithTextureData:&textureRawData];
            texOriginal = [[GLTexture alloc] initWithTextureData:&textureRawData];
            
            freeTextureData(&textureRawData);
        }
        
        glBindTexture(GL_TEXTURE_2D, saveName);
        
        if(texRender && texOriginal) 
        {
            glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFBO);
            
            // generate FBO
            glGenFramebuffers(1, &renderFBO);
            glBindFramebuffer(GL_FRAMEBUFFER, renderFBO);
            
            // associate texture with FBO
            glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texRender.textureName, 0);
            
            // check if it worked (probably worth doing :) )
            GLuint status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if (status != GL_FRAMEBUFFER_COMPLETE)
            {
                [self release];
                [NSException raise:@"Render Texture" format:@"Could not attach texture to framebuffer"];
            }
            
            glBindFramebuffer(GL_FRAMEBUFFER, oldFBO);
        }
        else
        {
            [self release];
            return nil;
        }
        
    }
    return self;
}



-(void) dealloc 
{
    glDeleteFramebuffersOES(1, &renderFBO);

    [texRender release];
    [texOriginal release];
    
    [super dealloc];
}

-(CGSize) contentSize
{
    return texRender.contentSize;
}

-(void) renderBegin
{
	CGSize texSize = texRender.contentSize;
	glViewport(0, 0, texSize.width, texSize.height);

	glGetIntegerv(GL_FRAMEBUFFER_BINDING, &oldFBO);
	glBindFramebuffer(GL_FRAMEBUFFER, renderFBO);//Will direct drawing to the frame buffer created above
}

-(void) renderEnd
{
	glBindFramebuffer(GL_FRAMEBUFFER, oldFBO);
}


-(UIImage*)getUIImage
{
	CGSize s = texRender.contentSize;
	int tx = s.width;
	int ty = s.height;
	
	int bitsPerComponent=8;			
	int bitsPerPixel=32;				
	
	int bytesPerRow					= (bitsPerPixel/8) * tx;
	NSInteger myDataLength			= bytesPerRow * ty;
	
    
    
    //GLubyte* buffer = malloc(sizeof(GLubyte)*myDataLength);
	static GLubyte* buffer = NULL;
    if(!buffer) 
    {
        buffer = malloc(2048*2048*4);
    }
    
	
	
	[self renderBegin];
	glReadPixels(0,0,tx,ty,GL_RGBA,GL_UNSIGNED_BYTE, buffer);
	[self renderEnd];

    // make data provider with data.
    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault;
    CGDataProviderRef provider		= CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
    CGColorSpaceRef colorSpaceRef	= CGColorSpaceCreateDeviceRGB();
    CGImageRef iref					= CGImageCreate(tx, ty,
                                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                    colorSpaceRef, bitmapInfo, provider,
                                                    NULL, false,
                                                    kCGRenderingIntentDefault);
    
    UIImage* image = [[[UIImage alloc] initWithCGImage:iref] autorelease];
    
    CGImageRelease(iref);	
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    //free(buffer);
    
    return image;
}


-(BOOL)saveBuffer:(NSString*)fileName
{
	NSArray *paths					= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory	= [paths objectAtIndex:0];
	NSString *fullPath				= [documentsDirectory stringByAppendingPathComponent:fileName];
	
	NSData *data = UIImagePNGRepresentation([self getUIImage]);
	
	return [data writeToFile:fullPath atomically:YES];
}


+ (GLProgram*)loadStandardProgram:(NSString*)programName
{        
    GLProgram* p = [[[GLProgram alloc] initWithVertexShaderFilename:programName fragmentShaderFilename:programName] autorelease];
    [p addAttribute:@"position"];
    [p addAttribute:@"texCoord"];
    [p link];
    return p;
}

-(void) drawInRect:(CGRect)rect usingStandardProgram:(GLProgram*)standardProgram
{
    GLfloat w = rect.size.width;
    GLfloat h = rect.size.height;
    CGPoint pt = rect.origin;
	GLfloat vertices[] = {pt.x,	pt.y, 0, pt.x+w, pt.y, 0, pt.x, pt.y+h, 0, pt.x+w, pt.y+h, 0};
	GLfloat coordinates[] = { 0, texRender.maxT, texRender.maxS, texRender.maxT, 0, 0, texRender.maxS, 0};
    
    [standardProgram use];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texOriginal.textureName);
    
    glUniform1i([standardProgram uniformIndex:@"texture"], 0);
    
    GLuint vertCoordAttr = [standardProgram attributeIndex:@"position"];
    GLuint texCoordAttr = [standardProgram attributeIndex:@"texCoord"];
    
    glVertexAttribPointer(vertCoordAttr, 3, GL_FLOAT, 0, 0, vertices);
    glEnableVertexAttribArray(vertCoordAttr);
    glVertexAttribPointer(texCoordAttr, 2, GL_FLOAT, 0, 0, coordinates);
    glEnableVertexAttribArray(texCoordAttr);
    
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


+ (void)loadBaseProgram
{        
    if(!baseProgram)
    {
        baseProgram = [[self loadStandardProgram:@"BaseShader"] retain];
    }
}


-(void) drawInRect:(CGRect)rect
{
    [self drawInRect:rect usingStandardProgram:baseProgram];
}

@end








