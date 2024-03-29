// DE2_115_SOPC.v

// Generated using ACDS version 18.1 625

`timescale 1 ps / 1 ps
module DE2_115_SOPC (
		input  wire        clk_clk,                                   //                      clk.clk
		input  wire [29:0] peripheral_0_conduit_end_lagsin_t,         // peripheral_0_conduit_end.lagsin_t
		input  wire        peripheral_0_conduit_end_lagsinvalid_t,    //                         .lagsinvalid_t
		input  wire [31:0] peripheral_0_conduit_end_debugdata_t,      //                         .debugdata_t
		input  wire        peripheral_0_conduit_end_debugdatavalid_t, //                         .debugdatavalid_t
		input  wire        peripheral_0_conduit_end_lagsenable_t,     //                         .lagsenable_t
		input  wire        peripheral_0_conduit_end_lagsshoot_t,      //                         .lagsshoot_t
		output wire        pwm_0_conduit_end_pwm,                     //        pwm_0_conduit_end.pwm
		output wire        pwm_1_conduit_end_pwm,                     //        pwm_1_conduit_end.pwm
		output wire        pwm_2_conduit_end_pwm,                     //        pwm_2_conduit_end.pwm
		input  wire        reset_reset_n                              //                    reset.reset_n
	);

	wire  [31:0] cpu_data_master_readdata;                                  // mm_interconnect_0:cpu_data_master_readdata -> cpu:d_readdata
	wire         cpu_data_master_waitrequest;                               // mm_interconnect_0:cpu_data_master_waitrequest -> cpu:d_waitrequest
	wire         cpu_data_master_debugaccess;                               // cpu:debug_mem_slave_debugaccess_to_roms -> mm_interconnect_0:cpu_data_master_debugaccess
	wire  [19:0] cpu_data_master_address;                                   // cpu:d_address -> mm_interconnect_0:cpu_data_master_address
	wire   [3:0] cpu_data_master_byteenable;                                // cpu:d_byteenable -> mm_interconnect_0:cpu_data_master_byteenable
	wire         cpu_data_master_read;                                      // cpu:d_read -> mm_interconnect_0:cpu_data_master_read
	wire         cpu_data_master_readdatavalid;                             // mm_interconnect_0:cpu_data_master_readdatavalid -> cpu:d_readdatavalid
	wire         cpu_data_master_write;                                     // cpu:d_write -> mm_interconnect_0:cpu_data_master_write
	wire  [31:0] cpu_data_master_writedata;                                 // cpu:d_writedata -> mm_interconnect_0:cpu_data_master_writedata
	wire  [31:0] cpu_instruction_master_readdata;                           // mm_interconnect_0:cpu_instruction_master_readdata -> cpu:i_readdata
	wire         cpu_instruction_master_waitrequest;                        // mm_interconnect_0:cpu_instruction_master_waitrequest -> cpu:i_waitrequest
	wire  [19:0] cpu_instruction_master_address;                            // cpu:i_address -> mm_interconnect_0:cpu_instruction_master_address
	wire         cpu_instruction_master_read;                               // cpu:i_read -> mm_interconnect_0:cpu_instruction_master_read
	wire         cpu_instruction_master_readdatavalid;                      // mm_interconnect_0:cpu_instruction_master_readdatavalid -> cpu:i_readdatavalid
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect;  // mm_interconnect_0:jtag_uart_avalon_jtag_slave_chipselect -> jtag_uart:av_chipselect
	wire  [31:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata;    // jtag_uart:av_readdata -> mm_interconnect_0:jtag_uart_avalon_jtag_slave_readdata
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest; // jtag_uart:av_waitrequest -> mm_interconnect_0:jtag_uart_avalon_jtag_slave_waitrequest
	wire   [0:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_address;     // mm_interconnect_0:jtag_uart_avalon_jtag_slave_address -> jtag_uart:av_address
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_read;        // mm_interconnect_0:jtag_uart_avalon_jtag_slave_read -> jtag_uart:av_read_n
	wire         mm_interconnect_0_jtag_uart_avalon_jtag_slave_write;       // mm_interconnect_0:jtag_uart_avalon_jtag_slave_write -> jtag_uart:av_write_n
	wire  [31:0] mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata;   // mm_interconnect_0:jtag_uart_avalon_jtag_slave_writedata -> jtag_uart:av_writedata
	wire  [31:0] mm_interconnect_0_pwm_0_avalon_slave_0_readdata;           // pwm_0:readdata -> mm_interconnect_0:pwm_0_avalon_slave_0_readdata
	wire   [1:0] mm_interconnect_0_pwm_0_avalon_slave_0_address;            // mm_interconnect_0:pwm_0_avalon_slave_0_address -> pwm_0:address
	wire         mm_interconnect_0_pwm_0_avalon_slave_0_read;               // mm_interconnect_0:pwm_0_avalon_slave_0_read -> pwm_0:read
	wire         mm_interconnect_0_pwm_0_avalon_slave_0_write;              // mm_interconnect_0:pwm_0_avalon_slave_0_write -> pwm_0:write
	wire  [31:0] mm_interconnect_0_pwm_0_avalon_slave_0_writedata;          // mm_interconnect_0:pwm_0_avalon_slave_0_writedata -> pwm_0:writedata
	wire  [31:0] mm_interconnect_0_pwm_1_avalon_slave_0_readdata;           // pwm_1:readdata -> mm_interconnect_0:pwm_1_avalon_slave_0_readdata
	wire   [1:0] mm_interconnect_0_pwm_1_avalon_slave_0_address;            // mm_interconnect_0:pwm_1_avalon_slave_0_address -> pwm_1:address
	wire         mm_interconnect_0_pwm_1_avalon_slave_0_read;               // mm_interconnect_0:pwm_1_avalon_slave_0_read -> pwm_1:read
	wire         mm_interconnect_0_pwm_1_avalon_slave_0_write;              // mm_interconnect_0:pwm_1_avalon_slave_0_write -> pwm_1:write
	wire  [31:0] mm_interconnect_0_pwm_1_avalon_slave_0_writedata;          // mm_interconnect_0:pwm_1_avalon_slave_0_writedata -> pwm_1:writedata
	wire  [31:0] mm_interconnect_0_pwm_2_avalon_slave_0_readdata;           // pwm_2:readdata -> mm_interconnect_0:pwm_2_avalon_slave_0_readdata
	wire   [1:0] mm_interconnect_0_pwm_2_avalon_slave_0_address;            // mm_interconnect_0:pwm_2_avalon_slave_0_address -> pwm_2:address
	wire         mm_interconnect_0_pwm_2_avalon_slave_0_read;               // mm_interconnect_0:pwm_2_avalon_slave_0_read -> pwm_2:read
	wire         mm_interconnect_0_pwm_2_avalon_slave_0_write;              // mm_interconnect_0:pwm_2_avalon_slave_0_write -> pwm_2:write
	wire  [31:0] mm_interconnect_0_pwm_2_avalon_slave_0_writedata;          // mm_interconnect_0:pwm_2_avalon_slave_0_writedata -> pwm_2:writedata
	wire  [31:0] mm_interconnect_0_peripheral_0_avalon_slave_0_readdata;    // peripheral_0:readdata -> mm_interconnect_0:peripheral_0_avalon_slave_0_readdata
	wire   [0:0] mm_interconnect_0_peripheral_0_avalon_slave_0_address;     // mm_interconnect_0:peripheral_0_avalon_slave_0_address -> peripheral_0:address
	wire  [31:0] mm_interconnect_0_cpu_debug_mem_slave_readdata;            // cpu:debug_mem_slave_readdata -> mm_interconnect_0:cpu_debug_mem_slave_readdata
	wire         mm_interconnect_0_cpu_debug_mem_slave_waitrequest;         // cpu:debug_mem_slave_waitrequest -> mm_interconnect_0:cpu_debug_mem_slave_waitrequest
	wire         mm_interconnect_0_cpu_debug_mem_slave_debugaccess;         // mm_interconnect_0:cpu_debug_mem_slave_debugaccess -> cpu:debug_mem_slave_debugaccess
	wire   [8:0] mm_interconnect_0_cpu_debug_mem_slave_address;             // mm_interconnect_0:cpu_debug_mem_slave_address -> cpu:debug_mem_slave_address
	wire         mm_interconnect_0_cpu_debug_mem_slave_read;                // mm_interconnect_0:cpu_debug_mem_slave_read -> cpu:debug_mem_slave_read
	wire   [3:0] mm_interconnect_0_cpu_debug_mem_slave_byteenable;          // mm_interconnect_0:cpu_debug_mem_slave_byteenable -> cpu:debug_mem_slave_byteenable
	wire         mm_interconnect_0_cpu_debug_mem_slave_write;               // mm_interconnect_0:cpu_debug_mem_slave_write -> cpu:debug_mem_slave_write
	wire  [31:0] mm_interconnect_0_cpu_debug_mem_slave_writedata;           // mm_interconnect_0:cpu_debug_mem_slave_writedata -> cpu:debug_mem_slave_writedata
	wire         mm_interconnect_0_onchip_memory2_s1_chipselect;            // mm_interconnect_0:onchip_memory2_s1_chipselect -> onchip_memory2:chipselect
	wire  [31:0] mm_interconnect_0_onchip_memory2_s1_readdata;              // onchip_memory2:readdata -> mm_interconnect_0:onchip_memory2_s1_readdata
	wire  [15:0] mm_interconnect_0_onchip_memory2_s1_address;               // mm_interconnect_0:onchip_memory2_s1_address -> onchip_memory2:address
	wire   [3:0] mm_interconnect_0_onchip_memory2_s1_byteenable;            // mm_interconnect_0:onchip_memory2_s1_byteenable -> onchip_memory2:byteenable
	wire         mm_interconnect_0_onchip_memory2_s1_write;                 // mm_interconnect_0:onchip_memory2_s1_write -> onchip_memory2:write
	wire  [31:0] mm_interconnect_0_onchip_memory2_s1_writedata;             // mm_interconnect_0:onchip_memory2_s1_writedata -> onchip_memory2:writedata
	wire         mm_interconnect_0_onchip_memory2_s1_clken;                 // mm_interconnect_0:onchip_memory2_s1_clken -> onchip_memory2:clken
	wire         irq_mapper_receiver0_irq;                                  // jtag_uart:av_irq -> irq_mapper:receiver0_irq
	wire  [31:0] cpu_irq_irq;                                               // irq_mapper:sender_irq -> cpu:irq
	wire         rst_controller_reset_out_reset;                            // rst_controller:reset_out -> [cpu:reset_n, irq_mapper:reset, jtag_uart:rst_n, mm_interconnect_0:cpu_reset_reset_bridge_in_reset_reset, onchip_memory2:reset, peripheral_0:reset, pwm_0:reset, pwm_1:reset, pwm_2:reset, rst_translator:in_reset]
	wire         rst_controller_reset_out_reset_req;                        // rst_controller:reset_req -> [cpu:reset_req, onchip_memory2:reset_req, rst_translator:reset_req_in]

	DE2_115_SOPC_cpu cpu (
		.clk                                 (clk_clk),                                           //                       clk.clk
		.reset_n                             (~rst_controller_reset_out_reset),                   //                     reset.reset_n
		.reset_req                           (rst_controller_reset_out_reset_req),                //                          .reset_req
		.d_address                           (cpu_data_master_address),                           //               data_master.address
		.d_byteenable                        (cpu_data_master_byteenable),                        //                          .byteenable
		.d_read                              (cpu_data_master_read),                              //                          .read
		.d_readdata                          (cpu_data_master_readdata),                          //                          .readdata
		.d_waitrequest                       (cpu_data_master_waitrequest),                       //                          .waitrequest
		.d_write                             (cpu_data_master_write),                             //                          .write
		.d_writedata                         (cpu_data_master_writedata),                         //                          .writedata
		.d_readdatavalid                     (cpu_data_master_readdatavalid),                     //                          .readdatavalid
		.debug_mem_slave_debugaccess_to_roms (cpu_data_master_debugaccess),                       //                          .debugaccess
		.i_address                           (cpu_instruction_master_address),                    //        instruction_master.address
		.i_read                              (cpu_instruction_master_read),                       //                          .read
		.i_readdata                          (cpu_instruction_master_readdata),                   //                          .readdata
		.i_waitrequest                       (cpu_instruction_master_waitrequest),                //                          .waitrequest
		.i_readdatavalid                     (cpu_instruction_master_readdatavalid),              //                          .readdatavalid
		.irq                                 (cpu_irq_irq),                                       //                       irq.irq
		.debug_reset_request                 (),                                                  //       debug_reset_request.reset
		.debug_mem_slave_address             (mm_interconnect_0_cpu_debug_mem_slave_address),     //           debug_mem_slave.address
		.debug_mem_slave_byteenable          (mm_interconnect_0_cpu_debug_mem_slave_byteenable),  //                          .byteenable
		.debug_mem_slave_debugaccess         (mm_interconnect_0_cpu_debug_mem_slave_debugaccess), //                          .debugaccess
		.debug_mem_slave_read                (mm_interconnect_0_cpu_debug_mem_slave_read),        //                          .read
		.debug_mem_slave_readdata            (mm_interconnect_0_cpu_debug_mem_slave_readdata),    //                          .readdata
		.debug_mem_slave_waitrequest         (mm_interconnect_0_cpu_debug_mem_slave_waitrequest), //                          .waitrequest
		.debug_mem_slave_write               (mm_interconnect_0_cpu_debug_mem_slave_write),       //                          .write
		.debug_mem_slave_writedata           (mm_interconnect_0_cpu_debug_mem_slave_writedata),   //                          .writedata
		.dummy_ci_port                       ()                                                   // custom_instruction_master.readra
	);

	DE2_115_SOPC_jtag_uart jtag_uart (
		.clk            (clk_clk),                                                   //               clk.clk
		.rst_n          (~rst_controller_reset_out_reset),                           //             reset.reset_n
		.av_chipselect  (mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect),  // avalon_jtag_slave.chipselect
		.av_address     (mm_interconnect_0_jtag_uart_avalon_jtag_slave_address),     //                  .address
		.av_read_n      (~mm_interconnect_0_jtag_uart_avalon_jtag_slave_read),       //                  .read_n
		.av_readdata    (mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata),    //                  .readdata
		.av_write_n     (~mm_interconnect_0_jtag_uart_avalon_jtag_slave_write),      //                  .write_n
		.av_writedata   (mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata),   //                  .writedata
		.av_waitrequest (mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest), //                  .waitrequest
		.av_irq         (irq_mapper_receiver0_irq)                                   //               irq.irq
	);

	DE2_115_SOPC_onchip_memory2 onchip_memory2 (
		.clk        (clk_clk),                                        //   clk1.clk
		.address    (mm_interconnect_0_onchip_memory2_s1_address),    //     s1.address
		.clken      (mm_interconnect_0_onchip_memory2_s1_clken),      //       .clken
		.chipselect (mm_interconnect_0_onchip_memory2_s1_chipselect), //       .chipselect
		.write      (mm_interconnect_0_onchip_memory2_s1_write),      //       .write
		.readdata   (mm_interconnect_0_onchip_memory2_s1_readdata),   //       .readdata
		.writedata  (mm_interconnect_0_onchip_memory2_s1_writedata),  //       .writedata
		.byteenable (mm_interconnect_0_onchip_memory2_s1_byteenable), //       .byteenable
		.reset      (rst_controller_reset_out_reset),                 // reset1.reset
		.reset_req  (rst_controller_reset_out_reset_req),             //       .reset_req
		.freeze     (1'b0)                                            // (terminated)
	);

	CpuPeripheral peripheral_0 (
		.clk            (clk_clk),                                                //          clock.clk
		.reset          (rst_controller_reset_out_reset),                         //          reset.reset
		.readdata       (mm_interconnect_0_peripheral_0_avalon_slave_0_readdata), // avalon_slave_0.readdata
		.address        (mm_interconnect_0_peripheral_0_avalon_slave_0_address),  //               .address
		.dataIn         (peripheral_0_conduit_end_lagsin_t),                      //    conduit_end.lagsin_t
		.dataInValid    (peripheral_0_conduit_end_lagsinvalid_t),                 //               .lagsinvalid_t
		.debugData      (peripheral_0_conduit_end_debugdata_t),                   //               .debugdata_t
		.debugDataValid (peripheral_0_conduit_end_debugdatavalid_t),              //               .debugdatavalid_t
		.dataEnable     (peripheral_0_conduit_end_lagsenable_t),                  //               .lagsenable_t
		.dataShoot      (peripheral_0_conduit_end_lagsshoot_t)                    //               .lagsshoot_t
	);

	pwm pwm_0 (
		.clk       (clk_clk),                                          //          clock.clk
		.reset     (rst_controller_reset_out_reset),                   //          reset.reset
		.address   (mm_interconnect_0_pwm_0_avalon_slave_0_address),   // avalon_slave_0.address
		.read      (mm_interconnect_0_pwm_0_avalon_slave_0_read),      //               .read
		.write     (mm_interconnect_0_pwm_0_avalon_slave_0_write),     //               .write
		.readdata  (mm_interconnect_0_pwm_0_avalon_slave_0_readdata),  //               .readdata
		.writedata (mm_interconnect_0_pwm_0_avalon_slave_0_writedata), //               .writedata
		.pwm_out   (pwm_0_conduit_end_pwm)                             //    conduit_end.pwm
	);

	pwm pwm_1 (
		.clk       (clk_clk),                                          //          clock.clk
		.reset     (rst_controller_reset_out_reset),                   //          reset.reset
		.address   (mm_interconnect_0_pwm_1_avalon_slave_0_address),   // avalon_slave_0.address
		.read      (mm_interconnect_0_pwm_1_avalon_slave_0_read),      //               .read
		.write     (mm_interconnect_0_pwm_1_avalon_slave_0_write),     //               .write
		.readdata  (mm_interconnect_0_pwm_1_avalon_slave_0_readdata),  //               .readdata
		.writedata (mm_interconnect_0_pwm_1_avalon_slave_0_writedata), //               .writedata
		.pwm_out   (pwm_1_conduit_end_pwm)                             //    conduit_end.pwm
	);

	pwm pwm_2 (
		.clk       (clk_clk),                                          //          clock.clk
		.reset     (rst_controller_reset_out_reset),                   //          reset.reset
		.address   (mm_interconnect_0_pwm_2_avalon_slave_0_address),   // avalon_slave_0.address
		.read      (mm_interconnect_0_pwm_2_avalon_slave_0_read),      //               .read
		.write     (mm_interconnect_0_pwm_2_avalon_slave_0_write),     //               .write
		.readdata  (mm_interconnect_0_pwm_2_avalon_slave_0_readdata),  //               .readdata
		.writedata (mm_interconnect_0_pwm_2_avalon_slave_0_writedata), //               .writedata
		.pwm_out   (pwm_2_conduit_end_pwm)                             //    conduit_end.pwm
	);

	DE2_115_SOPC_mm_interconnect_0 mm_interconnect_0 (
		.clk_50_clk_clk                          (clk_clk),                                                   //                      clk_50_clk.clk
		.cpu_reset_reset_bridge_in_reset_reset   (rst_controller_reset_out_reset),                            // cpu_reset_reset_bridge_in_reset.reset
		.cpu_data_master_address                 (cpu_data_master_address),                                   //                 cpu_data_master.address
		.cpu_data_master_waitrequest             (cpu_data_master_waitrequest),                               //                                .waitrequest
		.cpu_data_master_byteenable              (cpu_data_master_byteenable),                                //                                .byteenable
		.cpu_data_master_read                    (cpu_data_master_read),                                      //                                .read
		.cpu_data_master_readdata                (cpu_data_master_readdata),                                  //                                .readdata
		.cpu_data_master_readdatavalid           (cpu_data_master_readdatavalid),                             //                                .readdatavalid
		.cpu_data_master_write                   (cpu_data_master_write),                                     //                                .write
		.cpu_data_master_writedata               (cpu_data_master_writedata),                                 //                                .writedata
		.cpu_data_master_debugaccess             (cpu_data_master_debugaccess),                               //                                .debugaccess
		.cpu_instruction_master_address          (cpu_instruction_master_address),                            //          cpu_instruction_master.address
		.cpu_instruction_master_waitrequest      (cpu_instruction_master_waitrequest),                        //                                .waitrequest
		.cpu_instruction_master_read             (cpu_instruction_master_read),                               //                                .read
		.cpu_instruction_master_readdata         (cpu_instruction_master_readdata),                           //                                .readdata
		.cpu_instruction_master_readdatavalid    (cpu_instruction_master_readdatavalid),                      //                                .readdatavalid
		.cpu_debug_mem_slave_address             (mm_interconnect_0_cpu_debug_mem_slave_address),             //             cpu_debug_mem_slave.address
		.cpu_debug_mem_slave_write               (mm_interconnect_0_cpu_debug_mem_slave_write),               //                                .write
		.cpu_debug_mem_slave_read                (mm_interconnect_0_cpu_debug_mem_slave_read),                //                                .read
		.cpu_debug_mem_slave_readdata            (mm_interconnect_0_cpu_debug_mem_slave_readdata),            //                                .readdata
		.cpu_debug_mem_slave_writedata           (mm_interconnect_0_cpu_debug_mem_slave_writedata),           //                                .writedata
		.cpu_debug_mem_slave_byteenable          (mm_interconnect_0_cpu_debug_mem_slave_byteenable),          //                                .byteenable
		.cpu_debug_mem_slave_waitrequest         (mm_interconnect_0_cpu_debug_mem_slave_waitrequest),         //                                .waitrequest
		.cpu_debug_mem_slave_debugaccess         (mm_interconnect_0_cpu_debug_mem_slave_debugaccess),         //                                .debugaccess
		.jtag_uart_avalon_jtag_slave_address     (mm_interconnect_0_jtag_uart_avalon_jtag_slave_address),     //     jtag_uart_avalon_jtag_slave.address
		.jtag_uart_avalon_jtag_slave_write       (mm_interconnect_0_jtag_uart_avalon_jtag_slave_write),       //                                .write
		.jtag_uart_avalon_jtag_slave_read        (mm_interconnect_0_jtag_uart_avalon_jtag_slave_read),        //                                .read
		.jtag_uart_avalon_jtag_slave_readdata    (mm_interconnect_0_jtag_uart_avalon_jtag_slave_readdata),    //                                .readdata
		.jtag_uart_avalon_jtag_slave_writedata   (mm_interconnect_0_jtag_uart_avalon_jtag_slave_writedata),   //                                .writedata
		.jtag_uart_avalon_jtag_slave_waitrequest (mm_interconnect_0_jtag_uart_avalon_jtag_slave_waitrequest), //                                .waitrequest
		.jtag_uart_avalon_jtag_slave_chipselect  (mm_interconnect_0_jtag_uart_avalon_jtag_slave_chipselect),  //                                .chipselect
		.onchip_memory2_s1_address               (mm_interconnect_0_onchip_memory2_s1_address),               //               onchip_memory2_s1.address
		.onchip_memory2_s1_write                 (mm_interconnect_0_onchip_memory2_s1_write),                 //                                .write
		.onchip_memory2_s1_readdata              (mm_interconnect_0_onchip_memory2_s1_readdata),              //                                .readdata
		.onchip_memory2_s1_writedata             (mm_interconnect_0_onchip_memory2_s1_writedata),             //                                .writedata
		.onchip_memory2_s1_byteenable            (mm_interconnect_0_onchip_memory2_s1_byteenable),            //                                .byteenable
		.onchip_memory2_s1_chipselect            (mm_interconnect_0_onchip_memory2_s1_chipselect),            //                                .chipselect
		.onchip_memory2_s1_clken                 (mm_interconnect_0_onchip_memory2_s1_clken),                 //                                .clken
		.peripheral_0_avalon_slave_0_address     (mm_interconnect_0_peripheral_0_avalon_slave_0_address),     //     peripheral_0_avalon_slave_0.address
		.peripheral_0_avalon_slave_0_readdata    (mm_interconnect_0_peripheral_0_avalon_slave_0_readdata),    //                                .readdata
		.pwm_0_avalon_slave_0_address            (mm_interconnect_0_pwm_0_avalon_slave_0_address),            //            pwm_0_avalon_slave_0.address
		.pwm_0_avalon_slave_0_write              (mm_interconnect_0_pwm_0_avalon_slave_0_write),              //                                .write
		.pwm_0_avalon_slave_0_read               (mm_interconnect_0_pwm_0_avalon_slave_0_read),               //                                .read
		.pwm_0_avalon_slave_0_readdata           (mm_interconnect_0_pwm_0_avalon_slave_0_readdata),           //                                .readdata
		.pwm_0_avalon_slave_0_writedata          (mm_interconnect_0_pwm_0_avalon_slave_0_writedata),          //                                .writedata
		.pwm_1_avalon_slave_0_address            (mm_interconnect_0_pwm_1_avalon_slave_0_address),            //            pwm_1_avalon_slave_0.address
		.pwm_1_avalon_slave_0_write              (mm_interconnect_0_pwm_1_avalon_slave_0_write),              //                                .write
		.pwm_1_avalon_slave_0_read               (mm_interconnect_0_pwm_1_avalon_slave_0_read),               //                                .read
		.pwm_1_avalon_slave_0_readdata           (mm_interconnect_0_pwm_1_avalon_slave_0_readdata),           //                                .readdata
		.pwm_1_avalon_slave_0_writedata          (mm_interconnect_0_pwm_1_avalon_slave_0_writedata),          //                                .writedata
		.pwm_2_avalon_slave_0_address            (mm_interconnect_0_pwm_2_avalon_slave_0_address),            //            pwm_2_avalon_slave_0.address
		.pwm_2_avalon_slave_0_write              (mm_interconnect_0_pwm_2_avalon_slave_0_write),              //                                .write
		.pwm_2_avalon_slave_0_read               (mm_interconnect_0_pwm_2_avalon_slave_0_read),               //                                .read
		.pwm_2_avalon_slave_0_readdata           (mm_interconnect_0_pwm_2_avalon_slave_0_readdata),           //                                .readdata
		.pwm_2_avalon_slave_0_writedata          (mm_interconnect_0_pwm_2_avalon_slave_0_writedata)           //                                .writedata
	);

	DE2_115_SOPC_irq_mapper irq_mapper (
		.clk           (clk_clk),                        //       clk.clk
		.reset         (rst_controller_reset_out_reset), // clk_reset.reset
		.receiver0_irq (irq_mapper_receiver0_irq),       // receiver0.irq
		.sender_irq    (cpu_irq_irq)                     //    sender.irq
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (1),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                     // reset_in0.reset
		.clk            (clk_clk),                            //       clk.clk
		.reset_out      (rst_controller_reset_out_reset),     // reset_out.reset
		.reset_req      (rst_controller_reset_out_reset_req), //          .reset_req
		.reset_req_in0  (1'b0),                               // (terminated)
		.reset_in1      (1'b0),                               // (terminated)
		.reset_req_in1  (1'b0),                               // (terminated)
		.reset_in2      (1'b0),                               // (terminated)
		.reset_req_in2  (1'b0),                               // (terminated)
		.reset_in3      (1'b0),                               // (terminated)
		.reset_req_in3  (1'b0),                               // (terminated)
		.reset_in4      (1'b0),                               // (terminated)
		.reset_req_in4  (1'b0),                               // (terminated)
		.reset_in5      (1'b0),                               // (terminated)
		.reset_req_in5  (1'b0),                               // (terminated)
		.reset_in6      (1'b0),                               // (terminated)
		.reset_req_in6  (1'b0),                               // (terminated)
		.reset_in7      (1'b0),                               // (terminated)
		.reset_req_in7  (1'b0),                               // (terminated)
		.reset_in8      (1'b0),                               // (terminated)
		.reset_req_in8  (1'b0),                               // (terminated)
		.reset_in9      (1'b0),                               // (terminated)
		.reset_req_in9  (1'b0),                               // (terminated)
		.reset_in10     (1'b0),                               // (terminated)
		.reset_req_in10 (1'b0),                               // (terminated)
		.reset_in11     (1'b0),                               // (terminated)
		.reset_req_in11 (1'b0),                               // (terminated)
		.reset_in12     (1'b0),                               // (terminated)
		.reset_req_in12 (1'b0),                               // (terminated)
		.reset_in13     (1'b0),                               // (terminated)
		.reset_req_in13 (1'b0),                               // (terminated)
		.reset_in14     (1'b0),                               // (terminated)
		.reset_req_in14 (1'b0),                               // (terminated)
		.reset_in15     (1'b0),                               // (terminated)
		.reset_req_in15 (1'b0)                                // (terminated)
	);

endmodule
