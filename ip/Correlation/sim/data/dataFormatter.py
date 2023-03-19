import csv
import numpy as np

# open the file in the write mode
f = open('ip/Correlation/model/data/nepe2.csv',
         'w', encoding='UTF8', newline="")

# create the csv writer
writer = csv.writer(f)


def raspi_import(path, channels=5):
    with open(path, 'r') as fid:
        sample_period = np.fromfile(fid, count=1, dtype=float)[0]
        data = np.fromfile(fid, dtype=np.uint16)
        data = data.reshape((-1, channels))
    return sample_period, data


sample_period, data = raspi_import(
    'ip/Correlation/sim/data/nepe2.bin')  # Import data from binary file

x1 = data[:, 4][2000:]
x2 = data[:, 3][2000:]
x3 = data[:, 2][2000:]
x4 = data[:, 1][2000:]
x5 = data[:, 0][2000:]

# write a row to the csv file
for i in range(0, len(x1)):
    thing = [x5[i], x4[i], x3[i], x2[i], x1[i]]
    writer.writerow(thing)

# close the file
f.close()
