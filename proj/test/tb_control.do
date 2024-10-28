
add wave -noupdate -divider {control)
add wave -noupdate -divider {input}
add wave -noupdate -label opcode -radix binary /tb_control/s_opcode
add wave -noupdate -label funct -radix binary /tb_control/s_funct

add wave -noupdate -divider {output}
add wave -noupdate -label o_Ctrl /tb_control/s_Ctrl
add wave -noupdate -label expected_out /tb_control/expected_out

run 1250 ns