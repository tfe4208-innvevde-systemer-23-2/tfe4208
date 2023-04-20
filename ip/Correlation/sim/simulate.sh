rm -rf work
vlib work
vlog +cover=bcefsx -sv ../rtl/Correlation.sv ../rtl/CrosscorrelationIterator.sv ../rtl/edgeDetector.sv Correlation_test.sv
vsim -c -coverage Correlation_test -do "run 10ms;exit"
