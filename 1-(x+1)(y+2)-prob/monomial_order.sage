R.<t, x, y> = PolynomialRing(QQ, order='lex')

mon_order = R.term_order()
print('单项式序类型：', mon_order)
print('变量优先级（从高到低）：', R.variable_names(), '\n')

m1 = t ^ 2 * x * y ^ 3
m2 = t ^ 2 * x ^ 2
m3 = t * x ^ 5 * y ^ 10
m4 = x ^ 3 * y
m5 = y ^ 100
m6 = t ^ 2 * x * y ^ 2  # 与 m1 比，仅 y 指数不同
m7 = 3 * t ^ 2 * x ^ 2  # 与 m2 比，仅系数不同
m8 = x ^ 2 * y ^ 99
m9 = t * x ^ 4 * y ^ 11
m10 = x ^ 2 * y ^ 2
m11 = 1919810 * y ^ 0
m12 = 114514 * y ^ 100
m13 = 2 * t ^ 2 * x ^ 2

monomials = [m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13]

print('单项式及其指数元组 (t, x, y)：')
for m in monomials:
    exp_tuple = m.exponents()[0]
    print(f'{m}  ->  {exp_tuple}')

print('\n按 lex 顺序从大到小排序：')
sorted_mons = sorted(monomials, reverse=True)
for m in sorted_mons:
    exp_tuple = m.exponents()[0]
    print(f'{m}  ->  {exp_tuple}')
'''
3*t^2*x^2  ->  (2, 2, 0)
2*t^2*x^2  ->  (2, 2, 0)
t^2*x^2  ->  (2, 2, 0)
t^2*x*y^3  ->  (2, 1, 3)
t^2*x*y^2  ->  (2, 1, 2)
t*x^5*y^10  ->  (1, 5, 10)
t*x^4*y^11  ->  (1, 4, 11)
x^3*y  ->  (0, 3, 1)
x^2*y^99  ->  (0, 2, 99)
x^2*y^2  ->  (0, 2, 2)
114514*y^100  ->  (0, 0, 100)
y^100  ->  (0, 0, 100)
1919810  ->  (0, 0, 0)
'''
