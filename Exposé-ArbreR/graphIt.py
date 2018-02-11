import numpy as np
import matplotlib.pyplot as plt

latitude, longitude = np.loadtxt("IndexSlideMonuments", unpack=True)

plt.xlabel('longitude')
plt.ylabel('latitude')
#plt.axis([1.0, 2.4, , ymax]
plt.plot(longitude, latitude, 'o')
plt.savefig('default2')
plt.show()
