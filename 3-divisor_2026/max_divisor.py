from sage.all_cmdline import *
from time import perf_counter
from typing import List

# 1e16 只需要到47
prime_list = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151]


def dfs(idx, last_exp, current_val, current_divisors, n, global_max):
    '''
    idx: 当前使用的质数下标
    last_exp: 上一个质数的指数（保证非增）
    current_val: 当前构造的数
    current_divisors: 当前数的因数个数
    n: 上界
    global_max: 用列表包装以实现引用传递，global_max 存储最大因数个数和取得最大因数个数的最小值
    '''
    if current_divisors > global_max[0]:
        global_max[0] = current_divisors
        global_max[1] = current_val

    if idx >= len(prime_list):
        return

    p = prime_list[idx]
    # 如果 p > n // current_val，则无法再乘任何 p^e (e>=1)
    if p > n // current_val:
        return

    # 尝试指数 e 从 1 到 last_exp（含）
    for e in range(1, last_exp + 1):
        p_pow_e = p ** e
        # 检查 current_val * p^e 是否会超过 n
        # 使用逐步乘法避免溢出
        if current_val > n // p_pow_e:
            break
        new_val = current_val * p_pow_e
        new_divisors = current_divisors * (e + 1)
        dfs(idx + 1, e, new_val, new_divisors, n, global_max)


def max_divisors_upto(n):
    if n < 1:
        return 0
    global_max = [1, 1]  # d(1) = 1
    # 2^60 > 1e18
    dfs(0, 60, 1, 1, n, global_max)
    return global_max


def simple_check(result_list: List[List[int]]):
    for _, max_d, max_val in result_list:
        d_count = number_of_divisors(max_val)
        assert d_count == max_d


if __name__ == '__main__':
    result_list = []
    # 跑过一次范围46的，跑出一个解要6s了
    for e in range(1, 37):
        n = 10 ** e
        start_time = perf_counter()
        result = max_divisors_upto(n)
        end_time = perf_counter()
        print(f'n = 1e{e}: max d(k) = {result[0]}, max_val = {result[1]} (time: {end_time - start_time:.4f}s)')
        result_list.append([n, *result])
    print(result_list)

    start_time = perf_counter()
    simple_check(result_list)
    end_time = perf_counter()
    print(f'耗时：{end_time - start_time:.4f}s')
