	component DE2_115_SOPC is
		port (
			clk_clk                                   : in  std_logic                     := 'X';             -- clk
			pwm_0_conduit_end_pwm                     : out std_logic;                                        -- pwm
			pwm_1_conduit_end_pwm                     : out std_logic;                                        -- pwm
			pwm_2_conduit_end_pwm                     : out std_logic;                                        -- pwm
			reset_reset_n                             : in  std_logic                     := 'X';             -- reset_n
			peripheral_0_conduit_end_lagsin_t         : in  std_logic_vector(29 downto 0) := (others => 'X'); -- lagsin_t
			peripheral_0_conduit_end_lagsinvalid_t    : in  std_logic                     := 'X';             -- lagsinvalid_t
			peripheral_0_conduit_end_debugdata_t      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- debugdata_t
			peripheral_0_conduit_end_debugdatavalid_t : in  std_logic                     := 'X';             -- debugdatavalid_t
			peripheral_0_conduit_end_lagsenable_t     : in  std_logic                     := 'X';             -- lagsenable_t
			peripheral_0_conduit_end_lagsshoot_t      : in  std_logic                     := 'X'              -- lagsshoot_t
		);
	end component DE2_115_SOPC;

	u0 : component DE2_115_SOPC
		port map (
			clk_clk                                   => CONNECTED_TO_clk_clk,                                   --                      clk.clk
			pwm_0_conduit_end_pwm                     => CONNECTED_TO_pwm_0_conduit_end_pwm,                     --        pwm_0_conduit_end.pwm
			pwm_1_conduit_end_pwm                     => CONNECTED_TO_pwm_1_conduit_end_pwm,                     --        pwm_1_conduit_end.pwm
			pwm_2_conduit_end_pwm                     => CONNECTED_TO_pwm_2_conduit_end_pwm,                     --        pwm_2_conduit_end.pwm
			reset_reset_n                             => CONNECTED_TO_reset_reset_n,                             --                    reset.reset_n
			peripheral_0_conduit_end_lagsin_t         => CONNECTED_TO_peripheral_0_conduit_end_lagsin_t,         -- peripheral_0_conduit_end.lagsin_t
			peripheral_0_conduit_end_lagsinvalid_t    => CONNECTED_TO_peripheral_0_conduit_end_lagsinvalid_t,    --                         .lagsinvalid_t
			peripheral_0_conduit_end_debugdata_t      => CONNECTED_TO_peripheral_0_conduit_end_debugdata_t,      --                         .debugdata_t
			peripheral_0_conduit_end_debugdatavalid_t => CONNECTED_TO_peripheral_0_conduit_end_debugdatavalid_t, --                         .debugdatavalid_t
			peripheral_0_conduit_end_lagsenable_t     => CONNECTED_TO_peripheral_0_conduit_end_lagsenable_t,     --                         .lagsenable_t
			peripheral_0_conduit_end_lagsshoot_t      => CONNECTED_TO_peripheral_0_conduit_end_lagsshoot_t       --                         .lagsshoot_t
		);

