#!/bin/bash

set -e   # stop on error

# Clean old files
ghdl --clean
ghdl --remove

echo "=== ANALYSING ==="
ghdl -a ternary_full_adder.vhd
ghdl -a ternary_adder_N.vhd
ghdl -a tb_ternary_adder_N.vhd

echo "=== ELABORATING ==="
ghdl -e tb_ternary_adder_N

echo "=== RUNNING SIMULATION ==="
ghdl -r tb_ternary_adder_N # --vcd=wave.vcd

#echo "=== OPENING GTKWave ==="
#gtkwave wave.vcd #&
