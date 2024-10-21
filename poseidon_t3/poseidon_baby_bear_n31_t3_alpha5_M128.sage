import time

M_s = 128
N =  93
t = 3
alpha = 5
n = int(N / t) # n is log_2(prime)
R_F = 12
R_P = 19
prime = 2013265921 # 15 * 2^27 + 1
F = GF(prime)

timer_start = 0
timer_end = 0

round_constants = ['0x6630420a', '0x6e77b6b5', '0x085badf3', '0x06d17b3c', '0x2d2ca8bb', '0x3e585d13', '0x02c60c89', '0x3d73c75d', '0x44685392', '0x7545b9b7', '0x14abb4e4', '0x18bc8537', '0x204f93c1', '0x4081b364', '0x5cbe9f9b', '0x3cbf7bc2', '0x268a6eab', '0x6f243411', '0x2c7554f8', '0x5fab2c61', '0x111376ae', '0x2cfe0ebe', '0x36b2e729', '0x29909ad3', '0x28b820d6', '0x54323e5d', '0x324f30d3', '0x65f93d17', '0x4f8c73b2', '0x23d9fe34', '0x17909bd1', '0x74864a54', '0x7120da84', '0x4c238376', '0x28d0791e', '0x154f4ab1', '0x27cd497e', '0x32d48f16', '0x005e68b6', '0x686a839b', '0x3c24c8fb', '0x530722d5', '0x23fe799a', '0x235dc05f', '0x1912a500', '0x5bb5c2b0', '0x5742d7d7', '0x37477606', '0x1d600471', '0x427a8b2c', '0x378e1019', '0x77c59183', '0x1787f375', '0x3888bd46', '0x19f8e75d', '0x2b20ee30', '0x542facf5', '0x15a180f6', '0x70070f20', '0x6c39a0ff', '0x31b37ed9', '0x312b894e', '0x7126476a', '0x1c879970', '0x272cbd95', '0x0183dfe8', '0x67ea7dae', '0x14165ae7', '0x16c52e94', '0x2145c662', '0x5e1aa808', '0x3504210d', '0x0828c4e4', '0x2820e55d', '0x22e32ac0', '0x66ec39a3', '0x22c09c5e', '0x3d813bf3', '0x03e83fa3', '0x4b4e4247', '0x26889bfb', '0x06665c1a', '0x46bc0107', '0x669b08a0', '0x3418ce6a', '0x02ee61f5', '0x4175c981', '0x55237577', '0x52cefcdc', '0x6021d853', '0x1ff502b7', '0x1ff8ccbc', '0x1da37e17']

MDS_matrix=[['0x705af03f', '0x3baf41d4', '0x0e70e53b'],['0x57a98053', '0x041f6a49', '0x26e57800'],['0x4eee3e57', '0x2ea4062f', '0x247cf10b']]

MDS_matrix_field = matrix(F, t, t)

for i in range(0, t):
    for j in range(0, t):
        MDS_matrix_field[i, j] = F(int(MDS_matrix[i][j], 16))
round_constants_field = []
for i in range(0, (R_F + R_P) * t):
    round_constants_field.append(F(int(round_constants[i], 16)))


#MDS_matrix_field = MDS_matrix_field.transpose() # QUICK FIX TO CHANGE MATRIX MUL ORDER (BOTH M AND M^T ARE SECURE HERE!)

def print_words_to_hex(words):
    hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
    print(["{0:#0{1}x}".format(int(entry), hex_length) for entry in words])

def print_concat_words_to_large(words):
    hex_length = int(ceil(float(n) / 4))
    nums = ["{0:0{1}x}".format(int(entry), hex_length) for entry in words]
    final_string = "0x" + ''.join(nums)
    print(final_string)

def calc_equivalent_constants(constants):
    constants_temp = [constants[index:index+t] for index in range(0, len(constants), t)]

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    # Start moving round constants up
    # Calculate c_i' = M^(-1) * c_(i+1)
    # Split c_i': Add c_i'[0] AFTER the S-box, add the rest to c_i
    # I.e.: Store c_i'[0] for each of the partial rounds, and make c_i = c_i + c_i' (where now c_i'[0] = 0)
    num_rounds = R_F + R_P
    R_f = R_F / 2
    for i in range(num_rounds - 2 - R_f, R_f - 1, -1):
        inv_cip1 = list(vector(constants_temp[i+1]) * MDS_matrix_field_transpose.inverse())
        constants_temp[i] = list(vector(constants_temp[i]) + vector([0] + inv_cip1[1:]))
        constants_temp[i+1] = [inv_cip1[0]] + [0] * (t-1)


    return constants_temp

def calc_equivalent_matrices():
    # Following idea: Split M into M' * M'', where M'' is "cheap" and M' can move before the partial nonlinear layer
    # The "previous" matrix layer is then M * M'. Due to the construction of M', the M[0,0] and v values will be the same for the new M' (and I also, obviously)
    # Thus: Compute the matrices, store the w_hat and v_hat values

    MDS_matrix_field_transpose = MDS_matrix_field.transpose()

    w_hat_collection = []
    v_collection = []
    v = MDS_matrix_field_transpose[[0], list(range(1,t))]
    # print "M:", MDS_matrix_field_transpose
    # print "v:", v
    M_mul = MDS_matrix_field_transpose
    M_i = matrix(F, t, t)
    for i in range(R_P - 1, -1, -1):
        M_hat = M_mul[list(range(1,t)), list(range(1,t))]
        w = M_mul[list(range(1,t)), [0]]
        v = M_mul[[0], list(range(1,t))]
        v_collection.append(v.list())
        w_hat = M_hat.inverse() * w
        w_hat_collection.append(w_hat.list())

        # Generate new M_i, and multiplication M * M_i for "previous" round
        M_i = matrix.identity(t)
        M_i[list(range(1,t)), list(range(1,t))] = M_hat
        #M_mul = MDS_matrix_field_transpose * M_i

        test_mat = matrix(F, t, t)
        test_mat[[0], list(range(0, t))] = MDS_matrix_field_transpose[[0], list(range(0, t))]
        test_mat[[0], list(range(1, t))] = v
        test_mat[list(range(1, t)), [0]] = w_hat
        test_mat[list(range(1,t)), list(range(1,t))] = matrix.identity(t-1)

        # print M_mul == M_i * test_mat
        M_mul = MDS_matrix_field_transpose * M_i
        #return[M_i, test_mat]


        #M_mul = MDS_matrix_field_transpose * M_i
        #exit()
    #exit()
        

    # print [M_i, w_hat_collection, MDS_matrix_field_transpose[0, 0], v.list()]
    return [M_i, v_collection, w_hat_collection, MDS_matrix_field_transpose[0, 0]]

def cheap_matrix_mul(state_words, v, w_hat, M_0_0):
    state_words_new = [0] * t
    # row_1 = [M_0_0] + v
    # print "r1:", row_1
    # state_words_new[0] = sum([row_1[i] * state_words[i] for i in range(0, t)])
    # mul_column = [(state_words[0] * w_hat[i]) for i in range(0, t-1)]
    # add_column = [(mul_column[i] + state_words[i+1]) for i in range(0, t-1)]
    # state_words_new = [state_words_new[0]] + add_column
    # print "1:", state_words_new
    column_1 = [M_0_0] + w_hat
    state_words_new[0] = sum([column_1[i] * state_words[i] for i in range(0, t)])
    mul_row = [(state_words[0] * v[i]) for i in range(0, t-1)]
    add_row = [(mul_row[i] + state_words[i+1]) for i in range(0, t-1)]
    state_words_new = [state_words_new[0]] + add_row

    # test_mat = matrix(F, t, t)
    # # print "r2:", matrix([M_0_0] + v).list()
    # # print row_1 == matrix([M_0_0] + v).list()
    # test_mat[[0], range(0, t)] = matrix([M_0_0] + v)
    # test_mat[range(1, t), [0]] = matrix(w_hat).transpose()
    # test_mat[range(1,t), range(1,t)] = matrix.identity(t-1)
    # state_words_new = list(vector(state_words) * test_mat)
    # print "2:", state_words_new

    return state_words_new

def perm(input_words):
    round_constants_field_new = calc_equivalent_constants(round_constants_field)
    [M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()
    #[M_i, test_mat] = calc_equivalent_matrices()
    
    global timer_start, timer_end

    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    # Initial constants addition
    for i in range(0, t):
        state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
    # First full matrix multiplication
    state_words = list(vector(state_words) * M_i)
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        #state_words = list(vector(state_words) * M_i)
        state_words[0] = (state_words[0])^3
        # Moved constants addition
        if r < (R_P - 1):
            round_constants_round_counter += 1
            state_words[0] = state_words[0] + round_constants_field_new[round_constants_round_counter][0]
        # Optimized multiplication with cheap matrices
        state_words = cheap_matrix_mul(state_words, v_collection[R_P - r - 1], w_hat_collection[R_P - r - 1], M_0_0)
    round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    timer_end = time.time()
    
    return state_words

def perm_original(input_words):
    round_constants_field_new = [round_constants_field[index:index+t] for index in range(0, len(round_constants_field), t)]

    global timer_start, timer_end
    
    timer_start = time.time()

    R_f = int(R_F / 2)

    round_constants_round_counter = 0

    state_words = list(input_words)

    # First full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        state_words[0] = (state_words[0])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^3
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1
    
    timer_end = time.time()

    return state_words

input_words = []
for i in range(0, t):
    input_words.append(F(i))

output_words = None
num_iterations = 10
total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm_original(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for unoptimized:", average_time)

print("Input:")
print_words_to_hex(input_words)
print("Output:")
print_words_to_hex(output_words)

# print("Input (concat):")
# print_concat_words_to_large(input_words)
# print("Output (concat):")
# print_concat_words_to_large(output_words)

total_time_passed = 0
for i in range(0, num_iterations):
    output_words = perm(input_words)
    time_passed = timer_end - timer_start
    total_time_passed += time_passed
average_time = total_time_passed / float(num_iterations)
print("Average time for optimized:", average_time)

print("Input:")
print_words_to_hex(input_words)
print("Output:")
print_words_to_hex(output_words)

# print("Input (concat):")
# print_concat_words_to_large(input_words)
# print("Output (concat):")
# print_concat_words_to_large(output_words)



#----snippet to print optimized constants used in this code

round_constants_field_new = calc_equivalent_constants(round_constants_field)
[M_i, v_collection, w_hat_collection, M_0_0] = calc_equivalent_matrices()

# Flags
write_file = True

FILE = None
if write_file == True:
    FILE = open("optimized_poseidon_params_n%d_t%d_alpha%d_M%d.txt"%(n, t, alpha, M_s),'w')
    FILE.write("Params: n=%d, t=%d, alpha=%d, M=%d, R_F=%d, R_P=%d\n"%(n, t, alpha, M_s, R_F,R_P))
    FILE.write("Modulus = %d\n"%(prime))
#    FILE.write("Number of S-boxes: %d\n"%(ROUND_NUMBERS[2]))
    # FILE.write("Number of S-boxes per state element: %d\n"%(ceil(ROUND_NUMBERS[2] / float(NUM_CELLS))))

def print_round_constants_optimized(round_constants_optimized,n):
    if write_file == True:
            FILE.write("Optimized Round constants for GF(p):\n")

#   hex_length = int(ceil(float(n) / 4)) + 2 # +2 for "0x"
#    print(["{0:#0{1}x}".format(hex(entry), hex_length) for entry in round_constants_optimized])

    if write_file == True:
        FILE.write(str([entry for entry in round_constants_optimized]) + "\n\n")

def print_pre_sparse(M, t):       
    matrix_string = "["
    for i in range(0, t):
        matrix_string += str([entry for entry in M[i]])
        if i < (t-1):
            matrix_string += ","
    matrix_string += "]"
   # print("Pre_sparse MDS matrix:\n", matrix_string)
    if write_file == True:
        FILE.write("Pre_sparse MDS matrix::\n" + str(matrix_string)+ "\n\n")

def print_v(v_collection):
    if write_file == True:
        FILE.write("v collection: vector dimension: 1 x "+str(t-1)+"\n ")
        FILE.write(str([entry for entry in v_collection]) + "\n \n ")

def print_w_hat(w_hat_collection):
    if write_file == True:
        FILE.write("w_hat_collection:  vector dimension:" +str(t-1)+ " x 1" + "\n")
        FILE.write(str([entry for entry in w_hat_collection]) + "\n\n")

print_round_constants_optimized(round_constants_field_new, n)
print_pre_sparse(M_i, t)

if write_file == True:
    FILE.write("M_0_0:\n " + str(M_0_0)+ "\n\n")

print_v(v_collection)
print_w_hat(w_hat_collection)


if write_file == True:
    FILE.close()