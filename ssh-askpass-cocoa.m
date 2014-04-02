#import <Cocoa/Cocoa.h>

int main (int argc, const char * argv[]) {

    if (argc == 1) {
        fprintf(stdout, "ssh-askpass 0.1 (Cocoa version)\n");
        fprintf(stdout, "Copyright (c) 2014 Pavel Volkovitskiy <olfway@gmail.com>\n");
        fprintf(stdout, "https://github.com/olfway/ssh-askpass-cocoa\n");
        fprintf(stdout, "\n");
        fprintf(stdout, "Usage: %s \"askpass message\"\n", argv[0]);
        return 1;
    }

    [NSApplication sharedApplication];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp activateIgnoringOtherApps:YES];

    NSString *message = [NSString stringWithUTF8String:argv[1]];

    NSAlert *alert = [[NSAlert alloc] init];
    [alert.window setTitle:@"OpenSSH"];
    [alert setMessageText:@"SSH Agent"];
    [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setInformativeText:message];

    NSTextField *textField = [[((NSPanel*)(alert.window)).contentView subviews] objectAtIndex:5];
    NSSize size = [message sizeWithAttributes:@{NSFontAttributeName: textField.font}];

    NSArray *lines = [message componentsSeparatedByString:@"\n"];
    if ([lines count] == 2) {
        [alert setMessageText:[lines objectAtIndex:0]];
        [alert setInformativeText:[lines objectAtIndex:1]];
        size = [[lines objectAtIndex:1] sizeWithAttributes:@{NSFontAttributeName: textField.font}];
        NSRect frame = ((NSPanel*)alert.window).frame;
        frame.size.width = textField.frame.origin.x + size.width + 32;
        [alert.window setFrame:frame display:YES];
    }

    NSSecureTextField *passwordField;
    bool askpass = [message hasPrefix:@"Enter "] || [message hasSuffix:@"password: "];
    if (askpass) {
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        passwordField = [[NSSecureTextField alloc] initWithFrame:NSMakeRect(0, 0, MAX(size.width + 8, 295), size.height + 6)];
        [alert setAccessoryView:passwordField];
    } else {
        [alert addButtonWithTitle:@"Yes"];
        [alert addButtonWithTitle:@"No"];
    }

    [[[alert buttons] objectAtIndex:0] setKeyEquivalent:@"\r"];
    [[[alert buttons] objectAtIndex:1] setKeyEquivalent:@"\033"];

    if ([alert runModal] == NSAlertFirstButtonReturn) {
        // OK/Yes clicked
        if (askpass) {
            fprintf(stdout, "%s\n", [[passwordField stringValue] UTF8String]);
        }
        return 0;
    }
    return 1;
}

// cc -framework Cocoa -x objective-c -o ssh-askpass-cocoa ssh-askpass-cocoa.m

