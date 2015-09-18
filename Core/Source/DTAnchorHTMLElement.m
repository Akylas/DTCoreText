//
//  DTHTMLElementA.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 21.03.13.
//  Copyright (c) 2013 Drobnik.com. All rights reserved.
//

#import "DTCompatibility.h"
#import "DTAnchorHTMLElement.h"
#import "DTColorFunctions.h"

@implementation DTAnchorHTMLElement
{
	DTColor *_highlightedTextColor;
	BOOL _ignoreLinkStyle;
}

- (id)initWithName:(NSString *)name attributes:(NSDictionary *)attributes options:(NSDictionary *)options
{
	self = [super initWithName:name attributes:attributes];
	
	if (self)
	{
		_ignoreLinkStyle = [[options objectForKey:DTIgnoreLinkStyleOption] boolValue];
	}
	
	return self;
}

- (void)applyStyleDictionary:(NSDictionary *)styles
{
	[super applyStyleDictionary:styles];
	if (_ignoreLinkStyle) return;
	
	// get highlight color from a:active pseudo-selector
	NSString *activeColor = [styles objectForKey:@"active:color"];
	
	if (activeColor)
	{
		self.highlightedTextColor = DTColorCreateWithHTMLName(activeColor);
	}
}

- (NSAttributedString *)attributedString
{
	// super returns a mutable attributed string
	NSMutableAttributedString *mutableAttributedString = (NSMutableAttributedString *)[super attributedString];
	if (_ignoreLinkStyle) return mutableAttributedString;
	if (_ignoreLinkStyle || _highlightedTextColor)
	{
		NSRange range = NSMakeRange(0, [mutableAttributedString length]);
		
		if (_highlightedTextColor) {
			// this additional attribute keeps the highlight color
			[mutableAttributedString addAttribute:DTLinkHighlightColorAttribute value:(id)_highlightedTextColor range:range];
		}
		
		// we need to set the text color via the graphics context
		[mutableAttributedString addAttribute:(id)kCTForegroundColorFromContextAttributeName value:[NSNumber numberWithBool:YES] range:range];
	}
	
	return mutableAttributedString;
}

#pragma mark - Properties

@synthesize highlightedTextColor = _highlightedTextColor;

@end
