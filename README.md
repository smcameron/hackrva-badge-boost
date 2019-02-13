
This is a basic intro about how to add apps to the HackRVA badge.

*Warning:  The sample app doesn't actually work on the badge yet for some
reason.  I still need to debug that.*

I am assuming you're working on linux.  I have created a linux environment
that mimics much of the badge environment which allows you to develop badge
applications on linux without having to flash the code to the badge to check
every little thing. When you are reasonably sure that your code is working,
then you can flash it to the badge and check if it works as expected in the
real badge environment.

Step 0: Install the compiler on your linux laptop. (I will assume here
that you've already done that.  It's not hard, but I don't remember the
details. Ask in the badge slack channel.) 

Step 1: Clone the linux badge surrogate environment:

	`git clone git@github.com:smcameron/hackrva-badge-boost.git`

Step 2: Write your code:

	`cd hackrva-badge-boost`

	Check `sample_app/sample_app.c` and `Makefile` to see an example.

There will be a few linux specific bits which you should surround by

```c
	#ifdef __linux__
	#endif
```

In particular, at the beginning you need the following two sections
enclosed in "#ifdef __linux__" sections:

At the beginning:

```c
	#ifdef __linux__
	#include "../linux/linuxcompat.h"
	#endif
```

And at the end:

```c
	#ifdef __linux__
	int main(int argc, char *argv[])
	{
		start_gtk(&argc, &argv, myapp_callback, 240);
		return 0;
	}
	#endif
```

Instead of `myapp_callback`, use whatever function name you used
for your app's callback entry point name.

Step 3: Write your app.  Check `linux/linuxcompat.h` to see what functions
you may call.  You may need to include some header files to access some
functions, and you may need to include different header files on the badge
than on linux.

Use a pattern like this:

```c
	#ifdef __linux__
	#include <some_linux_header_file.h>
	#else
	#include <some_badge_header_file.h>
	#endif
```

There may be times when on linux, you need to call some function,
but on the badge you don't need such a function (or vice versa).

For such situations you can do something like this:

```c
	#ifdef __linux__
	#define LINUX_FUNCTION1 do { linux_function1(); } while (0)
	#else
	#define LINUX_FUNCTION1
	#endif
```

Then later in your code, you can say:

```c
	LINUX_FUNCTION1;
```

and on the badge, this will do nothing and generate no code, while on
linux, it will call linux_function1.


Step 4:  Get your app running on the badge.

1. Clone the badge repo and "git pull" to make sure it's up to date.

2. Add your \*.c files under the badge_apps/ directory.

3. Modify the Makefile to know about your files by adding them
   to the SRC_APPS_C variable.

4. Add a your header file into include/myapp.h (Substitute your appname for "myapp".)
In this header, put in a single function that is your app callback.  For instance:

```c
	#ifndef MYAPP_H__
	#define MYAPP_H__

	void myapp_callback(void);

	#endif
```

5. Modify src/menu.c:

```diff
diff --git a/src/menu.c b/src/menu.c
index 175d1d4..f0aad9a 100644
--- a/src/menu.c
+++ b/src/menu.c
@@ -15,6 +15,7 @@
 #include "conductor.h"
 #include "blinkenlights.h"
 #include "adc.h"
+#include "myapp.h"


 #define MAIN_MENU_BKG_COLOR GREY2
@@ -463,6 +464,7 @@ const struct menu_t games_m[] = {
    {"Blinkenlights", VERT_ITEM|DEFAULT_ITEM, FUNCTION, {(struct menu_t *)blinkenlights_cb}}, // Set other badges LED
    {"Conductor",     VERT_ITEM, FUNCTION, {(struct menu_t * )conductor_cb}}, // Tell other badges to play notes
    {"Sensors",       VERT_ITEM, FUNCTION, {(struct menu_t l* )adc_cb} },
+   {"MyApp",         VERT_ITEM, FUNCTION, {(struct menu_t * ) myapp} },
    {"Back",          VERT_ITEM|LAST_ITEM, BACK, {NULL} },
};
```

6. Copy your source files from the hackrva-badge-boost project into the `badge2019interp/badge_apps` project.
You don't need to copy any of the linux/\* files.

7. Build it for the badge...

Type `make` in the top level directory of the `badge2019interp` project...

8. Flash the badge

Press the button on the badge as you simultaneously plug it into the USB port
of your computer.  A green LED should be flashing.

Next, run `tools/bootloadit`. This will flash the firmware for the badge.

Then, unplug, and re-plug the badge into the USB port to reboot it.
At this point your program should be accessible via the main menu.

