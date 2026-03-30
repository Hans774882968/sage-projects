def compute_surface_of_revolution(curve_exprs, line_exprs):
    """
    计算旋转曲面方程
    :param curve_exprs: 曲线参数方程列表 [x_c(t), y_c(t), z_c(t)]
    :param line_exprs:  直线参数方程列表 [x_l(s), y_l(s), z_l(s)]
    :return: 曲面方程 f(x,y,z) = 0 的多项式
    """
    var('t s x y z')
    A = [expr.subs(s=0) for expr in line_exprs]
    V = [expr.subs(s=1) - expr.subs(s=0) for expr in line_exprs]

    if all(v == 0 for v in V):
        raise ValueError("直线的方向向量为零，请输入有效的直线方程。")

    Q = curve_exprs
    P = [x, y, z]

    # --- 方程 1: 轴向投影相等 (Dot Product Condition) ---
    # (P - A) . V = (Q - A) . V
    # 移项使得右边为 0: (P - A) . V - (Q - A) . V = 0
    proj_P = sum((p - a) * v for p, a, v in zip(P, A, V))
    proj_Q = sum((q - a) * v for q, a, v in zip(Q, A, V))
    eq1 = proj_P - proj_Q

    # --- 方程 2: 到轴距离平方相等 (Distance Squared Condition) ---
    # |(P - A) x V|^2 = |(Q - A) . V|^2
    # 叉积模长平方公式：|U x V|^2 = |U|^2|V|^2 - (U . V)^2
    # 或者直接计算叉积分量平方和。为了保持多项式形式，直接计算分量。
    def cross_product_sq(U, V_vec):
        cx = U[1] * V_vec[2] - U[2] * V_vec[1]
        cy = U[2] * V_vec[0] - U[0] * V_vec[2]
        cz = U[0] * V_vec[1] - U[1] * V_vec[0]
        return cx ^ 2 + cy ^ 2 + cz ^ 2

    vec_AP = [p - a for p, a in zip(P, A)]
    vec_AQ = [q - a for q, a in zip(Q, A)]

    dist_sq_P = cross_product_sq(vec_AP, V)
    dist_sq_Q = cross_product_sq(vec_AQ, V)

    eq2 = dist_sq_P - dist_sq_Q

    print("几何约束方程：")
    print(f"方程 1 (投影): {eq1 == 0}")
    print(f"方程 2 (距离): {eq2 == 0}")

    try:
        R = PolynomialRing(QQ, 't,x,y,z', order='lex')
        f1 = R(eq1)
        f2 = R(eq2)
    except TypeError:
        print("警告：检测到非有理数系数。尝试使用符号环 (SR) 作为基域，计算速度可能较慢。")
        R = PolynomialRing(SR, 't,x,y,z', order='lex')
        f1 = R(eq1)
        f2 = R(eq2)

    print("正在计算 Grobner 基 (这可能需要一些时间)...")
    I = R.ideal([f1, f2])
    G = I.groebner_basis()

    return G[-1]


def compute_surface_of_revolution_xyz(curve_exprs, line_exprs):
    """
    计算旋转曲面方程
    :param curve_exprs: 曲线方程列表 [f(x, y, z), g(x, y, z)]
    :param line_exprs:  直线参数方程列表 [x_l(t), y_l(t), z_l(t)]
    :return: 曲面方程 f(x,y,z) = 0 的多项式
    """
    var('t x y z x0 y0 z0')

    A = [expr.subs(t=0) for expr in line_exprs]
    V = [expr.subs(t=1) - expr.subs(t=0) for expr in line_exprs]

    if all(v == 0 for v in V):
        raise ValueError("直线的方向向量为零，请输入有效的直线方程。")

    P = [x, y, z]
    P0 = [x0, y0, z0]

    eq_curve = []
    for expr in curve_exprs:
        expr_sub = expr.subs({x: x0, y: y0, z: z0})
        eq_curve.append(expr_sub)

    # --- 方程 1: 轴向投影相等 (Dot Product Condition) ---
    # (P - A) . V = (Q - A) . V
    # 移项使得右边为 0: (P - A) . V - (Q - A) . V = 0
    proj_P = sum((p - a) * v for p, a, v in zip(P, A, V))
    proj_P0 = sum((p0 - a) * v for p0, a, v in zip(P0, A, V))
    eq_proj = proj_P - proj_P0

    # --- 方程 2: 到轴距离平方相等 (Distance Squared Condition) ---
    # |(P - A) x V|^2 = |(Q - A) . V|^2
    # 叉积模长平方公式：|U x V|^2 = |U|^2|V|^2 - (U . V)^2
    def cross_product_sq(U, V_vec):
        cx = U[1] * V_vec[2] - U[2] * V_vec[1]
        cy = U[2] * V_vec[0] - U[0] * V_vec[2]
        cz = U[0] * V_vec[1] - U[1] * V_vec[0]
        return cx ^ 2 + cy ^ 2 + cz ^ 2

    vec_AP = [p - a for p, a in zip(P, A)]
    vec_AP0 = [p0 - a for p0, a in zip(P0, A)]

    dist_sq_P = cross_product_sq(vec_AP, V)
    dist_sq_P0 = cross_product_sq(vec_AP0, V)
    eq_dist = dist_sq_P - dist_sq_P0

    all_eqs = eq_curve + [eq_proj, eq_dist]

    print(f"已构建 {len(all_eqs)} 个约束方程：")
    print(all_eqs)

    try:
        R = PolynomialRing(QQ, 'x0,y0,z0,x,y,z', order='lex')
        polys = [R(eq) for eq in all_eqs]
    except TypeError:
        print("警告：检测到非有理数系数，切换至符号环。")
        R = PolynomialRing(SR, 'x0,y0,z0,x,y,z', order='lex')
        polys = [R(eq) for eq in all_eqs]

    print("正在计算 Grobner 基...")
    I = R.ideal(polys)
    G = I.groebner_basis()

    return G[-1]
