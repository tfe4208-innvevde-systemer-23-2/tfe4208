from pysv import sv, compile_lib, generate_sv_binding
import numpy as np
import matplotlib.pyplot as plt


@sv()
def Correlate():
    print("Hello world!")


# Compile the function into a library
lib_path = compile_lib([Correlate], cwd="build", lib_name="Correlate")
# Generate SV binding
generate_sv_binding([Correlate], filename="FunctionalModel.sv")
