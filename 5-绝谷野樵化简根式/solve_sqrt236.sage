def solve_equation(c1, c2, c3, c4, pw, solve_last_poly=False):
    '''
    解方程`(a+b*sqrt(2)+c*sqrt(3)+d*sqrt(6))^pw == c1+c2*sqrt(2)+c3*sqrt(3)+c4*sqrt(6)`

    :param c1: 常数项
    :param c2: 根号2的系数
    :param c3: 根号3的系数
    :param c4: 根号6的系数
    :param pw: 幂
    :param solve_last_poly: 是否尝试解Grobner基的最后一个元素的方程
    '''
    S.<a, b, c, d, s2, s3> = PolynomialRing(QQ, order='lex')
    I = S.ideal([s2 ^ 2 - 2, s3 ^ 2 - 3])
    Quo = S.quotient(I)
    expr = Quo(a + b * s2 + c * s3 + d * s2 * s3)
    expanded = expr ^ pw
    rep = expanded.lift()
    # 现在 rep 是 a, b, c, d, s2, s3 的多项式，其中 s2, s3 次数 <= 1
    v1 = rep.coefficient({s2: 0, s3: 0})
    v2 = rep.coefficient({s2: 1, s3: 0})
    v3 = rep.coefficient({s2: 0, s3: 1})
    v4 = rep.coefficient({s2: 1, s3: 1})
    G = ideal(v1 - c1, v2 - c2, v3 - c3, v4 - c4).groebner_basis()
    for i, g in enumerate(G):
        print(f'G[{i}] =', g)
    last_var_poly = G[-1].factor()
    print(last_var_poly)
    if solve_last_poly:
        sols = solve(SR(last_var_poly), SR(d))
        sols = [sol.rhs() for sol in sols if sol.rhs().is_real()]
        print(sols)
    var_list = (a, b, c, d)
    return G, d, var_list


def eq1_conclusion(G, d):
    for i in range(len(G) - 2, -1, -1):
        g = G[i]
        sol_poly = g.subs({d: 7 / 6})
        print(sol_poly)


def eq2_conclusion(G, d):
    for i in range(len(G) - 2, -1, -1):
        g = G[i]
        sol_poly = g.subs({d: 1 / 6})
        print(sol_poly)


def eq3_conclusion(G, d, var_list):
    '''
    解法1，取 d = 0 ，解得 `c = 0, b = 7/6*sqrt(3), a = sqrt(3)`

    :param G: Grobner 基
    :param d: 字典序最大的变量
    :param var_list: 所有变量
    '''
    _, b, _, _ = var_list
    for i in range(len(G) - 2, -1, -1):
        g = G[i]
        sol_poly = g.subs({d: 0})
        print(sol_poly)
    poly1 = G[1].subs({d: 0})
    sols1 = solve(SR(poly1), SR(b))
    print(sols1)
    poly0 = G[0].subs({d: 0, b: 7 / 6 * sqrt(3)})
    print(poly0)


def eq3_conclusion2(G, d):
    '''
    发现取 d = 7/6 比取 d = 0 更容易解，而且能得到正确答案。
    两种方法都解得`(sqrt3 + 7/6 * sqrt6) ^ 2 = 67/6 + 7sqrt2`
    `c - 1`
    `10199/13824*b`
    `7/6*b^2`
    `b^4 - 67/12*b^2`
    `a + 4/7*b^3 + 80/21*b`

    :param G: Grobner 基
    :param d: 字典序最大的变量
    '''
    for i in range(len(G) - 2, -1, -1):
        g = G[i]
        sol_poly = g.subs({d: 7 / 6})
        print(sol_poly)


def eq4_conclusion(G, d, var_list):
    '''
    解得`d = 3/4, c = 4/3, b = 0, a = 1`，即`(1+4/3*sqrt3+3/4*sqrt6)^2 = 233 / 24 + 6*sqrt2 + 8/3*sqrt3 + 3/2*sqrt6`

    :param G: Grobner 基
    :param d: 字典序最大的变量
    '''
    _, b, c, _ = var_list
    for i in range(len(G) - 2, -1, -1):
        g = G[i]
        sol_poly = g.subs({d: 3 / 4})
        print(sol_poly)
    poly1 = G[1].subs({d: 3 / 4, c: 4 / 3})
    print(poly1)
    poly0 = G[0].subs({d: 3 / 4, c: 4 / 3})
    print(poly0)


G, d, _ = solve_equation(1028, 1159 / 2, 4336 / 9, 6551 / 18, 3, True)
print('-' * 10 + ' 人工写代码解Grobner基给我们的方程1 ' + '-' * 10)
eq1_conclusion(G, d)
'''
首先筛选出了唯一的实数解 d = 7/6
然后回代解得：
c = 4/3
b = 3/2
a = 8
'''

print()
G, d, _ = solve_equation(2, 4 / 3, 1, 2 / 3, 2, True)
print('-' * 10 + ' 人工写代码解Grobner基给我们的方程2 ' + '-' * 10)
eq2_conclusion(G, d)
'''
d = 1/6
c = 1/3
b = 1/2
a = 1
如果 d 取相反数，则 a~c 也一并取相反数
'''

print()
G, d, var_list = solve_equation(67 / 6, 7, 0, 0, 2, True)
eq3_conclusion(G, d, var_list)
eq3_conclusion2(G, d)

G, d, var_list = solve_equation(233 / 24, 6, 8 / 3, 3 / 2, 2, True)
eq4_conclusion(G, d, var_list)
