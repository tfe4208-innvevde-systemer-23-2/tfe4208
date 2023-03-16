rm -rf work
vlib work
vlog +cover=bcefsx -sv ../rtl/xxx.sv Correlation_test.sv
vsim -c -coverage Correlation_test -do "run 2000ns;exit"
