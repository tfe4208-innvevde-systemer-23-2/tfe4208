rm -rf work
vlib work
vlog +cover=bcefsx -sv ../rtl/SPI.sv ../rtl/fsm.sv ../rtl/ClockScaler.sv ../rtl/SiPo.sv SPI_test.sv
vsim -c -coverage SPI_test -do "run 200ns;exit"
