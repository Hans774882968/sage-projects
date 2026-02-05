import re
load('5-绝谷野樵化简根式/sqrt236_shared.sage')


def solve_equation_phase1(c1):
    R.<x> = QQ[]
    K.<s3> = NumberField([x ^ 2 - 3])
    L.<s12> = K.extension(x ^ 2 - 2 * s3)
    S.<a, b, c> = PolynomialRing(L)
    expr = ((a + b * s3 + c * s12) ^ 3 - c1) ^ 2
    print(expr)


def get_eqs(s):
    s_clean = re.sub(r'\s+', ' ', s.strip())
    terms = [term.strip() for term in s_clean.split('+') if term.strip()]

    type1 = []  # 无 s3, 无 s12
    type2 = []  # 有 s3, 无 s12
    type3 = []  # 无 s3, 有 s12
    type4 = []  # 有 s3, 有 s12

    for term in terms:
        has_s3 = 's3' in term
        has_s12 = 's12' in term

        if has_s3 and has_s12:
            coeff = term.replace('*s3*s12', '')
            type4.append(coeff)
        elif has_s3:
            coeff = term.replace('*s3', '')
            type2.append(coeff)
        elif has_s12:
            coeff = term.replace('*s12', '')
            type3.append(coeff)
        else:
            type1.append(term)

    eq1 = ' + '.join(type1) if type1 else '0'
    eq2 = ' + '.join(type2) if type2 else '0'
    eq3 = ' + '.join(type3) if type3 else '0'
    eq4 = ' + '.join(type4) if type4 else '0'
    return eq1, eq2, eq3, eq4


def solve_equation_phase2(c2, c3):
    s = '''
    a^6 + 6*s3*a^5*b + 45*a^4*b^2 + 60*s3*a^3*b^3 + 135*a^2*b^4 + 54*s3*a*b^5 + 27*b^6
    + 6*s12*a^5*c + 30*s3*s12*a^4*b*c + 180*s12*a^3*b^2*c + 180*s3*s12*a^2*b^3*c
    + 270*s12*a*b^4*c + 54*s3*s12*b^5*c + 30*s3*a^4*c^2 + 360*a^3*b*c^2 + 540*s3*a^2*b^2*c^2
    + 1080*a*b^3*c^2 + 270*s3*b^4*c^2 + 40*s3*s12*a^3*c^3 + 360*s12*a^2*b*c^3 +
    360*s3*s12*a*b^2*c^3 + 360*s12*b^3*c^3 + 180*a^2*c^4 + 360*s3*a*b*c^4 +
    540*b^2*c^4 + 72*s12*a*c^5 + 72*s3*s12*b*c^5 + 24*s3*c^6 + (-2)*a^3 + (-6*s3)*a^2*b
    + (-18)*a*b^2 + (-6*s3)*b^3 + (-6*s12)*a^2*c + (-12*s3*s12)*a*b*c + (-18*s12)*b^2*c
    + (-12*s3)*a*c^2 + (-36)*b*c^2 + (-4*s3*s12)*c^3 + 1
    '''
    eq1, eq2, eq3, eq4 = get_eqs(s)
    print(eq1)
    print(eq2)
    print(eq3)
    print(eq4)

    S.<a, b, c> = PolynomialRing(QQ, order='lex')
    eq1 = a ^ 6 + 45 * a ^ 4 * b ^ 2 + 135 * a ^ 2 * b ^ 4 + 27 * b ^ 6 + 360 * a ^ 3 * b * c ^ 2 + 1080 * a * b ^ 3 * c ^ 2 + 180 * a ^ 2 * c ^ 4 + 540 * b ^ 2 * c ^ 4 + (-2) * a ^ 3 + (-18) * a * b ^ 2 + (-36) * b * c ^ 2 + 1 - c2
    eq2 = 6 * a ^ 5 * b + 60 * a ^ 3 * b ^ 3 + 54 * a * b ^ 5 + 30 * a ^ 4 * c ^ 2 + 540 * a ^ 2 * b ^ 2 * c ^ 2 + 270 * b ^ 4 * c ^ 2 + 360 * a * b * c ^ 4 + 24 * c ^ 6 + (-6) * a ^ 2 * b + (-6) * b ^ 3 + (-12) * a * c ^ 2 - c3
    eq3 = 6 * a ^ 5 * c + 180 * a ^ 3 * b ^ 2 * c + 270 * a * b ^ 4 * c + 360 * a ^ 2 * b * c ^ 3 + 360 * b ^ 3 * c ^ 3 + 72 * a * c ^ 5 + (-6) * a ^ 2 * c + (-18) * b ^ 2 * c
    eq4 = 30 * a ^ 4 * b * c + 180 * a ^ 2 * b ^ 3 * c + 54 * b ^ 5 * c + 40 * a ^ 3 * c ^ 3 + 360 * a * b ^ 2 * c ^ 3 + 72 * b * c ^ 5 + (-12) * a * b * c + (-4) * c ^ 3
    G = ideal(eq1, eq2, eq3, eq4).groebner_basis()
    for i, g in enumerate(G):
        print(f'G[{i}] =', g)
    last_var_poly = G[-1].factor()
    print(last_var_poly)
    last_var = c
    sols = solve(SR(last_var_poly), SR(last_var))
    sols = [sol.rhs() for sol in sols if sol.rhs().is_real()]
    var_list = (a, b, c)
    wanted = back_substitution_with_a_sol(G, last_var, var_list, {last_var: 1 / 2})
    print(wanted)
    return G, last_var, var_list, sols

# 下面3种方法全部失败
# v1 = expr.coefficient({s3:0, s12:0})
# v2 = expr.coefficient({s3:1, s12:0})
# v3 = expr.coefficient({s3:0, s12:1})
# v4 = expr.coefficient({s3:1, s12:1})
# v1 = expr.subs({s3:0, s12:0})
# v2 = expr.subs({s3:1, s12:0})
# v3 = expr.subs({s3:0, s12:1})
# v4 = expr.subs({s3:1, s12:1})
# print(v1, type(v1))
# print(v2)

# xx = expr.polynomial(s12)
# print(xx)

# V, from_V, to_V = L.relative_vector_space()
# vec_eq = to_V(expr)
# print(vec_eq)
# eqs = [SR(comp) == 0 for comp in vec_eq]


# solve_equation_phase1(1)
solve_equation_phase2(-9, 6)
