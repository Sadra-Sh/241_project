vlib work

vlog PS2.v

vsim PS2

log {/*}

add wave {/*}

force {PS2_CLK} 1 0ns, 0 {5ns} -r 10ns
force {KEY} 0
force {PS2_DAT} 0 0ns, 1 {5ns} -r 10ns

run 200ns
