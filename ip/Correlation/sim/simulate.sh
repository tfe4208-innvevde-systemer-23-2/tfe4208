rm -rf work
vlib work
vlog +cover=bcefsx -sv ../rtl/Correlation.sv ../rtl/CrosscorrelationIterator.sv Correlation_test.sv
vsim -c -coverage Correlation_test -do "run 1ms;exit"
