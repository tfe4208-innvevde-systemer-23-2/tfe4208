rm -rf work
vlib work
vlog +cover=bcefsx -sv ../rtl/Peak.sv ../rtl/Fsm.sv ../rtl/PeakFinder.sv Peak_test.sv
vsim -c -coverage Peak_test -do "run 800ns;exit"
