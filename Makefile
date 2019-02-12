
CFLAGS=-pthread -fsanitize=address -Wall --pedantic -g
GTKCFLAGS:=$(subst -I,-isystem ,$(shell pkg-config --cflags gtk+-2.0))
GTKLDFLAGS:=$(shell pkg-config --libs gtk+-2.0) $(shell pkg-config --libs gthread-2.0)

LINUX_OBJS=linux/linuxcompat.o linux/bline.o

APPDIR=sample_app
APPNAME=sample_app

sample_app/sample_app:	${APPDIR}/${APPNAME}.c ${APPDIR}/smiley.h linux/linuxcompat.o linux/bline.o
	$(CC) ${CFLAGS} ${GTKCFLAGS} ${LINUX_OBJS} -o ${APPDIR}/${APPNAME} ${APPDIR}/${APPNAME}.c ${GTKLDFLAGS}

linux/linuxcompat.o:	linux/linuxcompat.c linux/linuxcompat.h
	$(CC) ${CFLAGS} ${GTKCFLAGS} -c -I linux linux/linuxcompat.c -o linux/linuxcompat.o

linux/bline.o:	linux/bline.c linux/bline.h
	$(CC) ${CFLAGS} -c linux/bline.c -o linux/bline.o

clean:
	rm -f *.o */*.o sample_app/sample_app

