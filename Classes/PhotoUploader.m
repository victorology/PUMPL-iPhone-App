//
//  PhotoUploader.m
//  PUMPL
//
//  Created by Harmandeep Singh on 21/01/11.
//  Copyright 2011 Route Me. All rights reserved.
//

#import "PhotoUploader.h"
#import "EnabledService.h"


@interface PhotoUploader()

- (void)uploadImageAndTitleToPUMPL;

@end



@implementation PhotoUploader

@synthesize delegate;

- (id)init
{
	return nil;
}

- (id)initWithImage:(UIImage *)image andTitle:(NSString *)title andServices:(NSMutableArray *)services andFilter:(NSInteger)appliedFilter
{
	if(image == nil)
		return nil;
	
	if(self = [super init])
	{
		_image = [image retain];
		_title = [title copy];
		_services = [services retain];
		_filterApplied = appliedFilter;
	}
		
	return self;
}

- (void)dealloc
{
	_request.delegate = nil;
	[_request setUploadProgressDelegate:nil];
	[_request cancel];
	[_request release];
	
	[_image release];
	[_title release];
	[_services release];
	[super dealloc];
}



- (void)startUploading
{
	[self uploadImageAndTitleToPUMPL];
}




- (void)uploadImageAndTitleToPUMPL
{
	if([delegate respondsToSelector:@selector(photoUploader:hasStartedTheStepWithTitle:)])
	{
		[delegate photoUploader:self hasStartedTheStepWithTitle:NSLocalizedString(@"UploadingToPUMPLKey", @"")];
	}
	
	NSDictionary *userInfo = [[DataManager sharedDataManager] getUserProfile];
	NSString *idString = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"id"]];
	NSString *session_api = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"session_api"]];
	NSData *imageData = UIImageJPEGRepresentation(_image, 25.0);//NSData *imageData = UIImagePNGRepresentation(_image);
	
	
	//Check the Facebook service if present and if it is enabled for upload or not because we are not seperately going to upload it to facebook.
	NSString *shouldUploadToFacebook = @"no";
	NSString *shouldUploadToTwitter = @"no";
	NSString *shouldUploadToTumblr = @"no";
	NSString *shouldUploadToMe2day = @"no";
	
	for(NSString *serviceName in _services)
	{
		if([serviceName isEqualToString:@"Facebook"])
		{
			shouldUploadToFacebook = @"yes";
		}
		else if([serviceName isEqualToString:@"Twitter"])
		{
			shouldUploadToTwitter = @"yes";
		}
		else if([serviceName isEqualToString:@"Tumblr"])
		{
			shouldUploadToTumblr = @"yes";
		}
        else if([serviceName isEqualToString:@"me2day"])
		{
			shouldUploadToMe2day = @"yes";
		}
	}
	
	
	NSString *filterString = nil;
	switch (_filterApplied) 
	{
		case kFilterTag:
		{
			filterString = @"Normal";
			break;
		}
			
		case kFilterTagNormal:
		{
			filterString = @"Normal";
			break;
		}
			
		case kFilterTagXPro:
		{
			filterString = @"XPro";
			break;
		}
			
		case kFilterTagVintage:
		{
			filterString = @"Vintage";
			break;
		}
			
		case kFilterTagLomo:
		{
			filterString = @"Lomo";
			break;
		}
			
		case kFilterTagPhotochrome:
		{
			filterString = @"Photochrom";
			break;
		}
			
		case kFilterTagMonochrome:
		{
			filterString = @"Monochrome";
			break;
		}
			
		case kFilterTagRedscale:
		{
			filterString = @"Redscale";
			break;
		}
			
		case kFilterTagPolaroid:
		{
			filterString = @"Polaroid";
			break;
		}
			
		case kFilterTagPlasticEye:
		{
			filterString = @"PlasticEye";
			break;
		}
			
			
		default:
			break;
	}
	
	
    
    NSString *shouldPostToFacebookWall = nil;
    NSString *shouldPostToFacebookAlbum = nil;
    NSString *facebookAlbumId = nil;
    if([shouldUploadToFacebook isEqualToString:@"yes"])
    {
        NSString *albumName = [[DataManager sharedDataManager] getFacebookUploadAlbumName];
        if(albumName)
        {
            shouldPostToFacebookWall = @"no";
            shouldPostToFacebookAlbum = @"yes";
            facebookAlbumId = [[DataManager sharedDataManager] getFacebookUploadAlbumID];
        }
        else
        {
            shouldPostToFacebookWall = @"yes";
            shouldPostToFacebookAlbum = @"no";
        }
    }
    
    
	
	if(imageData)
	{
		_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:kURLForPhotoUpload]];
		_request.delegate = self;
		_request.requestMethod = @"POST";
		[_request setPostValue:idString forKey:@"id"];
		[_request setPostValue:session_api forKey:@"session_api"];
		[_request setPostValue:shouldUploadToFacebook forKey:@"photo[post_to_facebook]"];
		[_request setPostValue:shouldUploadToTwitter forKey:@"photo[post_to_twitter]"];
		[_request setPostValue:shouldUploadToTumblr forKey:@"photo[post_to_tumblr]"];
        [_request setPostValue:shouldUploadToMe2day forKey:@"photo[post_to_me2day]"];
		[_request setPostValue:filterString forKey:@"filter"];
		[_request setUploadProgressDelegate:self];
		_request.timeOutSeconds = 500;
		
		
		if(_title)
		{
			[_request setPostValue:_title forKey:@"photo[title]"];
		}
        
        if(shouldPostToFacebookWall)
        {
            [_request setPostValue:shouldPostToFacebookWall forKey:@"photo[post_to_facebook_wall]"];
        }
        
        if(shouldPostToFacebookAlbum)
        {
            [_request setPostValue:shouldPostToFacebookAlbum forKey:@"photo[post_to_facebook_album]"];
        }
        
        if(facebookAlbumId)
        {
            [_request setPostValue:facebookAlbumId forKey:@"photo[album_id]"];
        }
		
		
		[_request setData:imageData withFileName:@"fileName.jpg" andContentType:@"image/jpg" forKey:@"photo[image]"];
		[_request startAsynchronous];
	}
	else 
	{
		NSString *errorMessage = @"Failed to upload Image to PUMPL because image is not correct";
		if([delegate respondsToSelector:@selector(photoUploader:hasEncounteredError:)])
		{
			[delegate photoUploader:self hasEncounteredError:errorMessage];
		}
	}
}





#pragma mark -
#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	NSDictionary *responseDic = [responseString JSONValue];

	
	NSInteger code = [[responseDic valueForKey:@"code"] integerValue];
	if(code == 0)
	{
		NSDictionary *photoInfo = [[responseDic valueForKey:@"value"] valueForKey:@"photo"];
		if(photoInfo != nil)
		{
			if([delegate respondsToSelector:@selector(photoUploaderHasFinishedUploading)])
			{
				[delegate photoUploaderHasFinishedUploading];
			}
		}
        else
        {
            NSString *errorMessage = NSLocalizedString(@"UnknownServerResponseKey", nil);
            if([delegate respondsToSelector:@selector(photoUploader:hasEncounteredError:)])
            {
                [delegate photoUploader:self hasEncounteredError:errorMessage];
            }
        }
	}
	else 
	{
		NSString *errorMessage = [responseDic valueForKey:@"error_message"];
		if([delegate respondsToSelector:@selector(photoUploader:hasEncounteredError:)])
		{
			[delegate photoUploader:self hasEncounteredError:errorMessage];
		}
	}
	 
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
	if([delegate respondsToSelector:@selector(photoUploader:hasEncounteredError:)])
	{
		[delegate photoUploader:self hasEncounteredError:[[request error] localizedDescription]];
	}
}


- (void)setProgress:(float)newProgress
{
	if([delegate respondsToSelector:@selector(photoUploader:uploadProgress:)])
	{
		[delegate photoUploader:self uploadProgress:newProgress];
	}
}





@end
