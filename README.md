# SimpleANN

Simple Feed Forward Neural Network with PSO for optimal weights

Transfer function: h[x(n)] -z*exp(-z^2/2)

z = norm((x(n)-c_j)/r_j)

PSO's particles X = [
    [w_1, r_11 , r_1D, c_11, ..., c_1D]
    [w_N, r_N1 , r_ND, c_N1, ..., c_ND]
]

N: hidden nodes
D: features

w: output weights
r: radio weight
c: center weight


## Execution

config.txt input must include number of columns existing from dataset input.m

* Simple execution (all columns): ´main´

* Selected execution (columns 1, 4 and 6) ´main config.txt´

  * config.txt file must include in the first line ´1 4 6´