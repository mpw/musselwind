/* MPWMAXParser.h Copyright (c) Marcel P. Weiher 1999-2008, All Rights Reserved,
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

        Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.

        Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in
        the documentation and/or other materials provided with the distribution.

        Neither the name Marcel Weiher nor the names of contributors may
        be used to endorse or promote products derived from this software
        without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
THE POSSIBILITY OF SUCH DAMAGE. */

#import <Foundation/Foundation.h>

#if MPWXMLINTEGRATED
#import "NSXMLParserMAX.h"
#else

#define MAX_ACTION_NONE			0
#define MAX_ACTION_PLIST		1
#define MAX_ACTION_CHILDREN		2

extern NSString *MPWXMLCDataKey;
extern NSString *MPWXMLPCDataKey;


@protocol NSXMLAttributes <NSObject> 

-(id)objectForKey:(id)aKey;								//	retrieve first value whose local name matches aKey
-(id)objectForUniqueKey:(id)aKey;						//	retrieve first value whose local name is identical to aKey
-(id)objectForUniqueKey:(id)aKey namespace:aNamespace;					//	retrieve first value whose local name is identical to aKey
-(id)objectsForKey:(id)aKey;						//	retrieve all values whose local name matches aKey
//-(id)objectsForUniqueKey:(id)aKey;				//	retrieve all values whose assigned tag (see MAX configuration messages) is aTag
-(id)objectForCaseInsensitiveKey:(id)aKey;			//	retrieve first value whose local name matches aKey ignoring case
-(id)objectAtIndex:(NSUInteger)anIndex;			//	get value by position
-(NSUInteger)count;
-(NSString*)combinedText;

@end

@class MPWXMLAttributes,MPWObjectCache;

#endif

typedef id (*XMLIMP)(id, SEL, ...);


@interface MPWMAXParser : NSObject   {
	id						data;
	id						scanner;
    id						documentHandler;

    id						dataCache;
	MPWObjectCache			*attributeCache;
    XMLIMP					getData,initDataBytesLength;
    void                    *_elementStack;
    NSInteger				tagStackLen,tagStackCapacity,maxDepthAllowed;
    XMLIMP					beginElement,endElement,characterDataAllowed;
	XMLIMP					characters,cdata,uniqueTagForCString;
	MPWXMLAttributes*		_attributes;

	NSMutableDictionary*	namespacePrefixToURIMap;
	id						characterHandler;
	MPWXMLAttributes*		emptyDict;

	id						defaultNamespaceHandler,namespaceHandlers;
	id						prefix2HandlerMap;
	id						parseResult;
 	NSInteger				numSpacesOnStack;
	BOOL					ignoreSpace,shouldProcessNamespaces;
	BOOL					shouldReportNamespacePrefixes, autotranslateUTF8,ignoreCase;
	BOOL					enforceTagNesting,lastTagWasOpen;
	BOOL					reportIgnoreableWhitespace,charactersAreSpace;	
	int						dataEncoding,cfDataEncoding;
	NSString*				version;
	const char*				lastGoodPosition;
	NSMutableData			*buffer;
	BOOL					isReceivingData;
	NSURL					*url;
	int						undefinedTagAction;
	NSError					*parserError;
}

+parser;															//	returns a non-configured parser

@property(assign) BOOL reportIgnoreableWhitespace;						//	default is NO  (whether to report whitespace in mixed content)
@property(assign) BOOL enforceTagNesting;								//	default is YES (NO allows HTML or slightly bad XML to be parsed)
@property(assign) BOOL ignoreCase;										//	default is NO  (YES makes it easier to deal with HTML)
@property(assign) BOOL shouldProcessNamespaces;							//	
@property(assign) int  undefinedTagAction;

-(BOOL)parse:(NSData*)xmlData;										//  process the XML data passed, start sending element(1) or tag(2) 
																	//  messages to the configured handlers according to the 
																	//  NSMAXParserDelegate 'protocol' and message patterns.
-(BOOL)parse;
-(BOOL)parseDataFromURL:(NSURL*)url;
-(id)parsedDataFromURL:(id)theUrlOrString;

-(NSInteger)currentElementNestingLevel;												//	nesting level of the element currently being processed
-(NSString*)elementNameAtNestingLevel:(NSInteger)depth;					//	the tag names at different nesting levels
-(id <NSXMLAttributes>)elementAttributesAtNestingLevel:(NSInteger)depth;		//	the tag attributes at different nesting levels
-bytesForCurrentElement;
-(void)setStringEncodingFromIANACharset:(NSString*)charSetName;
-(void)setMaxDepthAllowed:(NSInteger)maxDepth;
-(BOOL)isCurrentElementIncomplete;

-(id)parseResult;														//	root of the parse-tree constructed (valid after parse is complete)
-(void)setDelegate:handler;
-(NSError*)parserError;

//---	Configure element(1) messages to be sent for specific elements in a specific namespace (nil for the default namespace)
//---	Messages will be sent to a specific handler object.  Element names will be assigned numeric tags starting sequentially
//---	from the tagBase paramater.  The map dictionary allows XML tag names that are not compatible with Objective-C syntax
//---	rules for message names to be mapped to ones that are.

-(id )setHandler:(id)handler forElements:(NSArray*)elementNames inNamespace:(NSString*)namespaceString
							   prefix:(NSString*)prefix map:(NSDictionary*)map;

//---	Configure tag(1) messages to be sent for specific tags in a specific namespace (nil for the default namespace)
//---	Messages will be sent to a specific handler object.  The map dictionary allows XML tag names that are not
//---	compatible with Objective-C syntax  rules for message names to be mapped to ones that are.


-(id )setHandler:(id)handler forTags:(NSArray*)tagNamespace inNamespace:(NSString*)namespaceString 
						       prefix:(NSString*)prefix map:(NSDictionary*)map;

//---	Declare attributes we expect to handle for a specific namespace and assign them sequentially numbered integer
//---	tags for easy and efficient retrieval.  (Tags are also required to disambiguate potentially overlapping 
//---	names)


-(id )declareAttributes:(NSArray*)attributes inNamespace:(NSString*)namespaceString;

//---  utility construction methods

-buildPlistWithChildren:(MPWXMLAttributes*)children attributes:(MPWXMLAttributes*)attributes parser:(MPWMAXParser*)parser;


@end

