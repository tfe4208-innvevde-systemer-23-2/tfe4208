
module DE2_115_SOPC (
	clk_clk,
	peripheral_0_conduit_end_lagsin,
	peripheral_0_conduit_end_lagsinvalid,
	pwm_0_conduit_end_pwm,
	pwm_1_conduit_end_pwm,
	pwm_2_conduit_end_pwm,
	reset_reset_n);	

	input		clk_clk;
	input	[35:0]	peripheral_0_conduit_end_lagsin;
	input		peripheral_0_conduit_end_lagsinvalid;
	output		pwm_0_conduit_end_pwm;
	output		pwm_1_conduit_end_pwm;
	output		pwm_2_conduit_end_pwm;
	input		reset_reset_n;
endmodule
