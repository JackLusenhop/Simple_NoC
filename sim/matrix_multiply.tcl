----------------------------------------
# TOP-LEVEL TEMPLATE - BEGIN
#
# QSYS_SIMDIR is used in the Quartus-generated IP simulation script to
# construct paths to the files required to simulate the IP in your Quartus
# project. By default, the IP script assumes that you are launching the
# simulator from the IP script location. If launching from another
# location, set QSYS_SIMDIR to the output directory you specified when you
# generated the IP script, relative to the directory from which you launch
# the simulator.
#
#set QSYS_SIMDIR /mnt/vault0/sfberrio/repos/Simple_NoC/sim
set QSYS_SIMDIR [pwd]
#
#
# Source the generated IP simulation script.
# Script may fail if modelsim.ini file is not in read only mode
# adjust by using chmod 444 <dir>/modelsim.ini
source $QSYS_SIMDIR/mentor/msim_setup.tcl
#
# Set any compilation options you require (this is unusual).
# set USER_DEFINED_COMPILE_OPTIONS <compilation options>
# set USER_DEFINED_VHDL_COMPILE_OPTIONS <compilation options for VHDL>
# set USER_DEFINED_VERILOG_COMPILE_OPTIONS <compilation options for Verilog>
#
# Call command to compile the Quartus EDA simulation library.
# dev_com
#
# Call command to compile the Quartus-generated IP simulation files.
# com

# Create Stimulus and golden output files
exec python3 test_files/matrix_multiply/create_stimulus.py

# Add commands to compile all design files and testbench files, including
# the top level. (These are all the files required for simulation other
# than the files compiled by the Quartus-generated IP simulation script)
#

vlog +acc $QSYS_SIMDIR/testbench/matrix_multiply_tb.sv \
    $QSYS_SIMDIR/test_files/matrix_multiply/parameters.sv \
    $QSYS_SIMDIR/../src/axis/axis_passthrough.sv \
    $QSYS_SIMDIR/../src/mvm/*v \
    $QSYS_SIMDIR/../src/noc/*sv \
    $QSYS_SIMDIR/../src/top/mvm_top.sv

#
# Set the top-level simulation or testbench module/entity name, which is
# used by the elab command to elaborate the top level.
#
set TOP_LEVEL_NAME matrix_multiply_tb
#
# Set any elaboration options you require.
# set USER_DEFINED_ELAB_OPTIONS <elaboration options>
#
# Call command to elaborate your design and testbench.
elab_debug -suppress 14408
#
# Run the simulation with suppression.
run -a
#
# Report success to the shell.
# exit -code 0
#
# TOP-LEVEL TEMPLATE - END
