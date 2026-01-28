R.<c> = PolynomialRing(QQ)
f = c ^ 3 - 3 * c ^ 2 + 3
K = R.quotient(f, 'cbar')
cbar = K.gen()

denom = 1 + cbar - cbar ^ 2
inv_denom = denom.inverse()
print('1 + c - c^2 的逆元', inv_denom)

lhs1 = cbar * inv_denom
rhs1 = -cbar ^ 3 + 2 * cbar ^ 2 + cbar  # 也可以写 K(-c^3 + 2c^2 + c)
print('c / (1 + c - c^2) =', lhs1)
print('rhs1 =', rhs1, lhs1 == rhs1)

lhs2 = K(c * (1 - c)) * inv_denom
rhs2 = K(c ^ 4 - 3 * c ^ 3 + c ^ 2 + c)
print('c(1-c) / (1 + c - c^2) =', lhs2, rhs2, lhs2 == rhs2)

# PPT 里提到的初中常规题，直接这么写就能映射到商环里
wanted = K(c ^ 4 - 4 * c ^ 3 + 3 * c ^ 2 + 3 * c)
print(wanted)
