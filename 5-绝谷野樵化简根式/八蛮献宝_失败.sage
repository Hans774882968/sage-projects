def solve_equation(c1, c2, c3, c4, c5, c6, c7, c8, pw, print_G=False, print_last_poly=False):
    '''
    解方程`(a+b*sqrt(2)+c*sqrt(3)+d*sqrt(5))^pw == c1+c2*sqrt(2)+c3*sqrt(3)+c4*sqrt(5)+c5*sqrt(6)+c6*sqrt(10)+c7*sqrt(15)+c8*sqrt(30)`

    :param c1: 常数项
    :param c2: 根号2的系数
    :param c3: 根号3的系数
    :param c4: 根号5的系数
    :param c5: 根号6的系数
    :param c6: 根号10的系数
    :param c7: 根号15的系数
    :param c8: 根号30的系数
    :param pw: 幂
    :param print_G: 是否打印Grobner基
    :param print_last_poly: 是否打印Grobner基最后一个元素的因式分解
    '''
    S.<a, b, c, d, e, f, g, h, s2, s3, s5, s6, s10, s15, s30> = PolynomialRing(QQ, order='lex')
    I = S.ideal([s2 ^ 2 - 2, s3 ^ 2 - 3, s5 ^ 2 - 5])
    s6 = s2 * s3
    s10 = s2 * s5
    s15 = s3 * s5
    s30 = s2 * s3 * s5
    Quo = S.quotient(I)
    expr = Quo(a + b * s2 + c * s3 + d * s5 + e * s6 + f * s10 + g * s15 + h * s30)
    expanded = expr ^ pw
    rep = expanded.lift()
    v1 = rep.coefficient({s2: 0, s3: 0, s5: 0})
    v2 = rep.coefficient({s2: 1, s3: 0, s5: 0})
    v3 = rep.coefficient({s2: 0, s3: 1, s5: 0})
    v4 = rep.coefficient({s2: 0, s3: 0, s5: 1})
    v5 = rep.coefficient({s2: 1, s3: 1, s5: 0})
    v6 = rep.coefficient({s2: 1, s3: 0, s5: 1})
    v7 = rep.coefficient({s2: 0, s3: 1, s5: 1})
    v8 = rep.coefficient({s2: 1, s3: 1, s5: 1})
    print(v1)
    print(v2)
    print(v3)
    print(v4)
    print(v5)
    print(v6)
    print(v7)
    print(v8)
    G = ideal(v1 - c1, v2 - c2, v3 - c3, v4 - c4, v5 - c5, v6 - c6, v7 - c7, v8 - c8).groebner_basis(algorithm='singular:slimgb')
    if print_G:
        for i, gro in enumerate(G):
            print(f'G[{i}] =', gro)
    last_var_poly = G[-1].factor()
    if print_last_poly:
        print(last_var_poly)
    last_var = h
    sols = solve(SR(last_var_poly), SR(last_var))
    sols = [sol.rhs() for sol in sols if sol.rhs().is_real()]
    var_list = (a, b, c, d, e, f, g, h)
    return G, last_var, var_list, s2, s3, s5, sols, Quo


def back_substitution_with_a_sol(G, last_var, var_list, s2, s3, s5, current_sol):
    solved_vars = {last_var}

    # 从倒数第二项开始向前代入
    for i in range(len(G) - 2, -1, -1):
        g = G[i]
        '''
        将已知变量代入
        LLM 的代码在这里报错 TypeError: keys do not match self's parent
        问 LLM ，它胡说八道。但我自己 debug 发现，只需要这么写：
        new_var = next((item for item in var_list if item == rv), None)
        就能让变量的类型正确，这代码也就能跑通了
        '''
        g_sub = g.subs(current_sol)
        if not g_sub:
            continue
        remaining_vars = [v for v in g_sub.variables() if v not in solved_vars]

        if len(remaining_vars) == 1:
            rv = remaining_vars[0]
            # 转为符号表达式求解
            g_SR = SR(g_sub)
            try:
                sols_v = solve(g_SR == 0, SR(rv))
                if sols_v:
                    sol_val = sols_v[0].rhs()
                    new_var = next((item for item in var_list if item == rv), None)
                    current_sol[new_var] = QQbar(sol_val) if sol_val in QQ else sol_val
                    solved_vars.add(new_var)
                else:
                    break  # 无解
            except Exception as e:
                print('解方程遇到报错', e)
                break  # 求解失败
        elif len(remaining_vars) == 0:
            # 已满足，跳过
            continue
        else:
            # 多变量，暂时跳过（实际中 Gröbner 基应为三角形）
            continue

    ret = {str(k): v for k, v in current_sol.items()}
    return ret


def back_substitution(G, d, var_list, s2, s3, s5, sols):
    all_solutions = []
    for val in sols:
        current_sol = {d: QQbar(val) if val in QQ else val}
        current_sol = back_substitution_with_a_sol(G, d, var_list, s2, s3, s5, current_sol)
        all_solutions.append(current_sol)
    return all_solutions


def solve_directly(c1, c2, c3, c4, c5, c6, c7, c8):
    a, b, c, d, e, f, g, h = var('a b c d e f g h')
    v1 = a ^ 3 + 6 * a * b ^ 2 + 9 * a * c ^ 2 + 15 * a * d ^ 2 + 18 * a * e ^ 2 + 30 * a * f ^ 2 + 45 * a * g ^ 2 + 90 * a * h ^ 2 + 36 * b * c * e + 60 * b * d * f + 180 * b * g * h + 90 * c * d * g + 180 * c * f * h + 180 * d * e * h + 180 * e * f * g
    v2 = 3 * a ^ 2 * b + 18 * a * c * e + 30 * a * d * f + 90 * a * g * h + 2 * b ^ 3 + 9 * b * c ^ 2 + 15 * b * d ^ 2 + 18 * b * \
        e ^ 2 + 30 * b * f ^ 2 + 45 * b * g ^ 2 + 90 * b * h ^ 2 + 90 * c * d * h + 90 * c * f * g + 90 * d * e * g + 180 * e * f * h
    v3 = 3 * a ^ 2 * c + 12 * a * b * e + 30 * a * d * g + 60 * a * f * h + 6 * b ^ 2 * c + 60 * b * d * h + 60 * b * f * g + 3 * \
        c ^ 3 + 15 * c * d ^ 2 + 18 * c * e ^ 2 + 30 * c * f ^ 2 + 45 * c * g ^ 2 + 90 * c * h ^ 2 + 60 * d * e * f + 180 * e * g * h
    v4 = 3 * a ^ 2 * d + 12 * a * b * f + 18 * a * c * g + 36 * a * e * h + 6 * b ^ 2 * d + 36 * b * c * h + 36 * b * e * g + 9 * c ^ 2 * d + 36 * c * e * f + 5 * d ^ 3 + 18 * d * e ^ 2 + 30 * d * f ^ 2 + 45 * d * g ^ 2 + 90 * d * h ^ 2 + 180 * f * g * h
    v5 = 3 * a ^ 2 * e + 6 * a * b * c + 30 * a * d * h + 30 * a * f * g + 6 * b ^ 2 * e + 30 * b * d * g + 60 * b * f * h + 9 * c ^ 2 * e + 30 * c * d * f + 90 * c * g * h + 15 * d ^ 2 * e + 6 * e ^ 3 + 30 * e * f ^ 2 + 45 * e * g ^ 2 + 90 * e * h ^ 2
    v6 = 3 * a ^ 2 * f + 6 * a * b * d + 18 * a * c * h + 18 * a * e * g + 6 * b ^ 2 * f + 18 * b * c * g + 36 * b * e * h + 9 * c ^ 2 * f + 18 * c * d * e + 15 * d ^ 2 * f + 90 * d * g * h + 18 * e ^ 2 * f + 10 * f ^ 3 + 45 * f * g ^ 2 + 90 * f * h ^ 2
    v7 = 3 * a ^ 2 * g + 12 * a * b * h + 6 * a * c * d + 12 * a * e * f + 6 * b ^ 2 * g + 12 * b * c * f + 12 * b * d * e + 9 * c ^ 2 * g + 36 * c * e * h + 15 * d ^ 2 * g + 60 * d * f * h + 18 * e ^ 2 * g + 30 * f ^ 2 * g + 15 * g ^ 3 + 90 * g * h ^ 2
    v8 = 3 * a ^ 2 * h + 6 * a * b * g + 6 * a * c * f + 6 * a * d * e + 6 * b ^ 2 * h + 6 * b * c * d + 12 * b * e * f + 9 * c ^ 2 * h + 18 * c * e * g + 15 * d ^ 2 * h + 30 * d * f * g + 18 * e ^ 2 * h + 30 * f ^ 2 * h + 45 * g ^ 2 * h + 30 * h ^ 3
    sols = solve([
        v1 - c1, v2 - c2, v3 - c3, v4 - c4, v5 - c5, v6 - c6, v7 - c7, v8 - c8
    ])
    print(sols)


# 跑不出结果
solve_directly(2848 / 135, 1213 / 60, 704 / 45, 431 / 75, 101 / 12, 443 / 75, 229 / 50, 2123 / 900)
G, last_var, var_list, s2, s3, s5, sols, _ = solve_equation(2848 / 135, 1213 / 60, 704 / 45, 431 / 75, 101 / 12, 443 / 75, 229 / 50, 2123 / 900, 3, True, True)
