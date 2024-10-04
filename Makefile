FC = nvfortran
FCFLAGS = -acc

MOM_EOS.o: MOM_EOS.F90 MOM_EOS_base_type.mod
	$(FC) $(FCFLAGS) -c $<

MOM_EOS_base_type.mod: MOM_EOS_base_type.o
MOM_EOS_base_type.o: MOM_EOS_base_type.F90
	$(FC) $(FCFLAGS) -c $<

.PHONY: clean
clean:
	rm -f *.o *.mod
