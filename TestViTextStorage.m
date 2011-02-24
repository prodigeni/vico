#import "TestViTextStorage.h"
#include "logging.h"

@implementation TestViTextStorage

- (void)setUp
{
	textStorage = [[ViTextStorage alloc] init];
}

- (void)test001_AllocateTextStorage
{
	STAssertNotNil(textStorage, nil);
}

- (void)test002_InitialString
{
	STAssertEqualObjects([textStorage string], @"", nil);
}

- (void)test003_SetString
{
	[[textStorage mutableString] setString:@"bacon"];
	STAssertEqualObjects([textStorage string], @"bacon", nil);
}

- (void)test004_GetAttributes
{
	[[textStorage mutableString] setString:@"bacon"];
	NSRange range;
	NSDictionary *attrs = [textStorage attributesAtIndex:2 effectiveRange:&range];
	STAssertNotNil(attrs, nil);
	STAssertNotNil([attrs objectForKey:NSFontAttributeName], nil);
	STAssertTrue(range.location == 0, nil);
	STAssertTrue(range.length == [textStorage length], nil);
}

- (void)test005_lineLocation
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	STAssertEquals([textStorage locationForStartOfLine:3], 5LL, nil);
}

- (void)test006_locationOfInvalidLine
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	STAssertEquals([textStorage locationForStartOfLine:30], -1LL, nil);
}

- (void)test007_locationOfFirstLine
{
	/* Line number 0 doesn't really exist, treat it as line number 1. */
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	STAssertEquals([textStorage locationForStartOfLine:0], 0LL, nil);
	STAssertEquals([textStorage locationForStartOfLine:1], 0LL, nil);
}

- (void)test008_lineLocationAfterInsertingText
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage insertString:@"bacon!" atIndex:3];
	STAssertEquals([textStorage locationForStartOfLine:3], 5LL+6LL, nil);
}

- (void)test009_lineLocationAfterInsertingMultipleLinesOfText
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage insertString:@"chunky\nbacon" atIndex:3];
	STAssertEquals([textStorage locationForStartOfLine:3], 10LL, nil);
}

- (void)test010_lineLocationAfterDeletingText
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(2, 1) withString:@""];
	STAssertEquals([textStorage locationForStartOfLine:3], 4LL, nil);
}

- (void)test011_lineLocationAfterDeletingMultipleLinesOfText
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(0, 6) withString:@""];
	STAssertEquals([textStorage locationForStartOfLine:3], 8LL, nil);
}

- (void)test012_lineLocationAfterReplacingTextSameAmount
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	STAssertEquals([textStorage lineCount], 5ULL, nil);
	[textStorage replaceCharactersInRange:NSMakeRange(5, 3) withString:@"xxx"];
	STAssertEquals([textStorage locationForStartOfLine:4], 9LL, nil);
	STAssertEquals([textStorage lineCount], 5ULL, nil);
}

- (void)test013_lineLocationAfterReplacingTextLessAmount
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(5, 3) withString:@"xx"];
	STAssertEquals([textStorage locationForStartOfLine:4], 8LL, nil);
}

- (void)test014_lineLocationAfterReplacingTextMore
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(5, 3) withString:@"xxxx"];
	STAssertEquals([textStorage locationForStartOfLine:4], 10LL, nil);
}

- (void)test015_lineLocationAfterReplacingTextLessLines
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(0, 5) withString:@"bacon"];
	STAssertEquals([textStorage locationForStartOfLine:3], 14LL, nil);
}

- (void)test016_lineLocationAfterReplacingTextMoreLines
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(0, 5) withString:@"1\n2\n3\n"];
	STAssertEquals([textStorage locationForStartOfLine:3], 4LL, nil);
}

- (void)test017_lineLocationAfterBreakingLine
{
	[[textStorage mutableString] setString:@"chunky\ncrispy\nbacon"];
	[textStorage replaceCharactersInRange:NSMakeRange(3, 0) withString:@"\n"];
	STAssertEqualObjects([textStorage string], @"chu\nnky\ncrispy\nbacon", nil);
	STAssertEquals([textStorage locationForStartOfLine:3], 8LL, nil);
	STAssertEquals([textStorage lineCount], 4ULL, nil);
}

- (void)test020_lineCount
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	STAssertEquals([textStorage lineCount], 5ULL, nil);
}

- (void)test021_lineCountOfLineNotEndingWithNewline
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno"];
	STAssertEquals([textStorage lineCount], 5ULL, nil);
}

- (void)test022_lineCountAfterDeletingText
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(0, 3) withString:@""];
	STAssertEquals([textStorage lineCount], 4ULL, nil);
}

- (void)test023_lineCountAfterDeletingMultipleLinesOfText
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(0, 5) withString:@""];
	STAssertEquals([textStorage lineCount], 3ULL, nil);
}

- (void)test024_lineCountAfterDeletingMultipleLinesOfText2
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	[textStorage replaceCharactersInRange:NSMakeRange(0, 7) withString:@""];
	STAssertEquals([textStorage lineCount], 3ULL, nil);
}

- (void)test030_lineNumber
{
	[[textStorage mutableString] setString:@"a\nbc\ndef\nghij\nklmno\n"];
	STAssertEquals([textStorage lineNumberAtLocation:10], 4ULL, nil);
}

- (void)test031_lineNumberAtEOF
{
	[[textStorage mutableString] setString:@"a\n"];
	STAssertEquals([textStorage lineNumberAtLocation:2], 2ULL, nil);
}

- (void)test032_lineNumberInEmptyDocument
{
	[[textStorage mutableString] setString:@""];
	STAssertEquals([textStorage lineNumberAtLocation:0], 0ULL, nil);

	[textStorage insertString:@"a" atIndex:0];
	STAssertEquals([textStorage lineNumberAtLocation:0], 1ULL, nil);
	STAssertEquals([textStorage lineNumberAtLocation:1], 1ULL, nil);
	STAssertEquals([textStorage lineIndexAtLocation:1], 0ULL, nil);

	[textStorage insertString:@"\n" atIndex:1];
	STAssertEquals([textStorage lineNumberAtLocation:0], 1ULL, nil);
	STAssertEquals([textStorage lineNumberAtLocation:1], 1ULL, nil);
	STAssertEquals([textStorage lineNumberAtLocation:2], 2ULL, nil);
}

- (void)test040_locationOfLineWithManyLines
{
	int i;
	for (i = 0; i < 1234; i++)
		[textStorage insertString:[NSString stringWithFormat:@"%i\n", i] atIndex:[textStorage length]];

	STAssertEquals([textStorage locationForStartOfLine:10], 18LL, nil);

	STAssertEquals([textStorage lineCount], 1234ULL, nil);
	STAssertEquals([textStorage locationForStartOfLine:1017], 3970LL, nil);
	STAssertEquals([textStorage lineNumberAtLocation:3970], 1017ULL, nil);

	STAssertEquals([textStorage locationForStartOfLine:1000], 3886LL, nil);
}

- (void)test041_locationOfLineWithManyLinesAfterDeletingLines
{
	int i;
	for (i = 0; i < 1234; i++)
		[textStorage insertString:[NSString stringWithFormat:@"%i\n", i] atIndex:[textStorage length]];

	// remove first two lines
	[textStorage replaceCharactersInRange:NSMakeRange(0, 4) withString:@""];

	STAssertEquals([textStorage lineCount], 1232ULL, nil);
	STAssertEquals([textStorage locationForStartOfLine:1017], 3976LL, nil);
	STAssertEquals([textStorage lineNumberAtLocation:3976], 1017ULL, nil);

	// re-insert the first two lines
	[textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:@"0\n1\n"];

	STAssertEquals([textStorage lineCount], 1234ULL, nil);
	STAssertEquals([textStorage locationForStartOfLine:1017], 3970LL, nil);
	STAssertEquals([textStorage lineNumberAtLocation:3970], 1017ULL, nil);

	STAssertEquals([textStorage locationForStartOfLine:1000], 3886LL, nil);
}

- (void)test042_locationOfLineWithManyLinesAfterDeletingManyLines
{
	int i;
	for (i = 0; i < 1234; i++)
		[textStorage insertString:[NSString stringWithFormat:@"%i\n", i] atIndex:[textStorage length]];

	NSUInteger line1001 = [textStorage locationForStartOfLine:1001];
	[textStorage replaceCharactersInRange:NSMakeRange(line1001, [textStorage length] - line1001) withString:@""];
	STAssertEquals([textStorage lineCount], 1000ULL, nil);
	STAssertEquals([textStorage locationForStartOfLine:1000], (NSInteger)line1001 - (NSInteger)[@"999\n" length], nil);

	[textStorage replaceCharactersInRange:NSMakeRange(0, 4) withString:@""];
	STAssertEquals([textStorage lineCount], 998ULL, nil);
}

- (void)test043_mergeOfSkipPartitions
{
	int i;
	for (i = 0; i < 2100; i++)
		[textStorage insertString:@"x\n" atIndex:[textStorage length]];

	[textStorage replaceCharactersInRange:NSMakeRange(0, [textStorage length]) withString:@""];
	STAssertEquals([textStorage lineCount], 0ULL, nil);
}

@end