 
CC	= mpicxx

FSI_OBJSC  = fe_initialization.o fe_boundary_cond.o fb_beam.o \
		     fe_solver.o fe_io.o fe_vector_operators.o \
	         fe_elements.o   fe_geometrics.o \
		     fv_bcs.o        fv_bmv.o     fv_compgeom.o    fv_ibm.o fv_ibm_io.o  fv_init.o \
             fv_main.o       fv_metrics.o fv_poisson.o     fv_rhs.o\
		     fv_variables.o  fv_fsi.o     fv_implicitsolver.o\
		     fv_fsi_move.o   fv_solvers.o fe_transfer.o \
		     fv_les.o        fv_k-omega.o fv_wall_function.o fv_rhs2.o fv_poisson_hypre.o 


FSI_SOURCEC  = fe_initialization.c fe_boundary_cond.c fb_beam.c \
		     fe_solver.c fe_io.c fe_vector_operators.c \
	         fe_elements.c   fe_geometrics.c \
		     fv_bcs.c        fv_bmv.c     fv_compgeom.c    fv_ibm.c fv_ibm_io.c  fv_init.c \
             fv_main.c       fv_metrics.c fv_poisson.c     fv_rhs.c\
		     fv_variables.c  fv_fsi.c     fv_implicitsolver.c\
		     fv_fsi_move.c   fv_solvers.c fe_transfer.c \
		     fv_les.c        fv_k-omega.c fv_wall_function.c fv_rhs2.c fv_poisson_hypre.c

PETSC=$(PETSC_DIR)
PETSCINC=-I$(PETSC)/include
PETSCLIB=$(PETSC)/lib
#PETSCARCHINC=-I$(PETSC)/linux-thunder/include
#EIGEN_CPPFLAGS = -I/gpfs1/home/trung.le/Petsc/eigen



#PETSCINC=-I/gpfs/home/trungle/Petsc/petsc-3.1-p8/include
#MPIINC=-I/cm/shared/apps/mvapich2/gcc/64/2.1/include
#PETSCARCHINC=-I/gpfs/home/trungle/Petsc/petsc-3.1-p8/linux-debug/include
LIBDIR=-L$(PETSCLIB) -L./ 

#EIGEN_CPPFLAGS = -I/gpfs/home/trungle/Tools/eigen_lib
ALLFLAG = -Wall -Wwrite-strings -Wno-strict-aliasing -Wno-unknown-pragmas -g3  -L/mmfs1/home/trung.le/Petsc/petsc-3.2-p7/linux-prime/lib  -lpetsc -lX11 -lpthread -Wl,-rpath,/mmfs1/home/trung.le/Petsc/petsc-3.2-p7/linux-prime/lib -lHYPRE -Wl,-rpath,/cm/local/apps/gcc/10.2.0/lib/gcc/x86_64-linux-gnu/10.2.0 -Wl,-rpath,/cm/local/apps/gcc/10.2.0/lib64 -Wl,-rpath,/cm/local/apps/gcc/10.2.0/lib -Wl,-rpath,/mmfs1/apps/spack/0.16.1/linux-rhel8-zen2/gcc-10.2.0/hwloc-1.11.11-znktbn53x77rlqwk7jyl4aezf2hlaueh/lib -Wl,-rpath,/mmfs1/apps/spack/0.16.1/linux-rhel8-zen2/gcc-10.2.0/zlib-1.2.11-e4yw3y55ty527weaskhkdoabx5d7ptfc/lib -Wl,-rpath,/mmfs1/apps/spack/0.16.1/linux-rhel8-zen2/gcc-10.2.0/openmpi-3.1.6-sxqyko7cbnnwtdndem2gzrkgljwzrx6p/lib -lstdc++ -lflapack -lfblas -lm -L/mmfs1/apps/spack/0.16.1/linux-rhel8-zen2/gcc-10.2.0/hwloc-1.11.11-znktbn53x77rlqwk7jyl4aezf2hlaueh/lib -L/mmfs1/apps/spack/0.16.1/linux-rhel8-zen2/gcc-10.2.0/zlib-1.2.11-e4yw3y55ty527weaskhkdoabx5d7ptfc/lib -L/mmfs1/apps/spack/0.16.1/linux-rhel8-zen2/gcc-10.2.0/openmpi-3.1.6-sxqyko7cbnnwtdndem2gzrkgljwzrx6p/lib -L/cm/local/apps/gcc/10.2.0/lib/gcc/x86_64-linux-gnu/10.2.0 -L/cm/local/apps/gcc/10.2.0/lib64 -L/cm/local/apps/gcc/10.2.0/lib -ldl -lmpi -lgcc_s -lpthread -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lgfortran -lm -lgfortran -lm -lquadmath -lm -lstdc++ -ldl -lmpi -lgcc_s -lpthread -ldl

# --- For Agean -----
#PETSCINC_AEGEAN=-I$(PETSC)/include
#PETSCLIB_AEGEAN=-L$(PETSC)/lib


include ${PETSC_DIR}/conf/variables
include ${PETSC_DIR}/conf/rules
sinclude makefile.local

all: object run 


# Note that I turn off completely the DMMG Solver from the Code
# So that the code use only the current solver
beam: bobject run

object:  ex17 ex18 ex19 ex20 ex21 ex22 ex23 ex24 ex25 ex26 ex27 ex28 ex29 ex30 ex31 ex32 ex33 ex34 ex35 ex36 ex37 ex38 ex39 ex40 ex41 ex42 ex43 ex44 ex45

# This is for the AEGEAN MACHINE
bobject:  bex17 bex18 bex19 bex20 bex21 bex22 bex23 bex24 bex25 bex26 bex27 bex28 bex29 bex30 bex31 bex32 bex33 bex34 bex35 bex36 bex37 bex38 bex39 bex40 bex41 bex42 bex43 bex44 bex45

run:  
	mpicxx -o fsi ${FSI_OBJSC} ${PETSC_LIB} ${LIBFLAG} -I ${EIGEN_CPPFLAGS} 
	rm *.o

vtk:	vtk_vis.o
	mpicxx -o vtk vtk_vis.o ${ALLFLAG}

# visualization on AEGEAN

vis: vtk_a show

vtk_a:	
	mpicxx -c -o vtk_vis.o -DNDEBUG ${ALLFLAG} -I/usr/include -O3 -MMD -MP vtk_vis.c

show:  
	-$(CC) -o vtk vtk_vis.o ${PETSC_LIB} ${LIBFLAG} -I ${EIGEN_CPPFLAGS} 


###--------------This is for AEGEAN machine =====================
bex17:	
	mpicxx -c -o fe_initialization.o -DNDEBUG ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fe_initialization.c

bex18:	 
	-${CXX} -o fe_boundary_cond.o -c ${PETSCINC_AEGEAN}  -I/usr/include -O3 -MMD -MP fe_boundary_cond.c
 
bex19:	 
	-${CXX}  -o fb_beam.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP  fb_beam.c  

bex20:	 
	-${CXX}  -o fe_solver.o -c ${PETSCINC_AEGEAN}  -I/usr/include -O3 -MMD -MP fe_solver.c 
 
bex21:	 
	-${CXX}  -o fe_io.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP   fe_io.c  

bex22:	 
	-${CXX}  -o fe_vector_operators.o -c ${PETSCINC_AEGEAN}  -I/usr/include -O3 -MMD -MP  fe_vector_operators.c  

bex23:	 
	-${CXX}  -o fe_elements.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP  fe_elements.c 
 
bex24:	 
	-${CXX}  -o fe_geometrics.o -c ${PETSCINC_AEGEAN}  -I/usr/include -O3 -MMD -MP fe_geometrics.c
 
bex25:	 
	-${CXX}  -o fv_bcs.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_bcs.c 

bex26:	 
	-${CXX}  -o fv_bmv.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_bmv.c  ${EIGEN_CPPFLAGS}

bex27:	 
	-${CXX}  -o fv_compgeom.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_compgeom.c  ${EIGEN_CPPFLAGS}

bex28:	 
	-${CXX}  -o fv_ibm.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_ibm.c  ${EIGEN_CPPFLAGS}

bex29:	 
	-${CXX}  -o fv_ibm_io.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_ibm_io.c  ${EIGEN_CPPFLAGS}

bex30:	 
	-${CXX}  -o fv_init.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_init.c  ${EIGEN_CPPFLAGS}

bex31:	 
	-${CXX}  -o fv_main.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP  fv_main.c  ${EIGEN_CPPFLAGS}

bex32:	 
	-${CXX}  -o fv_metrics.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_metrics.c  ${EIGEN_CPPFLAGS}

bex33:	 
	-${CXX}  -o fv_poisson.o -c   ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_poisson.c  ${EIGEN_CPPFLAGS}

bex34:	 
	-${CXX}  -o fv_rhs.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_rhs.c  ${EIGEN_CPPFLAGS}

bex35:	 
	-${CXX}  -o fv_variables.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_variables.c  ${EIGEN_CPPFLAGS}

bex36:	 
	-${CXX}  -o fv_fsi.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_fsi.c  ${EIGEN_CPPFLAGS}

bex37:	 
	-${CXX}  -o fv_implicitsolver.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP  -I/safl/software/aegean/hypre/2.8.0b/gcc-4.7.0/include  fv_implicitsolver.c  ${EIGEN_CPPFLAGS}

bex38:	 
	-${CXX}  -o fv_fsi_move.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP  fv_fsi_move.c  ${EIGEN_CPPFLAGS}

bex39:	 
	-${CXX}  -o fv_solvers.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_solvers.c  ${EIGEN_CPPFLAGS}

bex40:	 
	-${CXX}  -o fe_transfer.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fe_transfer.c  ${EIGEN_CPPFLAGS}

bex41:	 
	-${CXX}  -o fv_les.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_les.c  ${EIGEN_CPPFLAGS}

bex42:	 
	-${CXX}  -o fv_k-omega.o -c ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_k-omega.c  ${EIGEN_CPPFLAGS}

bex43:	 
	-${CXX}  -o fv_wall_function.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_wall_function.c  ${EIGEN_CPPFLAGS}

bex44:	 
	-${CXX}  -o fv_rhs2.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP fv_rhs2.c  ${EIGEN_CPPFLAGS}

bex45:	 
	-${CXX}  -o fv_poisson_hypre.o -c  ${PETSCINC_AEGEAN} -I/usr/include -O3 -MMD -MP -I/safl/software/aegean/hypre/2.8.0b/gcc-4.7.0/include  fv_poisson_hypre.c  ${EIGEN_CPPFLAGS}


#============================ This is for LIRED machine ===================================================
#---------------------------------------------------------------------------------------------------------/
#========================================================================================================//	
ex17:	 
	-${CXX}  -o fe_initialization.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_initialization.c  ${EIGEN_CPPFLAGS}

ex18:	 
	-${CXX}  -o fe_boundary_cond.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_boundary_cond.c  ${EIGEN_CPPFLAGS}

ex19:	 
	-${CXX}  -o fb_beam.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fb_beam.c  ${EIGEN_CPPFLAGS}

ex20:	 
	-${CXX}  -o fe_solver.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_solver.c  ${EIGEN_CPPFLAGS}

ex21:	 
	-${CXX}  -o fe_io.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_io.c  ${EIGEN_CPPFLAGS}

ex22:	 
	-${CXX}  -o fe_vector_operators.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_vector_operators.c  ${EIGEN_CPPFLAGS}

ex23:	 
	-${CXX}  -o fe_elements.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_elements.c  ${EIGEN_CPPFLAGS}

ex24:	 
	-${CXX}  -o fe_geometrics.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_geometrics.c  ${EIGEN_CPPFLAGS}

ex25:	 
	-${CXX}  -o fv_bcs.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_bcs.c  ${EIGEN_CPPFLAGS}

ex26:	 
	-${CXX}  -o fv_bmv.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_bmv.c  ${EIGEN_CPPFLAGS}

ex27:	 
	-${CXX}  -o fv_compgeom.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_compgeom.c  ${EIGEN_CPPFLAGS}

ex28:	 
	-${CXX}  -o fv_ibm.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_ibm.c  ${EIGEN_CPPFLAGS}

ex29:	 
	-${CXX}  -o fv_ibm_io.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_ibm_io.c  ${EIGEN_CPPFLAGS}

ex30:	 
	-${CXX}  -o fv_init.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_init.c  ${EIGEN_CPPFLAGS}

ex31:	 
	-${CXX}  -o fv_main.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_main.c  ${EIGEN_CPPFLAGS}

ex32:	 
	-${CXX}  -o fv_metrics.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_metrics.c  ${EIGEN_CPPFLAGS}

ex33:	 
	-${CXX}  -o fv_poisson.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_poisson.c  ${EIGEN_CPPFLAGS}

ex34:	 
	-${CXX}  -o fv_rhs.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_rhs.c  ${EIGEN_CPPFLAGS}

ex35:	 
	-${CXX}  -o fv_variables.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_variables.c  ${EIGEN_CPPFLAGS}

ex36:	 
	-${CXX}  -o fv_fsi.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_fsi.c  ${EIGEN_CPPFLAGS}

ex37:	 
	-${CXX}  -o fv_implicitsolver.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_implicitsolver.c  ${EIGEN_CPPFLAGS}

ex38:	 
	-${CXX}  -o fv_fsi_move.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_fsi_move.c  ${EIGEN_CPPFLAGS}

ex39:	 
	-${CXX}  -o fv_solvers.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_solvers.c  ${EIGEN_CPPFLAGS}

ex40:	 
	-${CXX}  -o fe_transfer.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fe_transfer.c  ${EIGEN_CPPFLAGS}

ex41:	 
	-${CXX}  -o fv_les.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_les.c  ${EIGEN_CPPFLAGS}

ex42:	 
	-${CXX}  -o fv_k-omega.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_k-omega.c  ${EIGEN_CPPFLAGS}

ex43:	 
	-${CXX}  -o fv_wall_function.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_wall_function.c  ${EIGEN_CPPFLAGS}

ex44:	 
	-${CXX}  -o fv_rhs2.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_rhs2.c  ${EIGEN_CPPFLAGS}

ex45:	 
	-${CXX}  -o fv_poisson_hypre.o -c ${PETSCARCHINC}  ${PETSCINC} ${MPIINC}  fv_poisson_hypre.c  ${EIGEN_CPPFLAGS}

