vlib work

vlog part1.v

vsim part2

log {/*}

add wave {/*}

force {clock} 0 0ns, 1 {5ns} -r 10ns
force {address} 00000
force {data} 0001
force {wren} 1 

run 20ns

force {clock} 0 0ns, 1 {5ns} -r 10ns
force {address} 00010
force {data} 0010
force {wren} 1 

run 20ns

force {clock} 0 0ns, 1 {5ns} -r 10ns
force {address} 00011
force {data} 0100
force {wren} 0

run 20ns

