vlib work

vlog PS2.v

vsim PS2

log {/*}

add wave {/*}

force {PS2_CLK} 1 0ns, 0 {5ns} -r 10ns
force {CLOCK_50} 1 0ns, 0 {2ns} -r 4ns
force {SW} 1 0ns, 0 {20ns} -r 1000ns
force {PS2_DAT} 0 0ns, 1 {7ns} -r 14ns

run 1000ns
