import numpy as np
import scipy.signal as signal
from math import floor


def Correlate():
    num_channels = 4
    num_xCorrs = int(num_channels * (num_channels - 1) / 2)
    num_delays = 23
    window_length = 100
    input_filepath = 'data/nepe0.csv'
    ouput_filepath = input_filepath.split('.')[0] + '_model_result.csv'

    input = np.genfromtxt(input_filepath, dtype=int, delimiter=',')
    input = np.swapaxes(input, 0, 1)
    input = input[0:num_channels]

    print(num_xCorrs)

    output = np.zeros((num_xCorrs, input.shape[1], num_delays))

    a = 0
    b = 0
    for j in range(num_xCorrs):
        if j > 0 and b == num_channels - 1:
            a = a + 1
            b = a + 1
        else:
            b += 1
        print (f"j: {j}, a: {a}, b: {b}")
        # j a b
        # 0 0 1
        # 1 0 2
        # 2 0 3
        # 3 1 2
        # 4 1 3
        # 5 2 3

        for i in range(window_length, input.shape[1]):

            starting_sample = i - window_length

            correlation = signal.correlate(
                input[a, starting_sample:i], input[b, starting_sample:i], method="direct")
            output[j, i] = correlation[(
                correlation.shape[0] - num_delays) // 2:(correlation.shape[0] + num_delays) // 2] # Get the middle of the array, the delays we are interested in
            output[j, i] = np.roll(output[j, i], floor(num_delays / 2) + 1) # Place k=0 at the 0-index of the array, k=-1 is at the -1, k=1 is at the 1, etc.



    output = output.astype(int)
    # Reshape to 2D array
    # output = output.reshape(( output.shape[0] * output.shape[1], output.shape[2]))

    print(input)
    print(output)
    print(output.shape)

    for i in range(output.shape[0]):
        np.savetxt(ouput_filepath+str(i), output[i], fmt='%.1d', delimiter=",")


Correlate()
