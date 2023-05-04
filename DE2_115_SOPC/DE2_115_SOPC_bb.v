
module DE2_115_SOPC (
	clk_clk,
	pwm_0_conduit_end_pwm,
	pwm_1_conduit_end_pwm,
	pwm_2_conduit_end_pwm,
	reset_reset_n,
	peripheral_0_conduit_end_lagsin_t,
	peripheral_0_conduit_end_lagsinvalid_t,
	peripheral_0_conduit_end_debugdata_t,
	peripheral_0_conduit_end_debugdatavalid_t,
	peripheral_0_conduit_end_lagsenable_t,
	peripheral_0_conduit_end_lagsshoot_t);	

	input		clk_clk;
	output		pwm_0_conduit_end_pwm;
	output		pwm_1_conduit_end_pwm;
	output		pwm_2_conduit_end_pwm;
	input		reset_reset_n;
	input	[29:0]	peripheral_0_conduit_end_lagsin_t;
	input		peripheral_0_conduit_end_lagsinvalid_t;
	input	[31:0]	peripheral_0_conduit_end_debugdata_t;
	input		peripheral_0_conduit_end_debugdatavalid_t;
	input		peripheral_0_conduit_end_lagsenable_t;
	input		peripheral_0_conduit_end_lagsshoot_t;
endmodule
