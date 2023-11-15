vlib work

vlog part2.v

vsim part2

log {/*}

add wave {/*}



force {Clock} 1 0ns, 0 {5ns} -r 10ns
force {Reset} 0
force {Go} 0 0ns, 1 {5ns} -r 10ns

force {DataIn[0]} 1
force {DataIn[1]} 0
force {DataIn[2]} 0
force {DataIn[3]} 0
force {DataIn[4]} 0
force {DataIn[5]} 0
force {DataIn[6]} 0
force {DataIn[7]} 0

run 100ns
