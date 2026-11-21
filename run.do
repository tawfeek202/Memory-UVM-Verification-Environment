# ======================================================================
# QuestaSim Run Script for Memory UVM Environment
# ======================================================================

# 1. Create work library if it doesn't exist
if {[file exists work]} {
    vdel -lib work -all
}
vlib work

# 2. Compile Design and Testbench Files
# (Make sure file paths match your directory structure)
vlog -work work +incdir+. memory.sv
vlog -work work +incdir+. mem_if.sv
vlog -work work +incdir+. mem_pkg.sv
vlog -work work +incdir+. mem_top.sv

# 3. Simulate with UVM options
# -classdebug enables inspection of UVM component hierarchies
# -uvmcontrol=all enables UVM messaging controls
vsim -voptargs=+acc -classdebug -uvmcontrol=all work.mem_top +UVM_TESTNAME=mem_test

# 4. Add wave signals to waveform window (optional)
do wave.do

# 5. Run the simulation
run -all

# To keep the GUI open after run finishes, comment out "quit -sim"
# quit -sim