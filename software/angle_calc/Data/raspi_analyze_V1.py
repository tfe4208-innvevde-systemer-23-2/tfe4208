import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as signal


def raspi_import(path, channels=5):
    with open(path, 'r') as fid:
        sample_period = np.fromfile(fid, count=1, dtype=float)[0]
        data = np.fromfile(fid, dtype=np.uint16)
        data = data.reshape((-1, channels))
    return sample_period, data


def theta(lags):  # Calculate the incident angle
    if lags[0]-lags[1]-lags[2] < 0:
        return (np.arctan(np.sqrt(3)*(lags[0]+lags[1])/(lags[0]-lags[1]-2*lags[2]))+np.pi)*180/np.pi
    else:
        return np.arctan(np.sqrt(3)*(lags[0]+lags[1])/(lags[0]-lags[1]-2*lags[2]))*180/np.pi


sample_period, data = raspi_import(
    'en_mling2.bin')  # Import data from binary file

data = signal.detrend(data, axis=0)  # removes DC component for each channel
num_of_samples = data.shape[0]  # returns shape of matrix

# Cut out garbage data at the start
x1 = (data[:, 4]/(4095/2.95))[5000:]
x2 = (data[:, 3]/(4095/2.95))[5000:]
x3 = (data[:, 2]/(4095/2.95))[5000:]
x4 = (data[:, 1]/(4095/2.95))[5000:]
x5 = (data[:, 0]/(4095/2.95))[5000:]

I = np.linspace(-4*len(x1), 4*len(x1)-1, 4*(2*(len(x1)-1)))  # 4x upsampling
l = np.linspace(-4*len(x1), 4*len(x1)-1, 2*len(x1)-1)

x21 = np.abs(np.interp(I, l, signal.correlate(x2, x1)))
x31 = np.abs(np.interp(I, l, signal.correlate(x3, x1)))
x41 = np.abs(np.interp(I, l, signal.correlate(x4, x1)))
x32 = np.abs(np.interp(I, l, signal.correlate(x3, x2)))
x42 = np.abs(np.interp(I, l, signal.correlate(x4, x2)))
x43 = np.abs(np.interp(I, l, signal.correlate(x4, x3)))
# x04 = np.abs(np.interp(I, l, signal.correlate(x0, x4)))


lags = [round(I[x21.argmax()])/31250, round(I[x31.argmax()])/31250, round(I[x41.argmax()])/31250,
        round(I[x32.argmax()])/31250, round(I[x42.argmax()])/31250, round(I[x43.argmax()])/31250]

print("Lags: ", lags)
# print("Calculated angle: ", round(theta(lags), 1))

plt.figure(figsize=(6, 3))
plt.plot(x1)
plt.plot(x2)
plt.plot(x3)
plt.xlabel("Punktprøve")
plt.ylabel("Spenning [V]")
plt.show()

plt.figure(figsize=(8, 4))
plt.plot(I, x01)
plt.xlabel("Forskyvning l")
plt.ylabel("Krysskorrelasjon")
plt.show()
