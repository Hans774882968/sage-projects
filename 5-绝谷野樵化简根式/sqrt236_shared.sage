def solve_equation236(c1, c2, c3, c4, pw, print_G=False, print_last_poly=False):
    '''
    解方程`(a+b*sqrt(2)+c*sqrt(3)+d*sqrt(6))^pw == c1+c2*sqrt(2)+c3*sqrt(3)+c4*sqrt(6)`

    :param c1: 常数项
    :param c2: 根号2的系数
    :param c3: 根号3的系数
    :param c4: 根号6的系数
    :param pw: 幂
    :param print_G: 是否打印Grobner基
    :param print_last_poly: 是否打印Grobner基最后一个元素的因式分解
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
    if print_G:
        for i, g in enumerate(G):
            print(f'G[{i}] =', g)
    last_var_poly = G[-1].factor()
    if print_last_poly:
        print(last_var_poly)
    last_var = d
    sols = solve(SR(last_var_poly), SR(last_var))
    sols = [sol.rhs() for sol in sols if sol.rhs().is_real()]
    var_list = (a, b, c, d)
    return G, last_var, var_list, s2, s3, sols, Quo


def back_substitution_with_a_sol(G, last_var, var_list, current_sol):
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


def back_substitution(G, last_var, var_list, sols):
    all_solutions = []
    for val in sols:
        current_sol = {last_var: QQbar(val) if val in QQ else val}
        current_sol = back_substitution_with_a_sol(G, last_var, var_list, current_sol)
        all_solutions.append(current_sol)
    return all_solutions


def get_expr_from_sol236(sol, s2, s3):
    return sol['a'] + sol['b'] * s2 + sol['c'] * s3 + sol['d'] * s2 * s3
