import time

M_s = 128
N = 192
t = 3
alpha = 5
n = int(N / t)  # n is log_2(prime)
R_F = 8 
R_P = 26
prime = 2^64 - 2^32 + 1 
F = GF(prime)

timer_start = 0
timer_end = 0

round_constants = ['0xd139a9a5a7013b20', '0xf42fd8b72c9b8f4a', '0x34ea4af844e9a96e', '0x79bea190675a7751', '0x3a23dbd66cc58a4f', '0x7970a92572c3239b', '0x811bdfddc8eb1a3d', '0xfa87fe188c520cc9', '0x1f2abe4010fa60b8', '0xaf7d4b15e6583f91', '0xb52b91ecb22d0cb5', '0x337467baedbb3034', '0x65ae540c19485610', '0xb6dace571987f2a8', '0xcb498f1e96f057d9', '0x1d2462686b0206e2', '0xc295ed65ddcfb989', '0x49e26b5e3e5edabf', '0xbd107cbcce1dfc6d', '0x60f3c31c7a0f3fca', '0x5bda770129e6aa2c', '0x6cc21cbb2b70152b', '0x3542a1279c49cc0c', '0x681970c9fd6fd667', '0xd43cc9accfe64efa', '0x04f6e74758ba6ac0', '0xd01c89be54c7b429', '0xf2d049f58c79c66a', '0x81548c55cfabdeb6', '0xe48b50b9370f1b7f', '0xf1848e7dd8933a8a', '0xff5a4a05989054fa', '0x5751aa09248317de', '0x27f7ab040fa5e1bb', '0x25f26114ba946ece', '0x66fdfd6c75f0c9b5', '0xaa0c9da742c073cd', '0x4f30190d5aef1e34', '0x7757151c0e83606b', '0x0040f9df7bad804a', '0x93c8ccf38bb78eda', '0xbea6bdb84494be05', '0xc32cad2a444aa534', '0x56ba0b739606c19b', '0x6d1b3a4ce7ae4f6c', '0x2ac6043ebea85eba', '0x879e053458b1bd22', '0xa96543726d2366cf', '0xd9fa38daf10c5ca4', '0xd3ad4a0cf194b2c9', '0x5f0d54778291d76e', '0x5e5ebac4199bddda', '0xa5ccff652d7e0379', '0x5cb52d1e76899a03', '0x2522c75b869c05e9', '0x00d02813e174cd15', '0x6e0e50259ab1ef1c', '0xc0a433ed0022c05a', '0xc20adc8524fc7afd', '0x859af64e17a09d0a', '0xed20f475e5a99ccd', '0x6430de2936b8e121', '0x48fc7588191549eb', '0x7bd5d150a3d24b5b', '0xb2fd5452ead18106', '0xb5ba1e18cdd3f509', '0x666092d16351dec9', '0x9f9d3368de0bad44', '0xbe146073e1b9f837', '0x783e09fef4dc04e4', '0x93fdf14215ad2c22', '0x8beb68bbbea06b27', '0x1c9c4911a6136885', '0xc47a357b73b66938', '0x7d029de7e09c2e74', '0x49f4678c9a58de75', '0xbe1cafacf9731a65', '0x06bc732a62dbd55e', '0xbc93a152f23569c2', '0x0f6ea026c067272c', '0x04ee156e3f45f4da', '0xd582a56e20101a6a', '0x6661e6f260e589a0', '0x33ce260f7c6c48a1', '0xe0bf3b16bc0fef5b', '0xcc096a755386a711', '0x36e646b392036776', '0x9db335f003f877c4', '0x236b9d6822e85d55', '0xce602f155bb310c8', '0x41bee88b6d06cdf3', '0x5521cea11bf449e2', '0xe377cfa8da9522b4', '0x0cb6bb16ada973eb', '0x304e846c7a1b9d3a', '0x8079c87d4c3722ba', '0x9f8203bbae5511a4', '0x81fa8101218dac3a', '0x7b9922110831c31b', '0xe08b931efb613b96', '0xa9be231880354cd6', '0xe9b13b092cd34b7c']

MDS_matrix=[['0x347d28a488a22a3b', '0x7eed34eb862035f3', '0xe1b338a1a769b0bb'],['0x21e6dc6f53709a9b', '0x5776844d2ec8cc1f', '0x24dddf5a998807f5'],['0x675d71f9cd558c68', '0x58baaf1afb376561', '0xe7ddb4f307541571']]

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
            state_words[i] = (state_words[i])^alpha
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
        state_words[0] = (state_words[0])^alpha
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
            state_words[i] = (state_words[i])^alpha
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
            state_words[i] = (state_words[i])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Middle partial rounds
    for r in range(0, R_P):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        state_words[0] = (state_words[0])^alpha
        state_words = list(MDS_matrix_field * vector(state_words))
        round_constants_round_counter += 1

    # Last full rounds
    for r in range(0, R_f):
        # Round constants, nonlinear layer, matrix multiplication
        for i in range(0, t):
            state_words[i] = state_words[i] + round_constants_field_new[round_constants_round_counter][i]
        for i in range(0, t):
            state_words[i] = (state_words[i])^alpha
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