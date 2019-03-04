
CFLAGS=-pthread -fsanitize=address -Wall --pedantic -g
GTKCFLAGS:=$(subst -I,-isystem ,$(shell pkg-config --cflags gtk+-2.0))
GTKLDFLAGS:=$(shell pkg-config --libs gtk+-2.0) $(shell pkg-config --libs gthread-2.0)

LINUX_OBJS=linux/linuxcompat.o linux/bline.o badge_apps/xorshift.o

APPDIR=badge_apps
IRXMIT=irxmit
LASERTAG=lasertag
MAZE=maze

all:	sample_app/sample_app ${APPDIR}/${IRXMIT} ${APPDIR}/${LASERTAG} ${APPDIR}/${MAZE}

sample_app/sample_app:	sample_app/sample_app.c sample_app/smiley.h linux/linuxcompat.o linux/bline.o ${LINUX_OBJS}
	$(CC) ${CFLAGS} ${GTKCFLAGS} ${LINUX_OBJS} -o sample_app/sample_app sample_app/sample_app.c ${GTKLDFLAGS}

${APPDIR}/${IRXMIT}:	${APPDIR}/${IRXMIT}.c linux/linuxcompat.o linux/bline.o
	$(CC) ${CFLAGS} ${GTKCFLAGS} ${LINUX_OBJS} -o ${APPDIR}/${IRXMIT} ${APPDIR}/${IRXMIT}.c ${GTKLDFLAGS}

${APPDIR}/${LASERTAG}:	${APPDIR}/${LASERTAG}.c linux/linuxcompat.o linux/bline.o
	$(CC) ${CFLAGS} ${GTKCFLAGS} ${LINUX_OBJS} -o ${APPDIR}/${LASERTAG} ${APPDIR}/${LASERTAG}.c ${GTKLDFLAGS}

${APPDIR}/xorshift.o:	${APPDIR}/xorshift.c ${APPDIR}/xorshift.h
	$(CC) ${CFLAGS} ${GTKCFLAGS} -c ${APPDIR}/xorshift.c -o ${APPDIR}/xorshift.o

${APPDIR}/${MAZE}:	${APPDIR}/${MAZE}.c linux/linuxcompat.o linux/bline.o ${APPDIR}/xorshift.o \
			${APPDIR}/bones_points.h \
			${APPDIR}/build_bug_on.h \
			${APPDIR}/chalice_points.h \
			${APPDIR}/chest_points.h \
			${APPDIR}/cobra_points.h \
			${APPDIR}/down_ladder_points.h \
			${APPDIR}/dragon_points.h \
			${APPDIR}/grenade_points.h \
			${APPDIR}/lasertag.h \
			${APPDIR}/lasertag-protocol.h \
			${APPDIR}/orc_points.h \
			${APPDIR}/phantasm_points.h \
			${APPDIR}/player_points.h \
			${APPDIR}/potion_points.h \
			${APPDIR}/scroll_points.h \
			${APPDIR}/shield_points.h \
			${APPDIR}/sword_points.h \
			${APPDIR}/up_ladder_points.h
	$(CC) ${CFLAGS} ${GTKCFLAGS} ${LINUX_OBJS} -o ${APPDIR}/${MAZE} ${APPDIR}/${MAZE}.c ${GTKLDFLAGS}

linux/linuxcompat.o:	linux/linuxcompat.c linux/linuxcompat.h
	$(CC) ${CFLAGS} ${GTKCFLAGS} -c -I linux linux/linuxcompat.c -o linux/linuxcompat.o

linux/bline.o:	linux/bline.c linux/bline.h
	$(CC) ${CFLAGS} -c linux/bline.c -o linux/bline.o


clean:
	rm -f *.o */*.o sample_app/sample_app ${APPDIR}/*.o ${APPDIR}/${MAZE} ${APPDIR}/${IRXMIT} ${APPDIR}/${LASERTAG}

