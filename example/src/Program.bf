using System;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Interop;
using static libexpat.libexpat;

namespace example;

static class Helper
{
	public static void foo() { }
}

static class Program
{
	typealias FILE = void*;

	[CLink] public static extern FILE* fopen(char8* path, char8* mode);
	[CLink] public static extern bool ferror(FILE* file);
	[CLink] public static extern size_t fread(void* buffer, size_t size, size_t count, FILE* stream);
	[CLink] public static extern void fprintf(FILE* file, char8* str, ...);
	[CLink] public static extern c_int feof(FILE* file);

	const int BUFSIZ = 512;

	static void startElement(void* userData, XML_Char* name, XML_Char** atts)
	{
		Debug.WriteLine($"{StringView(name)}");
	}

	static void endElement(void* userData, XML_Char* name) { }

	static int Main(params String[] args)
	{
		XML_Parser parser = XML_ParserCreate(null);
		c_int done;
		c_int depth = 0;

		if (parser == null)
		{
			Debug.WriteLine("Couldn't allocate memory for parser\n");
			return 1;
		}

		XML_SetUserData(parser, &depth);

		XML_SetElementHandler(parser, => startElement, => endElement);

		repeat
		{
			let buf = XML_GetBuffer(parser, BUFSIZ);

			if (buf == null)
			{
				Debug.WriteLine("Couldn't allocate memory for buffer\n");
				XML_ParserFree(parser);
				return 1;
			}

			let fp = fopen("test.xml", "rb");

			size_t len = fread(buf, 1, BUFSIZ, fp);

			if (ferror(fp))
			{
				Debug.WriteLine("Read error\n");
				XML_ParserFree(parser);
				return 1;
			}

			done = feof(fp);

			if (XML_ParseBuffer(parser, (int)len, done) == .XML_STATUS_ERROR)
			{
				Debug.WriteLine($"Parse error at line {XML_GetCurrentLineNumber(parser)}:\n{XML_ErrorString(XML_GetErrorCode(parser))}\n");
				XML_ParserFree(parser);
				return 1;
			}
		} while (done == 0);

		XML_ParserFree(parser);

		return 0;
	}
}