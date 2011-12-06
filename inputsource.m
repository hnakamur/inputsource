#include <Carbon/Carbon.h>
#include <stdio.h>
 
#define VERSION "1.0"

static void show_usage(const char *program);

int main (int argc, const char * argv[])
{
  int ret = 0;
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  if (argc == 1) {
    TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
    NSString *id = TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
    printf("%s\n", [id UTF8String]);
  } else if (argc == 2) {
    if (strcmp(argv[1], "-h") == 0) {
      show_usage(argv[0]);
    } else {
      NSString *id = [NSString stringWithUTF8String: argv[1]];
      NSDictionary *props = [NSDictionary dictionaryWithObject: id
                                          forKey: kTISPropertyInputSourceID];
      NSArray *sources = TISCreateInputSourceList(props, false);
      if ([sources count] == 0) {
        ret = 1;
      } else {
        OSStatus status = TISSelectInputSource([sources objectAtIndex: 0]);
        if (status == paramErr) {
          ret = 2;
        }
      }
    }
  }
  [pool drain];
  return ret;
}

static void show_usage(const char *program) {
  fprintf(stderr, "inputsource version %s\n", VERSION);
  fprintf(stderr, "\n");
  fprintf(stderr, "Usage:\n");
  fprintf(stderr, "  %s\n", program);
  fprintf(stderr, "         Prints current input source id.\n");
  fprintf(stderr, "\n");
  fprintf(stderr, "  %s input_source_id\n", program);
  fprintf(stderr, "         Select input source.\n");
  fprintf(stderr, "\n");
  fprintf(stderr, "  %s -h\n", program);
  fprintf(stderr, "         Show this help.\n");
}
