MOM_EOS.o: MOM_EOS.F90 MOM_EOS_base_type.mod
	nvfortran -acc -c $<

MOM_EOS_base_type.mod: MOM_EOS_base_type.o
MOM_EOS_base_type.o: MOM_EOS_base_type.F90
	nvfortran -acc -c $<

.PHONY: clean
clean:
	rm -f *.o *.mod
