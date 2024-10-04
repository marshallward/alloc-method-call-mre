FC = nvfortran
FCFLAGS = -acc

EOS.o: EOS.F90 EOS_base_mod.mod
	$(FC) $(FCFLAGS) -c $<

EOS_base_mod.mod: EOS_base_mod.o
EOS_base_mod.o: EOS_base_mod.F90
	$(FC) $(FCFLAGS) -c $<

.PHONY: clean
clean:
	rm -f *.o *.mod
