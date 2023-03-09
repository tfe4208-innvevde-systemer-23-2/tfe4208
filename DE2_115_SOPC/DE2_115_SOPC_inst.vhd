	component DE2_115_SOPC is
		port (
			clk_clk               : in  std_logic := 'X'; -- clk
			pwm_0_conduit_end_pwm : out std_logic;        -- pwm
			pwm_1_conduit_end_pwm : out std_logic;        -- pwm
			reset_reset_n         : in  std_logic := 'X'  -- reset_n
		);
	end component DE2_115_SOPC;

	u0 : component DE2_115_SOPC
		port map (
			clk_clk               => CONNECTED_TO_clk_clk,               --               clk.clk
			pwm_0_conduit_end_pwm => CONNECTED_TO_pwm_0_conduit_end_pwm, -- pwm_0_conduit_end.pwm
			pwm_1_conduit_end_pwm => CONNECTED_TO_pwm_1_conduit_end_pwm, -- pwm_1_conduit_end.pwm
			reset_reset_n         => CONNECTED_TO_reset_reset_n          --             reset.reset_n
		);

