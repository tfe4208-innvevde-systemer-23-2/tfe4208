rm -rf work
vlib work
vlog +cover=bcefsx -sv ../rtl/Spi.sv ../rtl/Fsm.sv ../rtl/ClockScaler.sv ../rtl/SiPo.sv Spi_test.sv
vsim -c -coverage Spi_test -do "run 2000ns;exit"
