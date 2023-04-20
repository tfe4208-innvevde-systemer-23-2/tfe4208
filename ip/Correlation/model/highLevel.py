import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal

l1 = [0, 0, 0, 0, 0, 2, 1, 1, 0, 0, 1, 0, 1, 0, 2, 1, 1, 0,
      0, 1, 0, 1, 1, 0, 2, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0]
l2 = [0, 0, 0, 0, 0, 1, 2, 1, 1, 2, 3, 1, 0, 0, 2, 1, 1, 0,
      0, 1, 0, 1, 1, 0, 2, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0]


def raspi_import(path, channels=5):
    with open(path, 'r') as fid:
        sample_period = np.fromfile(fid, count=1, dtype=float)[0]
        data = np.fromfile(fid, dtype=np.uint16)
        data = data.reshape((-1, channels))
    return sample_period, data


sample_period, data = raspi_import(
    'ip/Correlation/model/data/nepe2.bin')  # Import data from binary file

data = signal.detrend(data, axis=0)  # removes DC component for each channel
num_of_samples = data.shape[0]  # returns shape of matrix

# Cut out garbage data at the start
x1 = data[:, 4][20000:]/5000
x2 = data[:, 3][20000:]/5000
x3 = data[:, 2][20000:]/5000
x4 = data[:, 1][20000:]/5000
x5 = data[:, 0][20000:]/5000

maxLags = 20


def npCorrelate(l1, l2):
    return signal.correlate(l1, l2)


def testCorrelate(l1, l2):
    x12_test = [0]
    for i in range(0, 2*len(l1)-2):
        x12_test.append(0)
        if (i <= len(l1)):
            for a in range(0, i):
                diff = len(l1)-1-i
                x12_test[i] += l1[a]*l2[diff+a]
        else:
            for a in range(0, (2*len(l1))-1-i):
                diff = i+1-len(l1)
                x12_test[i] += l1[diff+a]*l2[a]
    return x12_test


def rtlCorrelate(l1, l2):
    x12_rtl = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    for i in range(maxLags, len(l1)-maxLags):
        for a in range(0, maxLags):
            x12_rtl[a] = macUnit(
                l1[a+i], l1[len(l1)-maxLags], l2[i+maxLags-1], x12_rtl[a])
            x12_rtl[-a] = macUnit(
                l1[-a+i], l1[len(l1)-maxLags], l2[i-maxLags], x12_rtl[-a])
        x12_rtl[0] = 2*macUnit(l1[i], l1[len(l1)-maxLags],
                               l2[i-maxLags], x12_rtl[0])
    return x12_rtl


def macUnit(newest, oldest, zero, acc):
    return acc + (newest * zero) - (oldest * zero)


def peak(data):
    temp = 0
    index = 0
    for i in range(0, len(data)):
        if data[i] > temp:
            index = i
            temp = data[i]
    return index


xnew = np.linspace(-maxLags+1, maxLags-1, 2*maxLags-1)
x = np.linspace(-len(x1)+1, len(x1)-1, 2*len(x1)-1)

# print(peak(npCorrelate(x1, x2)))
# print(peak(testCorrelate(x1, x2)))
# print(peak(rtlCorrelate(x1, x2)))
plt.plot(x, signal.correlate(x3, x4))
# plt.plot(x, testCorrelate(x3, x4))
plt.plot(xnew, rtlCorrelate(x3, x4))
plt.xlim([-50, 50])
plt.show()
