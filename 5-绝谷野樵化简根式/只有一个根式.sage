def simplify_nested_sqrt(c1, c2, c3):
    """
    尝试将 sqrt(c1 + c2*sqrt(c3)) 化为 sqrt(a) ± sqrt(b)，其中 a,b ∈ QQ, a,b ≥ 0.
    要求 c1, c2, c3 ∈ QQ，且 c3 > 0.

    返回 (a, b, sgn) 使得 sqrt(c1 + c2*sqrt(c3)) == sqrt(a) + sgn*sqrt(b),
    其中 sgn = +1 if c2 >= 0, else -1.
    若无法表示为这种形式，则返回 None.
    """
    # 确保输入是有理数
    c1 = QQ(c1)
    c2 = QQ(c2)
    c3 = QQ(c3)

    if c3 <= 0:
        raise ValueError("c3 must be positive rational")

    # 特殊情况： c2 == 0 ，则原式 = sqrt(c1)，只需检查 c1 是否为平方数
    if c2 == 0:
        if c1 < 0:
            return None
        sqrt_c1 = sqrt(c1)
        if sqrt_c1 in QQ:
            return (c1, 0, 1)
        else:
            return None

    sgn = 1 if c2 > 0 else -1

    R.<x> = QQ[]
    poly = x ^ 2 - c1 * x + (c2 ^ 2 * c3) / 4

    roots = poly.roots(multiplicities=False)

    if len(roots) != 2:
        # 判别式非完全平方，根不在 QQ 中
        return None

    a, b = roots[0], roots[1]

    if a < 0 or b < 0:
        return None

    lhs = sqrt(c1 + c2 * sqrt(c3))
    rhs1 = sqrt(a) + sgn * sqrt(b)
    rhs2 = sqrt(b) + sgn * sqrt(a)
    if abs(lhs.n(50) - rhs1.n(50)) < 1e-10:
        return (a, b, sgn)
    if abs(lhs.n(50) - rhs2.n(50)) < 1e-10:
        return (b, a, sgn)
    return None


if __name__ == "__main__":
    '''
    https://zhuanlan.zhihu.com/p/663659377
    (2, 1, 1) sqrt(3 + 2*sqrt(2)) = sqrt(2) + sqrt(1)
    (3, 2, -1) sqrt(5 - 2*sqrt(6)) = sqrt(3) - sqrt(2)
    (4, 3, 1)
    (4, 3, -1)
    (5/2, 3/2, -1) (根号10-根号6)/2
    None 无法化简
    (49/6, 3, 1) 7/6*sqrt(6) + sqrt(3)
    (9, 2, -1) 3 - sqrt(2)
    (9/2, 3/2, -1) (3*sqrt(2) - sqrt(6))/2
    (23/2, 7/2, -1)
    '''
    cases = [
        (3, 2, 2),
        (5, -2, 6),
        (7, 4, 3),
        (7, -4, 3),
        (4, -1, 15),
        (1, 1, 3),
        (67 / 6, 7, 2),
        (11, -1, 72),
        (6, -3, 3),
        (15, -1, 161),
    ]
    for cas in cases:
        result = simplify_nested_sqrt(*cas)
        print(result)
