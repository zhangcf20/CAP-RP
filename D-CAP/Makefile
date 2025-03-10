FC = gfortran-9 -ffixed-line-length-none
FFLAGS = -O 
CC = gcc-6
CFLAGS = ${FFLAGS} 

SACHOME = /usr/local/sac

CAP  = cap cap_dir mtdcmp radpttn

SUBS = fft.o Complex.o radiats.o grid3d.o futterman.o sacio.o trap.o \
	cap_sub.o nrutil.o jacobi.o eigsrt.o

all: $(CAP)

cap cap_dir: %:%.o $(SUBS) 
	$(CC) -o $@ $^ -L$(SACHOME)/lib -lsac -lsacio -lm

cap_dir.o: cap.c
	$(CC) -DDIRECTIVITY -c -o $@ $<

mtdcmp: mtdcmp.o
	$(FC) -o $@ $@.o

radpttn: radpttn.o radiats.o
	$(CC) -o $@ $@.o radiats.o -lm

clean:
	rm -f $(CAP) *.o
