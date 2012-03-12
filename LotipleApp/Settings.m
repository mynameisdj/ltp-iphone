//
//  Settings.m
//  LotipleApp
//
//  Created by kueecc on 11. 4. 18..
//  Copyright 2011 Home. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize usedId, usedPw;
@synthesize saveId, savePw, tokenKey, tokenSecret, developMode;
@synthesize cardNum1, cardNum2, cardNum3, cardNum4, cardYear, cardMonth, cardType;

Settings* _settings;

+ (id)instance
{
	if (!_settings)
	{
		_settings = [[Settings alloc] init];
	}
	
	return _settings;
}

- (id)init
{
	self = [super init];
	if (self)
	{
		saveId = YES;
		savePw = YES;
		
		[self load];
	}
	
	return self;
}


+ (NSString*)file
{
	NSString* fileName = @"Lotiple.dat";
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	NSString* filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	return filePath;
}

- (void)save
{
	NSMutableData* data = [NSMutableData dataWithCapacity:100];
	
	NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject:self.usedId forKey:@"usedId"];
	[archiver encodeObject:self.usedPw forKey:@"usedPw"];
    [archiver encodeObject:self.tokenKey forKey:@"tokenKey"];
    [archiver encodeObject:self.tokenSecret forKey:@"tokenSecret"];
	[archiver encodeObject:self.cardNum1 forKey:@"cardNum1"];
	[archiver encodeObject:self.cardNum2 forKey:@"cardNum2"];
	[archiver encodeObject:self.cardNum3 forKey:@"cardNum3"];
	[archiver encodeObject:self.cardNum4 forKey:@"cardNum4"];
	[archiver encodeObject:self.cardMonth forKey:@"cardMonth"];
	[archiver encodeObject:self.cardYear forKey:@"cardYear"];
	[archiver encodeObject:self.cardType forKey:@"cardType"];
    [archiver encodeBool:self.developMode forKey:@"developMode"];

	[archiver finishEncoding];
	
	[data writeToFile:[Settings file] options:NSDataWritingFileProtectionComplete error:nil];
	//[data writeToFile:[Settings file] atomically:YES];

	[archiver release];

	// crash..
	//[data release];
}

- (void)load
{
	NSData* data = [NSData dataWithContentsOfFile:[Settings file]];
	if (data)
	{
		NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		//NSKeyedUnarchiver* unarchiver = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		if (unarchiver)
		{
			self.usedId = [unarchiver decodeObjectForKey:@"usedId"];
			self.usedPw = [unarchiver decodeObjectForKey:@"usedPw"];
            self.tokenKey = [unarchiver decodeObjectForKey:@"tokenKey"];
            self.tokenSecret = [unarchiver decodeObjectForKey:@"tokenSecret"];
			self.cardNum1 = [unarchiver decodeObjectForKey:@"cardNum1"];
			self.cardNum2 = [unarchiver decodeObjectForKey:@"cardNum2"];
			self.cardNum3 = [unarchiver decodeObjectForKey:@"cardNum3"];
			self.cardNum4 = [unarchiver decodeObjectForKey:@"cardNum4"];
			self.cardMonth = [unarchiver decodeObjectForKey:@"cardMonth"];
			self.cardYear = [unarchiver decodeObjectForKey:@"cardYear"];
			self.cardType = [unarchiver decodeObjectForKey:@"cardType"];
			self.developMode = [unarchiver decodeBoolForKey:@"developMode"];
			[unarchiver release];
		}
		
		// crash
		//[data release];
	}
}


@end
